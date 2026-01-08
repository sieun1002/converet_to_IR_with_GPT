; ModuleID = 'sub_1400025A0.ll'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i8** @sub_140002650()
declare i8* @sub_140002728(i8*, i8*, i8*, i32)

define i8* @sub_1400025A0(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %call0 = call i8* @sub_140002710(i32 1)
  %call1 = call i8** @sub_140002650()
  %0 = load i8*, i8** %call1, align 8
  %call2 = call i8* @sub_140002728(i8* %0, i8* %call0, i8* %rcx, i32 0)
  ret i8* %call2
}