; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@qword_140008258 = external global i8*, align 8
@qword_140008270 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_1400027E8(i32, i32)

define i32 @sub_140001EF0(i32 %ecx, i8* %rdx) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %cont, label %ret_zero

ret_zero:
  ret i32 0

cont:
  %call = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %fail, label %success

fail:
  ret i32 -1

success:
  %p_i32 = bitcast i8* %call to i32*
  store i32 %ecx, i32* %p_i32, align 4
  %p_plus8 = getelementptr i8, i8* %call, i64 8
  %p_plus8p = bitcast i8* %p_plus8 to i8**
  store i8* %rdx, i8** %p_plus8p, align 8
  %fpraw1 = load i8*, i8** @qword_140008258, align 8
  %fp1 = bitcast i8* %fpraw1 to void (i8*)*
  call void %fp1(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %p_plus16 = getelementptr i8, i8* %call, i64 16
  %p_plus16p = bitcast i8* %p_plus16 to i8**
  store i8* %head, i8** %p_plus16p, align 8
  store i8* %call, i8** @qword_1400070E0, align 8
  %fpraw2 = load i8*, i8** @qword_140008270, align 8
  %fp2 = bitcast i8* %fpraw2 to void (i8*)*
  call void %fp2(i8* @unk_140007100)
  ret i32 0
}