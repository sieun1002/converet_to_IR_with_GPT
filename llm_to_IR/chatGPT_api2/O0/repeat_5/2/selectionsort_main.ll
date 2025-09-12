; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x124D
; Intent: sort and print an integer array (confidence=0.95). Evidence: calls selection_sort; prints with "%d ".
; Preconditions: selection_sort expects (i32* array, i32 n)
; Postconditions: prints "Sorted array: " followed by the sorted integers

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00"
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00"
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare dso_local void @selection_sort(i32*, i32)
declare dso_local i32 @printf(i8*, ...)
declare dso_local void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard0 = load i64, i64* @__stack_chk_guard
  %arr = alloca [5 x i32]
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %0
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %1
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %2
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %3
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %4
  call void @selection_sort(i32* %0, i32 5)
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt)
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body.end ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %idx64 = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx64
  %val = load i32, i32* %elem.ptr
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %val)
  br label %loop.body.end

loop.body.end:
  %i.next = add i32 %i, 1
  br label %loop.cond

after.loop:
  %guard1 = load i64, i64* @__stack_chk_guard
  %chk = icmp eq i64 %guard0, %guard1
  br i1 %chk, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}