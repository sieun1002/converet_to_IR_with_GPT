; ModuleID = 'usermatherr_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i8*, double, double, double }

@qword_1400070B0 = dso_local global i32 (%struct._exception*)* null, align 8

declare dso_local void @__setusermatherr(i32 (%struct._exception*)*)

define dso_local void @sub_140002070(i32 (%struct._exception*)* %handler) {
entry:
  store i32 (%struct._exception*)* %handler, i32 (%struct._exception*)** @qword_1400070B0, align 8
  tail call void @__setusermatherr(i32 (%struct._exception*)* %handler)
  ret void
}