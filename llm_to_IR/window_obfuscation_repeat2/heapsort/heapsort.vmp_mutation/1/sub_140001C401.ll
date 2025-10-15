; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i8* null, align 8

@off_1400043B0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8
@off_1400043A0 = external global i8*, align 8

@__imp_VirtualProtect = external dllimport global i8*, align 8

@aUnknownPseudoR = external global i8, align 1
@aDBitPseudoRelo = external global i8, align 1
@aUnknownPseudoR_0 = external global i8, align 1

declare i32 @sub_140002630()
declare i64 @sub_140002880()
declare void @sub_140001AD0(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @sub_140001A70(i8*, ...)

define dso_local void @sub_140001C40() {
entry:
  %t0 = load i32, i32* @dword_1400070A0, align 4
  %cmp0 = icmp eq i32 %t0, 0
  br i1 %cmp0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n = call i32 @sub_140002630()
  %n64 = sext i32 %n to i64
  %m5 = mul nsw i64 %n64, 5
  %m40 = shl i64 %m5, 3
  %add15 = add i64 %m40, 15
  %align16 = and i64 %add15, -16
  %sz = call i64 @sub_140002880()
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* null, i8** @qword_1400070A8, align 8
  br label %ret

ret:
  ret void
}