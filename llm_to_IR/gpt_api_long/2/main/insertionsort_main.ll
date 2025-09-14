; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1247
; Intent: Sort a fixed array with insertion_sort and print it (confidence=0.92). Evidence: call to insertion_sort with length 10; loop printing elements with "%d ".
; Preconditions:
; Postconditions:

; Only the needed extern declarations:
declare void @insertion_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @insertion_sort(i32* %base, i64 10)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %loop.body, label %after

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

after:
  %putc = call i32 @putchar(i32 10)
  br i1 true, label %retblk, label %chkfail

chkfail:
  call void @__stack_chk_fail()
  unreachable

retblk:
  ret i32 0
}