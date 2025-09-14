; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13F7
; Intent: Sorts a static array using merge_sort and prints the result (confidence=0.95). Evidence: call to merge_sort; loop printing with "%d "
; Preconditions: merge_sort expects a valid i32 array pointer and length (elements).
; Postconditions: Prints the (sorted) array and a trailing newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %e0p = getelementptr inbounds i32, i32* %arr0, i64 0
  store i32 9, i32* %e0p, align 4
  %e1p = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %e1p, align 4
  %e2p = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %e2p, align 4
  %e3p = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %e3p, align 4
  %e4p = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %e4p, align 4
  %e5p = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %e5p, align 4
  %e6p = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %e6p, align 4
  %e7p = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %e7p, align 4
  %e8p = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %e8p, align 4
  %e9p = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %e9p, align 4
  call void @merge_sort(i32* %arr0, i64 10)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 @printf(i8* %fmt, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

after:
  %pcall = call i32 @putchar(i32 10)
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}