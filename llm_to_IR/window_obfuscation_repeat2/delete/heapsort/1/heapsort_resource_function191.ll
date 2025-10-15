; ModuleID = 'sub_140001CA0_module'
source_filename = "sub_140001CA0.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043B0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*
@off_1400043A0 = external dso_local global i8*

@__imp_VirtualProtect = external dso_local global i32 (i8*, i64, i32, i32*)*

@aUnknownPseudoR = external dso_local constant i8
@aDBitPseudoRelo = external dso_local constant i8
@aUnknownPseudoR_0 = external dso_local constant i8

declare dso_local i32 @sub_140002690()
declare dso_local void @sub_1400028E0()
declare dso_local void @sub_140001B30(i8*)
declare dso_local i8* @memcpy(i8*, i8*, i64)
declare dso_local i32 @sub_140001AD0(i8*, ...)

define dso_local void @sub_140001CA0() local_unnamed_addr {
entry:
  %g = load i32, i32* @dword_1400070A0, align 4
  %t0 = icmp eq i32 %g, 0
  br i1 %t0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %r = call i32 @sub_140002690()
  %r64 = sext i32 %r to i64
  %mul5 = mul i64 %r64, 5
  %mul40 = mul i64 %mul5, 8
  %add15 = add i64 %mul40, 15
  %mask = and i64 %add15, -16
  call void @sub_1400028E0()
  %dyn = alloca i8, i64 %mask, align 16
  %var50 = alloca [16 x i8], align 16
  store i32 0, i32* @dword_1400070A4, align 4
  %var50ptr = getelementptr inbounds [16 x i8], [16 x i8]* %var50, i64 0, i64 0
  store i8* %var50ptr, i8** @qword_1400070A8, align 8
  %end = load i8*, i8** @off_1400043B0, align 8
  %start = load i8*, i8** @off_1400043C0, align 8
  %endint = ptrtoint i8* %end to i64
  %startint = ptrtoint i8* %start to i64
  %diff = sub i64 %endint, %startint
  %cmp_le7 = icmp sle i64 %diff, 7
  br i1 %cmp_le7, label %ret, label %check_gt_b

check_gt_b:
  %cmp_gtb = icmp sgt i64 %diff, 11
  br i1 %cmp_gtb, label %after, label %after

after:
  br label %ret

ret:
  ret void
}