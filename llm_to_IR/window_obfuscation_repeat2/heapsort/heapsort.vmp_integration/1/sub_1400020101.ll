; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global i64, align 8

define void @sub_140002010(i64 %rcx) {
entry:
  store i64 %rcx, i64* @qword_1400070B0, align 8
  ret void
}