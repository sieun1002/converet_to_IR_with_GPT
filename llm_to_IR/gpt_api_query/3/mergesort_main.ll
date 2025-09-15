; ModuleID = 'main.ll'
source_filename = "main.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail() noreturn

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %cookie = alloca i64, align 8

  %guard.load = load i64, i64* @__stack_chk_guard
  store i64 %guard.load, i64* %cookie, align 8

  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  store i64 10, i64* %n, align 8

  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  call void @merge_sort(i32* %arr0, i64 %nval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %i.cur, %n.cur
  br i1 %cond, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

after:
  %call2 = call i32 @putchar(i32 10)

  %cookie.load = load i64, i64* %cookie, align 8
  %guard.check = load i64, i64* @__stack_chk_guard
  %cmpcan = icmp ne i64 %cookie.load, %guard.check
  br i1 %cmpcan, label %fail, label %ret

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}