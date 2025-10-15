; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i8* null, align 8

@off_1400043A0 = dso_local global i8* null, align 8
@off_1400043B0 = dso_local global i8* null, align 8
@off_1400043C0 = dso_local global i8* null, align 8

@__imp_VirtualProtect = external dso_local global i1 (i8*, i64, i32, i32*)*

@.str.unknown_bit = private unnamed_addr constant [40 x i8] c"  Unknown pseudo relocation bit size %d\00", align 1
@.str.range = private unnamed_addr constant [44 x i8] c"%d bit pseudo relocation at %p out of range\00", align 1
@.str.unknown_proto = private unnamed_addr constant [49 x i8] c"  Unknown pseudo relocation protocol version %d.\00", align 1

declare dso_local void @sub_140001AD0(i8* noundef)
declare dso_local void @sub_140001B30(i8* noundef)
declare dso_local i32 @sub_140002690()
declare dso_local i64 @sub_1400028E0()
declare dso_local i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)
declare dso_local i1 @VirtualProtect(i8* noundef, i64 noundef, i32 noundef, i32* noundef)

define dso_local void @sub_140001CA0() local_unnamed_addr {
entry:
  %t0 = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %t0, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  store i32 0, i32* @dword_1400070A4, align 4
  ret void

ret:
  ret void
}