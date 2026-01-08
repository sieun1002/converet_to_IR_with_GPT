; ModuleID = 'sub_140001700.ll'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @loc_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798()

define void @sub_140001700(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %arr = alloca [3 x i8*], align 8
  %gep0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 0
  store i8* %rdx, i8** %gep0, align 8
  %gep1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 1
  store i8* %r8, i8** %gep1, align 8
  %gep2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 2
  store i8* %r9, i8** %gep2, align 8
  %arrptr = bitcast [3 x i8*]* %arr to i8*
  %t0 = call i8* @loc_140002710(i32 2)
  %str = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %t0, i8* %str)
  %t1 = call i8* @loc_140002710(i32 2)
  call void @sub_140002560(i8* %t1, i8* %rcx, i8* %arrptr)
  call void @sub_140002798()
  unreachable
}