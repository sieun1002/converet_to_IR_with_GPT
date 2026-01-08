; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)
declare i32 @loc_140023D27(i8*)

define i32 @sub_140001EF0(i32 %ecx_in, i8* %rdx_in) {
entry:
  %g = load i32, i32* @dword_1400070E8
  %tst = icmp ne i32 %g, 0
  br i1 %tst, label %alloc, label %ret_zero

ret_zero:
  ret i32 0

alloc:
  %call_alloc = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %call_alloc, null
  br i1 %isnull, label %ret_neg1, label %have_mem

ret_neg1:
  ret i32 -1

have_mem:
  %p_i32 = bitcast i8* %call_alloc to i32*
  store i32 %ecx_in, i32* %p_i32
  %ptr_slot_i8 = getelementptr inbounds i8, i8* %call_alloc, i64 8
  %ptr_slot = bitcast i8* %ptr_slot_i8 to i8**
  store i8* %rdx_in, i8** %ptr_slot
  %status = call i32 @loc_140023D27(i8* @unk_140007100)
  ret i32 %status
}