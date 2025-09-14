; ModuleID = 'sboxes_p.ll'
source_filename = "sboxes_p"
target triple = "x86_64-unknown-linux-gnu"

@SBOX = external dso_local constant [512 x i8]
@P    = external dso_local constant [32 x i8]

declare dso_local i64 @permute(i64 %src, i8* %ptable, i32 %in_bits, i32 %out_bits)

define dso_local i64 @sboxes_p(i64 %in) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %res = phi i32 [ 0, %entry ], [ %res.new, %body ]
  %cond = icmp sle i32 %i, 7
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  ; sa = 42 - i*6
  %mul = mul nuw nsw i32 %i, 6
  %sa = sub nsw i32 42, %mul
  %sa64 = zext i32 %sa to i64

  ; chunk = (in >> sa) & 0x3F
  %shr = lshr i64 %in, %sa64
  %chunk32 = trunc i64 %shr to i32
  %chunk6 = and i32 %chunk32, 63

  ; row = ((chunk >> 4) & 2) | (chunk & 1)
  %t1 = lshr i32 %chunk6, 4
  %t2 = and i32 %t1, 2
  %t3 = and i32 %chunk6, 1
  %row = or i32 %t2, %t3

  ; col = (chunk >> 1) & 0xF
  %t4 = lshr i32 %chunk6, 1
  %col = and i32 %t4, 15

  ; s = SBOX[i*64 + row*16 + col]
  %i64 = mul nuw nsw i32 %i, 64
  %row16 = shl i32 %row, 4
  %idx32.pre = add i32 %i64, %row16
  %idx32 = add i32 %idx32.pre, %col
  %idx64 = zext i32 %idx32 to i64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %idx64
  %s8 = load i8, i8* %sbox.ptr, align 1
  %s32 = zext i8 %s8 to i32

  ; res = (res << 4) | s
  %res.shl = shl i32 %res, 4
  %res.new = or i32 %res.shl, %s32

  ; i++
  %inc = add nsw i32 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %res64 = zext i32 %res to i64
  %p.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %call = call i64 @permute(i64 %res64, i8* %p.ptr, i32 32, i32 32)
  ret i64 %call
}