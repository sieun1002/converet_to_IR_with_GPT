; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = internal global i8* null, align 8

declare i32 @__setusermatherr()

define dso_local i32 @sub_140002070(i8* %cb) local_unnamed_addr {
entry:
  store i8* %cb, i8** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr()
  ret i32 %call
}