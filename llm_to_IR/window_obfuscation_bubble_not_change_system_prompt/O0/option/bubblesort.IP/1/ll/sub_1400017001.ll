; ModuleID = 'sub_140001700'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @loc_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798() noreturn

define void @sub_140001700(i64 %rcx_param, i64 %rdx_param, i64 %r8_param, i64 %r9_param) {
entry:
  %args = alloca [3 x i64], align 8
  %var20 = alloca i8*, align 8
  %ptr0 = getelementptr inbounds [3 x i64], [3 x i64]* %args, i64 0, i64 0
  store i64 %rdx_param, i64* %ptr0, align 8
  %ptr1 = getelementptr inbounds [3 x i64], [3 x i64]* %args, i64 0, i64 1
  store i64 %r8_param, i64* %ptr1, align 8
  %ptr2 = getelementptr inbounds [3 x i64], [3 x i64]* %args, i64 0, i64 2
  store i64 %r9_param, i64* %ptr2, align 8
  %ptr0_i8 = bitcast i64* %ptr0 to i8*
  store i8* %ptr0_i8, i8** %var20, align 8
  %hdl1 = call i8* @loc_140002710(i32 2)
  %str = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %hdl1, i8* %str)
  %va_ptr = load i8*, i8** %var20, align 8
  %hdl2 = call i8* @loc_140002710(i32 2)
  %fmt_ptr = inttoptr i64 %rcx_param to i8*
  call void @sub_140002560(i8* %hdl2, i8* %fmt_ptr, i8* %va_ptr)
  call void @sub_140002798()
  unreachable
}