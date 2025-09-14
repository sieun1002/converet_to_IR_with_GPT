; ModuleID = 'binary_to_ir'
source_filename = "binary"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external thread_local global i64

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary, align 8

  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 8, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 4, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 2, i32* %p4, align 4

  %idx = call i32 @linear_search(i32* %p0, i32 5, i32 4)
  %cmp = icmp eq i32 %idx, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmt, i32 %idx)
  br label %afterprint

notfound:
  %msg = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %callputs = call i32 @puts(i8* %msg)
  br label %afterprint

afterprint:
  %guard2 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %saved, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}