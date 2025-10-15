; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_140002BA8(i32, i32)
declare void @sub_1400DA76B(i8*)
declare void @sub_1403CBAAE(i8*)

define i32 @sub_1400022B0(i32 %a, i8* %b, i8* %c) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %cont, label %ret_zero

ret_zero:
  ret i32 0

cont:
  %ptr = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %ptr, null
  br i1 %isnull, label %ret_m1, label %have_ptr

ret_m1:
  ret i32 -1

have_ptr:
  %p_i32 = bitcast i8* %ptr to i32*
  store i32 %a, i32* %p_i32, align 4
  %p_off8 = getelementptr i8, i8* %ptr, i64 8
  %p_ptr8 = bitcast i8* %p_off8 to i8**
  store i8* %c, i8** %p_ptr8, align 8
  %p_off16 = getelementptr i8, i8* %ptr, i64 16
  %p_ptr16 = bitcast i8* %p_off16 to i8**
  store i8* null, i8** %p_ptr16, align 8
  store i8* %ptr, i8** @qword_1400070E0, align 8
  call void @sub_1400DA76B(i8* @unk_140007100)
  call void @sub_1403CBAAE(i8* @unk_140007100)
  ret i32 0
}