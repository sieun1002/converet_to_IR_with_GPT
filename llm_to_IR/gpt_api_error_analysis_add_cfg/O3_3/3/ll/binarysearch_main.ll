; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2030 = external global <4 x i32>, align 16
@xmmword_2040 = external global <4 x i32>, align 16
@qword_2050   = external global i64, align 8
@__stack_chk_guard = external global i64, align 8

@.str.index    = private constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.notfound = private constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() local_unnamed_addr {
entry_1080:
  %arr = alloca [8 x i32], align 16
  %keys_area = alloca [12 x i8], align 8
  %saved_canary = alloca i64, align 8

  %guard_load0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard_load0, i64* %saved_canary, align 8

  %vec0 = load <4 x i32>, <4 x i32>* @xmmword_2030, align 16
  %arr_vec_ptr0 = bitcast [8 x i32]* %arr to <4 x i32>*
  store <4 x i32> %vec0, <4 x i32>* %arr_vec_ptr0, align 16

  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_2040, align 16
  %arr_second_ptr = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 4
  %arr_vec_ptr1 = bitcast i32* %arr_second_ptr to <4 x i32>*
  store <4 x i32> %vec1, <4 x i32>* %arr_vec_ptr1, align 16

  %keys_base = bitcast [12 x i8]* %keys_area to i8*
  %p0_i64 = bitcast i8* %keys_base to i64*
  %qv = load i64, i64* @qword_2050, align 8
  store i64 %qv, i64* %p0_i64, align 8
  %p8 = getelementptr inbounds i8, i8* %keys_base, i64 8
  %p8_i32 = bitcast i8* %p8 to i32*
  store i32 -5, i32* %p8_i32, align 4

  %end_ptr = getelementptr inbounds i8, i8* %keys_base, i64 12
  br label %loc_10E0

loc_10E0:                                              ; preds = %entry_1080, %loc_1127
  %r12_cur = phi i8* [ %keys_base, %entry_1080 ], [ %r12_next, %loc_1127 ]
  %r12_i32ptr = bitcast i8* %r12_cur to i32*
  %key_val = load i32, i32* %r12_i32ptr, align 4
  br label %loc_1105

loc_1105:                                              ; preds = %loc_10E0, %loc_10F0, %loc_1150
  %lo = phi i64 [ 0, %loc_10E0 ], [ %lo_in, %loc_10F0 ], [ %lo_next_1150, %loc_1150 ]
  %hi = phi i64 [ 9, %loc_10E0 ], [ %mid, %loc_10F0 ], [ %hi_in.1, %loc_1150 ]
  %key_phi = phi i32 [ %key_val, %loc_10E0 ], [ %key_phi.1, %loc_10F0 ], [ %key_phi.2, %loc_1150 ]
  %r12_passthru = phi i8* [ %r12_cur, %loc_10E0 ], [ %r12_passthru.1, %loc_10F0 ], [ %r12_passthru.2, %loc_1150 ]
  %cmp_lo_hi = icmp ult i64 %lo, %hi
  br i1 %cmp_lo_hi, label %loc_10F0, label %loc_1105_tail

loc_10F0:                                              ; preds = %loc_1105
  %lo_in = phi i64 [ %lo, %loc_1105 ]
  %hi_in = phi i64 [ %hi, %loc_1105 ]
  %key_phi.1 = phi i32 [ %key_phi, %loc_1105 ]
  %r12_passthru.1 = phi i8* [ %r12_passthru, %loc_1105 ]
  %t0 = sub i64 %hi_in, %lo_in
  %t1 = lshr i64 %t0, 1
  %mid = add i64 %t1, %lo_in
  %arr_gep_mid = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 %mid
  %val_mid = load i32, i32* %arr_gep_mid, align 4
  %cond_jg = icmp sgt i32 %key_phi.1, %val_mid
  br i1 %cond_jg, label %loc_1150, label %loc_1105

loc_1150:                                              ; preds = %loc_10F0
  %hi_in.1 = phi i64 [ %hi_in, %loc_10F0 ]
  %lo_in.1 = phi i64 [ %lo_in, %loc_10F0 ]
  %mid_in = phi i64 [ %mid, %loc_10F0 ]
  %key_phi.2 = phi i32 [ %key_phi.1, %loc_10F0 ]
  %r12_passthru.2 = phi i8* [ %r12_passthru.1, %loc_10F0 ]
  %lo_next_1150 = add i64 %mid_in, 1
  br label %loc_1105

loc_1105_tail:                                         ; preds = %loc_1105
  %cmp_lo_8 = icmp ugt i64 %lo, 8
  br i1 %cmp_lo_8, label %loc_1156, label %loc_1105_checkeq

loc_1105_checkeq:                                      ; preds = %loc_1105_tail
  %arr_idx_ptr = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 %lo
  %arr_idx_val = load i32, i32* %arr_idx_ptr, align 4
  %cmp_ne = icmp ne i32 %key_phi, %arr_idx_val
  br i1 %cmp_ne, label %loc_1156, label %loc_1118_call

loc_1118_call:                                         ; preds = %loc_1105_checkeq
  %fmt1_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.index, i64 0, i64 0
  %call_ok = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1_ptr, i32 %key_phi, i64 %lo)
  br label %loc_1127

loc_1156:                                              ; preds = %loc_1105_tail, %loc_1105_checkeq
  %key_nf = phi i32 [ %key_phi, %loc_1105_tail ], [ %key_phi, %loc_1105_checkeq ]
  %fmt2_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.notfound, i64 0, i64 0
  %call_nf = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2_ptr, i32 %key_nf)
  br label %loc_1127

loc_1127:                                              ; preds = %loc_1118_call, %loc_1156
  %r12_in = phi i8* [ %r12_passthru, %loc_1118_call ], [ %r12_passthru, %loc_1156 ]
  %r12_next = getelementptr inbounds i8, i8* %r12_in, i64 4
  %cmp_end = icmp ne i8* %end_ptr, %r12_next
  br i1 %cmp_end, label %loc_10E0, label %epilogue_check

epilogue_check:                                        ; preds = %loc_1127
  %guard_saved = load i64, i64* %saved_canary, align 8
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  %guard_eq = icmp eq i64 %guard_saved, %guard_now
  br i1 %guard_eq, label %ret_block, label %loc_116B

ret_block:                                             ; preds = %epilogue_check
  ret i32 0

loc_116B:                                              ; preds = %epilogue_check
  call void @___stack_chk_fail()
  unreachable
}