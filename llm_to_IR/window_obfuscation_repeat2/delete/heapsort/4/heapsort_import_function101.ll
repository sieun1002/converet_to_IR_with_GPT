; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i64, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_140002BA8(i32, i32)
declare i8* @sub_1400DA76B(i8*)
declare void @sub_1403CBAAE(i8*)

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %alloc, label %ret_zero

alloc:
  %p = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret_neg1, label %have_p

have_p:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %p_plus8 = getelementptr i8, i8* %p, i64 8
  %p_ptrptr = bitcast i8* %p_plus8 to i8**
  store i8* %arg1, i8** %p_ptrptr, align 8
  %call1 = call i8* @sub_1400DA76B(i8* @unk_140007100)
  call void @sub_1403CBAAE(i8* @unk_140007100)
  br label %ret_zero

ret_zero:
  ret i32 0

ret_neg1:
  ret i32 -1
}