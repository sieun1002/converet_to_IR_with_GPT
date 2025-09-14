; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x128B
; Intent: initialize an int array, sort it with bubble_sort, then print elements and a newline (confidence=0.95). Evidence: call to bubble_sort(arr, 10); loop printing "%d " followed by putchar('\n')
; Preconditions: none
; Postconditions: prints sorted array; returns 0

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %format = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8
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
  %i = phi i64 [ 0, %entry ], [ %inc, %body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds i32, i32* %p0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %call = call i32 (i8*, ...) @printf(i8* %format, i32 %elem)
  %inc = add i64 %i, 1
  br label %loop

after:
  %pc = call i32 @putchar(i32 10)
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %can = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %can, %guard2
  br i1 %ok, label %ret, label %ssp.fail

ssp.fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}