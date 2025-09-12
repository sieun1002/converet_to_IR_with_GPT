; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Demonstrate heap sort on a static int array (confidence=0.74). Evidence: calls heap_sort with local array and prints before/after using "%d ".
; Preconditions: None
; Postconditions: Returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

@.str_before = private unnamed_addr constant [16 x i8] c"Before sorting:\00", align 1
@.str_after = private unnamed_addr constant [15 x i8] c"After sorting:\00", align 1
@.str_num = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; initialize array: {7,3,9,1,4,8,2,6,5}
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 4
  %1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %2, align 4
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %8, align 4

  ; print header before
  %hdr1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_before, i64 0, i64 0
  %call_hdr1 = call i32 (i8*, ...) @printf(i8* %hdr1)

  ; for (i = 0; i < 9; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop_before.cond

loop_before.cond:                                ; preds = %loop_before.body, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp.i = icmp ult i64 %i.val, 9
  br i1 %cmp.i, label %loop_before.body, label %loop_before.end

loop_before.body:                                ; preds = %loop_before.cond
  %gep.valptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %val = load i32, i32* %gep.valptr, align 4
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @.str_num, i64 0, i64 0
  %call_num = call i32 (i8*, ...) @printf(i8* %fmt_num, i32 %val)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop_before.cond

loop_before.end:                                 ; preds = %loop_before.cond
  ; newline
  %nl1 = call i32 @putchar(i32 10)

  ; heap_sort(arr, 9)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.ptr, i64 9)

  ; print header after
  %hdr2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str_after, i64 0, i64 0
  %call_hdr2 = call i32 (i8*, ...) @printf(i8* %hdr2)

  ; for (j = 0; j < 9; ++j) printf("%d ", arr[j]);
  store i64 0, i64* %j, align 8
  br label %loop_after.cond

loop_after.cond:                                 ; preds = %loop_after.body, %loop_before.end
  %j.val = load i64, i64* %j, align 8
  %cmp.j = icmp ult i64 %j.val, 9
  br i1 %cmp.j, label %loop_after.body, label %loop_after.end

loop_after.body:                                 ; preds = %loop_after.cond
  %gep.valptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %val2 = load i32, i32* %gep.valptr2, align 4
  %fmt_num2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_num, i64 0, i64 0
  %call_num2 = call i32 (i8*, ...) @printf(i8* %fmt_num2, i32 %val2)
  %inc2 = add i64 %j.val, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop_after.cond

loop_after.end:                                  ; preds = %loop_after.cond
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}