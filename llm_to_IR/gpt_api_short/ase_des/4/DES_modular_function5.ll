; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule ; Address: 0x135F
; Intent: DES key schedule: derive 16 round subkeys using PC1/PC2 and left-rotations (confidence=0.92). Evidence: use of PC1/PC2 tables, SHIFTS, rotl28, 16-iteration loop.
; Preconditions: out must point to at least 16 contiguous 8-byte slots.
; Postconditions: out[i] contains 48-bit subkeys in 64-bit slots for i in [0..15].

; Only the necessary external declarations:
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

@PC1 = external constant i8
@PC2 = external constant i8
@SHIFTS = external constant i32

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  ; Apply PC1: 64->56 bits
  %perm1 = call i64 @permute(i64 %key, i8* @PC1, i32 56, i32 64)
  %shr = lshr i64 %perm1, 28
  %c32 = trunc i64 %shr to i32
  %c28 = and i32 %c32, 268435455
  %d32 = trunc i64 %perm1 to i32
  %d28 = and i32 %d32, 268435455
  br label %loop

loop:                                             ; do-while style loop
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.end ]
  %C = phi i32 [ %c28, %entry ], [ %Cnext, %loop.end ]
  %D = phi i32 [ %d28, %entry ], [ %Dnext, %loop.end ]
  ; load shift amount for round i
  %idx64 = zext i32 %i to i64
  %shift.ptr = getelementptr inbounds i32, i32* @SHIFTS, i64 %idx64
  %shift = load i32, i32* %shift.ptr, align 4
  ; rotate C and D by shift (mod 28)
  %Cnext = call i32 @rotl28(i32 %C, i32 %shift)
  %Dnext = call i32 @rotl28(i32 %D, i32 %shift)
  ; recombine into 56-bit value
  %Cext = zext i32 %Cnext to i64
  %Cshl = shl i64 %Cext, 28
  %Dext = zext i32 %Dnext to i64
  %CD = or i64 %Cshl, %Dext
  ; Apply PC2: 56->48 bits, store as 64-bit
  %subkey = call i64 @permute(i64 %CD, i8* @PC2, i32 48, i32 56)
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %idx64
  store i64 %subkey, i64* %out.ptr, align 8
  ; increment and continue if i+1 <= 15
  %i.next = add i32 %i, 1
  br label %loop.end

loop.end:
  %cond = icmp sle i32 %i.next, 15
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}