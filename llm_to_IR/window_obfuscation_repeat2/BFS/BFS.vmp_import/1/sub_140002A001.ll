; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare i8** @sub_140002AF0()
declare void @sub_140002BC8(i8*, i8*, i8*, i8*, i8*)

define void @sub_140002A00(i8* %rcx_param, i8* %rdx_param, i8* %r8_param) {
entry:
  %retptr = call i8** @sub_140002AF0()
  %firstarg = load i8*, i8** %retptr, align 8
  call void @sub_140002BC8(i8* %firstarg, i8* %rcx_param, i8* %rdx_param, i8* null, i8* %r8_param)
  ret void
}