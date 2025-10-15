; Target: Windows x64 MSVC
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = dso_local global i8* null, align 8

declare dso_local i32 @__setusermatherr()

define dso_local i32 @sub_140002070(i8* %arg0) local_unnamed_addr {
entry:
  store i8* %arg0, i8** @qword_1400070B0, align 8
  %call = tail call i32 @__setusermatherr()
  ret i32 %call
}