; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Demonstrate heap sort by printing an array before and after sorting (confidence=0.86). Evidence: call to heap_sort; two print loops with headers and newline.
; Preconditions: heap_sort expects a valid pointer to i32 and a non-negative length.
; Postconditions: Returns 0 after printing arrays; calls __stack_chk_fail on canary mismatch.

@__stack_chk_guard = external global i64

@.str.before = private unnamed_addr constant [17 x i8] c"Before sorting:\0A\00", align 1
@.str.after  = private unnamed_addr constant [16 x i8] c"After sorting:\0A\00", align 1
@.str.d      = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @heap_sort(i32*, i64)
declare dso_local void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %saved_canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; stack canary setup
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %saved_canary, align 8

  ; initialize array: {7,3,9,1,4,8,2,6,5}
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8, align 4

  ; n = 9
  %n = add i64 0, 9

  ; printf("Before sorting:\n");
  %fmt_before = getelementptr inbounds [17 x i8], [17 x i8]* @.str.before, i64 0, i64 0
  %call_before = call i32 (i8*, ...) @printf(i8* %fmt_before)

  ; for (i = 0; i < n; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop_pre

loop_pre:                                          ; preds = %loop_body, %entry
  %i_val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i_val, %n
  br i1 %cmp, label %loop_body, label %loop_end

loop_body:                                         ; preds = %loop_pre
  %elem_ptr = getelementptr inbounds i32, i32* %arr0, i64 %i_val
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call_print = call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem)
  %inc = add i64 %i_val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop_pre

loop_end:                                          ; preds = %loop_pre
  ; putchar('\n');
  %newline1 = call i32 @putchar(i32 10)

  ; heap_sort(arr, n);
  call void @heap_sort(i32* %arr0, i64 %n)

  ; printf("After sorting:\n");
  %fmt_after = getelementptr inbounds [16 x i8], [16 x i8]* @.str.after, i64 0, i64 0
  %call_after = call i32 (i8*, ...) @printf(i8* %fmt_after)

  ; for (j = 0; j < n; ++j) printf("%d ", arr[j]);
  store i64 0, i64* %j, align 8
  br label %loop2_pre

loop2_pre:                                         ; preds = %loop2_body, %loop_end
  %j_val = load i64, i64* %j, align 8
  %cmp2 = icmp ult i64 %j_val, %n
  br i1 %cmp2, label %loop2_body, label %loop2_end

loop2_body:                                        ; preds = %loop2_pre
  %elem_ptr2 = getelementptr inbounds i32, i32* %arr0, i64 %j_val
  %elem2 = load i32, i32* %elem_ptr2, align 4
  %fmt_d2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call_print2 = call i32 (i8*, ...) @printf(i8* %fmt_d2, i32 %elem2)
  %inc2 = add i64 %j_val, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2_pre

loop2_end:                                         ; preds = %loop2_pre
  ; putchar('\n');
  %newline2 = call i32 @putchar(i32 10)

  ; stack canary check
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %saved_canary, align 8
  %canary_ok = icmp eq i64 %guard1, %saved
  br i1 %canary_ok, label %ret, label %stack_fail

stack_fail:                                        ; preds = %loop2_end
  call void @__stack_chk_fail()
  unreachable

ret:                                               ; preds = %loop2_end
  ret i32 0
}