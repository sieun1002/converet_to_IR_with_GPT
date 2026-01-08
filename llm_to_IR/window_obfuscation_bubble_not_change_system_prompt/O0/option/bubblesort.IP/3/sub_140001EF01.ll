; ModuleID = 'sub_140001EF0'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)
declare void @sub_1400F4AF3(i8*)
declare void @sub_1403D557D(i8*)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8
  %tst = icmp ne i32 %g, 0
  br i1 %tst, label %proceed, label %ret_zero

ret_zero:
  ret i32 0

proceed:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret_neg1, label %nonnull

ret_neg1:
  ret i32 -1

nonnull:
  %field0ptr = bitcast i8* %p to i32*
  store i32 %arg0, i32* %field0ptr
  %ptr_plus8 = getelementptr i8, i8* %p, i64 8
  %field8ptr = bitcast i8* %ptr_plus8 to i8**
  store i8* %arg1, i8** %field8ptr
  call void @sub_1400F4AF3(i8* @unk_140007100)
  %old = load i8*, i8** @qword_1400070E0
  %ptr_plus16 = getelementptr i8, i8* %p, i64 16
  %field16ptr = bitcast i8* %ptr_plus16 to i8**
  store i8* %old, i8** %field16ptr
  store i8* %p, i8** @qword_1400070E0
  call void @sub_1403D557D(i8* @unk_140007100)
  ret i32 0
}