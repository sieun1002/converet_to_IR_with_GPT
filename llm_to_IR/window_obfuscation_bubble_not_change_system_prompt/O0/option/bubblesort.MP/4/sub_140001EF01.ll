; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8
@qword_140008258 = external global void (i8*)*
@qword_140008270 = external global void (i8*)*

declare i8* @sub_1400027E8(i32, i32)

define i32 @sub_140001EF0(i32 %ecx_in, i8* %rdx_in) {
entry:
  %g = load i32, i32* @dword_1400070E8
  %nz = icmp ne i32 %g, 0
  br i1 %nz, label %cont, label %ret_zero

ret_zero:
  ret i32 0

cont:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %fail, label %have

fail:
  ret i32 -1

have:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %ecx_in, i32* %p_i32, align 4

  %p_plus8 = getelementptr i8, i8* %p, i64 8
  %p8_ptr = bitcast i8* %p_plus8 to i8**
  store i8* %rdx_in, i8** %p8_ptr, align 8

  %fp1_ptr = load void (i8*)*, void (i8*)** @qword_140008258
  call void %fp1_ptr(i8* @unk_140007100)

  %old = load i8*, i8** @qword_1400070E0
  %p_plus16 = getelementptr i8, i8* %p, i64 16
  %p16_ptr = bitcast i8* %p_plus16 to i8**
  store i8* %old, i8** %p16_ptr, align 8

  store i8* %p, i8** @qword_1400070E0

  %fp2_ptr = load void (i8*)*, void (i8*)** @qword_140008270
  call void %fp2_ptr(i8* @unk_140007100)

  ret i32 0
}