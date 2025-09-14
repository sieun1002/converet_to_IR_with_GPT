; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Print an array before and after sorting it using heap_sort (confidence=0.86). Evidence: prints elements with "%d ", calls heap_sort, prints again.
; Preconditions: None
; Postconditions: Prints two lists of numbers and a newline after each; calls heap_sort(arr, 9).

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@str_before = private unnamed_addr constant [17 x i8] c"Before sorting:\0A\00"
@str_after = private unnamed_addr constant [16 x i8] c"After sorting:\0A\00"
@str_d = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary, align 8

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

  ; printf("Before sorting:\n");
  %p_before = getelementptr inbounds [17 x i8], [17 x i8]* @str_before, i64 0, i64 0
  %call_before = call i32 (i8*, ...) @printf(i8* %p_before)

  br label %loop1

loop1:                                            ; i from 0 to 8
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.body ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @str_d, i64 0, i64 0
  %call_print1 = call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem1)
  %i1.next = add i64 %i1, 1
  br label %loop1

loop1.end:
  %nl1 = call i32 @putchar(i32 10)

  ; heap_sort(&arr[0], 9)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base, i64 9)

  ; printf("After sorting:\n");
  %p_after = getelementptr inbounds [16 x i8], [16 x i8]* @str_after, i64 0, i64 0
  %call_after = call i32 (i8*, ...) @printf(i8* %p_after)

  br label %loop2

loop2:                                            ; i from 0 to 8
  %i2 = phi i64 [ 0, %loop1.end ], [ %i2.next, %loop2.body ]
  %cmp2 = icmp ult i64 %i2, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %call_print2 = call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem2)
  %i2.next = add i64 %i2, 1
  br label %loop2

loop2.end:
  %nl2 = call i32 @putchar(i32 10)

  ; stack canary check
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary, align 8
  %canary.ok = icmp eq i64 %guard.cur, %guard.saved
  br i1 %canary.ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}