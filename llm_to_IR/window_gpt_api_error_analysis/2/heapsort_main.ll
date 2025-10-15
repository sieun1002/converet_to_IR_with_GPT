; ModuleID = 'heapsort_module'
source_filename = "heapsort_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str0 = private unnamed_addr constant [17 x i8] c"Original array:\0A\00", align 1
@.str1 = private unnamed_addr constant [15 x i8] c"Sorted array:\0A\00", align 1
@.str2 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local void @heap_sort(i32* noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %build.start

build.start:
  %half = lshr i64 %n, 1
  %i0 = add i64 %half, -1
  br label %build.loop

build.loop:
  %i = phi i64 [ %i0, %build.start ], [ %i.dec, %after.sift ]
  br label %sift.loop

sift.loop:
  %i.s = phi i64 [ %i, %build.loop ], [ %i.next, %sift.cont ]
  %li2 = shl i64 %i.s, 1
  %left = add i64 %li2, 1
  %hasLeft = icmp ult i64 %left, %n
  br i1 %hasLeft, label %sift.body, label %after.sift

sift.body:
  %right = add i64 %left, 1
  %hasRight = icmp ult i64 %right, %n
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  br i1 %hasRight, label %check.right, label %after.right

check.right:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %cmp.gt = icmp sgt i32 %right.val, %left.val
  br i1 %cmp.gt, label %choose.right, label %after.right

choose.right:
  br label %after.right

after.right:
  %largest.idx = phi i64 [ %right, %choose.right ], [ %left, %check.right ], [ %left, %sift.body ]
  %largest.val = phi i32 [ %right.val, %choose.right ], [ %left.val, %check.right ], [ %left.val, %sift.body ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.s
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.lt = icmp slt i32 %i.val, %largest.val
  br i1 %cmp.lt, label %do.swap, label %after.sift

do.swap:
  %largest.ptr = getelementptr inbounds i32, i32* %arr, i64 %largest.idx
  store i32 %i.val, i32* %largest.ptr, align 4
  store i32 %largest.val, i32* %i.ptr, align 4
  br label %sift.cont

sift.cont:
  %i.next = phi i64 [ %largest.idx, %do.swap ]
  br label %sift.loop

after.sift:
  %i.gt.zero = icmp ugt i64 %i, 0
  %i.dec = add i64 %i, -1
  br i1 %i.gt.zero, label %build.loop, label %heap.built

heap.built:
  %end0 = add i64 %n, -1
  br label %extract.loop

extract.loop:
  %end = phi i64 [ %end0, %heap.built ], [ %end.dec, %after.extract.sift ]
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %root.val = load i32, i32* %root.ptr, align 4
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %root.val, i32* %end.ptr, align 4
  store i32 %end.val, i32* %root.ptr, align 4
  br label %extract.sift.loop

extract.sift.loop:
  %i2 = phi i64 [ 0, %extract.loop ], [ %largest2.idx, %extract.do.swap ]
  %li2b = shl i64 %i2, 1
  %left2 = add i64 %li2b, 1
  %hasLeft2 = icmp ult i64 %left2, %end
  br i1 %hasLeft2, label %extract.sift.body, label %after.extract.sift

extract.sift.body:
  %right2 = add i64 %left2, 1
  %hasRight2 = icmp ult i64 %right2, %end
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  br i1 %hasRight2, label %ex.check.right, label %ex.after.right

ex.check.right:
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %cmp.gt2 = icmp sgt i32 %right2.val, %left2.val
  br i1 %cmp.gt2, label %ex.choose.right, label %ex.after.right

ex.choose.right:
  br label %ex.after.right

ex.after.right:
  %largest2.idx = phi i64 [ %right2, %ex.choose.right ], [ %left2, %ex.check.right ], [ %left2, %extract.sift.body ]
  %largest2.val = phi i32 [ %right2.val, %ex.choose.right ], [ %left2.val, %ex.check.right ], [ %left2.val, %extract.sift.body ]
  %i2.ptr = getelementptr inbounds i32, i32* %arr, i64 %i2
  %i2.val = load i32, i32* %i2.ptr, align 4
  %cmp.lt2 = icmp slt i32 %i2.val, %largest2.val
  br i1 %cmp.lt2, label %extract.do.swap, label %after.extract.sift

extract.do.swap:
  %largest2.ptr = getelementptr inbounds i32, i32* %arr, i64 %largest2.idx
  store i32 %i2.val, i32* %largest2.ptr, align 4
  store i32 %largest2.val, i32* %i2.ptr, align 4
  br label %extract.sift.loop

after.extract.sift:
  %end.gt1 = icmp ugt i64 %end, 1
  %end.dec = add i64 %end, -1
  br i1 %end.gt1, label %extract.loop, label %ret

ret:
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 5, i32* %arr8, align 4
  %fmt0 = getelementptr inbounds [17 x i8], [17 x i8]* @.str0, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* noundef %fmt0)
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:
  %idx = load i64, i64* %i, align 8
  %cmp1 = icmp ult i64 %idx, 9
  br i1 %cmp1, label %loop1.body, label %after.loop1

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtInt = getelementptr inbounds [4 x i8], [4 x i8]* @.str2, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* noundef %fmtInt, i32 noundef %elem)
  %idx.next = add i64 %idx, 1
  store i64 %idx.next, i64* %i, align 8
  br label %loop1

after.loop1:
  %nl = call i32 @putchar(i32 noundef 10)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* noundef %arr.ptr, i64 noundef 9)
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* noundef %fmt1)
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %idx2 = load i64, i64* %j, align 8
  %cmp2 = icmp ult i64 %idx2, 9
  br i1 %cmp2, label %loop2.body, label %after.loop2

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx2
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %call3 = call i32 (i8*, ...) @printf(i8* noundef %fmtInt, i32 noundef %elem2)
  %idx2.next = add i64 %idx2, 1
  store i64 %idx2.next, i64* %j, align 8
  br label %loop2

after.loop2:
  %nl2 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}