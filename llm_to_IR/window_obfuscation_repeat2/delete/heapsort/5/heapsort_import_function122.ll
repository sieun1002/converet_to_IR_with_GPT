; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140002240()
declare void @sub_140002BB0(i8*)
declare void @sub_1403DDA29(i8*)
declare void @sub_1400024E0()
declare i32 @sub_1400E06D5(i8*)

define i32 @sub_1400023D0(i8* %arg1, i32 %edx) {
entry:
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %bb_2498, label %bb_after_eq2

bb_after_eq2:
  %cmp_gt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_gt2, label %bb_2408, label %bb_le2

bb_le2:
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %bb_2420, label %bb_edx1

bb_edx1:
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %g0_is_zero = icmp eq i32 %g0, 0
  br i1 %g0_is_zero, label %bb_24C0, label %bb_set1_return

bb_set1_return:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

bb_2408:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %bb_240D, label %ret1

bb_240D:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_zero = icmp eq i32 %g1, 0
  br i1 %g1_zero, label %ret1, label %bb_call_2240_then_2420

bb_call_2240_then_2420:
  call void @sub_140002240()
  br label %bb_2420

bb_2420:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_nz = icmp ne i32 %g2, 0
  br i1 %g2_nz, label %bb_24B0, label %bb_check_eq1

bb_check_eq1:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_is_one = icmp eq i32 %g3, 1
  br i1 %g3_is_one, label %bb_list, label %ret1

bb_list:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %bb_246B, label %bb_loop

bb_loop:
  %current = phi i8* [ %head, %bb_list ], [ %next, %bb_loop ]
  %gep16 = getelementptr i8, i8* %current, i64 16
  %next_ptr = bitcast i8* %gep16 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  call void @sub_140002BB0(i8* %current)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %bb_loop, label %bb_246B

bb_246B:
  %p_unk = getelementptr i8, i8* @unk_140007100, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1403DDA29(i8* %p_unk)
  br label %ret1

bb_2498:
  call void @sub_1400024E0()
  br label %ret1

bb_24B0:
  call void @sub_140002240()
  br label %bb_24C0

bb_24C0:
  %p_unk2 = getelementptr i8, i8* @unk_140007100, i64 0
  %call_eax = call i32 @sub_1400E06D5(i8* %p_unk2)
  %adj = add i32 %call_eax, 57367
  %rax64 = zext i32 %adj to i64
  %addr = sub i64 %rax64, 1869574000
  %ptr = inttoptr i64 %addr to i8**
  %fp_i8 = load i8*, i8** %ptr, align 8
  %fp = bitcast i8* %fp_i8 to void ()*
  call void %fp()
  unreachable

ret1:
  ret i32 1
}