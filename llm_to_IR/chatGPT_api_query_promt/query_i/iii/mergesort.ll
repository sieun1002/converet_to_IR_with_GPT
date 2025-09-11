; ModuleID = 'mergesort_from_binary.ll'
source_filename = "mergesort_from_binary"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@init = private unnamed_addr constant [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], align 16

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias writeonly, i8* noalias readonly, i64, i1 immarg)

define i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %init.i8 = bitcast [10 x i32]* @init to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr.i8, i8* align 16 %init.i8, i64 40, i1 false)

  %bufraw = call i8* @malloc(i64 40)
  %bufnull = icmp eq i8* %bufraw, null
  br i1 %bufnull, label %print, label %sort

sort:
  %buf = bitcast i8* %bufraw to i32*
  %src0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %outer.cond

outer.cond:
  %src = phi i32* [ %src0, %sort ], [ %dst_swapped, %outer.body.end ]
  %dst = phi i32* [ %buf, %sort ], [ %src_swapped, %outer.body.end ]
  %run = phi i32 [ 1, %sort ], [ %run.next, %outer.body.end ]
  %cmp_run = icmp slt i32 %run, 10
  br i1 %cmp_run, label %outer.body, label %outer.end

outer.body:
  br label %inner.cond

inner.cond:
  %i = phi i32 [ 0, %outer.body ], [ %i.next, %inner.after ]
  %cont = icmp slt i32 %i, 10
  br i1 %cont, label %merge.init, label %outer.body.end

merge.init:
  %left = %i
  %midtmp = add nsw i32 %i, %run
  %mid.cmp = icmp slt i32 %midtmp, 10
  %mid = select i1 %mid.cmp, i32 %midtmp, i32 10
  %r2 = shl nuw i32 %run, 1
  %endtmp = add nsw i32 %i, %r2
  %end.cmp = icmp slt i32 %endtmp, 10
  %end = select i1 %end.cmp, i32 %endtmp, i32 10
  br label %merge.loop

merge.loop:
  %li = phi i32 [ %left, %merge.init ], [ %li.next, %store.left ], [ %li, %store.right ]
  %ri = phi i32 [ %mid,  %merge.init ], [ %ri, %store.left ], [ %ri.next, %store.right ]
  %di = phi i32 [ %left, %merge.init ], [ %di.nextL, %store.left ], [ %di.nextR, %store.right ]
  %cmp.di = icmp slt i32 %di, %end
  br i1 %cmp.di, label %select.source, label %inner.after

select.source:
  %left.remain = icmp slt i32 %li, %mid
  br i1 %left.remain, label %checkRight, label %take.right

checkRight:
  %right.remain = icmp slt i32 %ri, %end
  br i1 %right.remain, label %cmpLR, label %take.left

cmpLR:
  %li64 = sext i32 %li to i64
  %ri64 = sext i32 %ri to i64
  %lptr = getelementptr inbounds i32, i32* %src, i64 %li64
  %rptr = getelementptr inbounds i32, i32* %src, i64 %ri64
  %lval = load i32, i32* %lptr, align 4
  %rval = load i32, i32* %rptr, align 4
  %cmp.le = icmp sle i32 %lval, %rval
  br i1 %cmp.le, label %take.left.withL, label %take.right.withR

take.left:
  %li64.a = sext i32 %li to i64
  %lptr.a = getelementptr inbounds i32, i32* %src, i64 %li64.a
  %lval.a = load i32, i32* %lptr.a, align 4
  br label %store.left

take.left.withL:
  br label %store.left

store.left:
  %lval.phi = phi i32 [ %lval, %take.left.withL ], [ %lval.a, %take.left ]
  %di64L = sext i32 %di to i64
  %dptrL = getelementptr inbounds i32, i32* %dst, i64 %di64L
  store i32 %lval.phi, i32* %dptrL, align 4
  %li.next = add nsw i32 %li, 1
  %di.nextL = add nsw i32 %di, 1
  br label %merge.loop

take.right:
  %ri64.b = sext i32 %ri to i64
  %rptr.b = getelementptr inbounds i32, i32* %src, i64 %ri64.b
  %rval.b = load i32, i32* %rptr.b, align 4
  br label %store.right

take.right.withR:
  br label %store.right

store.right:
  %rval.phi = phi i32 [ %rval, %take.right.withR ], [ %rval.b, %take.right ]
  %di64R = sext i32 %di to i64
  %dptrR = getelementptr inbounds i32, i32* %dst, i64 %di64R
  store i32 %rval.phi, i32* %dptrR, align 4
  %ri.next = add nsw i32 %ri, 1
  %di.nextR = add nsw i32 %di, 1
  br label %merge.loop

inner.after:
  %i.next = add nsw i32 %i, %r2
  br label %inner.cond

outer.body.end:
  %src_swapped = %dst
  %dst_swapped = %src
  %run.next = shl nuw i32 %run, 1
  br label %outer.cond

outer.end:
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %needcopy = icmp ne i32* %src, %arr.base
  br i1 %needcopy, label %copy, label %aftercopy

copy:
  %arr.i8.copy = bitcast [10 x i32]* %arr to i8*
  %src.i8 = bitcast i32* %src to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %arr.i8.copy, i8* align 4 %src.i8, i64 40, i1 false)
  br label %aftercopy

aftercopy:
  call void @free(i8* %bufraw)
  br label %print

print:
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  br label %loop.print

loop.print:
  %j = phi i32 [ 0, %print ], [ %j.next, %loop.body ]
  %contp = icmp slt i32 %j, 10
  br i1 %contp, label %loop.body, label %print.nl

loop.body:
  %j64 = sext i32 %j to i64
  %eptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j64
  %val = load i32, i32* %eptr, align 4
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %val)
  %j.next = add nsw i32 %j, 1
  br label %loop.print

print.nl:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
  ret i32 0
}