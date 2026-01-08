target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = external global i8, align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798()

define void @sub_140001700(i8* %0, i8* %1, i8* %2, i8* %3) noreturn {
entry:
  %va_save = alloca [3 x i8*], align 8
  %var20 = alloca i8*, align 8
  %gep0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va_save, i64 0, i64 0
  store i8* %1, i8** %gep0, align 8
  %gep1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va_save, i64 0, i64 1
  store i8* %2, i8** %gep1, align 8
  %gep2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va_save, i64 0, i64 2
  store i8* %3, i8** %gep2, align 8
  %addr_arg8 = bitcast i8** %gep0 to i8*
  store i8* %addr_arg8, i8** %var20, align 8
  %ctx1 = call i8* @sub_140002710(i32 2)
  call void @sub_140002600(i8* %ctx1, i8* @aMingwW64Runtim)
  %rsi_ptr = load i8*, i8** %var20, align 8
  %ctx2 = call i8* @sub_140002710(i32 2)
  call void @sub_140002560(i8* %ctx2, i8* %0, i8* %rsi_ptr)
  call void @sub_140002798()
  unreachable
}