; ModuleID = 'sub_140002070.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type opaque

@qword_1400070B0 = external global i32 (%struct._exception*)*, align 8

declare i32 @__setusermatherr(i32 (%struct._exception*)*)

define i32 @sub_140002070(i32 (%struct._exception*)* %handler) {
entry:
  store i32 (%struct._exception*)* %handler, i32 (%struct._exception*)** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr(i32 (%struct._exception*)* %handler)
  ret i32 %call
}