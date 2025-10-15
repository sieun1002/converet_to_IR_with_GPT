; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = global i8* null, align 8

declare i32 @__setusermatherr(i8*)

define i32 @sub_140002140(i8* %arg) {
entry:
  store i8* %arg, i8** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr(i8* %arg)
  ret i32 %call
}