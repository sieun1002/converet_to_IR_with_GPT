; ModuleID = 'module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @loc_14030CB24()
declare void @sub_14030FAB2()
declare void @loc_140309B7C()
declare void @sub_1402EC79E()

@qword_140008278 = external global void (...)*

define void @sub_140002B50() {
entry:
  call void @loc_14030CB24()
  call void @sub_14030FAB2()
  call void @loc_140309B7C()
  call void @sub_1402EC79E()
  %0 = load void (...)*, void (...)** @qword_140008278, align 8
  %1 = bitcast void (...)* %0 to void ()*
  tail call void %1()
  ret void
}