; ModuleID = 'sub_140001EF0_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)
declare void @sub_1400D1A4D(i8*)
declare void @sub_1400FEC0A(i8*)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %flag = load i32, i32* @dword_1400070E8
  %flag_nonzero = icmp ne i32 %flag, 0
  br i1 %flag_nonzero, label %alloc, label %ret_zero

alloc:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret_minus1, label %init

init:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32
  %p_plus8 = getelementptr i8, i8* %p, i64 8
  %p_ptr = bitcast i8* %p_plus8 to i8**
  store i8* %arg1, i8** %p_ptr
  call void @sub_1400D1A4D(i8* @unk_140007100)
  %old_head = load i8*, i8** @qword_1400070E0
  %p_plus16 = getelementptr i8, i8* %p, i64 16
  %p_next = bitcast i8* %p_plus16 to i8**
  store i8* %old_head, i8** %p_next
  store i8* %p, i8** @qword_1400070E0
  call void @sub_1400FEC0A(i8* @unk_140007100)
  br label %ret_zero

ret_minus1:
  ret i32 -1

ret_zero:
  ret i32 0
}