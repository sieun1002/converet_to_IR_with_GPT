; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = global i32 (i8*)* null, align 8

declare i32 @__setusermatherr(i32 (i8*)*)

define dso_local i32 @sub_140002070(i32 (i8*)* %handler) {
entry:
  store i32 (i8*)* %handler, i32 (i8*)** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr(i32 (i8*)* %handler)
  ret i32 %call
}