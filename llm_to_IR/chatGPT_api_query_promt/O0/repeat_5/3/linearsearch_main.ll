; ModuleID = 'recovered'
source_filename = "recovered.ll"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canaryslot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %key = alloca i32, align 4
  %idx = alloca i32, align 4

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canaryslot, align 8

  %arr.elem0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.elem0, align 4
  %arr.elem1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.elem1, align 4
  %arr.elem2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr.elem2, align 4
  %arr.elem3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr.elem3, align 4
  %arr.elem4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.elem4, align 4

  store i32 5, i32* %n, align 4
  store i32 4, i32* %key, align 4

  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  %key.val = load i32, i32* %key, align 4
  %call = call i32 @linear_search(i32* %arr.ptr, i32 %n.val, i32 %key.val)
  store i32 %call, i32* %idx, align 4

  %isneg1 = icmp eq i32 %call, -1
  br i1 %isneg1, label %notfound, label %found

found:
  %idxval = load i32, i32* %idx, align 4
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %pcall = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idxval)
  br label %afterprint

notfound:
  %notptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %putscall = call i32 @puts(i8* %notptr)
  br label %afterprint

afterprint:
  %loaded = load i64, i64* %canaryslot, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %cmp = icmp eq i64 %loaded, %guard2
  br i1 %cmp, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}