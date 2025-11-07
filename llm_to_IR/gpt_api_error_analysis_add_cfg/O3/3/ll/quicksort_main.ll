; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@unk_2004 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_2008 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@xmmword_2010 = external global <4 x i32>, align 16
@xmmword_2020 = external global <4 x i32>, align 16
@__stack_chk_guard = external global i64

declare void @quick_sort(i32* noundef, i32 noundef, i32 noundef)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
b1080:
  %arr = alloca [9 x i32], align 16
  %guard = alloca i64, align 8
  %g0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g0, i64* %guard, align 8
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %p0.vec = bitcast i32* %p0 to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %p0.vec, align 16
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %p4.vec = bitcast i32* %p4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %p4.vec, align 16
  %p8 = getelementptr inbounds i32, i32* %p0, i64 8
  store i32 4, i32* %p8, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  call void @quick_sort(i32* %p0, i32 0, i32 9)
  br label %loc_10E0

loc_10E0:
  %rbx.cur = phi i32* [ %p0, %b1080 ], [ %rbx.next, %loc_10E0 ]
  %val = load i32, i32* %rbx.cur, align 4
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt, i32 %val)
  %endptr = getelementptr inbounds i32, i32* %p0, i64 9
  %cmp = icmp ne i32* %endptr, %rbx.next
  br i1 %cmp, label %loc_10E0, label %bb10FA

bb10FA:
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl)
  %saved = load i64, i64* %guard, align 8
  %cur = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %cur
  br i1 %ok, label %bb111D, label %loc_1128

bb111D:
  ret i32 0

loc_1128:
  call void @__stack_chk_fail()
  unreachable
}