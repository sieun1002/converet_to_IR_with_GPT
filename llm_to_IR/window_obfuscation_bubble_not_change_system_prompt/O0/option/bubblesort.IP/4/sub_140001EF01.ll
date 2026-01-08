; ModuleID = 'sub_140001EF0'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)
declare void @sub_1400F4AF3(i8*)
declare void @sub_1403D557D(i8*)

define i32 @sub_140001EF0(i32 %ecx, i8* %rdx) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %g, 0
  br i1 %cmp, label %alloc, label %ret0

ret0:
  ret i32 0

alloc:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %fail, label %init

fail:
  ret i32 -1

init:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %ecx, i32* %p_i32, align 4
  %p_plus8 = getelementptr i8, i8* %p, i64 8
  %p_plus8_ptr = bitcast i8* %p_plus8 to i8**
  store i8* %rdx, i8** %p_plus8_ptr, align 8
  call void @sub_1400F4AF3(i8* @unk_140007100)
  %old = load i8*, i8** @qword_1400070E0, align 8
  %p_plus16 = getelementptr i8, i8* %p, i64 16
  %p_plus16_ptr = bitcast i8* %p_plus16 to i8**
  store i8* %old, i8** %p_plus16_ptr, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_1403D557D(i8* @unk_140007100)
  ret i32 0
}