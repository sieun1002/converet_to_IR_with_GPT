; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external thread_local global i64
@xmmword_2020 = external constant <4 x i32>, align 16
@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
entry_1080:
  %arr = alloca [5 x i32], align 16
  %saved_can = alloca i64, align 8

  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %saved_can, align 8

  %arr.vptr = bitcast [5 x i32]* %arr to <4 x i32>*
  %vecinit = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vecinit, <4 x i32>* %arr.vptr, align 16

  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %fifth.ptr = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 13, i32* %fifth.ptr, align 4

  call void @selection_sort(i32* %arr.base, i32 5)

  %sorted.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call0 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %sorted.ptr)
  br label %loc_10E0

loc_10E0:
  %rbx.cur = phi i32* [ %arr.base, %entry_1080 ], [ %rbx.next, %loc_10E0 ]
  %val = load i32, i32* %rbx.cur, align 4
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %end.ptr = getelementptr inbounds i32, i32* %arr.base, i64 5
  %cmp = icmp ne i32* %rbx.next, %end.ptr
  br i1 %cmp, label %loc_10E0, label %after_10FA

after_10FA:
  %saved1 = load i64, i64* %saved_can, align 8
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved1, %guard1
  br i1 %ok, label %ret_1114, label %loc_1115

ret_1114:
  ret i32 0

loc_1115:
  call void @___stack_chk_fail()
  unreachable
}