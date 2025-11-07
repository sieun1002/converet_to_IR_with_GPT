; ModuleID = 'linear_search'
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %val) {
bb_1180:
  ; 0x1184: test esi, esi
  %cmp_len_le0 = icmp sle i32 %len, 0
  ; 0x1186: jle short loc_11A0
  br i1 %cmp_len_le0, label %loc_11A0, label %bb_1188

bb_1188:
  ; 0x1188: movsxd rsi, esi
  %len64_init = sext i32 %len to i64
  ; 0x118b: xor eax, eax  (handled via PHI with 0)
  ; 0x118d: jmp short loc_1199
  br label %loc_1199

loc_1190:                                           ; preds = %loc_1199
  ; 0x1190: add rax, 1
  %idx_inc = add i64 %idx_phi, 1
  ; 0x1194: cmp rax, rsi
  %cmp_idx_eq_len = icmp eq i64 %idx_inc, %len64_phi
  ; 0x1197: jz short loc_11A0
  ; fall-through to loc_1199 otherwise
  br i1 %cmp_idx_eq_len, label %loc_11A0, label %loc_1199

loc_1199:                                           ; preds = %bb_1188, %loc_1190
  ; Loop-carried values (RAX index, RSI bound)
  %idx_phi = phi i64 [ 0, %bb_1188 ], [ %idx_inc, %loc_1190 ]
  %len64_phi = phi i64 [ %len64_init, %bb_1188 ], [ %len64_phi, %loc_1190 ]
  ; 0x1199: cmp [rdi+rax*4], edx
  %elem_ptr = getelementptr inbounds i32, i32* %arr, i64 %idx_phi
  %elem_val = load i32, i32* %elem_ptr, align 4
  %cmp_ne = icmp ne i32 %elem_val, %val
  ; 0x119c: jnz short loc_1190
  ; fall-through to 0x119e retn on equality
  br i1 %cmp_ne, label %loc_1190, label %bb_119e

bb_119e:                                            ; preds = %loc_1199
  ; 0x119e: retn (success, return EAX = index)
  %ret_idx32 = trunc i64 %idx_phi to i32
  ret i32 %ret_idx32

loc_11A0:                                           ; preds = %bb_1180, %loc_1190
  ; 0x11A0: mov eax, 0FFFFFFFFh
  ; 0x11A5: retn
  ret i32 -1
}