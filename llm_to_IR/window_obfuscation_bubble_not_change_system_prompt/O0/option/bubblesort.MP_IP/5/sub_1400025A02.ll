; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i8** @sub_140002650()
declare i8* @sub_140002728(i8*, i8*, i8*, i8*, i8*)

define i8* @sub_1400025A0(i8* %arg_rcx, i8* %arg_rdx, i8* %arg_r8, i8* %arg_r9) {
entry:
  %va_area = alloca [3 x i8*], align 8
  %rbx.save = bitcast i8* %arg_rcx to i8*
  %va_ptr0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va_area, i64 0, i64 0
  store i8* %arg_rdx, i8** %va_ptr0, align 8
  %va_ptr1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va_area, i64 0, i64 1
  store i8* %arg_r8, i8** %va_ptr1, align 8
  %va_ptr2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va_area, i64 0, i64 2
  store i8* %arg_r9, i8** %va_ptr2, align 8
  %rsi.ptr = getelementptr inbounds [3 x i8*], [3 x i8*]* %va_area, i64 0, i64 0
  %call710 = call i8* @sub_140002710(i32 1)
  %call650 = call i8** @sub_140002650()
  %rcx_for_728 = load i8*, i8** %call650, align 8
  %null_r9 = bitcast i8* null to i8*
  %rsi.as.i8 = bitcast i8** %rsi.ptr to i8*
  %call728 = call i8* @sub_140002728(i8* %rcx_for_728, i8* %call710, i8* %rbx.save, i8* %null_r9, i8* %rsi.as.i8)
  ret i8* %call728
}