; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13F7
; Intent: sort an array with merge_sort and print it (confidence=0.98). Evidence: call to merge_sort; printf loop with "%d " then newline
; Preconditions: merge_sort expects (int*, size_t) semantics
; Postconditions: prints sorted elements followed by newline; returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @merge_sort(i32*, i64)
declare void @___stack_chk_fail()

@__stack_chk_guard = external global i64
@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  call void @merge_sort(i32* %0, i64 10)
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %inc = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %putc = call i32 @putchar(i32 10)
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary.slot, align 8
  %canary.ok = icmp eq i64 %saved, %guard.end
  br i1 %canary.ok, label %ret, label %stackfail

stackfail:                                        ; preds = %for.end
  call void @___stack_chk_fail()
  unreachable

ret:                                              ; preds = %for.end
  ret i32 0
}