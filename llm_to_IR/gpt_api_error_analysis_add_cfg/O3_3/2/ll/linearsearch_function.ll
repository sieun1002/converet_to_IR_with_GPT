; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %len, i32 %val) {
entry_1180:
  ; 0x1180: endbr64
  ; 0x1184: test esi, esi
  %cmp_len_nonpos = icmp sle i32 %len, 0
  ; 0x1186: jle short loc_11A0
  br i1 %cmp_len_nonpos, label %loc_11A0, label %loc_1188

loc_1188:                                           ; 0x1188
  ; 0x1188: movsxd rsi, esi
  %len64 = sext i32 %len to i64
  ; 0x118b: xor eax, eax
  ; 0x118d: jmp short loc_1199
  br label %loc_1199

loc_1190:                                           ; 0x1190
  ; predecessor: loc_1199 via jnz
  ; 0x1190: add rax, 1
  %idx.from.1199 = phi i64 [ %idx.cur, %loc_1199 ]
  %idx.inc = add i64 %idx.from.1199, 1
  ; 0x1194: cmp rax, rsi
  ; 0x1197: jz short loc_11A0
  %cmp_reached_end = icmp eq i64 %idx.inc, %len64
  br i1 %cmp_reached_end, label %loc_11A0, label %loc_1199

loc_1199:                                           ; 0x1199
  ; predecessors: loc_1188 (init), loc_1190 (loop)
  %idx.cur = phi i64 [ 0, %loc_1188 ], [ %idx.inc, %loc_1190 ]
  ; 0x1199: cmp [rdi+rax*4], edx
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp_ne = icmp ne i32 %elem, %val
  ; 0x119c: jnz short loc_1190
  br i1 %cmp_ne, label %loc_1190, label %loc_119e

loc_119e:                                           ; 0x119e
  ; fall-through return on match
  %retidx = trunc i64 %idx.cur to i32
  ret i32 %retidx

loc_11A0:                                           ; 0x11a0
  ; 0x11a0: mov eax, 0FFFFFFFFh
  ; 0x11a5: retn
  ret i32 -1
}