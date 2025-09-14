; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns ; Address: 0x13CD
; Intent: AES MixColumns in-place on 16-byte state (confidence=0.98). Evidence: xtime() over pairwise XORs; 4-column loop updating bytes with XOR pattern.
; Preconditions: state points to at least 16 writable bytes.
; Postconditions: state is transformed in-place by AES MixColumns.

; Only the necessary external declarations:
declare i32 @xtime(i32)

define dso_local void @mix_columns(i8* noundef %state) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %base_off = mul i32 %i, 4
  %p0 = getelementptr inbounds i8, i8* %state, i32 %base_off
  %p1 = getelementptr inbounds i8, i8* %p0, i32 1
  %p2 = getelementptr inbounds i8, i8* %p0, i32 2
  %p3 = getelementptr inbounds i8, i8* %p0, i32 3
  %a = load i8, i8* %p0, align 1
  %b = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1
  %t0 = xor i8 %a, %b
  %t1 = xor i8 %t0, %c
  %t = xor i8 %t1, %d

  ; s0 = a ^ xtime(a^b) ^ t
  %ab = xor i8 %a, %b
  %ab_z = zext i8 %ab to i32
  %xt_ab = call i32 @xtime(i32 %ab_z)
  %xt_ab_tr = trunc i32 %xt_ab to i8
  %s0u = xor i8 %xt_ab_tr, %t
  %s0n = xor i8 %a, %s0u
  store i8 %s0n, i8* %p0, align 1

  ; s1 = b ^ xtime(b^c) ^ t
  %bc = xor i8 %b, %c
  %bc_z = zext i8 %bc to i32
  %xt_bc = call i32 @xtime(i32 %bc_z)
  %xt_bc_tr = trunc i32 %xt_bc to i8
  %s1u = xor i8 %xt_bc_tr, %t
  %s1n = xor i8 %b, %s1u
  store i8 %s1n, i8* %p1, align 1

  ; s2 = c ^ xtime(c^d) ^ t
  %cd = xor i8 %c, %d
  %cd_z = zext i8 %cd to i32
  %xt_cd = call i32 @xtime(i32 %cd_z)
  %xt_cd_tr = trunc i32 %xt_cd to i8
  %s2u = xor i8 %xt_cd_tr, %t
  %s2n = xor i8 %c, %s2u
  store i8 %s2n, i8* %p2, align 1

  ; s3 = d ^ xtime(d^a) ^ t
  %da = xor i8 %d, %a
  %da_z = zext i8 %da to i32
  %xt_da = call i32 @xtime(i32 %da_z)
  %xt_da_tr = trunc i32 %xt_da to i8
  %s3u = xor i8 %xt_da_tr, %t
  %s3n = xor i8 %d, %s3u
  store i8 %s3n, i8* %p3, align 1

  br label %latch

latch:                                            ; preds = %body
  %i.next = add nuw nsw i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  ret void
}