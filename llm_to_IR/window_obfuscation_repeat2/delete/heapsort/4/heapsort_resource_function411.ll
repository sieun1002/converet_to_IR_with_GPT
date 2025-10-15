; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043F0 = external dso_local global i8*

define dso_local i64 @sub_140002A20() {
entry:
  %0 = load i8*, i8** @off_1400043F0, align 8
  %1 = bitcast i8* %0 to i64*
  %2 = load i64, i64* %1, align 8
  ret i64 %2
}