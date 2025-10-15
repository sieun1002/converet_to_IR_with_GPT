; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_1400029B0(i8*, i8*, i8*, i8*)
declare void @sub_140002A88(i8*, i8*, i8*, i8*)

define void @sub_140002960(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %arg10_slot = alloca i8*, align 8
  %arg18_slot = alloca i8*, align 8
  %var20_slot = alloca i8**, align 8
  %var38_slot = alloca i8**, align 8
  store i8* %r8, i8** %arg10_slot, align 8
  store i8* %r9, i8** %arg18_slot, align 8
  store i8** %arg10_slot, i8*** %var20_slot, align 8
  %call1 = call i8* @sub_1400029B0(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9)
  %ptrptr = bitcast i8* %call1 to i8**
  %loaded = load i8*, i8** %ptrptr, align 8
  store i8** %arg10_slot, i8*** %var38_slot, align 8
  call void @sub_140002A88(i8* %loaded, i8* %rcx, i8* %rdx, i8* null)
  ret void
}