; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [16 x i8] c"Sorted array: \00\00", align 1
@xmmword_2020 = external dso_local constant [16 x i8], align 16
@__stack_chk_guard = external dso_local global i64

declare dso_local void @selection_sort(i32* nocapture, i32)
declare dso_local i32 @___printf_chk(i32, i8*, ...)
declare dso_local void @___stack_chk_fail() noreturn

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define dso_local i32 @main() local_unnamed_addr {
bb_1080:
  %arr = alloca [5 x i32], align 16
  %canary = alloca i64, align 8
  %g0 = load i64, i64* @__stack_chk_guard
  store i64 %g0, i64* %canary, align 8
  %dst.i8 = bitcast [5 x i32]* %arr to i8*
  %src.i8 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2020, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %dst.i8, i8* align 16 %src.i8, i64 16, i1 false)
  %elt4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %elt4, align 4
  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %arr.ptr, i32 5)
  %sorted.str = getelementptr inbounds [16 x i8], [16 x i8]* @.str.sorted, i64 0, i64 0
  %call0 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %sorted.str)
  %endptr = getelementptr inbounds i32, i32* %arr.ptr, i64 5
  br label %bb_10E0

bb_10E0:
  %p = phi i32* [ %arr.ptr, %bb_1080 ], [ %next, %bb_10E0 ]
  %val = load i32, i32* %p, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmtptr, i32 %val)
  %next = getelementptr inbounds i32, i32* %p, i64 1
  %cond = icmp ne i32* %next, %endptr
  br i1 %cond, label %bb_10E0, label %after

after:
  %g1 = load i64, i64* @__stack_chk_guard
  %gsaved = load i64, i64* %canary, align 8
  %canm = icmp ne i64 %gsaved, %g1
  br i1 %canm, label %bb_1115, label %ret

bb_1115:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}