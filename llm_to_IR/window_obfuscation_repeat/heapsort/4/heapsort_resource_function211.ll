; ModuleID = 'ir_fix'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type opaque

@qword_1400070B0 = global i32 (%struct._exception*)* null, align 8

declare i32 @__setusermatherr(i32 (%struct._exception*)*)

define i32 @sub_140002070(i32 (%struct._exception*)* %handler) {
entry:
  store i32 (%struct._exception*)* %handler, i32 (%struct._exception*)** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr(i32 (%struct._exception*)* %handler)
  ret i32 %call
}