; ModuleID = 'merge_sort_module'
source_filename = "merge_sort.ll"
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8* nocapture)
declare i8* @memcpy(i8* noalias, i8* noalias, i64)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %alloc

alloc:
  %size0 = shl i64 %n, 2
  %mem0 = call noalias i8* @malloc(i64 %size0)
  %isnull = icmp eq i8* %mem0, null
  br i1 %isnull, label %ret, label %init

init:
  %block0 = bitcast i8* %mem0 to i32*
  br label %outer

outer:
  %run = phi i64 [ 1, %init ], [ %run.next, %finish.inner ]
  %src.ptr = phi i32* [ %arr, %init ], [ %src.to.next, %finish.inner ]
  %dest.ptr = phi i32* [ %block0, %init ], [ %dest.to.next, %finish.inner ]
  %condOuter = icmp ult i64 %run, %n
  br i1 %condOuter, label %inner.init, label %afterOuter

inner.init:
  br label %inner.loop

inner.loop:
  %start = phi i64 [ 0, %inner.init ], [ %start.next, %after.merge.range ]
  %checkStart = icmp ult i64 %start, %n
  br i1 %checkStart, label %prepare.ranges, label %finish.inner

prepare.ranges:
  %mid.tmp = add i64 %start, %run
  %mid.cmp = icmp ult i64 %mid.tmp, %n
  %mid = select i1 %mid.cmp, i64 %mid.tmp, i64 %n
  %twoRun.p = add i64 %run, %run
  %right.tmp = add i64 %start, %twoRun.p
  %right.cmp = icmp ult i64 %right.tmp, %n
  %right = select i1 %right.cmp, i64 %right.tmp, i64 %n
  br label %merge.loop

merge.loop:
  %i.idx = phi i64 [ %start, %prepare.ranges ], [ %i.next.phi, %merge.latch ]
  %j.idx = phi i64 [ %mid, %prepare.ranges ], [ %j.next.phi, %merge.latch ]
  %k.idx = phi i64 [ %start, %prepare.ranges ], [ %k.next.phi, %merge.latch ]
  %k.lt.right = icmp ult i64 %k.idx, %right
  br i1 %k.lt.right, label %choose, label %after.merge.range

choose:
  %i.lt.mid = icmp ult i64 %i.idx, %mid
  br i1 %i.lt.mid, label %check_j, label %take_j

check_j:
  %j.lt.right = icmp ult i64 %j.idx, %right
  br i1 %j.lt.right, label %compare_vals, label %take_i

compare_vals:
  %i.gep = getelementptr inbounds i32, i32* %src.ptr, i64 %i.idx
  %ival = load i32, i32* %i.gep, align 4
  %j.gep = getelementptr inbounds i32, i32* %src.ptr, i64 %j.idx
  %jval = load i32, i32* %j.gep, align 4
  %left_le_right = icmp sle i32 %ival, %jval
  br i1 %left_le_right, label %take_i, label %take_j

take_i:
  %i.src.ptr = getelementptr inbounds i32, i32* %src.ptr, i64 %i.idx
  %i.val2 = load i32, i32* %i.src.ptr, align 4
  %k.dest.ptr = getelementptr inbounds i32, i32* %dest.ptr, i64 %k.idx
  store i32 %i.val2, i32* %k.dest.ptr, align 4
  %i.inc = add i64 %i.idx, 1
  %k.inc = add i64 %k.idx, 1
  br label %merge.latch

take_j:
  %j.src.ptr = getelementptr inbounds i32, i32* %src.ptr, i64 %j.idx
  %j.val2 = load i32, i32* %j.src.ptr, align 4
  %k.dest.ptr2 = getelementptr inbounds i32, i32* %dest.ptr, i64 %k.idx
  store i32 %j.val2, i32* %k.dest.ptr2, align 4
  %j.inc = add i64 %j.idx, 1
  %k.inc2 = add i64 %k.idx, 1
  br label %merge.latch

merge.latch:
  %i.next.phi = phi i64 [ %i.inc, %take_i ], [ %i.idx, %take_j ]
  %j.next.phi = phi i64 [ %j.idx, %take_i ], [ %j.inc, %take_j ]
  %k.next.phi = phi i64 [ %k.inc, %take_i ], [ %k.inc2, %take_j ]
  br label %merge.loop

after.merge.range:
  %twoRun2 = add i64 %run, %run
  %start.next = add i64 %start, %twoRun2
  br label %inner.loop

finish.inner:
  %src.to.next = bitcast i32* %dest.ptr to i32*
  %dest.to.next = bitcast i32* %src.ptr to i32*
  %run.next = shl i64 %run, 1
  br label %outer

afterOuter:
  %src_is_arr = icmp eq i32* %src.ptr, %arr
  br i1 %src_is_arr, label %skipCopy, label %doCopy

doCopy:
  %size2 = shl i64 %n, 2
  %arr.i8 = bitcast i32* %arr to i8*
  %src.i8 = bitcast i32* %src.ptr to i8*
  %callmemcpy = call i8* @memcpy(i8* %arr.i8, i8* %src.i8, i64 %size2)
  br label %skipCopy

skipCopy:
  call void @free(i8* %mem0)
  br label %ret

ret:
  ret void
}