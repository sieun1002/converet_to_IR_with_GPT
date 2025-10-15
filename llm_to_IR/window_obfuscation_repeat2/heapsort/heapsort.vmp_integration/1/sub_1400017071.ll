; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_1400E7EAF()

define i64 @sub_140001707(i64 %rbx_in, i64 %r12_in) {
entry:
  %sum1 = add i64 %rbx_in, %r12_in
  %sum2 = add i64 %sum1, 799448468
  call void @loc_1400E7EAF()
  ret i64 %sum2
}