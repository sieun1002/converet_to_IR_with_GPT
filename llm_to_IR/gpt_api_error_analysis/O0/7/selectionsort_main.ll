; ModuleID = 'main_module'
target triple = "x86_64-unknown-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.num = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %array = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8
  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %arr.base, align 4
  %a1.ptr = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 10, i32* %a1.ptr, align 4
  %a2.ptr = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 14, i32* %a2.ptr, align 4
  %a3.ptr = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 37, i32* %a3.ptr, align 4
  %a4.ptr = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 13, i32* %a4.ptr, align 4
  store i32 5, i32* %len, align 4
  %len.val = load i32, i32* %len, align 4
  call void @selection_sort(i32* %arr.base, i32 %len.val)
  %fmt.sorted.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call.print.sorted = call i32 (i8*, ...) @printf(i8* %fmt.sorted.ptr)
  br label %for.cond

for.cond:
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp slt i32 %i.phi, %len.val
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idx.ext = sext i32 %i.phi to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %idx.ext
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmt.num.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.num, i64 0, i64 0
  %call.print.num = call i32 (i8*, ...) @printf(i8* %fmt.num.ptr, i32 %elem.val)
  br label %for.inc

for.inc:
  %i.next = add nsw i32 %i.phi, 1
  br label %for.cond

for.end:
  %guard.saved = load i64, i64* %canary, align 8
  %guard.current = load i64, i64* @__stack_chk_guard, align 8
  %cmp.canary = icmp ne i64 %guard.saved, %guard.current
  br i1 %cmp.canary, label %stackfail, label %ret

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}