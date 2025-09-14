; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule ; Address: 0x135F
; Intent: Generate DES round subkeys using PC1/PC2 and left-rotations (confidence=0.93). Evidence: use of PC1/PC2 tables, 28-bit halves with SHIFTS, 16-iteration loop.
; Preconditions: out must point to space for at least 16 i64 entries.
; Postconditions: out[0..15] contain 48-bit subkeys in low bits of each i64.

@PC1 = external constant i8
@PC2 = external constant i8
@SHIFTS = external constant i32

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  %p1 = call i64 @permute(i64 %key, i8* @PC1, i32 56, i32 64)
  %p1_hi = lshr i64 %p1, 28
  %p1_hi32.tr = trunc i64 %p1_hi to i32
  %hi0 = and i32 %p1_hi32.tr, 268435455
  %p1_lo32.tr = trunc i64 %p1 to i32
  %lo0 = and i32 %p1_lo32.tr, 268435455
  br label %loop

loop:                                             ; preds = %entry, %loop_body
  %idx = phi i32 [ 0, %entry ], [ %idx.next, %loop_body ]
  %hi = phi i32 [ %hi0, %entry ], [ %hi.rot, %loop_body ]
  %lo = phi i32 [ %lo0, %entry ], [ %lo.rot, %loop_body ]
  %cond = icmp sle i32 %idx, 15
  br i1 %cond, label %loop_body, label %exit

loop_body:                                        ; preds = %loop
  %idx.ext = sext i32 %idx to i64
  %sh.ptr = getelementptr inbounds i32, i32* @SHIFTS, i64 %idx.ext
  %sh = load i32, i32* %sh.ptr, align 4
  %hi.rot = call i32 @rotl28(i32 %hi, i32 %sh)
  %lo.rot = call i32 @rotl28(i32 %lo, i32 %sh)
  %hi64 = zext i32 %hi.rot to i64
  %hi.shift = shl i64 %hi64, 28
  %lo64 = zext i32 %lo.rot to i64
  %combined = or i64 %hi.shift, %lo64
  %subkey = call i64 @permute(i64 %combined, i8* @PC2, i32 48, i32 56)
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %idx.ext
  store i64 %subkey, i64* %out.ptr, align 8
  %idx.next = add i32 %idx, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}