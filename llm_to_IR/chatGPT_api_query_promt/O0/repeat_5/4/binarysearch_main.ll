; ModuleID = 'bin2ir'
source_filename = "bin2ir"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail() noreturn
declare i64 @binary_search(i32*, i64, i32)

define i32 @main() {
entry:
  ; stack protector prologue
  %canary.slot = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

  ; locals
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8

  ; initialize array: [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5,  i32* %arr.base, align 4
  %arr.1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 -1,  i32* %arr.1, align 4
  %arr.2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 0,   i32* %arr.2, align 4
  %arr.3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 2,   i32* %arr.3, align 4
  %arr.4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 2,   i32* %arr.4, align 4
  %arr.5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 3,   i32* %arr.5, align 4
  %arr.6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 7,   i32* %arr.6, align 4
  %arr.7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 9,   i32* %arr.7, align 4
  %arr.8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 12,  i32* %arr.8, align 4

  ; initialize keys: [2, 5, -5]
  %keys.base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2,   i32* %keys.base, align 4
  %keys.1 = getelementptr inbounds i32, i32* %keys.base, i64 1
  store i32 5,   i32* %keys.1, align 4
  %keys.2 = getelementptr inbounds i32, i32* %keys.base, i64 2
  store i32 -5,  i32* %keys.2, align 4

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                         ; preds = %loop.body, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, 3
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                         ; preds = %loop.cond
  ; key = keys[i]
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4

  ; idx = binary_search(arr, 9, key)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arr.ptr, i64 9, i32 %key)

  ; if (idx < 0) -> not found
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:                                              ; preds = %loop.body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %idx)
  br label %cont

notfound:                                           ; preds = %loop.body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %cont

cont:                                               ; preds = %found, %notfound
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

loop.end:                                          ; preds = %loop.cond
  ; stack protector epilogue
  %saved = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %guard.now
  br i1 %ok, label %ret, label %stackfail

stackfail:                                         ; preds = %loop.end
  call void @__stack_chk_fail()
  unreachable

ret:                                               ; preds = %loop.end
  ret i32 0
}