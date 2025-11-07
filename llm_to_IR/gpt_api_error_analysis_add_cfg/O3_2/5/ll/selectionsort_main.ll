; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2020 = external global <4 x i32>, align 16
@__stack_chk_guard = external thread_local global i64

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare void @selection_sort(i32*, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
bb_1080:
  %arr = alloca [5 x i32], align 16
  %saved_canary = alloca i64, align 8

  %vec = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %vecptr = bitcast i32* %base to <4 x i32>*
  store <4 x i32> %vec, <4 x i32>* %vecptr, align 16
  %fifth = getelementptr inbounds i32, i32* %base, i64 4
  store i32 13, i32* %fifth, align 4

  %canary = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canary, i64* %saved_canary, align 8

  %end = getelementptr inbounds i32, i32* %base, i64 5

  call void @selection_sort(i32* %base, i32 5)

  %hfmt = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %hdr = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %hfmt)
  br label %bb_10E0

bb_10E0:
  %cur = phi i32* [ %base, %bb_1080 ], [ %next, %bb_10E0 ]
  %val = load i32, i32* %cur, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt, i32 %val)
  %next = getelementptr inbounds i32, i32* %cur, i64 1
  %cont = icmp ne i32* %next, %end
  br i1 %cont, label %bb_10E0, label %bb_10FA

bb_10FA:
  %cur_canary = load i64, i64* @__stack_chk_guard, align 8
  %saved_val = load i64, i64* %saved_canary, align 8
  %mismatch = icmp ne i64 %saved_val, %cur_canary
  br i1 %mismatch, label %bb_1115, label %bb_ret

bb_ret:
  ret i32 0

bb_1115:
  call void @___stack_chk_fail()
  unreachable
}