; ModuleID = 'recovered_main'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@unk_2004 = dso_local constant [4 x i8] c"%d \00", align 1
@unk_2008 = dso_local constant [2 x i8] c"\0A\00", align 1
@xmmword_2010 = external dso_local global <4 x i32>, align 16
@xmmword_2020 = external dso_local global <4 x i32>, align 16
@__stack_chk_guard = external dso_local global i64, align 8

declare dso_local void @quick_sort(i32* noundef, i32 noundef, i32 noundef)
declare dso_local i32 @___printf_chk(i32 noundef, i8* noundef, ...)
declare dso_local void @___stack_chk_fail() noreturn

define dso_local i32 @main() {
loc_1080:
  %buf = alloca [48 x i8], align 16
  %buf.base.i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  %end.ptr = getelementptr inbounds i8, i8* %buf.base.i8, i64 36
  %slot.ptr = bitcast i8* %end.ptr to i64*
  store i64 %guard0, i64* %slot.ptr, align 8
  %vec0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %ptr.vec0 = bitcast i8* %buf.base.i8 to <4 x i32>*
  store <4 x i32> %vec0, <4 x i32>* %ptr.vec0, align 16
  %ptr.vec1.i8 = getelementptr inbounds i8, i8* %buf.base.i8, i64 16
  %ptr.vec1 = bitcast i8* %ptr.vec1.i8 to <4 x i32>*
  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vec1, <4 x i32>* %ptr.vec1, align 16
  %base.i32 = bitcast i8* %buf.base.i8 to i32*
  %idx8 = getelementptr inbounds i32, i32* %base.i32, i64 8
  store i32 4, i32* %idx8, align 4
  %q.base = bitcast i8* %buf.base.i8 to i32*
  call void @quick_sort(i32* noundef %q.base, i32 noundef 0, i32 noundef 9)
  br label %loc_10DC

loc_10DC:
  br label %loc_10E0

loc_10E0:
  %rbx.cur = phi i8* [ %buf.base.i8, %loc_10DC ], [ %rbx.next.2, %loc_10F5 ]
  %rbx.cur.i32p = bitcast i8* %rbx.cur to i32*
  %val = load i32, i32* %rbx.cur.i32p, align 4
  %rbx.next = getelementptr inbounds i8, i8* %rbx.cur, i64 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 noundef 2, i8* noundef %fmt.ptr, i32 noundef %val)
  br label %loc_10F5

loc_10F5:
  %rbx.next.2 = phi i8* [ %rbx.next, %loc_10E0 ]
  %cmp = icmp ne i8* %end.ptr, %rbx.next.2
  br i1 %cmp, label %loc_10E0, label %loc_10FA

loc_10FA:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 noundef 2, i8* noundef %nl.ptr)
  br label %loc_110D

loc_110D:
  %saved = load i64, i64* %slot.ptr, align 8
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %guard1
  br i1 %ok, label %loc_111D, label %loc_1128

loc_111D:
  ret i32 0

loc_1128:
  call void @___stack_chk_fail()
  unreachable
}