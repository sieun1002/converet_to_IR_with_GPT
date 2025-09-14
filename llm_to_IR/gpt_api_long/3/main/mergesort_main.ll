; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13F7
; Intent: Initialize array, sort with merge_sort, then print the sorted numbers (confidence=0.92). Evidence: call to merge_sort; loop printing "%d ".
; Preconditions: merge_sort sorts in-place: (i32* base, i64 count).
; Postconditions: Prints 10 integers followed by a newline.

; Only the needed extern declarations:
declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

@__stack_chk_guard = external global i64
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = load i64, i64* @__stack_chk_guard
  %arr = alloca [10 x i32], align 16
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %base, align 4
  %p1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %base, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %base, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %base, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %base, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %base, i64 9
  store i32 0, i32* %p9, align 4

  call void @merge_sort(i32* %base, i64 10)

  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %after

body:
  %iptr = getelementptr inbounds i32, i32* %base, i64 %i
  %val = load i32, i32* %iptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %i.next = add i64 %i, 1
  br label %loop

after:
  %pc = call i32 @putchar(i32 10)
  %chk = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %canary, %chk
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}