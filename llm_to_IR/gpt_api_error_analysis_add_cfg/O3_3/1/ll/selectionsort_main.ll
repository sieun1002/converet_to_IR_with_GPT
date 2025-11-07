; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

@xmmword_2020 = external global <16 x i8>, align 16
@__stack_chk_guard = external thread_local global i64

declare void @selection_sort(i32*, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
L1080:
  %arr = alloca [5 x i32], align 16
  %canary.slot = alloca i64, align 8
  %guard.init = load i64, i64* @__stack_chk_guard
  store i64 %guard.init, i64* %canary.slot, align 8
  %vec16 = load <16 x i8>, <16 x i8>* @xmmword_2020, align 16
  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %arr.vec.ptr = bitcast i32* %arr.base to <16 x i8>*
  store <16 x i8> %vec16, <16 x i8>* %arr.vec.ptr, align 16
  %elem4.ptr = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 13, i32* %elem4.ptr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %arr.base, i64 5
  %fmt.d.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %sorted.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call void @selection_sort(i32* %arr.base, i32 5)
  br label %L10CC_after_call

L10CC_after_call:
  %call.hdr = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %sorted.ptr)
  br label %L10DF_to_L10E0

L10DF_to_L10E0:
  br label %L10E0

L10E0:
  %rbx.cur = phi i32* [ %arr.base, %L10DF_to_L10E0 ], [ %rbx.next, %L10F0_after_call ]
  %val = load i32, i32* %rbx.cur, align 4
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %call.val = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.d.ptr, i32 %val)
  br label %L10F0_after_call

L10F0_after_call:
  %cmp.ne = icmp ne i32* %rbx.next, %end.ptr
  br i1 %cmp.ne, label %L10E0, label %L10FA

L10FA:
  %guard.now = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary.slot, align 8
  %canary.mismatch = icmp ne i64 %guard.saved, %guard.now
  br i1 %canary.mismatch, label %L1115, label %L110A_ret

L110A_ret:
  ret i32 0

L1115:
  call void @___stack_chk_fail()
  unreachable
}