; ModuleID = 'sub_140001700'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8**)
declare void @sub_140002798()

define void @sub_140001700(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %saved_rcx = alloca i8*, align 8
  %arr = alloca [3 x i8*], align 8
  %var20 = alloca i8**, align 8
  store i8* %rcx, i8** %saved_rcx, align 8
  %arr0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 0
  store i8* %rdx, i8** %arr0, align 8
  %arr1 = getelementptr inbounds i8*, i8** %arr0, i64 1
  store i8* %r8, i8** %arr1, align 8
  %arr2 = getelementptr inbounds i8*, i8** %arr0, i64 2
  store i8* %r9, i8** %arr2, align 8
  store i8** %arr0, i8*** %var20, align 8
  %call1 = call i8* @sub_140002710(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %call1, i8* %strptr)
  %args_ptr = load i8**, i8*** %var20, align 8
  %call2 = call i8* @sub_140002710(i32 2)
  %orig = load i8*, i8** %saved_rcx, align 8
  call void @sub_140002560(i8* %call2, i8* %orig, i8** %args_ptr)
  call void @sub_140002798()
  ret void
}