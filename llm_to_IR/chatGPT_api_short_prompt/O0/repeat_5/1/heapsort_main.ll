; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Print an array, heap-sort it, then print it again (confidence=0.86). Evidence: calls heap_sort; prints elements with "%d " before and after.
; Preconditions: none
; Postconditions: After heap_sort returns, the printed array is sorted.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @___stack_chk_fail()
@__stack_chk_guard = external global i64

@aD = private unnamed_addr constant [4 x i8] c"%d \00"
@format = private unnamed_addr constant [14 x i8] c"Before sort:\0A\00"
@byte_2011 = private unnamed_addr constant [13 x i8] c"After sort:\0A\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary.slot, align 8

  ; initialize array elements
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

  store i64 9, i64* %n, align 8

  ; print header
  %fmt0 = getelementptr inbounds [14 x i8], [14 x i8]* @format, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)

  ; first loop: print array
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %cmp1 = icmp ult i64 %i.val, %n.val
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                      ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %numfmt = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %numfmt, i32 %elem)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                       ; preds = %loop1.cond
  call i32 @putchar(i32 10)

  ; sort
  %base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n2 = load i64, i64* %n, align 8
  call void @heap_sort(i32* %base.ptr, i64 %n2)

  ; print footer/header for sorted array
  %fmt1 = getelementptr inbounds [13 x i8], [13 x i8]* @byte_2011, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1)

  ; second loop: print array
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %loop1.end
  %j.val = load i64, i64* %j, align 8
  %n.val2 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j.val, %n.val2
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                      ; preds = %loop2.cond
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %numfmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %numfmt2, i32 %elem2)
  %inc2 = add i64 %j.val, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2.cond

loop2.end:                                       ; preds = %loop2.cond
  call i32 @putchar(i32 10)

  ; stack canary check
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.slot, align 8
  %canary.diff = icmp ne i64 %guard.saved, %guard.end
  br i1 %canary.diff, label %stack_fail, label %ret

stack_fail:                                       ; preds = %loop2.end
  call void @___stack_chk_fail()
  unreachable

ret:                                              ; preds = %loop2.end
  ret i32 0
}