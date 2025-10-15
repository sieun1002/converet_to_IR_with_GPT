; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()
declare void @sub_140001010()

define void @start() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %rcx) {
entry:
  %saved_rcx = ptrtoint i8* %rcx to i64
  %ptrptr = bitcast i8* %rcx to i8**
  %rdx_val = load i8*, i8** %ptrptr, align 8
  %exc_code_ptr = bitcast i8* %rdx_val to i32*
  %eax_val = load i32, i32* %exc_code_ptr, align 4
  %masked = and i32 %eax_val, 553648127
  %cmp_magic = icmp eq i32 %masked, 541541187
  br i1 %cmp_magic, label %bb_130, label %bb_0A1

bb_130:                                            ; loc_140002130
  %byteptr = getelementptr i8, i8* %rdx_val, i64 4
  %b = load i8, i8* %byteptr, align 1
  %b1 = and i8 %b, 1
  %cond_b1 = icmp ne i8 %b1, 0
  br i1 %cond_b1, label %bb_0A1, label %ret_def

bb_0A1:                                            ; loc_1400020A1
  %cmp_high = icmp ugt i32 %eax_val, 3221225622
  br i1 %cmp_high, label %bb_0EF, label %bb_rangecheck

bb_rangecheck:
  %cmp_le_8B = icmp ule i32 %eax_val, 3221225611
  br i1 %cmp_le_8B, label %bb_110, label %bb_switch

bb_switch:                                         ; jump table range cases
  switch i32 %eax_val, label %ret_def [
    i32 3221225612, label %bb_0D0
    i32 3221225613, label %bb_0D0
    i32 3221225614, label %bb_0D0
    i32 3221225615, label %bb_0D0
    i32 3221225616, label %bb_0D0
    i32 3221225617, label %bb_0D0
    i32 3221225619, label %bb_0D0
    i32 3221225620, label %bb_190
    i32 3221225622, label %bb_15E
  ]

bb_110:                                            ; loc_140002110
  %is_av = icmp eq i32 %eax_val, 3221225509
  br i1 %is_av, label %bb_1C0, label %bb_110_gtcheck

bb_110_gtcheck:
  %gt_0005 = icmp ugt i32 %eax_val, 3221225509
  br i1 %gt_0005, label %bb_150, label %bb_110_else

bb_110_else:
  %is_80000002 = icmp eq i32 %eax_val, 2147483650
  br i1 %is_80000002, label %ret_def, label %bb_0EF

bb_150:                                            ; loc_140002150
  %is_0008 = icmp eq i32 %eax_val, 3221225512
  br i1 %is_0008, label %ret_def, label %bb_150_next

bb_150_next:
  %is_001D = icmp eq i32 %eax_val, 3221225533
  br i1 %is_001D, label %bb_15E, label %bb_0EF

bb_0D0:                                            ; loc_1400020D0
  %sig_dfl_ptr0 = call i8* @signal(i32 8, i8* null)
  %sig_dfl_ptr0_i = ptrtoint i8* %sig_dfl_ptr0 to i64
  %is_one_0 = icmp eq i64 %sig_dfl_ptr0_i, 1
  br i1 %is_one_0, label %bb_224, label %bb_0E6

bb_190:                                            ; loc_140002190
  %sig_dfl_ptr1 = call i8* @signal(i32 8, i8* null)
  %sig_dfl_ptr1_i = ptrtoint i8* %sig_dfl_ptr1 to i64
  %is_one_1 = icmp eq i64 %sig_dfl_ptr1_i, 1
  br i1 %is_one_1, label %bb_190_setign, label %bb_0E6

bb_190_setign:                                     ; edx=1, ecx=8; call signal; then default
  %ign_ptr0 = inttoptr i64 1 to i8*
  %_ = call i8* @signal(i32 8, i8* %ign_ptr0)
  br label %ret_def

bb_0E6:                                            ; loc_1400020E6
  %sig_prev_phi = phi i8* [ %sig_dfl_ptr0, %bb_0D0 ], [ %sig_dfl_ptr1, %bb_190 ]
  %prev_is_null = icmp eq i8* %sig_prev_phi, null
  br i1 %prev_is_null, label %bb_0EF, label %bb_1F0

bb_15E:                                            ; loc_14000215E
  %sig_dfl_ill = call i8* @signal(i32 4, i8* null)
  %sig_dfl_ill_i = ptrtoint i8* %sig_dfl_ill to i64
  %ill_is_one = icmp eq i64 %sig_dfl_ill_i, 1
  br i1 %ill_is_one, label %bb_210, label %bb_15E_test

bb_15E_test:
  %ill_is_null = icmp eq i8* %sig_dfl_ill, null
  br i1 %ill_is_null, label %bb_0EF, label %bb_15E_call

bb_15E_call:
  %ill_fn = bitcast i8* %sig_dfl_ill to void (i32)*
  call void %ill_fn(i32 4)
  br label %ret_def

bb_1C0:                                            ; loc_1400021C0
  %sig_dfl_segv = call i8* @signal(i32 11, i8* null)
  %sig_dfl_segv_i = ptrtoint i8* %sig_dfl_segv to i64
  %segv_is_one = icmp eq i64 %sig_dfl_segv_i, 1
  br i1 %segv_is_one, label %bb_1FC, label %bb_1C0_test

bb_1C0_test:
  %segv_is_null = icmp eq i8* %sig_dfl_segv, null
  br i1 %segv_is_null, label %bb_0EF, label %bb_1C0_call

bb_1C0_call:
  %segv_fn = bitcast i8* %sig_dfl_segv to void (i32)*
  call void %segv_fn(i32 11)
  br label %ret_def

bb_1F0:                                            ; loc_1400021F0
  %prev_fn = bitcast i8* %sig_prev_phi to void (i32)*
  call void %prev_fn(i32 8)
  br label %ret_def

bb_1FC:                                            ; loc_1400021FC
  %ign_ptr1 = inttoptr i64 1 to i8*
  %__ = call i8* @signal(i32 11, i8* %ign_ptr1)
  br label %ret_def

bb_210:                                            ; loc_140002210
  %ign_ptr2 = inttoptr i64 1 to i8*
  %___ = call i8* @signal(i32 4, i8* %ign_ptr2)
  br label %ret_def

bb_224:                                            ; loc_140002224
  %ign_ptr3 = inttoptr i64 1 to i8*
  %____ = call i8* @signal(i32 8, i8* %ign_ptr3)
  call void @sub_1400024E0()
  br label %ret_def

bb_0EF:                                            ; loc_1400020EF
  %fp_handler = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %is_null_fp = icmp eq i32 (i8*)* %fp_handler, null
  br i1 %is_null_fp, label %ret_zero, label %call_fp

call_fp:
  %rcx_ptr = inttoptr i64 %saved_rcx to i8*
  %res = call i32 %fp_handler(i8* %rcx_ptr)
  ret i32 %res

ret_zero:                                          ; loc_140002140
  ret i32 0

ret_def:                                           ; def_1400020C7
  ret i32 -1
}