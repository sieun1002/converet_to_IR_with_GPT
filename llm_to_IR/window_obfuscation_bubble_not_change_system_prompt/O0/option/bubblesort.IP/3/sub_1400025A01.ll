; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @loc_140002710(i32)
declare i8** @sub_140002650()
declare void @sub_140002728(i8*, i8*, i8*, i32, i8*)

define void @sub_1400025A0(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4) {
entry:
  %va_array = alloca [3 x i8*], align 8
  %var20 = alloca i8**, align 8
  %va_ptr0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %va_array, i64 0, i64 0
  store i8* %arg2, i8** %va_ptr0, align 8
  %va_ptr1 = getelementptr inbounds i8*, i8** %va_ptr0, i64 1
  store i8* %arg3, i8** %va_ptr1, align 8
  %va_ptr2 = getelementptr inbounds i8*, i8** %va_ptr0, i64 2
  store i8* %arg4, i8** %va_ptr2, align 8
  store i8** %va_ptr0, i8*** %var20, align 8
  %call_loc_140002710 = call i8* @loc_140002710(i32 1)
  %call_sub_140002650 = call i8** @sub_140002650()
  %rcx_val = load i8*, i8** %call_sub_140002650, align 8
  %rsi_as_i8 = bitcast i8** %va_ptr0 to i8*
  call void @sub_140002728(i8* %rcx_val, i8* %call_loc_140002710, i8* %arg1, i32 0, i8* %rsi_as_i8)
  ret void
}