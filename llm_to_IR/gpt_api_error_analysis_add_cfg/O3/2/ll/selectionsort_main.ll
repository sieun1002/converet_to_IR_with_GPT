; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.s = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@xmmword_2020 = external dso_local constant <16 x i8>, align 16
@__stack_chk_guard = external dso_local global i64, align 8

declare dso_local void @selection_sort(i32* noundef, i32 noundef)
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local void @__stack_chk_fail() noreturn

define dso_local i32 @main(i32 %argc, i8** %argv) {
loc_1080:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8
  %arr.vecptr = bitcast [5 x i32]* %arr to <16 x i8>*
  %vecinit = load <16 x i8>, <16 x i8>* @xmmword_2020, align 16
  store <16 x i8> %vecinit, <16 x i8>* %arr.vecptr, align 16
  %p5 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %p5, align 4
  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %p0, i32 5)
  %sorted.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %fmtS = getelementptr inbounds [3 x i8], [3 x i8]* @.str.s, i64 0, i64 0
  %call.header = call i32 (i8*, ...) @printf(i8* %fmtS, i8* %sorted.ptr)
  %base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %end = getelementptr inbounds i32, i32* %base, i64 5
  br label %loc_10E0

loc_10E0:
  %rbx.phi = phi i32* [ %base, %loc_1080 ], [ %rbx.next, %loc_10E0 ]
  %val = load i32, i32* %rbx.phi, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  %rbx.next = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  %call.print = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %cmp.cont = icmp ne i32* %rbx.next, %end
  br i1 %cmp.cont, label %loc_10E0, label %loc_10FA

loc_10FA:
  %saved.guard = load i64, i64* %canary.slot, align 8
  %cur.guard = load i64, i64* @__stack_chk_guard, align 8
  %canary.bad = icmp ne i64 %saved.guard, %cur.guard
  br i1 %canary.bad, label %loc_1115, label %loc_110A

loc_1115:
  call void @__stack_chk_fail()
  unreachable

loc_110A:
  ret i32 0
}