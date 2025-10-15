; ModuleID = 'sub_140002070_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._exception = type opaque

@qword_1400070B0 = external dso_local global i32 (%struct._exception*)*, align 8

declare dso_local i32 @__setusermatherr(i32 (%struct._exception*)*)

define dso_local i32 @sub_140002070(i32 (%struct._exception*)* %0) local_unnamed_addr {
entry:
  store i32 (%struct._exception*)* %0, i32 (%struct._exception*)** @qword_1400070B0, align 8
  %1 = musttail call i32 @__setusermatherr(i32 (%struct._exception*)* %0)
  ret i32 %1
}