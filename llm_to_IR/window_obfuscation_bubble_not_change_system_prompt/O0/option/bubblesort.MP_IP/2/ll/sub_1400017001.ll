target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798()

define void @sub_140001700(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) local_unnamed_addr {
entry:
  %va = alloca [3 x i8*], align 8
  %p0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va, i32 0, i32 0
  store i8* %rdx, i8** %p0, align 8
  %p1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va, i32 0, i32 1
  store i8* %r8, i8** %p1, align 8
  %p2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va, i32 0, i32 2
  store i8* %r9, i8** %p2, align 8
  %stream1 = call i8* @sub_140002710(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %stream1, i8* %msgptr)
  %va_ptr = bitcast [3 x i8*]* %va to i8*
  %stream2 = call i8* @sub_140002710(i32 2)
  call void @sub_140002560(i8* %stream2, i8* %rcx, i8* %va_ptr)
  call void @sub_140002798()
  ret void
}