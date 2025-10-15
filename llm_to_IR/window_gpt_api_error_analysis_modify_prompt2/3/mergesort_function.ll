; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)
declare dllimport i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %blk.i8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %blk.i8, null
  br i1 %isnull, label %ret, label %init

init:
  %blk = bitcast i8* %blk.i8 to i32*
  br label %outer.cond

outer.cond:
  %width = phi i64 [ 1, %init ], [ %width.next, %after_pass ]
  %src = phi i32* [ %arr, %init ], [ %src.next, %after_pass ]
  %tmp = phi i32* [ %blk, %init ], [ %tmp.next, %after_pass ]
  %cond.outer = icmp ult i64 %width, %n
  br i1 %cond.outer, label %pass.init, label %after_outer

pass.init:
  br label %chunk.cond

chunk.cond:
  %start = phi i64 [ 0, %pass.init ], [ %start.next, %after_merge ]
  %cont.chunks = icmp ult i64 %start, %n
  br i1 %cont.chunks, label %chunk.setup, label %after_pass

chunk.setup:
  %mid.tmp = add i64 %start, %width
  %mid.gt = icmp ugt i64 %mid.tmp, %n
  %mid = select i1 %mid.gt, i64 %n, i64 %mid.tmp
  %tw = shl i64 %width, 1
  %right.tmp = add i64 %start, %tw
  %right.gt = icmp ugt i64 %right.tmp, %n
  %right = select i1 %right.gt, i64 %n, i64 %right.tmp
  br label %merge.cond

merge.cond:
  %k = phi i64 [ %start, %chunk.setup ], [ %k.next.l, %left.copy ], [ %k.next.r, %right.copy ]
  %i = phi i64 [ %start, %chunk.setup ], [ %i.next, %left.copy ], [ %i, %right.copy ]
  %j = phi i64 [ %mid, %chunk.setup ], [ %j, %left.copy ], [ %j.next, %right.copy ]
  %k.lt.right = icmp ult i64 %k, %right
  br i1 %k.lt.right, label %cmp.leftbound, label %after_merge

cmp.leftbound:
  %i.ge.mid = icmp uge i64 %i, %mid
  br i1 %i.ge.mid, label %right.copy, label %cmp.rightbound

cmp.rightbound:
  %j.ge.right = icmp uge i64 %j, %right
  br i1 %j.ge.right, label %left.copy, label %cmp.values

cmp.values:
  %i.ptr = getelementptr i32, i32* %src, i64 %i
  %li = load i32, i32* %i.ptr, align 4
  %j.ptr = getelementptr i32, i32* %src, i64 %j
  %rj = load i32, i32* %j.ptr, align 4
  %lgt = icmp sgt i32 %li, %rj
  br i1 %lgt, label %right.copy, label %left.copy

left.copy:
  %i.ptr.l = getelementptr i32, i32* %src, i64 %i
  %li.l = load i32, i32* %i.ptr.l, align 4
  %dst.ptr.l = getelementptr i32, i32* %tmp, i64 %k
  store i32 %li.l, i32* %dst.ptr.l, align 4
  %i.next = add i64 %i, 1
  %k.next.l = add i64 %k, 1
  br label %merge.cond

right.copy:
  %j.ptr.r = getelementptr i32, i32* %src, i64 %j
  %rj.r = load i32, i32* %j.ptr.r, align 4
  %dst.ptr.r = getelementptr i32, i32* %tmp, i64 %k
  store i32 %rj.r, i32* %dst.ptr.r, align 4
  %j.next = add i64 %j, 1
  %k.next.r = add i64 %k, 1
  br label %merge.cond

after_merge:
  %start.next = add i64 %start, %tw
  br label %chunk.cond

after_pass:
  %src.next = bitcast i32* %tmp to i32*
  %tmp.next = bitcast i32* %src to i32*
  %width.next = shl i64 %width, 1
  br label %outer.cond

after_outer:
  %neq = icmp ne i32* %src, %arr
  br i1 %neq, label %do.memcpy, label %free.block

do.memcpy:
  %dst.i8 = bitcast i32* %arr to i8*
  %src.i8 = bitcast i32* %src to i8*
  %bytes = shl i64 %n, 2
  %call.memcpy = call i8* @memcpy(i8* %dst.i8, i8* %src.i8, i64 %bytes)
  br label %free.block

free.block:
  call void @free(i8* %blk.i8)
  br label %ret

ret:
  ret void
}