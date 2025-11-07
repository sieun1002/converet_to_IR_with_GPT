; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %count, i32 %value) {
bb_1180:                                           ; 0x1180
  ; endbr64
  %cmp_jle = icmp sle i32 %count, 0                ; test esi, esi ; jle loc_11A0
  br i1 %cmp_jle, label %loc_11a0, label %bb_1188

bb_1188:                                           ; 0x1188..0x118d
  %count64 = sext i32 %count to i64                ; movsxd rsi, esi
  br label %loc_1199                                ; jmp loc_1199

loc_1190:                                          ; 0x1190
  %idx_inc = add i64 %idx, 1                       ; add rax, 1
  %cmp_end = icmp eq i64 %idx_inc, %count64        ; cmp rax, rsi ; jz loc_11A0
  br i1 %cmp_end, label %loc_11a0, label %loc_1199

loc_1199:                                          ; 0x1199
  %idx = phi i64 [ 0, %bb_1188 ], [ %idx_inc, %loc_1190 ]
  %elem_ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %elem_ptr, align 4
  %cmp_jnz = icmp ne i32 %elem, %value             ; cmp [rdi+rax*4], edx ; jnz loc_1190
  br i1 %cmp_jnz, label %loc_1190, label %loc_119e

loc_119e:                                          ; 0x119e
  %ret_idx = trunc i64 %idx to i32
  ret i32 %ret_idx

loc_11a0:                                          ; 0x11a0
  ret i32 -1
}