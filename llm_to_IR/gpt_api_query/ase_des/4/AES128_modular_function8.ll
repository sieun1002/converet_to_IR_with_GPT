; ModuleID = 'key_expansion.ll'
target triple = "x86_64-unknown-linux-gnu"

declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define void @key_expansion(i8* %in, i8* %out) {
entry:
  %i = alloca i32, align 4
  %idx = alloca i32, align 4
  %round = alloca i32, align 4
  %b0 = alloca i8, align 1
  %b1 = alloca i8, align 1
  %b2 = alloca i8, align 1
  %b3 = alloca i8, align 1
  %tmp = alloca i8, align 1
  store i32 0, i32* %i, align 4
  br label %copy.loop

copy.loop:                                        ; preds = %copy.body, %entry
  %i.cur = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.cur, 15
  br i1 %cmp, label %copy.body, label %copy.end

copy.body:                                        ; preds = %copy.loop
  %i64 = sext i32 %i.cur to i64
  %src.ptr = getelementptr inbounds i8, i8* %in, i64 %i64
  %val = load i8, i8* %src.ptr, align 1
  %dst.ptr = getelementptr inbounds i8, i8* %out, i64 %i64
  store i8 %val, i8* %dst.ptr, align 1
  %inc = add i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %copy.loop

copy.end:                                         ; preds = %copy.loop
  store i32 16, i32* %idx, align 4
  store i32 0, i32* %round, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %after.transform, %copy.end
  %idx.cur = load i32, i32* %idx, align 4
  %cmp2 = icmp sle i32 %idx.cur, 175
  br i1 %cmp2, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %i64_4 = sext i32 %idx.cur to i64
  %offm4 = add i64 %i64_4, -4
  %p0 = getelementptr inbounds i8, i8* %out, i64 %offm4
  %v0 = load i8, i8* %p0, align 1
  store i8 %v0, i8* %b0, align 1
  %offm3 = add i64 %i64_4, -3
  %p1 = getelementptr inbounds i8, i8* %out, i64 %offm3
  %v1 = load i8, i8* %p1, align 1
  store i8 %v1, i8* %b1, align 1
  %offm2 = add i64 %i64_4, -2
  %p2 = getelementptr inbounds i8, i8* %out, i64 %offm2
  %v2 = load i8, i8* %p2, align 1
  store i8 %v2, i8* %b2, align 1
  %offm1 = add i64 %i64_4, -1
  %p3 = getelementptr inbounds i8, i8* %out, i64 %offm1
  %v3 = load i8, i8* %p3, align 1
  store i8 %v3, i8* %b3, align 1
  %and = and i32 %idx.cur, 15
  %iszero = icmp eq i32 %and, 0
  br i1 %iszero, label %do.transform, label %after.transform

do.transform:                                     ; preds = %loop.body
  %b0v = load i8, i8* %b0, align 1
  store i8 %b0v, i8* %tmp, align 1
  %b1v = load i8, i8* %b1, align 1
  store i8 %b1v, i8* %b0, align 1
  %b2v = load i8, i8* %b2, align 1
  store i8 %b2v, i8* %b1, align 1
  %b3v = load i8, i8* %b3, align 1
  store i8 %b3v, i8* %b2, align 1
  %tmpv = load i8, i8* %tmp, align 1
  store i8 %tmpv, i8* %b3, align 1
  %b0l = load i8, i8* %b0, align 1
  %b0z = zext i8 %b0l to i32
  %sb0 = call i8 @sbox_lookup(i32 %b0z)
  store i8 %sb0, i8* %b0, align 1
  %b1l = load i8, i8* %b1, align 1
  %b1z = zext i8 %b1l to i32
  %sb1 = call i8 @sbox_lookup(i32 %b1z)
  store i8 %sb1, i8* %b1, align 1
  %b2l = load i8, i8* %b2, align 1
  %b2z = zext i8 %b2l to i32
  %sb2 = call i8 @sbox_lookup(i32 %b2z)
  store i8 %sb2, i8* %b2, align 1
  %b3l = load i8, i8* %b3, align 1
  %b3z = zext i8 %b3l to i32
  %sb3 = call i8 @sbox_lookup(i32 %b3z)
  store i8 %sb3, i8* %b3, align 1
  %round.cur = load i32, i32* %round, align 4
  %round.plus1 = add i32 %round.cur, 1
  store i32 %round.plus1, i32* %round, align 4
  %round.tr = trunc i32 %round.cur to i8
  %round.z = zext i8 %round.tr to i32
  %rc = call i8 @rcon(i32 %round.z)
  %b0cur = load i8, i8* %b0, align 1
  %rc.z = zext i8 %rc to i32
  %b0.z = zext i8 %b0cur to i32
  %xor0 = xor i32 %b0.z, %rc.z
  %xor0t = trunc i32 %xor0 to i8
  store i8 %xor0t, i8* %b0, align 1
  br label %after.transform

after.transform:                                  ; preds = %do.transform, %loop.body
  %offm16 = add i64 %i64_4, -16
  %p16 = getelementptr inbounds i8, i8* %out, i64 %offm16
  %prev0 = load i8, i8* %p16, align 1
  %prev0.z = zext i8 %prev0 to i32
  %b0f = load i8, i8* %b0, align 1
  %b0f.z = zext i8 %b0f to i32
  %x0 = xor i32 %prev0.z, %b0f.z
  %x0t = trunc i32 %x0 to i8
  %pdst0 = getelementptr inbounds i8, i8* %out, i64 %i64_4
  store i8 %x0t, i8* %pdst0, align 1
  %offm15 = add i64 %i64_4, -15
  %p15 = getelementptr inbounds i8, i8* %out, i64 %offm15
  %prev1 = load i8, i8* %p15, align 1
  %prev1.z = zext i8 %prev1 to i32
  %b1f = load i8, i8* %b1, align 1
  %b1f.z = zext i8 %b1f to i32
  %x1 = xor i32 %prev1.z, %b1f.z
  %x1t = trunc i32 %x1 to i8
  %pdst1off = add i64 %i64_4, 1
  %pdst1 = getelementptr inbounds i8, i8* %out, i64 %pdst1off
  store i8 %x1t, i8* %pdst1, align 1
  %offm14 = add i64 %i64_4, -14
  %p14 = getelementptr inbounds i8, i8* %out, i64 %offm14
  %prev2 = load i8, i8* %p14, align 1
  %prev2.z = zext i8 %prev2 to i32
  %b2f = load i8, i8* %b2, align 1
  %b2f.z = zext i8 %b2f to i32
  %x2 = xor i32 %prev2.z, %b2f.z
  %x2t = trunc i32 %x2 to i8
  %pdst2off = add i64 %i64_4, 2
  %pdst2 = getelementptr inbounds i8, i8* %out, i64 %pdst2off
  store i8 %x2t, i8* %pdst2, align 1
  %offm13 = add i64 %i64_4, -13
  %p13 = getelementptr inbounds i8, i8* %out, i64 %offm13
  %prev3 = load i8, i8* %p13, align 1
  %prev3.z = zext i8 %prev3 to i32
  %b3f = load i8, i8* %b3, align 1
  %b3f.z = zext i8 %b3f to i32
  %x3 = xor i32 %prev3.z, %b3f.z
  %x3t = trunc i32 %x3 to i8
  %pdst3off = add i64 %i64_4, 3
  %pdst3 = getelementptr inbounds i8, i8* %out, i64 %pdst3off
  store i8 %x3t, i8* %pdst3, align 1
  %idx.next = add i32 %idx.cur, 4
  store i32 %idx.next, i32* %idx, align 4
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret void
}