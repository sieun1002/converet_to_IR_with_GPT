; ModuleID = 'module'
source_filename = "module"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = external global i32, align 4

declare dso_local void @sub_140001870()

define dso_local void @sub_1400018F0() local_unnamed_addr #0 {
entry:
  %load0 = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %load0, 0
  br i1 %iszero, label %set_then_jump, label %ret

set_then_jump:                                    ; preds = %entry
  store i32 1, i32* @dword_140007030, align 4
  musttail call void @sub_140001870()
  ret void

ret:                                              ; preds = %entry
  ret void
}

attributes #0 = { "frame-pointer"="none" }