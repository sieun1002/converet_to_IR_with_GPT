; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = global i32 0, align 4

declare i32 @sub_140001870()

define i32 @sub_1400018F0() {
entry:
  %val = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %val, 0
  br i1 %iszero, label %do_call, label %ret_val

ret_val:
  ret i32 %val

do_call:
  store i32 1, i32* @dword_140007030, align 4
  %tail = musttail call i32 @sub_140001870()
  ret i32 %tail
}