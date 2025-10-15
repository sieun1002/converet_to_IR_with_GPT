; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004470 = external global i64
@qword_140008280 = external global i8*
@off_140004480 = external global i32
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8*
@dword_140007008 = external global i32
@off_140004460 = external global i8*
@off_1400044A0 = external global i8*
@off_140004490 = external global i8*

declare i8* @sub_140002B00()
declare void @sub_14000165D(i32, i8*, i8*)
declare i32 @sub_140002B10(i32)
declare void @sub_140002BF0()
declare void @sub_140002C40(i32)
declare void @sub_140001D70()
declare i8* @sub_1403CB9E2(i8*)
declare void @sub_140002C30(i8*)
declare void @sub_140002C58(i8*, i8*, i8*)
declare i8* @sub_140002BA0(i8*)
declare void @sub_140002C20(i8*, i8*)
declare void @sub_1400019C0()
declare void @sub_140002150()
declare void @nullsub_1()

define dso_local i32 @sub_140001010() nounwind {
entry:
  ret i32 0
}