target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002710(i32)
declare i64* @sub_140002650()
declare i64 @sub_140002728(i64, i64, i64, i64, i8*)

define i64 @sub_1400025A0(i64 %rcx_in, i64 %rdx_in, i64 %r8_in, i64 %r9_in) {
entry:
  %rbx = alloca i64, align 8
  store i64 %rcx_in, i64* %rbx, align 8
  %spill = alloca [3 x i64], align 8
  %spill0.ptr = getelementptr inbounds [3 x i64], [3 x i64]* %spill, i64 0, i64 0
  %rsi.ptr = bitcast i64* %spill0.ptr to i8*
  store i64 %rdx_in, i64* %spill0.ptr, align 8
  %spill1.ptr = getelementptr inbounds i64, i64* %spill0.ptr, i64 1
  store i64 %r8_in, i64* %spill1.ptr, align 8
  %spill2.ptr = getelementptr inbounds i64, i64* %spill0.ptr, i64 2
  store i64 %r9_in, i64* %spill2.ptr, align 8
  %var20 = alloca i8*, align 8
  store i8* %rsi.ptr, i8** %var20, align 8
  %call1 = call i64 @sub_140002710(i32 1)
  %rdi.save = alloca i64, align 8
  store i64 %call1, i64* %rdi.save, align 8
  %rax2.ptr = call i64* @sub_140002650()
  %rbx.val = load i64, i64* %rbx, align 8
  %rdi.val = load i64, i64* %rdi.save, align 8
  %rcx.val = load i64, i64* %rax2.ptr, align 8
  %var38 = alloca i8*, align 8
  store i8* %rsi.ptr, i8** %var38, align 8
  %ret = call i64 @sub_140002728(i64 %rcx.val, i64 %rdi.val, i64 %rbx.val, i64 0, i8* %rsi.ptr)
  ret i64 %ret
}