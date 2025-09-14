; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail() noreturn

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrptr, align 4
  %p1 = getelementptr inbounds i32, i32* %arrptr, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrptr, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrptr, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrptr, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrptr, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrptr, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrptr, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrptr, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrptr, i64 9
  store i32 0, i32* %p9, align 4

  store i64 10, i64* %n, align 8

  %nval = load i64, i64* %n, align 8
  call void @merge_sort(i32* %arrptr, i64 %nval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %iv, %ncur
  br i1 %cond, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arrptr, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %iv.next = add i64 %iv, 1
  store i64 %iv.next, i64* %i, align 8
  br label %loop

after:
  %pc = call i32 @putchar(i32 10)
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %saved, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}