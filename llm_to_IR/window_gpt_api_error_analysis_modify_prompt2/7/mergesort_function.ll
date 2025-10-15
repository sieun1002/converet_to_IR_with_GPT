target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arg_0, i64 %arg_8) {
entry:
  %cmp_le1 = icmp ule i64 %arg_8, 1
  br i1 %cmp_le1, label %exit, label %malloc.blk

malloc.blk:
  %bytes = shl i64 %arg_8, 2
  %blk_i8 = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %blk_i8, null
  br i1 %isnull, label %exit, label %init

init:
  %Block = bitcast i8* %blk_i8 to i32*
  br label %outer.cond

outer.cond:
  %Src.cur = phi i32* [ %arg_0, %init ], [ %Buf.cur, %outer.inc ]
  %Buf.cur = phi i32* [ %Block, %init ], [ %Src.cur, %outer.inc ]
  %run.cur = phi i64 [ 1, %init ], [ %run.dbl, %outer.inc ]
  %cond.outer = icmp ult i64 %run.cur, %arg_8
  br i1 %cond.outer, label %chunk.cond, label %outer.after

chunk.cond:
  %i.cur = phi i64 [ 0, %outer.cond ], [ %i.next, %merge.end ]
  %cond.i = icmp ult i64 %i.cur, %arg_8
  br i1 %cond.i, label %chunk.body.init, label %outer.inc

chunk.body.init:
  %run2 = add i64 %run.cur, %run.cur
  %mid.cand = add i64 %i.cur, %run.cur
  %mid.cmp = icmp ult i64 %mid.cand, %arg_8
  %mid = select i1 %mid.cmp, i64 %mid.cand, i64 %arg_8
  %end.cand = add i64 %i.cur, %run2
  %end.cmp = icmp ult i64 %end.cand, %arg_8
  %end = select i1 %end.cmp, i64 %end.cand, i64 %arg_8
  br label %merge.cond

merge.cond:
  %left.cur = phi i64 [ %i.cur, %chunk.body.init ], [ %left.next, %merge.latch ]
  %right.cur = phi i64 [ %mid, %chunk.body.init ], [ %right.next, %merge.latch ]
  %dest.cur = phi i64 [ %i.cur, %chunk.body.init ], [ %dest.next, %merge.latch ]
  %cond.dest = icmp ult i64 %dest.cur, %end
  br i1 %cond.dest, label %choose.entry, label %merge.end

choose.entry:
  %leftok = icmp ult i64 %left.cur, %mid
  br i1 %leftok, label %check.right, label %choose.right

check.right:
  %rightok = icmp ult i64 %right.cur, %end
  br i1 %rightok, label %compare.lr, label %choose.left

compare.lr:
  %lptr = getelementptr inbounds i32, i32* %Src.cur, i64 %left.cur
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %Src.cur, i64 %right.cur
  %rval = load i32, i32* %rptr, align 4
  %cmp.sgt = icmp sgt i32 %lval, %rval
  br i1 %cmp.sgt, label %choose.right, label %choose.left.withl

choose.left.withl:
  %dptr.l = getelementptr inbounds i32, i32* %Buf.cur, i64 %dest.cur
  store i32 %lval, i32* %dptr.l, align 4
  %left.inc = add i64 %left.cur, 1
  %dest.inc = add i64 %dest.cur, 1
  br label %merge.latch

choose.left:
  %lptr2 = getelementptr inbounds i32, i32* %Src.cur, i64 %left.cur
  %lval2 = load i32, i32* %lptr2, align 4
  %dptr.l2 = getelementptr inbounds i32, i32* %Buf.cur, i64 %dest.cur
  store i32 %lval2, i32* %dptr.l2, align 4
  %left.inc2 = add i64 %left.cur, 1
  %dest.inc2 = add i64 %dest.cur, 1
  br label %merge.latch

choose.right:
  %rptr2 = getelementptr inbounds i32, i32* %Src.cur, i64 %right.cur
  %rval2 = load i32, i32* %rptr2, align 4
  %dptr.r = getelementptr inbounds i32, i32* %Buf.cur, i64 %dest.cur
  store i32 %rval2, i32* %dptr.r, align 4
  %right.inc = add i64 %right.cur, 1
  %dest.inc3 = add i64 %dest.cur, 1
  br label %merge.latch

merge.latch:
  %left.next = phi i64 [ %left.inc, %choose.left.withl ], [ %left.inc2, %choose.left ], [ %left.cur, %choose.right ]
  %right.next = phi i64 [ %right.cur, %choose.left.withl ], [ %right.cur, %choose.left ], [ %right.inc, %choose.right ]
  %dest.next = phi i64 [ %dest.inc, %choose.left.withl ], [ %dest.inc2, %choose.left ], [ %dest.inc3, %choose.right ]
  br label %merge.cond

merge.end:
  %i.next = add i64 %i.cur, %run2
  br label %chunk.cond

outer.inc:
  %run.dbl = shl i64 %run.cur, 1
  br label %outer.cond

outer.after:
  %needcpy = icmp ne i32* %Src.cur, %arg_0
  br i1 %needcpy, label %do.memcpy, label %skip.memcpy

do.memcpy:
  %dst.i8 = bitcast i32* %arg_0 to i8*
  %src.i8 = bitcast i32* %Src.cur to i8*
  %callcpy = call i8* @memcpy(i8* %dst.i8, i8* %src.i8, i64 %bytes)
  br label %after.copy

skip.memcpy:
  br label %after.copy

after.copy:
  call void @free(i8* %blk_i8)
  br label %exit

exit:
  ret void
}