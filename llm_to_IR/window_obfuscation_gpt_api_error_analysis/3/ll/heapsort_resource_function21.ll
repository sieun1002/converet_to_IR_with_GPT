; ModuleID = 'sub_140002070.ll'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = dso_local global i8* null, align 8

declare dso_local i32 @__setusermatherr(i8* %handler)

define dso_local i32 @sub_140002070(i8* %handler) local_unnamed_addr {
entry:
  store i8* %handler, i8** @qword_1400070B0, align 8
  %ret = musttail call i32 @__setusermatherr(i8* %handler)
  ret i32 %ret
}