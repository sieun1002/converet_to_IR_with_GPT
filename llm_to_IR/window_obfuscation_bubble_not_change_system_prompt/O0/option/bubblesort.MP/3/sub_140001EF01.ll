; ModuleID = 'sub_140001EF0.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1
@qword_140008258 = external global void (i8*)*, align 8
@qword_140008270 = external global void (i8*)*, align 8

declare i8* @sub_1400027E8(i32, i32)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp eq i32 %g, 0
  br i1 %cmp, label %ret0, label %do

ret0:
  ret i32 0

do:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %retneg1, label %havep

retneg1:
  ret i32 -1

havep:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %p_p64 = bitcast i8* %p_plus8 to i8**
  store i8* %arg1, i8** %p_p64, align 8
  %f1ptr = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %f1ptr(i8* @unk_140007100)
  %old = load i8*, i8** @qword_1400070E0, align 8
  %p_plus16 = getelementptr inbounds i8, i8* %p, i64 16
  %p_next = bitcast i8* %p_plus16 to i8**
  store i8* %old, i8** %p_next, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  %f2ptr = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  call void %f2ptr(i8* @unk_140007100)
  ret i32 0
}