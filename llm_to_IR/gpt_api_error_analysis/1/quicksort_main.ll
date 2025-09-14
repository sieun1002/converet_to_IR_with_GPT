; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @quick_sort(i32* %arr, i64 %low, i64 %high) {
entry:
  %cmp = icmp slt i64 %low, %high
  br i1 %cmp, label %part, label %ret

part:
  %p = call i64 @partition(i32* %arr, i64 %low, i64 %high)
  %condL = icmp sgt i64 %p, %low
  br i1 %condL, label %left, label %after_left

left:
  %pm1 = add nsw i64 %p, -1
  call void @quick_sort(i32* %arr, i64 %low, i64 %pm1)
  br label %after_left

after_left:
  %condR = icmp slt i64 %p, %high
  br i1 %condR, label %right, label %ret

right:
  %pp1 = add nsw i64 %p, 1
  call void @quick_sort(i32* %arr, i64 %pp1, i64 %high)
  br label %ret

ret:
  ret void
}

define i64 @partition(i32* %arr, i64 %low, i64 %high) {
entry:
  %hptr = getelementptr inbounds i32, i32* %arr, i64 %high
  %pivot = load i32, i32* %hptr, align 4
  %i_init = add nsw i64 %low, -1
  %high_minus1 = add nsw i64 %high, -1
  br label %loop_head

loop_head:
  %j = phi i64 [ %low, %entry ], [ %j_next, %j_inc ]
  %i_cur = phi i64 [ %i_init, %entry ], [ %i_updated, %j_inc ]
  %cmp = icmp sle i64 %j, %high_minus1
  br i1 %cmp, label %body, label %after_loop

body:
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %aj = load i32, i32* %jptr, align 4
  %le = icmp sle i32 %aj, %pivot
  br i1 %le, label %iftrue, label %iffalse

iftrue:
  %i1 = add nsw i64 %i_cur, 1
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i1
  %ai = load i32, i32* %iptr, align 4
  store i32 %aj, i32* %iptr, align 4
  store i32 %ai, i32* %jptr, align 4
  br label %j_inc

iffalse:
  br label %j_inc

j_inc:
  %i_updated = phi i64 [ %i1, %iftrue ], [ %i_cur, %iffalse ]
  %j_next = add nsw i64 %j, 1
  br label %loop_head

after_loop:
  %i_end = phi i64 [ %i_cur, %loop_head ]
  %ip1 = add nsw i64 %i_end, 1
  %iptr2 = getelementptr inbounds i32, i32* %arr, i64 %ip1
  %aip1 = load i32, i32* %iptr2, align 4
  store i32 %pivot, i32* %iptr2, align 4
  store i32 %aip1, i32* %hptr, align 4
  ret i64 %ip1
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
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
  %lenval = load i64, i64* %len, align 8
  %cmp = icmp ule i64 %lenval, 1
  br i1 %cmp, label %after_sort, label %do_sort

do_sort:
  %high = add i64 %lenval, -1
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arrdecay, i64 0, i64 %high)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %len2 = load i64, i64* %len, align 8
  %cond = icmp ult i64 %iv, %len2
  br i1 %cond, label %print, label %done

print:
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}