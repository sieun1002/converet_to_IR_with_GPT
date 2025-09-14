; ModuleID = 'binary_search_main'
source_filename = "binary_search_main.c"
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

@__stack_chk_guard = external global i64

declare i64 @binary_search(i32* noundef %arr, i64 noundef %n, i32 noundef %key)
declare i32 @printf(i8* noundef, ...)
declare void @__stack_chk_fail() nounwind

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i64, align 8
  %kcount = alloca i64, align 8
  %i = alloca i64, align 8
  %idx = alloca i64, align 8
  %guard_slot = alloca i64, align 8

  %guard_val = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard_val, i64* %guard_slot, align 8

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %arr.i0 = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 -5, i32* %arr.i0, align 4
  %arr.i1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 -1, i32* %arr.i1, align 4
  %arr.i2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 0, i32* %arr.i2, align 4
  %arr.i3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 2, i32* %arr.i3, align 4
  %arr.i4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 2, i32* %arr.i4, align 4
  %arr.i5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 3, i32* %arr.i5, align 4
  %arr.i6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 7, i32* %arr.i6, align 4
  %arr.i7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 9, i32* %arr.i7, align 4
  %arr.i8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 12, i32* %arr.i8, align 4

  store i64 9, i64* %n, align 8

  %keys.base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %keys.i0 = getelementptr inbounds i32, i32* %keys.base, i64 0
  store i32 2, i32* %keys.i0, align 4
  %keys.i1 = getelementptr inbounds i32, i32* %keys.base, i64 1
  store i32 5, i32* %keys.i1, align 4
  %keys.i2 = getelementptr inbounds i32, i32* %keys.base, i64 2
  store i32 -5, i32* %keys.i2, align 4

  store i64 3, i64* %kcount, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %kcount.val = load i64, i64* %kcount, align 8
  %cond = icmp ult i64 %i.val, %kcount.val
  br i1 %cond, label %body, label %after

body:
  %key.ptr = getelementptr inbounds i32, i32* %keys.base, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4
  %n.val = load i64, i64* %n, align 8
  %bs.res = call i64 @binary_search(i32* %arr.base, i64 %n.val, i32 %key)
  store i64 %bs.res, i64* %idx, align 8
  %is.neg = icmp slt i64 %bs.res, 0
  br i1 %is.neg, label %notfound, label %found

found:
  %fmt.found.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %printf.found = call i32 (i8*, ...) @printf(i8* %fmt.found.ptr, i32 %key, i64 %bs.res)
  br label %inc

notfound:
  %fmt.nf.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  %printf.nf = call i32 (i8*, ...) @printf(i8* %fmt.nf.ptr, i32 %key)
  br label %inc

inc:
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

after:
  %guard_saved = load i64, i64* %guard_slot, align 8
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  %guard_ok = icmp eq i64 %guard_saved, %guard_now
  br i1 %guard_ok, label %ret.ok, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret.ok:
  ret i32 0
}