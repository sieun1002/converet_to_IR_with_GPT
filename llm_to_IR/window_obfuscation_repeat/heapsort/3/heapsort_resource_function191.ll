; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = internal global i32 0, align 4
@dword_1400070A4 = internal global i32 0, align 4
@qword_1400070A8 = internal global i8* null, align 8
@off_1400043B0 = internal global i8* null, align 8
@off_1400043C0 = internal global i8* null, align 8
@off_1400043A0 = internal global i8* null, align 8

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