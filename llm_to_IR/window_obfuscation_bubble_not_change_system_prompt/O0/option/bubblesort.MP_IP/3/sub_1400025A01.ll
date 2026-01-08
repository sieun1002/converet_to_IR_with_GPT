target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i8** @sub_140002650()
declare i8* @sub_140002728(i8*, i8*, i8*, i32, i8**)

define i8* @sub_1400025A0(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4) {
entry:
  %args = alloca [3 x i8*], align 8
  %args0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 0
  store i8* %arg2, i8** %args0, align 8
  %args1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 1
  store i8* %arg3, i8** %args1, align 8
  %args2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 2
  store i8* %arg4, i8** %args2, align 8
  %rdi_val = call i8* @sub_140002710(i32 1)
  %rax2 = call i8** @sub_140002650()
  %rcx_val = load i8*, i8** %rax2, align 8
  %res = call i8* @sub_140002728(i8* %rcx_val, i8* %rdi_val, i8* %arg1, i32 0, i8** %args0)
  ret i8* %res
}