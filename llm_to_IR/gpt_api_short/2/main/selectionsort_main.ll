; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124D
; Intent: sort an integer array and print it (confidence=0.94). Evidence: call to selection_sort; printing "Sorted array: " and "%d ".
; Preconditions: none
; Postconditions: prints sorted array to stdout; returns 0

; Only the necessary external declarations:
declare void @selection_sort(i32*, i32)
declare i32 @_printf(i8*, ...)
declare void @___stack_chk_fail()
@__stack_chk_guard = external global i64

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00"
@.str.dsp = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4

  ; stack canary setup
  %guard_init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard_init, i64* %canary, align 8

  ; initialize array: {29, 10, 14, 37, 13}
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 16

  store i32 5, i32* %n, align 4

  ; call selection_sort(&arr[0], n)
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrdecay, i32 %nval)

  ; printf("Sorted array: ")
  %p.sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call0 = call i32 @_printf(i8* %p.sorted)

  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %idx = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %p.dsp = getelementptr inbounds [4 x i8], [4 x i8]* @.str.dsp, i64 0, i64 0
  %call1 = call i32 @_printf(i8* %p.dsp, i32 %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

after.loop:
  ; stack canary check
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  %guard_saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guard_saved, %guard_now
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}