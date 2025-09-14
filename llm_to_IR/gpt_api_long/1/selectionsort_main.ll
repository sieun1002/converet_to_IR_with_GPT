; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x124D
; Intent: Initialize an array, sort it with selection_sort, and print the sorted elements (confidence=0.95). Evidence: call to selection_sort; printf with "Sorted array: "
; Preconditions: selection_sort expects (i32* array, i32 n).
; Postconditions: prints "Sorted array: " followed by the sorted numbers, returns 0.

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00"
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00"
@__stack_chk_guard = external global i64

declare i32 @_printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @___stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %guard_in = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard_in, i64* %canary, align 8
  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 10, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 14, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 37, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 13, i32* %p4, align 4
  call void @selection_sort(i32* %p0, i32 5)
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call_printf_hdr = call i32 @_printf(i8* %fmt)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %i64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %p0, i64 %i64
  %val = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call_printf_num = call i32 @_printf(i8* %fmt2, i32 %val)
  br label %loop.latch

loop.latch:
  %i.next = add nsw i32 %i, 1
  br label %loop

after:
  %canary_out = load i64, i64* %canary, align 8
  %guard_chk = load i64, i64* @__stack_chk_guard, align 8
  %canary_ok = icmp eq i64 %canary_out, %guard_chk
  br i1 %canary_ok, label %ret, label %stackfail

stackfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}