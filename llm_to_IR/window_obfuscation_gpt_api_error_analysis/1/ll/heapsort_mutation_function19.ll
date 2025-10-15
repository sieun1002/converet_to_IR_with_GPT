; ModuleID = 'sub_140002070.ll'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = internal global i8* null, align 8

declare i32 @__setusermatherr(i8*)

define i32 @sub_140002070(i8* %0) {
entry:
  store i8* %0, i8** @qword_1400070B0, align 8
  %1 = tail call i32 @__setusermatherr(i8* %0)
  ret i32 %1
}