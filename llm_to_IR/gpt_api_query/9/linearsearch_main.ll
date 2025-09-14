; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

@__stack_chk_guard = external thread_local global i64
declare void @__stack_chk_fail() noreturn
declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %key = alloca i32, align 4
  %idx = alloca i32, align 4

  %guardval = load i64, i64* @__stack_chk_guard
  store i64 %guardval, i64* %canary, align 8

  %arrptr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arrptr0, align 4
  %arrptr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arrptr1, align 4
  %arrptr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arrptr2, align 4
  %arrptr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arrptr3, align 4
  %arrptr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arrptr4, align 4

  store i32 5, i32* %len, align 4
  store i32 4, i32* %key, align 4

  %lenv = load i32, i32* %len, align 4
  %keyv = load i32, i32* %key, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linear_search(i32* %arrptr, i32 %lenv, i32 %keyv)
  store i32 %call, i32* %idx, align 4

  %idxv = load i32, i32* %idx, align 4
  %cmp = icmp ne i32 %idxv, -1
  br i1 %cmp, label %found, label %notfound

found:
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %idxv2 = load i32, i32* %idx, align 4
  %callp = call i32 (i8*, ...) @printf(i8* %fmt, i32 %idxv2)
  br label %after

notfound:
  %s = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %callputs = call i32 @puts(i8* %s)
  br label %after

after:
  %guardval2 = load i64, i64* @__stack_chk_guard
  %canary_saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %canary_saved, %guardval2
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}