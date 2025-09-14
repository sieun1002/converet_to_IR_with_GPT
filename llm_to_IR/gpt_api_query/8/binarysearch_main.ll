; ModuleID = 'recovered'
source_filename = "recovered"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1
@__stack_chk_guard = external global i64

declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard
  store i64 %0, i64* %canary, align 8

  store [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], [9 x i32]* %arr, align 16
  store [3 x i32] [i32 2, i32 5, i32 -5], [3 x i32]* %keys, align 16

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %1 = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %1, 3
  br i1 %cmp, label %body, label %done

body:
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %1
  %key = load i32, i32* %keyptr, align 4
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arrptr, i64 9, i32 %key)
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %idx)
  br label %inc

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:
  %2 = add i64 %1, 1
  store i64 %2, i64* %i, align 8
  br label %loop

done:
  %3 = load i64, i64* %canary, align 8
  %4 = load i64, i64* @__stack_chk_guard
  %cmpcan = icmp ne i64 %3, %4
  br i1 %cmpcan, label %stackfail, label %ret

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}