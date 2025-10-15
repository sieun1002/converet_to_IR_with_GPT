; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

%struct._exception = type { i32, i8*, double, double, double }

@qword_1400070B0 = dso_local global i8* null, align 8

declare dllimport i32 @_setusermatherr(i32 (%struct._exception*)*)

define dso_local i32 @sub_140002070(i32 (%struct._exception*)* %cb) local_unnamed_addr {
entry:
  %0 = bitcast i32 (%struct._exception*)* %cb to i8*
  store i8* %0, i8** @qword_1400070B0, align 8
  %1 = tail call i32 @_setusermatherr(i32 (%struct._exception*)* %cb)
  ret i32 %1
}