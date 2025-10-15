; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@qword_140008278 = external global i8*

declare i32 @loc_1403E6A8E(...)
declare i32 @loc_1400E35C2(...)
declare i32 @sub_1403DEB78(...)
declare i32 @loc_14002A223(...)

define void @sub_140002B50() {
entry:
  %c1 = call i32 (...) @loc_1403E6A8E()
  %c2 = call i32 (...) @loc_1400E35C2()
  %c3 = call i32 (...) @sub_1403DEB78()
  %c4 = call i32 (...) @loc_14002A223()
  %p = load i8*, i8** @qword_140008278
  %fp = bitcast i8* %p to void ()*
  tail call void %fp()
  ret void
}