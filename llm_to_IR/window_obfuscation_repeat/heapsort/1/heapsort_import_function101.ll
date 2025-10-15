; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@unk_140007100 = external global i8, align 1
@qword_1400070E0 = external global i8*, align 8

declare i8* @sub_140002BA8(i32, i32)
declare void @sub_1400DA76B(i8*)
declare void @sub_1403CBAAE()

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %gval = load i32, i32* @dword_1400070E8, align 4
  %has_flag = icmp ne i32 %gval, 0
  br i1 %has_flag, label %alloc, label %ret_zero

ret_zero:
  ret i32 0

alloc:
  %buf = call i8* @sub_140002BA8(i32 1, i32 24)
  %is_null = icmp eq i8* %buf, null
  br i1 %is_null, label %ret_fail, label %init

ret_fail:
  ret i32 -1

init:
  %buf_i32 = bitcast i8* %buf to i32*
  store i32 %arg0, i32* %buf_i32, align 4
  %buf_plus8 = getelementptr i8, i8* %buf, i64 8
  %buf_plus8_ptr = bitcast i8* %buf_plus8 to i8**
  store i8* %arg1, i8** %buf_plus8_ptr, align 8
  call void @sub_1400DA76B(i8* @unk_140007100)
  %buf_plus16 = getelementptr i8, i8* %buf, i64 16
  %buf_plus16_ptr = bitcast i8* %buf_plus16 to i8**
  store i8* null, i8** %buf_plus16_ptr, align 8
  store i8* %buf, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE()
  ret i32 0
}