; ModuleID = 'sub_140001EF0.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_1400027E8(i32, i32)
declare void @loc_1405F6BA6(i8*)
declare void @sub_140024080(i8*)

define i32 @sub_140001EF0(i32 %ecx, i8* %rdx) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %0, 0
  br i1 %cmp, label %cond, label %ret0

ret0:
  ret i32 0

cond:
  %call = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %retm1, label %haveptr

haveptr:
  %p_i32 = bitcast i8* %call to i32*
  store i32 %ecx, i32* %p_i32, align 4
  %p8 = getelementptr inbounds i8, i8* %call, i64 8
  %p8_cast = bitcast i8* %p8 to i8**
  store i8* %rdx, i8** %p8_cast, align 8
  call void @loc_1405F6BA6(i8* @unk_140007100)
  %old = load i8*, i8** @qword_1400070E0, align 8
  %p10 = getelementptr inbounds i8, i8* %call, i64 16
  %p10_cast = bitcast i8* %p10 to i8**
  store i8* %old, i8** %p10_cast, align 8
  store i8* %call, i8** @qword_1400070E0, align 8
  call void @sub_140024080(i8* @unk_140007100)
  br label %retm1

retm1:
  ret i32 -1
}