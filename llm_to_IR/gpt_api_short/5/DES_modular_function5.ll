; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule ; Address: 0x135F
; Intent: DES key schedule (generate 16 48-bit subkeys) (confidence=0.97). Evidence: PC1/PC2 permutations, SHIFTS table, 16-round loop.
; Preconditions: out must point to an array of at least 16 i64 entries.
; Postconditions: out[i] holds the i-th 48-bit subkey in the low bits of a 64-bit word.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)
@PC1 = external dso_local global i8
@PC2 = external dso_local global i8
@SHIFTS = external dso_local global i32

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  %pc1 = call i64 @permute(i64 %key, i8* @PC1, i32 56, i32 64)
  %hi = lshr i64 %pc1, 28
  %left0.tr = trunc i64 %hi to i32
  %left0 = and i32 %left0.tr, 268435455
  %right0.tr = trunc i64 %pc1 to i32
  %right0 = and i32 %right0.tr, 268435455
  br label %loop.header

loop.header:                                       ; preds = %entry, %loop.body
  %i = phi i32 [ 0, %entry ], [ %i.inc, %loop.body ]
  %left = phi i32 [ %left0, %entry ], [ %left.rot, %loop.body ]
  %right = phi i32 [ %right0, %entry ], [ %right.rot, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                         ; preds = %loop.header
  %idx = sext i32 %i to i64
  %shift.ptr = getelementptr inbounds i32, i32* @SHIFTS, i64 %idx
  %shift = load i32, i32* %shift.ptr, align 4
  %left.rot = call i32 @rotl28(i32 %left, i32 %shift)
  %right.rot = call i32 @rotl28(i32 %right, i32 %shift)
  %left64 = zext i32 %left.rot to i64
  %shl = shl i64 %left64, 28
  %right64 = zext i32 %right.rot to i64
  %concat = or i64 %shl, %right64
  %outptr = getelementptr inbounds i64, i64* %out, i64 %idx
  %subkey = call i64 @permute(i64 %concat, i8* @PC2, i32 48, i32 56)
  store i64 %subkey, i64* %outptr, align 8
  %i.inc = add nsw i32 %i, 1
  br label %loop.header

exit:                                              ; preds = %loop.header
  ret void
}