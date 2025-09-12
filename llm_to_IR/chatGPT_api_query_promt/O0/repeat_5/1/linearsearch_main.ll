; ModuleID = 'binary.ll'
source_filename = "binary"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

@__stack_chk_guard = external global i64

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %key = alloca i32, align 4
  %idx = alloca i32, align 4
  %canary.slot = alloca i64, align 8

  %canary0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canary0, i64* %canary.slot, align 8

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4

  store i32 5, i32* %n, align 4
  store i32 4, i32* %key, align 4

  %n.val = load i32, i32* %n, align 4
  %key.val = load i32, i32* %key, align 4
  %call = call i32 @linear_search(i32* %arr0, i32 %n.val, i32 %key.val)
  store i32 %call, i32* %idx, align 4

  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %resload = load i32, i32* %idx, align 4
  %pcr = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %resload)
  br label %check

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %pp = call i32 @puts(i8* %sptr)
  br label %check

check:
  %canary1 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %saved, %canary1
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}