; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns ; Address: 0x13CD
; Intent: AES MixColumns transformation (confidence=0.95). Evidence: xtime() on pairwise XORs and in-place matrix mix over 4-byte groups
; Preconditions: state points to at least 16 bytes (AES state), aligned to 1 byte
; Postconditions: state bytes transformed in place by MixColumns

; Only the necessary external declarations:
declare zeroext i8 @xtime(i32) local_unnamed_addr

define dso_local void @mix_columns(i8* nocapture %state) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %ret

body:                                             ; preds = %loop
  %base = mul nsw i32 %i, 4
  %idx0 = sext i32 %base to i64
  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0
  %a = load i8, i8* %p0, align 1
  %base1 = add nsw i32 %base, 1
  %idx1 = sext i32 %base1 to i64
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1
  %b = load i8, i8* %p1, align 1
  %base2 = add nsw i32 %base, 2
  %idx2 = sext i32 %base2 to i64
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2
  %c = load i8, i8* %p2, align 1
  %base3 = add nsw i32 %base, 3
  %idx3 = sext i32 %base3 to i64
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3
  %d = load i8, i8* %p3, align 1

  ; t = a ^ b ^ c ^ d
  %t_ab = xor i8 %a, %b
  %t_abc = xor i8 %t_ab, %c
  %t = xor i8 %t_abc, %d

  ; new0 = a ^ xtime(a ^ b) ^ t
  %ab = xor i8 %a, %b
  %ab_zext = zext i8 %ab to i32
  %xt0 = call zeroext i8 @xtime(i32 %ab_zext)
  %x0 = xor i8 %xt0, %t
  %new0 = xor i8 %x0, %a
  store i8 %new0, i8* %p0, align 1

  ; new1 = b ^ xtime(b ^ c) ^ t
  %bc = xor i8 %b, %c
  %bc_zext = zext i8 %bc to i32
  %xt1 = call zeroext i8 @xtime(i32 %bc_zext)
  %x1 = xor i8 %xt1, %t
  %new1 = xor i8 %x1, %b
  store i8 %new1, i8* %p1, align 1

  ; new2 = c ^ xtime(c ^ d) ^ t
  %cd = xor i8 %c, %d
  %cd_zext = zext i8 %cd to i32
  %xt2 = call zeroext i8 @xtime(i32 %cd_zext)
  %x2 = xor i8 %xt2, %t
  %new2 = xor i8 %x2, %c
  store i8 %new2, i8* %p2, align 1

  ; new3 = d ^ xtime(d ^ a) ^ t
  %da = xor i8 %d, %a
  %da_zext = zext i8 %da to i32
  %xt3 = call zeroext i8 @xtime(i32 %da_zext)
  %x3 = xor i8 %xt3, %t
  %new3 = xor i8 %x3, %d
  store i8 %new3, i8* %p3, align 1

  %inc = add nsw i32 %i, 1
  br label %loop

ret:                                              ; preds = %loop
  ret void
}