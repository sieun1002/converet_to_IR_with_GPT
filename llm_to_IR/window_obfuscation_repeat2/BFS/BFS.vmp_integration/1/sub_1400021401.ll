; ModuleID = 'ir_module'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = dso_local global i64 0, align 8

declare dso_local void @loc_140002C60(...)

define dso_local void @sub_140002140(i64 %rcx_arg) {
entry:
  store i64 %rcx_arg, i64* @qword_1400070B0, align 8
  tail call void (...) @loc_140002C60()
  ret void
}