; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13F7
; Intent: sort an int array with merge_sort and print the result (confidence=0.86). Evidence: calls merge_sort(a, n); loop prints "%d " for each element.
; Preconditions: merge_sort expects a valid pointer to i32 and a length (i64).
; Postconditions: prints the elements followed by a newline; returns 0; stack protector enforced.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @merge_sort(i32*, i64)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %g0 = load i64, i64* @__stack_chk_guard
  store i64 %g0, i64* %canary, align 8

  ; initialize array: 9,1,5,3,7,2,8,6,4,0
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %a0, align 4
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %a2, align 4
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %a3, align 4
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %a4, align 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %a5, align 4
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %a6, align 4
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %a8, align 4
  %a9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %a9, align 4

  store i64 10, i64* %len, align 8

  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %n = load i64, i64* %len, align 8
  call void @merge_sort(i32* %arrptr, i64 %n)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %iv = load i64, i64* %i, align 8
  %n1 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %iv, %n1
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %pc = call i32 @putchar(i32 10)
  %saved = load i64, i64* %canary, align 8
  %g1 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %saved, %g1
  br i1 %ok, label %ret, label %stkfail

stkfail:                                          ; preds = %loop.end
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %loop.end
  ret i32 0
}