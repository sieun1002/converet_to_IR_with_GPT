; ModuleID: 'lifted'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = external dso_local global i32, align 4
@qword_1400070E0 = external dso_local global i8*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local i8* @sub_140002BA8(i32, i32)
declare dso_local i8* @sub_1400DA76B(i8*)
declare dso_local void @sub_1403CBAAE(i8*)

define dso_local i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %if.then, label %ret_zero

ret_zero:                                         ; preds = %entry
  ret i32 0

if.then:                                          ; preds = %entry
  %saved_arg0 = alloca i32, align 4
  %saved_arg1 = alloca i8*, align 8
  %saved_p = alloca i8*, align 8
  store i32 %arg0, i32* %saved_arg0, align 4
  store i8* %arg1, i8** %saved_arg1, align 8
  %call_p = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %call_p, null
  br i1 %isnull, label %ret_minus1, label %cont

ret_minus1:                                       ; preds = %if.then
  ret i32 -1

cont:                                             ; preds = %if.then
  store i8* %call_p, i8** %saved_p, align 8
  %p_i32ptr = bitcast i8* %call_p to i32*
  %val_arg0 = load i32, i32* %saved_arg0, align 4
  store i32 %val_arg0, i32* %p_i32ptr, align 4
  %p_plus8 = getelementptr i8, i8* %call_p, i64 8
  %p_plus8_ptr = bitcast i8* %p_plus8 to i8**
  %val_arg1 = load i8*, i8** %saved_arg1, align 8
  store i8* %val_arg1, i8** %p_plus8_ptr, align 8
  %ret76 = call i8* @sub_1400DA76B(i8* @unk_140007100)
  %rcx_as_i64 = ptrtoint i8* @unk_140007100 to i64
  %ecx32 = trunc i64 %rcx_as_i64 to i32
  %addr_m = getelementptr i8, i8* %ret76, i64 -117
  %addr_m_i32 = bitcast i8* %addr_m to i32*
  %m32 = load i32, i32* %addr_m_i32, align 1
  %sub_ecx = sub i32 %ecx32, %m32
  %borrow = icmp ult i32 %ecx32, %m32
  %rax_as_i64 = ptrtoint i8* %ret76 to i64
  %eax32 = trunc i64 %rax_as_i64 to i32
  %add_base = add i32 %eax32, 19912
  %carry = zext i1 %borrow to i32
  %adc_eax = add i32 %add_base, %carry
  %p_reload = load i8*, i8** %saved_p, align 8
  %p_plus16 = getelementptr i8, i8* %p_reload, i64 16
  %p_plus16_i64 = bitcast i8* %p_plus16 to i64*
  store i64 0, i64* %p_plus16_i64, align 8
  store i8* %p_reload, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE(i8* @unk_140007100)
  ret i32 0
}