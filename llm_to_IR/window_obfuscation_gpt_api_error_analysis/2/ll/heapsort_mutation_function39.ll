; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043F0 = external global i8**

define i8* @sub_140002A20() {
entry:
  %p1 = load i8**, i8*** @off_1400043F0, align 8
  %p2 = load i8*, i8** %p1, align 8
  ret i8* %p2
}