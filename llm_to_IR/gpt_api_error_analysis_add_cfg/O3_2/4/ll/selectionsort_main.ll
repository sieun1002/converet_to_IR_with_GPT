; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str_sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@xmmword_2020 = external global <4 x i32>, align 16
@__stack_chk_guard = external global i64

declare void @selection_sort(i32*, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
L1080:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary.slot, align 8
  %vec = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %arr.vecptr = bitcast [5 x i32]* %arr to <4 x i32>*
  store <4 x i32> %vec, <4 x i32>* %arr.vecptr, align 16
  %arr.idx4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr.idx4, align 4
  %base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %end = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 5
  call void @selection_sort(i32* %base, i32 5)
  %hdrptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %hdrptr)
  br label %L10E0

L10E0:
  %cur = phi i32* [ %base, %L1080 ], [ %next, %L10E0 ]
  %val = load i32, i32* %cur, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call.elem = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmtptr, i32 %val)
  %next = getelementptr inbounds i32, i32* %cur, i64 1
  %cont = icmp ne i32* %next, %end
  br i1 %cont, label %L10E0, label %L10FA

L10FA:
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.slot, align 8
  %mismatch = icmp ne i64 %guard.saved, %guard.now
  br i1 %mismatch, label %L1115, label %L110A

L110A:
  ret i32 0

L1115:
  call void @___stack_chk_fail()
  unreachable
}