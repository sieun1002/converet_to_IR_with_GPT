; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external dso_local global [4 x i32], align 16
@xmmword_2020 = external dso_local global [4 x i32], align 16
@__stack_chk_guard = external dso_local global i64, align 8

@unk_2004 = private constant [4 x i8] c"%d \00", align 1
@unk_2008 = private constant [2 x i8] c"\0A\00", align 1

declare dso_local void @quick_sort(i32*, i32, i32)
declare dso_local i32 @___printf_chk(i32, i8*, ...)
declare dso_local void @___stack_chk_fail() noreturn

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias writeonly, i8* noalias readonly, i64, i1 immarg)

define dso_local i32 @main() {
loc_1080:
  %arr = alloca [9 x i32], align 16
  %canary.slot = alloca i64, align 8
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %canary.slot, align 8
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %arr0.i8 = bitcast i32* %arr0 to i8*
  %src2010.i8 = bitcast [4 x i32]* @xmmword_2010 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr0.i8, i8* align 16 %src2010.i8, i64 16, i1 false)
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  %arr4.i8 = bitcast i32* %arr4 to i8*
  %src2020.i8 = bitcast [4 x i32]* @xmmword_2020 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr4.i8, i8* align 16 %src2020.i8, i64 16, i1 false)
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8, align 4
  call void @quick_sort(i32* %arr0, i32 0, i32 9)
  %arr.i8 = bitcast i32* %arr0 to i8*
  %endptr = getelementptr inbounds i8, i8* %arr.i8, i64 36
  br label %loc_10E0

loc_10E0:
  %cur = phi i32* [ %arr0, %loc_1080 ], [ %cur.next, %loc_10E0 ]
  %val = load i32, i32* %cur, align 4
  %cur.next = getelementptr inbounds i32, i32* %cur, i64 1
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1, i32 %val)
  %cur.next.i8 = bitcast i32* %cur.next to i8*
  %cmp.loop = icmp ne i8* %endptr, %cur.next.i8
  br i1 %cmp.loop, label %loc_10E0, label %loc_10FA

loc_10FA:
  %fmt2 = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %saved.guard = load i64, i64* %canary.slot, align 8
  %cmp.canary = icmp ne i64 %saved.guard, %guard.now
  br i1 %cmp.canary, label %loc_1128, label %loc_111D

loc_1128:
  call void @___stack_chk_fail()
  unreachable

loc_111D:
  ret i32 0
}