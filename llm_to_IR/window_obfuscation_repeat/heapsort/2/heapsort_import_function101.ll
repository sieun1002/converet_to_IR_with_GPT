; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global [1 x i8]

declare i8* @sub_140002BA8(i32, i32)
declare void @sub_1400DA76B(i8*)
declare void @sub_1403CBAAE(i8*)

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %iszero = icmp eq i32 %g, 0
  br i1 %iszero, label %ret_zero, label %cont

ret_zero:
  ret i32 0

cont:
  %p = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret_neg1, label %ok

ok:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %p_plus8 = getelementptr i8, i8* %p, i64 8
  %p_plus8_ptr = bitcast i8* %p_plus8 to i8**
  store i8* %arg1, i8** %p_plus8_ptr, align 8
  %unk_ptr = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_1400DA76B(i8* %unk_ptr)
  %p_plus16 = getelementptr i8, i8* %p, i64 16
  %p_plus16_ptr = bitcast i8* %p_plus16 to i8**
  store i8* null, i8** %p_plus16_ptr, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE(i8* %unk_ptr)
  ret i32 0

ret_neg1:
  ret i32 -1
}