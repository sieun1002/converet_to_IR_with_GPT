; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = dso_local global i8* null, align 8

declare dllimport i32 @__setusermatherr(i8*)

define dso_local i32 @sub_140002070(i8* %0) {
entry:
  store i8* %0, i8** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr(i8* %0)
  ret i32 %call
}