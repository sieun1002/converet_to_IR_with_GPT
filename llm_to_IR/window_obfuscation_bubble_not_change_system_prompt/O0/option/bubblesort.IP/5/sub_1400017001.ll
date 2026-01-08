target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @loc_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798() noreturn

define void @sub_140001700(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %arg8_slot = alloca i8*, align 8
  %arg10_slot = alloca i8*, align 8
  %arg18_slot = alloca i8*, align 8
  %var20 = alloca i8**, align 8
  store i8* %rdx, i8** %arg8_slot, align 8
  store i8* %r8, i8** %arg10_slot, align 8
  store i8* %r9, i8** %arg18_slot, align 8
  store i8** %arg8_slot, i8*** %var20, align 8
  %call1 = call i8* @loc_140002710(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %call1, i8* %strptr)
  %tmp0 = load i8**, i8*** %var20, align 8
  %call2 = call i8* @loc_140002710(i32 2)
  %r8arg = bitcast i8** %tmp0 to i8*
  call void @sub_140002560(i8* %call2, i8* %rcx, i8* %r8arg)
  call void @sub_140002798()
  unreachable
}