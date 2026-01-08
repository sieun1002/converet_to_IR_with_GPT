; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1
@qword_140008258 = external global i8*, align 8
@qword_140008270 = external global i8*, align 8

declare i8* @sub_1400027E8(i32, i32)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %0, 0
  br i1 %cmp, label %alloc, label %ret0

ret0:
  ret i32 0

alloc:
  %call = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %retm1, label %cont

retm1:
  ret i32 -1

cont:
  %p_i32 = bitcast i8* %call to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %off8 = getelementptr inbounds i8, i8* %call, i64 8
  %off8_pp = bitcast i8* %off8 to i8**
  store i8* %arg1, i8** %off8_pp, align 8
  %fp1raw = load i8*, i8** @qword_140008258, align 8
  %fp1 = bitcast i8* %fp1raw to void (i8*)*
  call void %fp1(i8* @unk_140007100)
  %prev = load i8*, i8** @qword_1400070E0, align 8
  %off16 = getelementptr inbounds i8, i8* %call, i64 16
  %off16_pp = bitcast i8* %off16 to i8**
  store i8* %prev, i8** %off16_pp, align 8
  store i8* %call, i8** @qword_1400070E0, align 8
  %fp2raw = load i8*, i8** @qword_140008270, align 8
  %fp2 = bitcast i8* %fp2raw to void (i8*)*
  call void %fp2(i8* @unk_140007100)
  ret i32 0
}