; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32, align 4
@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@off_1400043B0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8
@off_1400043A0 = external global i8*, align 8
@__imp_VirtualProtect = external global i32 (i8*, i64, i32, i32*)*, align 8

@aUnknownPseudoR = private unnamed_addr constant [40 x i8] c"  Unknown pseudo relocation bit size %d\00", align 1
@aDBitPseudoRelo = private unnamed_addr constant [44 x i8] c"%d bit pseudo relocation at %p out of range\00", align 1
@aUnknownPseudoR_0 = private unnamed_addr constant [48 x i8] c"  Unknown pseudo relocation protocol version %d\00", align 1

declare i32 @sub_140002690()
declare void @sub_1400028E0(i64)
declare void @sub_140001B30(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001CA0() local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  br label %ret

ret:
  ret void
}