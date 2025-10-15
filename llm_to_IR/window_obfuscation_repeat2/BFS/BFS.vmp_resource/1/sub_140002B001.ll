; ModuleID = 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"

@off_140004410 = external global i64*, align 8

define dso_local i64 @sub_140002B00() {
entry:
  %0 = load i64*, i64** @off_140004410, align 8
  %1 = load i64, i64* %0, align 8
  ret i64 %1
}