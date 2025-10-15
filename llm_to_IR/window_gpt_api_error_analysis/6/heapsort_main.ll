; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

@.str.orig = private unnamed_addr constant [17 x i8] c"Original array: \00"
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00"
@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define internal void @sift_down(i32* %arr, i64 %start, i64 %end) {
entry:
  br label %loop.cond

loop.cond:
  %root = phi i64 [ %start, %entry ], [ %root.next, %do.swap ]
  %tmp.mul = mul i64 %root, 2
  %left = add i64 %tmp.mul, 1
  %hasLeft = icmp ule i64 %left, %end
  br i1 %hasLeft, label %do.compare, label %ret

do.compare:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 %root
  %root.val = load i32, i32* %root.ptr, align 4
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %cmp0 = icmp slt i32 %root.val, %left.val
  %swapcand = select i1 %cmp0, i64 %left, i64 %root
  %right = add i64 %left, 1
  %hasRight = icmp ule i64 %right, %end
  br i1 %hasRight, label %checkright, label %after.right

checkright:
  %swapcand.ptr = getelementptr inbounds i32, i32* %arr, i64 %swapcand
  %swapcand.val = load i32, i32* %swapcand.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %cmp1 = icmp slt i32 %swapcand.val, %right.val
  %swapidx2 = select i1 %cmp1, i64 %right, i64 %swapcand
  br label %after.right

after.right:
  %swapidx = phi i64 [ %swapcand, %do.compare ], [ %swapidx2, %checkright ]
  %isroot = icmp eq i64 %swapidx, %root
  br i1 %isroot, label %ret, label %do.swap

do.swap:
  %root.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %root
  %swap.ptr = getelementptr inbounds i32, i32* %arr, i64 %swapidx
  %val.root2 = load i32, i32* %root.ptr2, align 4
  %val.swap = load i32, i32* %swap.ptr, align 4
  store i32 %val.swap, i32* %root.ptr2, align 4
  store i32 %val.root2, i32* %swap.ptr, align 4
  %root.next = add i64 %swapidx, 0
  br label %loop.cond

ret:
  ret void
}

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %le1 = icmp ule i64 %n, 1
  br i1 %le1, label %ret, label %proceed

proceed:
  %n.minus1 = add i64 %n, -1
  %half = udiv i64 %n, 2
  %start0 = add i64 %half, -1
  br label %build.header

build.header:
  %start = phi i64 [ %start0, %proceed ], [ %start.next, %build.iter ]
  %ge0 = icmp sge i64 %start, 0
  br i1 %ge0, label %build.iter, label %heap.header

build.iter:
  call void @sift_down(i32* %arr, i64 %start, i64 %n.minus1)
  %start.next = add i64 %start, -1
  br label %build.header

heap.header:
  %end = phi i64 [ %n.minus1, %build.header ], [ %end.next, %heap.body ]
  %gt0 = icmp ugt i64 %end, 0
  br i1 %gt0, label %heap.body, label %ret

heap.body:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %v0 = load i32, i32* %ptr0, align 4
  %vend = load i32, i32* %end.ptr, align 4
  store i32 %vend, i32* %ptr0, align 4
  store i32 %v0, i32* %end.ptr, align 4
  %end.next = add i64 %end, -1
  call void @sift_down(i32* %arr, i64 0, i64 %end.next)
  br label %heap.header

ret:
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len.addr = alloca i64, align 8
  store i64 9, i64* %len.addr, align 8
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 5, i32* %p8, align 4
  %orig.ptr = getelementptr inbounds [17 x i8], [17 x i8]* @.str.orig, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %orig.ptr)
  %len = load i64, i64* %len.addr, align 8
  br label %loop1.header

loop1.header:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmpI = icmp ult i64 %i, %len
  br i1 %cmpI, label %loop1.body, label %loop1.after

loop1.body:
  %elem.ptr0 = getelementptr inbounds i32, i32* %arr.base, i64 %i
  %elem0 = load i32, i32* %elem.ptr0, align 4
  %fmt.ptr0 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmt.ptr0, i32 %elem0)
  %i.next = add i64 %i, 1
  br label %loop1.header

loop1.after:
  %c10 = call i32 @putchar(i32 10)
  %len2 = load i64, i64* %len.addr, align 8
  call void @heap_sort(i32* %arr.base, i64 %len2)
  %sorted.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %sorted.ptr)
  br label %loop2.header

loop2.header:
  %j = phi i64 [ 0, %loop1.after ], [ %j.next, %loop2.body ]
  %cmpJ = icmp ult i64 %j, %len2
  br i1 %cmpJ, label %loop2.body, label %loop2.after

loop2.body:
  %elem.ptr1 = getelementptr inbounds i32, i32* %arr.base, i64 %j
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmt.ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @printf(i8* %fmt.ptr1, i32 %elem1)
  %j.next = add i64 %j, 1
  br label %loop2.header

loop2.after:
  %cnl = call i32 @putchar(i32 10)
  ret i32 0
}