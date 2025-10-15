; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043F0 = external global i8*, align 8

define i8* @sub_140002A20() {
entry:
  %0 = load i8*, i8** @off_1400043F0, align 8
  %1 = bitcast i8* %0 to i8**
  %2 = load i8*, i8** %1, align 8
  ret i8* %2
}