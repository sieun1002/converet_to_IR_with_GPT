; ModuleID = 'init_guard'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = external global i32, align 4

declare i32 @sub_140001870()

define i32 @sub_1400018F0() {
entry:
  %g = load i32, i32* @dword_140007030, align 4
  %is_zero = icmp eq i32 %g, 0
  br i1 %is_zero, label %do_init, label %ret_existing

ret_existing:
  ret i32 %g

do_init:
  store i32 1, i32* @dword_140007030, align 4
  %res = musttail call i32 @sub_140001870()
  ret i32 %res
}