; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@unk_140007100 = external global i8, align 1

declare i8* @sub_1400027E8(i32, i32)
declare void @loc_140023D27(i8*)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %g, 0
  br i1 %cmp, label %nonzero, label %ret_zero

ret_zero:
  ret i32 0

nonzero:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %fail, label %cont

fail:
  ret i32 -1

cont:
  %p32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p32, align 4
  %p_off8 = getelementptr i8, i8* %p, i64 8
  %pptr = bitcast i8* %p_off8 to i8**
  store i8* %arg1, i8** %pptr, align 8
  call void @loc_140023D27(i8* @unk_140007100)
  ret i32 0
}