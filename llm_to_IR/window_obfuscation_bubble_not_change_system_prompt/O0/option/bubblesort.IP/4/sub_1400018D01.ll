; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32, align 4
@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@off_1400043D0 = external global i8*, align 8
@off_1400043E0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8
@loc_1400027B5 = external global i8

declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_140001700(i8*, ...)
declare i32 @sub_1400BF822()

define void @sub_1400018D0() local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %init, label %ret

init:                                             ; preds = %entry
  store i32 1, i32* @dword_1400070A0, align 4
  %n = call i32 @sub_1400022D0()
  %n.sext = sext i32 %n to i64
  %mul5 = mul i64 %n.sext, 5
  %mul8 = mul i64 %mul5, 8
  %add15 = add i64 %mul8, 15
  %align16 = and i64 %add15, -16
  %chk = call i64 @sub_140002520()
  %buf = alloca i8, i64 %align16, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %buf, i8** @qword_1400070A8, align 8
  br label %ret

ret:                                              ; preds = %init, %entry
  ret void
}