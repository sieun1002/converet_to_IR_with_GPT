; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @loc_140002C85(i32, i32)
declare void @sub_1402F1EA6(i8*)
declare void @loc_1402F822B(i8*)

define i32 @sub_140002390(i32 %ecx, i8* %rdx, i8* %r8) {
entry:
  %load_flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %load_flag, 0
  br i1 %tst, label %then, label %ret_zero

ret_zero:
  ret i32 0

then:
  %p = call i8* @loc_140002C85(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret_neg1, label %cont

ret_neg1:
  ret i32 -1

cont:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %ecx, i32* %p_i32, align 4
  %ptr8 = getelementptr i8, i8* %p, i64 8
  %ptr8_pp = bitcast i8* %ptr8 to i8**
  store i8* %r8, i8** %ptr8_pp, align 8
  %ptr16 = getelementptr i8, i8* %p, i64 16
  %ptr16_pp = bitcast i8* %ptr16 to i8**
  store i8* %rdx, i8** %ptr16_pp, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_1402F1EA6(i8* @unk_140007100)
  call void @loc_1402F822B(i8* @unk_140007100)
  ret i32 0
}