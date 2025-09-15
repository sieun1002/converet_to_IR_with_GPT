; ModuleID = 'quicksort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %arr.idx1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.idx2, align 4
  %arr.idx3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.idx3, align 4
  %arr.idx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.idx4, align 4
  %arr.idx5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.idx5, align 4
  %arr.idx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.idx6, align 4
  %arr.idx7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.idx7, align 4
  %arr.idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 4
  %arr.idx9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.idx9, align 4
  store i64 10, i64* %len, align 8
  %len.load = load i64, i64* %len, align 8
  %cmp.len = icmp ule i64 %len.load, 1
  br i1 %cmp.len, label %skip_sort, label %do_sort

do_sort:                                          ; preds = %entry
  %len.load2 = load i64, i64* %len, align 8
  %high = sub i64 %len.load2, 1
  call void @quick_sort(i32* %arr.base, i64 0, i64 %high)
  br label %skip_sort

skip_sort:                                        ; preds = %do_sort, %entry
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %skip_sort
  %i.val = load i64, i64* %i, align 8
  %len.load3 = load i64, i64* %len, align 8
  %loop.cmp = icmp ult i64 %i.val, %len.load3
  br i1 %loop.cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) {
entry:
  br label %while.head

while.head:                                       ; preds = %outer.cont, %entry
  %lo.ph = phi i64 [ %lo, %entry ], [ %lo.next, %outer.cont ]
  %hi.ph = phi i64 [ %hi, %entry ], [ %hi.next, %outer.cont ]
  %cmp.lohi = icmp slt i64 %lo.ph, %hi.ph
  br i1 %cmp.lohi, label %partition.init, label %exit

partition.init:                                   ; preds = %while.head
  %i.init = add nsw i64 %lo.ph, 0
  %j.init = add nsw i64 %hi.ph, 0
  %diff = sub nsw i64 %hi.ph, %lo.ph
  %half = ashr i64 %diff, 1
  %mid = add nsw i64 %lo.ph, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan.i

scan.i:                                           ; preds = %resume.inner, %scan.i.inc, %partition.init
  %i.cur = phi i64 [ %i.init, %partition.init ], [ %i.next, %scan.i.inc ], [ %i.after, %resume.inner ]
  %j.start = phi i64 [ %j.init, %partition.init ], [ %j.start, %scan.i.inc ], [ %j.after, %resume.inner ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.pivot.gt.i = icmp sgt i32 %pivot, %i.val
  br i1 %cmp.pivot.gt.i, label %scan.i.inc, label %scan.j.entry

scan.i.inc:                                       ; preds = %scan.i
  %i.next = add nsw i64 %i.cur, 1
  br label %scan.i

scan.j.entry:                                     ; preds = %scan.i
  br label %scan.j

scan.j:                                           ; preds = %scan.j.dec, %scan.j.entry
  %j.cur = phi i64 [ %j.start, %scan.j.entry ], [ %j.next, %scan.j.dec ]
  %i.hold = phi i64 [ %i.cur, %scan.j.entry ], [ %i.hold, %scan.j.dec ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.pivot.lt.j = icmp slt i32 %pivot, %j.val
  br i1 %cmp.pivot.lt.j, label %scan.j.dec, label %check

scan.j.dec:                                       ; preds = %scan.j
  %j.next = add nsw i64 %j.cur, -1
  br label %scan.j

check:                                            ; preds = %scan.j
  %cmp.i.le.j = icmp sle i64 %i.hold, %j.cur
  br i1 %cmp.i.le.j, label %do.swap, label %after.inner

do.swap:                                          ; preds = %check
  %i.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i.hold
  %j.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %tmp.i.load = load i32, i32* %i.ptr2, align 4
  %tmp.j.load = load i32, i32* %j.ptr2, align 4
  store i32 %tmp.j.load, i32* %i.ptr2, align 4
  store i32 %tmp.i.load, i32* %j.ptr2, align 4
  %i.after = add nsw i64 %i.hold, 1
  %j.after = add nsw i64 %j.cur, -1
  br label %resume.inner

resume.inner:                                     ; preds = %do.swap
  br label %scan.i

after.inner:                                      ; preds = %check
  %left.size = sub nsw i64 %j.cur, %lo.ph
  %right.size = sub nsw i64 %hi.ph, %i.hold
  %cmp.left.ge.right = icmp sge i64 %left.size, %right.size
  br i1 %cmp.left.ge.right, label %right.first, label %left.first

left.first:                                       ; preds = %after.inner
  %condL = icmp slt i64 %lo.ph, %j.cur
  br i1 %condL, label %call.left, label %skip.left

call.left:                                        ; preds = %left.first
  call void @quick_sort(i32* %arr, i64 %lo.ph, i64 %j.cur)
  br label %skip.left

skip.left:                                        ; preds = %call.left, %left.first
  %lo.next.left = add i64 %i.hold, 0
  br label %outer.cont

right.first:                                      ; preds = %after.inner
  %condR = icmp slt i64 %i.hold, %hi.ph
  br i1 %condR, label %call.right, label %skip.right

call.right:                                       ; preds = %right.first
  call void @quick_sort(i32* %arr, i64 %i.hold, i64 %hi.ph)
  br label %skip.right

skip.right:                                       ; preds = %call.right, %right.first
  br label %outer.cont

outer.cont:                                       ; preds = %skip.right, %skip.left
  %lo.next = phi i64 [ %lo.next.left, %skip.left ], [ %lo.ph, %skip.right ]
  %hi.next = phi i64 [ %hi.ph, %skip.left ], [ %j.cur, %skip.right ]
  br label %while.head

exit:                                             ; preds = %while.head
  ret void
}
