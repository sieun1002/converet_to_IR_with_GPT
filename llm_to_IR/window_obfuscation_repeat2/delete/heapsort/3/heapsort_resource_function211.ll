; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = global ptr null, align 8

declare i32 @__setusermatherr(ptr)

define i32 @sub_140002070(ptr %handler) {
entry:
  store ptr %handler, ptr @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr(ptr %handler)
  ret i32 %call
}