; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = dso_local global i32 1
@qword_1400070E0 = dso_local global i8* null
@unk_140007100 = dso_local global [1 x i8] zeroinitializer, align 1

declare dso_local i8* @sub_140002BA8(i32, i32)
declare dso_local void @sub_1400DA76B(i8*)
declare dso_local void @sub_1403CBAAE(i8*)

define dso_local i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %flag, 0
  br i1 %cmp, label %alloc, label %ret0

ret0:
  ret i32 0

alloc:
  %p = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %retm1, label %cont

retm1:
  ret i32 -1

cont:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %gep8 = getelementptr inbounds i8, i8* %p, i64 8
  %gep8p = bitcast i8* %gep8 to i8**
  store i8* %arg1, i8** %gep8p, align 8
  %gep16 = getelementptr inbounds i8, i8* %p, i64 16
  %gep16p = bitcast i8* %gep16 to i8**
  store i8* null, i8** %gep16p, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  %unkptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_1400DA76B(i8* %unkptr)
  call void @sub_1403CBAAE(i8* %unkptr)
  ret i32 0
}