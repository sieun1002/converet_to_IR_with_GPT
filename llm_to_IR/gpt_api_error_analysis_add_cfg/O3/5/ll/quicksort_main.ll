; ModuleID = 'main_from_0x1080_0x112d'
source_filename = "main_from_1080_to_112d"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@unk_2004 = unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_2008 = unnamed_addr constant [2 x i8] c"\0A\00", align 1
@xmmword_2010 = unnamed_addr constant <4 x i32> <i32 8, i32 3, i32 7, i32 1>, align 16
@xmmword_2020 = unnamed_addr constant <4 x i32> <i32 4, i32 9, i32 2, i32 6>, align 16
@__stack_chk_guard = external global i64, align 8

declare void @quick_sort(i32* noundef, i32 noundef, i32 noundef)
declare i32 @___printf_chk(i32 noundef, i8* noundef, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
loc_1080:
  %arr = alloca [10 x i32], align 16
  %canary = alloca i64, align 8
  %arr.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr.i8 = bitcast i32* %arr.i32 to i8*
  %guard.ld = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.ld, i64* %canary, align 8
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %v0.dst = bitcast i32* %arr.i32 to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %v0.dst, align 16
  %arr.plus4 = getelementptr inbounds i32, i32* %arr.i32, i64 4
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %v1.dst = bitcast i32* %arr.plus4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %v1.dst, align 16
  %idx8.ptr = getelementptr inbounds i32, i32* %arr.i32, i64 8
  store i32 4, i32* %idx8.ptr, align 4
  %endptr = getelementptr inbounds i8, i8* %arr.i8, i64 40
  call void @quick_sort(i32* %arr.i32, i32 0, i32 9)
  br label %loc_10E0

loc_10E0:
  %rbx.cur = phi i8* [ %arr.i8, %loc_1080 ], [ %rbx.inc, %loc_10E0 ]
  %rbx.i32p = bitcast i8* %rbx.cur to i32*
  %val = load i32, i32* %rbx.i32p, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %call.chk = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %rbx.inc = getelementptr inbounds i8, i8* %rbx.cur, i64 4
  %cmp = icmp ne i8* %rbx.inc, %endptr
  br i1 %cmp, label %loc_10E0, label %loc_10FA

loc_10FA:
  %fmt2.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2.ptr)
  %saved = load i64, i64* %canary, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %diff = sub i64 %saved, %guard2
  %tst = icmp ne i64 %diff, 0
  br i1 %tst, label %loc_1128, label %loc_111D

loc_111D:
  ret i32 0

loc_1128:
  call void @___stack_chk_fail()
  unreachable
}