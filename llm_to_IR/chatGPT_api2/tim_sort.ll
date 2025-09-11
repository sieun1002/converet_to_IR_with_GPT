; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1100
; Intent: Initialize a 15-int array, sort it in-place with timsort_constprop_0, and print the result as space-separated integers ending with newline (confidence=0.85). Evidence: call to timsort_constprop_0; printf pattern "%d%s" with " " and "\n".
; Preconditions: timsort_constprop_0 expects exactly 15 i32 elements at the pointer argument.
; Postconditions: Prints 15 integers: 14 with a trailing space, then the last followed by newline.

@.str.fmt = private unnamed_addr constant [5 x i8] c"%d%s\00"
@.str.space = private unnamed_addr constant [2 x i8] c" \00"
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00"

; Only the needed extern declarations:
declare void @timsort_constprop_0(i32* nocapture) local_unnamed_addr
declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [15 x i32], align 16
  %arr0 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 0
  ; initialize 15-element array: pairs derived from 64-bit constants and final -1 sentinel
  %p0 = getelementptr inbounds i32, i32* %arr0, i64 0
  store i32 5, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 1, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 9, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 5, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 5, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 7, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 8, i32* %p9, align 4
  %p10 = getelementptr inbounds i32, i32* %arr0, i64 10
  store i32 0, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %arr0, i64 11
  store i32 4, i32* %p11, align 4
  %p12 = getelementptr inbounds i32, i32* %arr0, i64 12
  store i32 4, i32* %p12, align 4
  %p13 = getelementptr inbounds i32, i32* %arr0, i64 13
  store i32 10, i32* %p13, align 4
  %p14 = getelementptr inbounds i32, i32* %arr0, i64 14
  store i32 -1, i32* %p14, align 4

  ; sort in-place
  call void @timsort_constprop_0(i32* %arr0)

  ; print first 14 elements with trailing space
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cond = icmp slt i64 %i, 14
  br i1 %cond, label %loop.body, label %after_loop

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [5 x i8], [5 x i8]* @.str.fmt, i64 0, i64 0
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %elem, i8* %space.ptr)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

after_loop:
  ; print last element with newline
  %last = load i32, i32* %p14, align 4
  %fmt.ptr2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.fmt, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr2, i32 %last, i8* %nl.ptr)
  ret i32 0
}