; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare void @insertion_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @__stack_chk_fail() noreturn

define dso_local i32 @main() {
entry:
  %guard.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8

  ; stack protector prologue
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %guard.slot, align 8

  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %a0, align 4
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %a2, align 4
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %a3, align 4
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %a4, align 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %a5, align 4
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %a6, align 4
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %a8, align 4
  %a9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %a9, align 4

  ; len = 10
  store i64 10, i64* %len, align 8

  ; call insertion_sort(arr, len)
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %len.val = load i64, i64* %len, align 8
  call void @insertion_sort(i32* noundef %arr.ptr, i64 noundef %len.val)

  ; for (i = 0; i < len; ++i) printf("%d ", arr[i]);
  br label %for.cond

for.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i, %len.cur
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %elt.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elt.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %val)
  %inc = add nuw nsw i64 %i, 1
  br label %for.cond

for.end:
  %call.putchar = call i32 @putchar(i32 noundef 10)

  ; stack protector epilogue
  %guard.end = load i64, i64* %guard.slot, align 8
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %guard.ok = icmp eq i64 %guard.end, %guard.cur
  br i1 %guard.ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}