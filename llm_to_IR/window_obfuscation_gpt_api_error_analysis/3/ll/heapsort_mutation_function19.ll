; ModuleID = 'sub_140002070.ll'
source_filename = "sub_140002070.ll"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = global i8* null, align 8

declare i32 @__setusermatherr(i8* noundef)

define i32 @sub_140002070(i8* noundef %handler) {
entry:
  store i8* %handler, i8** @qword_1400070B0, align 8
  %tail = musttail call i32 @__setusermatherr(i8* noundef %handler)
  ret i32 %tail
}