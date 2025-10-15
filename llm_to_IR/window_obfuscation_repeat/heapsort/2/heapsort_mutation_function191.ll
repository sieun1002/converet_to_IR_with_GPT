; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = dso_local global i8* null, align 8

declare dso_local i32 @__setusermatherr(i8*)

define dso_local i32 @sub_140002070(i8* %handler) {
entry:
  store i8* %handler, i8** @qword_1400070B0, align 8
  %call = musttail call i32 @__setusermatherr(i8* %handler)
  ret i32 %call
}