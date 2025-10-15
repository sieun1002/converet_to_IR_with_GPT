; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@qword_1400070B0 = dso_local global i8* null, align 8

declare dllimport i32 @__setusermatherr(i8*)

define dso_local i32 @sub_140002070(i8* %handler) {
entry:
  store i8* %handler, i8** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr(i8* %handler)
  ret i32 %call
}