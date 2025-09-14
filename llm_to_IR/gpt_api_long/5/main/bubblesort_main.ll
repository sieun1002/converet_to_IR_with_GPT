; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x128B
; Intent: Sort and print a fixed array using bubble_sort (confidence=0.95). Evidence: bubble_sort called with int* and length; loop prints elements with "%d " then newline
; Preconditions: bubble_sort sorts in-place: (i32* a, i64 n)
; Postconditions: Prints 10 integers followed by a newline

@.str = private unnamed_addr constant [4 x i8] c"%d \00"
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %p0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %p0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %p0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %p0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %p0, i64 9
  store i32 0, i32* %p9, align 4
  call void @bubble_sort(i32* %p0, i64 10)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %inc, %loop_body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop_body, label %after_loop

loop_body:
  %elt.ptr = getelementptr inbounds i32, i32* %p0, i64 %i
  %val = load i32, i32* %elt.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add nuw nsw i64 %i, 1
  br label %loop

after_loop:
  %nl = call i32 @putchar(i32 10)
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %guard0, %guard1
  br i1 %ok, label %retblk, label %failblk

failblk:
  call void @__stack_chk_fail()
  unreachable

retblk:
  ret i32 0
}