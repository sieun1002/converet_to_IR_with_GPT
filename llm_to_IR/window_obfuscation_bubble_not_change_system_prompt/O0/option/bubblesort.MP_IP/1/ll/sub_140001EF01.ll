; ModuleID = 'sub_140001EF0_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)
declare i32 @loc_140023D27(i8*)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) local_unnamed_addr {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %nz = icmp ne i32 %g, 0
  br i1 %nz, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %retm1, label %init

retm1:
  ret i32 -1

init:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %p_plus8 = getelementptr i8, i8* %p, i64 8
  %p_ptrptr = bitcast i8* %p_plus8 to i8**
  store i8* %arg1, i8** %p_ptrptr, align 8
  %res = call i32 @loc_140023D27(i8* @unk_140007100)
  ret i32 %res
}