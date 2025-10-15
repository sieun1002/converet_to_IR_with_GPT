; ModuleID = 'quicksort_module'
source_filename = "quicksort_module"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @quick_sort(i32* nocapture %arr, i32 %low, i32 %high) {
entry:
  %cmp = icmp slt i32 %low, %high
  br i1 %cmp, label %do, label %ret

do:
  %high.idx = sext i32 %high to i64
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %high.idx
  %pivot = load i32, i32* %pivot.ptr, align 4
  %i0 = add nsw i32 %low, -1
  br label %loop

loop:
  %i.phi = phi i32 [ %i0, %do ], [ %i.next, %loop.body.end ]
  %j.phi = phi i32 [ %low, %do ], [ %j.next, %loop.body.end ]
  %highm1 = add nsw i32 %high, -1
  %cmpj = icmp sle i32 %j.phi, %highm1
  br i1 %cmpj, label %loop.body, label %after.loop

loop.body:
  %j.idx64 = sext i32 %j.phi to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %vj = load i32, i32* %j.ptr, align 4
  %le = icmp sle i32 %vj, %pivot
  br i1 %le, label %then.swap, label %no.swap

then.swap:
  %i.inc = add nsw i32 %i.phi, 1
  %i64 = sext i32 %i.inc to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %vi = load i32, i32* %i.ptr, align 4
  store i32 %vj, i32* %i.ptr, align 4
  store i32 %vi, i32* %j.ptr, align 4
  br label %loop.body.end

no.swap:
  br label %loop.body.end

loop.body.end:
  %i.next = phi i32 [ %i.inc, %then.swap ], [ %i.phi, %no.swap ]
  %j.next = add nsw i32 %j.phi, 1
  br label %loop

after.loop:
  %ip1 = add nsw i32 %i.phi, 1
  %ip1_64 = sext i32 %ip1 to i64
  %ip1.ptr = getelementptr inbounds i32, i32* %arr, i64 %ip1_64
  %v_ip1 = load i32, i32* %ip1.ptr, align 4
  store i32 %pivot, i32* %ip1.ptr, align 4
  store i32 %v_ip1, i32* %pivot.ptr, align 4
  %p = add nsw i32 %i.phi, 1
  %pm1 = add nsw i32 %p, -1
  call void @quick_sort(i32* %arr, i32 %low, i32 %pm1)
  %pp1 = add nsw i32 %p, 1
  call void @quick_sort(i32* %arr, i32 %pp1, i32 %high)
  br label %ret

ret:
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %idx = alloca i64, align 8
  call void @__main()
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4
  store i64 10, i64* %len, align 8
  %lenv = load i64, i64* %len, align 8
  %cmplen = icmp ugt i64 %lenv, 1
  br i1 %cmplen, label %do_sort, label %after_sort

do_sort:
  %arrbase = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %high64 = add i64 %lenv, -1
  %high32 = trunc i64 %high64 to i32
  call void @quick_sort(i32* %arrbase, i32 0, i32 %high32)
  br label %after_sort

after_sort:
  store i64 0, i64* %idx, align 8
  br label %print_loop

print_loop:
  %idxv = load i64, i64* %idx, align 8
  %lenv2 = load i64, i64* %len, align 8
  %cont = icmp ult i64 %idxv, %lenv2
  br i1 %cont, label %print_body, label %print_end

print_body:
  %arrbase2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i32, i32* %arrbase2, i64 %idxv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %next = add i64 %idxv, 1
  store i64 %next, i64* %idx, align 8
  br label %print_loop

print_end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}