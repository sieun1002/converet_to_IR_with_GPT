; ModuleID = 'key_schedule.ll'
target triple = "x86_64-pc-linux-gnu"

@PC1    = external constant [56 x i8], align 1
@PC2    = external constant [48 x i8], align 1
@SHIFTS = external constant [16 x i32], align 4

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define void @key_schedule(i64 %key, i64* %out) {
entry:
  %pc1.ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %perm = call i64 @permute(i64 %key, i8* %pc1.ptr, i32 56, i32 64)
  %perm_shr = lshr i64 %perm, 28
  %left32 = trunc i64 %perm_shr to i32
  %left = and i32 %left32, 268435455
  %right32 = trunc i64 %perm to i32
  %right = and i32 %right32, 268435455
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %l.phi = phi i32 [ %left, %entry ], [ %l.mask, %loop.body ]
  %r.phi = phi i32 [ %right, %entry ], [ %r.mask, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx64 = zext i32 %i to i64
  %shift.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx64
  %shift = load i32, i32* %shift.ptr, align 4
  %l.rot = call i32 @rotl28(i32 %l.phi, i32 %shift)
  %r.rot = call i32 @rotl28(i32 %r.phi, i32 %shift)
  %l.mask = and i32 %l.rot, 268435455
  %r.mask = and i32 %r.rot, 268435455
  %l64 = zext i32 %l.mask to i64
  %high = shl i64 %l64, 28
  %r64 = zext i32 %r.mask to i64
  %combined = or i64 %high, %r64
  %pc2.ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %subkey = call i64 @permute(i64 %combined, i8* %pc2.ptr, i32 48, i32 56)
  %out.elem = getelementptr inbounds i64, i64* %out, i64 %idx64
  store i64 %subkey, i64* %out.elem, align 8
  %i.next = add i32 %i, 1
  br label %loop.header

exit:
  ret void
}