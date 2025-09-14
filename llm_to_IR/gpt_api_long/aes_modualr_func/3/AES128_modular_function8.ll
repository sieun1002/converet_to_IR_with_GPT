; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion  ; Address: 0x000015A0
; Intent: AES-128 key expansion (176-byte schedule) (confidence=0.95). Evidence: copy 16-byte key, S-box + Rcon, 176-byte output
; Preconditions: %key readable for at least 16 bytes; %expanded writable for at least 176 bytes
; Postconditions: Writes expanded key schedule to %expanded[0..175]

; Only the needed extern declarations:
declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define dso_local void @key_expansion(i8* %key, i8* %expanded) local_unnamed_addr {
entry:
  br label %copy.loop

copy.loop:                                           ; i = 0..15
  %ci = phi i32 [ 0, %entry ], [ %ci.next, %copy.body ]
  %copy.cond = icmp sle i32 %ci, 15
  br i1 %copy.cond, label %copy.body, label %after.copy

copy.body:
  %ci.ext = sext i32 %ci to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %ci.ext
  %key.val = load i8, i8* %key.ptr, align 1
  %exp.ptr = getelementptr inbounds i8, i8* %expanded, i64 %ci.ext
  store i8 %key.val, i8* %exp.ptr, align 1
  %ci.next = add nsw i32 %ci, 1
  br label %copy.loop

after.copy:
  br label %loop.header

loop.header:                                         ; i from 16 to 175 step 4
  %i = phi i32 [ 16, %after.copy ], [ %i.next, %write.after ]
  %rc = phi i32 [ 0, %after.copy ], [ %rc.after, %write.after ]
  %cont = icmp sle i32 %i, 175
  br i1 %cont, label %load.body, label %exit

load.body:
  %i.m4 = add nsw i32 %i, -4
  %i.m3 = add nsw i32 %i, -3
  %i.m2 = add nsw i32 %i, -2
  %i.m1 = add nsw i32 %i, -1
  %i.m4.ext = sext i32 %i.m4 to i64
  %i.m3.ext = sext i32 %i.m3 to i64
  %i.m2.ext = sext i32 %i.m2 to i64
  %i.m1.ext = sext i32 %i.m1 to i64
  %p.m4 = getelementptr inbounds i8, i8* %expanded, i64 %i.m4.ext
  %p.m3 = getelementptr inbounds i8, i8* %expanded, i64 %i.m3.ext
  %p.m2 = getelementptr inbounds i8, i8* %expanded, i64 %i.m2.ext
  %p.m1 = getelementptr inbounds i8, i8* %expanded, i64 %i.m1.ext
  %t0 = load i8, i8* %p.m4, align 1
  %t1 = load i8, i8* %p.m3, align 1
  %t2 = load i8, i8* %p.m2, align 1
  %t3 = load i8, i8* %p.m1, align 1
  %mask = and i32 %i, 15
  %is0 = icmp eq i32 %mask, 0
  br i1 %is0, label %do.rot, label %skip.rot

do.rot:                                              ; rotate, sbox, rcon
  ; RotWord
  %ra = zext i8 %t1 to i32
  %rb = zext i8 %t2 to i32
  %rc_ = zext i8 %t3 to i32
  %rd = zext i8 %t0 to i32
  ; SubWord via S-box
  %sa = call i8 @sbox_lookup(i32 %ra)
  %sb = call i8 @sbox_lookup(i32 %rb)
  %sc = call i8 @sbox_lookup(i32 %rc_)
  %sd = call i8 @sbox_lookup(i32 %rd)
  ; Rcon with pre-increment old rc low byte
  %oldrc.trunc = trunc i32 %rc to i8
  %oldrc.z = zext i8 %oldrc.trunc to i32
  %rcon.byte = call i8 @rcon(i32 %oldrc.z)
  %rc.next = add nsw i32 %rc, 1
  %temp0.r = xor i8 %sa, %rcon.byte
  br label %after.cond

skip.rot:
  br label %after.cond

after.cond:
  %temp0 = phi i8 [ %temp0.r, %do.rot ], [ %t0, %skip.rot ]
  %temp1 = phi i8 [ %sb, %do.rot ], [ %t1, %skip.rot ]
  %temp2 = phi i8 [ %sc, %do.rot ], [ %t2, %skip.rot ]
  %temp3 = phi i8 [ %sd, %do.rot ], [ %t3, %skip.rot ]
  %rc.after = phi i32 [ %rc.next, %do.rot ], [ %rc, %skip.rot ]

  ; w[i + k] = w[i - 16 + k] XOR temp[k], for k=0..3
  %i.m16 = add nsw i32 %i, -16
  %i.m16.ext = sext i32 %i.m16 to i64
  %i.ext = sext i32 %i to i64

  ; k = 0
  %prev0.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.m16.ext
  %prev0 = load i8, i8* %prev0.ptr, align 1
  %out0.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.ext
  %out0 = xor i8 %prev0, %temp0
  store i8 %out0, i8* %out0.ptr, align 1

  ; k = 1
  %i.m16.p1 = add nsw i64 %i.m16.ext, 1
  %prev1.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.m16.p1
  %prev1 = load i8, i8* %prev1.ptr, align 1
  %i.p1 = add nsw i64 %i.ext, 1
  %out1.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.p1
  %out1 = xor i8 %prev1, %temp1
  store i8 %out1, i8* %out1.ptr, align 1

  ; k = 2
  %i.m16.p2 = add nsw i64 %i.m16.ext, 2
  %prev2.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.m16.p2
  %prev2 = load i8, i8* %prev2.ptr, align 1
  %i.p2 = add nsw i64 %i.ext, 2
  %out2.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.p2
  %out2 = xor i8 %prev2, %temp2
  store i8 %out2, i8* %out2.ptr, align 1

  ; k = 3
  %i.m16.p3 = add nsw i64 %i.m16.ext, 3
  %prev3.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.m16.p3
  %prev3 = load i8, i8* %prev3.ptr, align 1
  %i.p3 = add nsw i64 %i.ext, 3
  %out3.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.p3
  %out3 = xor i8 %prev3, %temp3
  store i8 %out3, i8* %out3.ptr, align 1

write.after:
  %i.next = add nsw i32 %i, 4
  br label %loop.header

exit:
  ret void
}