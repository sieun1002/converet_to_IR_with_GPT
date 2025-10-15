; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare i32 @sub_140002630()
declare void @sub_140002880()
declare void @sub_140001AD0(i8*)
declare void @sub_140002B08(i8*, i8*, i32)
declare void @sub_1400E4E7C()
declare i32 @sub_140001A70(i8*, ...)

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043B0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*
@off_1400043A0 = external dso_local global i8*
@aUnknownPseudoR = external dso_local global [1 x i8]
@aDBitPseudoRelo = external dso_local global [1 x i8]
@aUnknownPseudoR_0 = external dso_local global [1 x i8]

define void @sub_140001C40() {
entry:
  %g = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %g, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  ret void

ret:
  ret void
}