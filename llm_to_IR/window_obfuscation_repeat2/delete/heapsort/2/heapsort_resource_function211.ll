target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = dso_local global i8* null, align 8

declare dso_local i32 @__setusermatherr(i8*)

define dso_local i32 @sub_140002070(i8* %0) local_unnamed_addr {
entry:
  store i8* %0, i8** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr(i8* %0)
  ret i32 %call
}