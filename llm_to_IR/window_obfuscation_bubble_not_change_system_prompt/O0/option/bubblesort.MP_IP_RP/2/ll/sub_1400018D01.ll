; ModuleID = 'sub_1400018D0'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*

@aUnknownPseudoR = external global i8*
@aDBitPseudoRelo = external global i8*
@aUnknownPseudoR_0 = external global i8*

declare i32 @sub_1400022D0()
declare void @sub_140002520(i64)
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i32)
declare i32 @sub_1404E27D2()
declare void @sub_140001700(i8*, ...)

define void @sub_1400018D0() {
entry:
  %gs_flag = load i32, i32* @dword_1400070A0, align 4
  %gs_flag_zero = icmp eq i32 %gs_flag, 0
  br i1 %gs_flag_zero, label %init, label %ret

ret:
  ret void

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n32 = call i32 @sub_1400022D0()
  %n64 = sext i32 %n32 to i64
  %mul5 = mul i64 %n64, 5
  %mul40 = mul i64 %mul5, 8
  %add15 = add i64 %mul40, 15
  %align16 = and i64 %add15, -16
  call void @sub_140002520(i64 %align16)
  %endp = load i8*, i8** @off_1400043D0, align 8
  %curp = load i8*, i8** @off_1400043E0, align 8
  %dyn = alloca i8, i64 %align16, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  %base = bitcast i8* %dyn to i8*
  store i8* %base, i8** @qword_1400070A8, align 8
  %endp_int = ptrtoint i8* %endp to i64
  %curp_int = ptrtoint i8* %curp to i64
  %diff = sub i64 %endp_int, %curp_int
  %diff_le_7 = icmp sle i64 %diff, 7
  br i1 %diff_le_7, label %ret, label %ret
}