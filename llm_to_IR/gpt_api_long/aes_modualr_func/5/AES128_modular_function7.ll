; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns  ; Address: 0x13CD
; Intent: AES MixColumns transform on 16-byte state in place (confidence=0.98). Evidence: 4-column loop with xtime over adjacent bytes; XOR pattern matches 2/3 GF(2^8) coefficients.

; Preconditions: %state points to at least 16 writable bytes (AES state).
; Postconditions: State is transformed in place per AES MixColumns.

; Only the needed extern declarations:
declare zeroext i8 @xtime(i32)

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %check

check:
  %i = phi i32 [ 0, entry ], [ %inc, %check_back ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:
  %mul = mul nuw nsw i32 %i, 4
  %idx0 = sext i32 %mul to i64
  %add1 = add nuw nsw i32 %mul, 1
  %idx1 = sext i32 %add1 to i64
  %add2 = add nuw nsw i32 %mul, 2
  %idx2 = sext i32 %add2 to i64
  %add3 = add nuw nsw i32 %mul, 3
  %idx3 = sext i32 %add3 to i64

  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3

  %a0 = load i8, i8* %p0, align 1
  %a1 = load i8, i8* %p1, align 1
  %a2 = load i8, i8* %p2, align 1
  %a3 = load i8, i8* %p3, align 1

  %t0 = xor i8 %a0, %a1
  %t1 = xor i8 %t0, %a2
  %t = xor i8 %t1, %a3

  ; new a0
  %x01 = xor i8 %a0, %a1
  %x01_z = zext i8 %x01 to i32
  %xt0 = call zeroext i8 @xtime(i32 %x01_z)
  %tmp0 = xor i8 %xt0, %t
  %n0 = xor i8 %a0, %tmp0
  store i8 %n0, i8* %p0, align 1

  ; new a1
  %x12 = xor i8 %a1, %a2
  %x12_z = zext i8 %x12 to i32
  %xt1 = call zeroext i8 @xtime(i32 %x12_z)
  %tmp1 = xor i8 %xt1, %t
  %n1 = xor i8 %a1, %tmp1
  store i8 %n1, i8* %p1, align 1

  ; new a2
  %x23 = xor i8 %a2, %a3
  %x23_z = zext i8 %x23 to i32
  %xt2 = call zeroext i8 @xtime(i32 %x23_z)
  %tmp2 = xor i8 %xt2, %t
  %n2 = xor i8 %a2, %tmp2
  store i8 %n2, i8* %p2, align 1

  ; new a3
  %x30 = xor i8 %a3, %a0
  %x30_z = zext i8 %x30 to i32
  %xt3 = call zeroext i8 @xtime(i32 %x30_z)
  %tmp3 = xor i8 %xt3, %t
  %n3 = xor i8 %a3, %tmp3
  store i8 %n3, i8* %p3, align 1

  br label %check_back

check_back:
  %inc = add nuw nsw i32 %i, 1
  br label %check

exit:
  ret void
}