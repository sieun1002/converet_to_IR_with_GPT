; ModuleID = 'sub_140001EF0'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_1400027E8(i32, i32)

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@qword_140008258 = external global void (i8*)*
@qword_140008270 = external global void (i8*)*
@unk_140007100 = external global i8

define i32 @sub_140001EF0(i32 %ecx, i8* %rdx) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp eq i32 %flag, 0
  br i1 %cmp0, label %ret_zero, label %cont

ret_zero:
  ret i32 0

cont:
  %call = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %ret_minus1, label %have

ret_minus1:
  ret i32 -1

have:
  %p_i32 = bitcast i8* %call to i32*
  store i32 %ecx, i32* %p_i32, align 4
  %off8 = getelementptr inbounds i8, i8* %call, i64 8
  %p_ptr = bitcast i8* %off8 to i8**
  store i8* %rdx, i8** %p_ptr, align 8
  %fp1 = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %fp1(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %off16 = getelementptr inbounds i8, i8* %call, i64 16
  %p_next = bitcast i8* %off16 to i8**
  store i8* %head, i8** %p_next, align 8
  store i8* %call, i8** @qword_1400070E0, align 8
  %fp2 = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  call void %fp2(i8* @unk_140007100)
  ret i32 0
}