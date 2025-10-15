; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

; external functions referenced
declare i32 @sub_140002770()
declare i64 @sub_1400029C0()
declare void @sub_140001C00(i8*)
declare void @sub_140001BA0(i8*)
declare void @sub_1403D1F32()

; external globals referenced
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*
@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

; external string symbols referenced
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

; external code label used as a call target base
@loc_140002C55 = external global i8

define void @sub_140001D70() {
entry:
  %v = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %v, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  ret void

ret:
  ret void
}