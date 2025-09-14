; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion  ; Address: 0x000015A0
; Intent: AES-128 key schedule expansion from 16-byte key into 176-byte round keys (confidence=0.96). Evidence: sbox_lookup/rcon calls; copy 16 bytes then loop to 0xAF with RotWord/SubWord/Rcon
; Preconditions: %key points to at least 16 bytes; %out points to at least 176 bytes
; Postconditions: %out[0..15] = %key[0..15]; %out[16..175] expanded per AES-128 schedule

; Only the needed extern declarations:
declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define dso_local void @key_expansion(i8* %key, i8* %out) local_unnamed_addr {
entry:
  br label %copy.cond

copy.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %copy.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %copy.body, label %post.copy

copy.body:
  %i.z = sext i32 %i to i64
  %src.ptr = getelementptr inbounds i8, i8* %key, i64 %i.z
  %dst.ptr = getelementptr inbounds i8, i8* %out, i64 %i.z
  %b = load i8, i8* %src.ptr, align 1
  store i8 %b, i8* %dst.ptr, align 1
  %i.next = add i32 %i, 1
  br label %copy.cond

post.copy:
  br label %outer.cond

outer.cond:
  %widx = phi i32 [ 16, %post.copy ], [ %widx.next, %outer.store ]
  %rconcnt = phi i32 [ 0, %post.copy ], [ %rconcnt.next, %outer.store ]
  %cmpw = icmp sle i32 %widx, 175
  br i1 %cmpw, label %outer.body, label %exit

outer.body:
  %widx.i64 = sext i32 %widx to i64
  %m4 = add i64 %widx.i64, -4
  %m3 = add i64 %widx.i64, -3
  %m2 = add i64 %widx.i64, -2
  %m1 = add i64 %widx.i64, -1
  %p.m4 = getelementptr inbounds i8, i8* %out, i64 %m4
  %p.m3 = getelementptr inbounds i8, i8* %out, i64 %m3
  %p.m2 = getelementptr inbounds i8, i8* %out, i64 %m2
  %p.m1 = getelementptr inbounds i8, i8* %out, i64 %m1
  %b0 = load i8, i8* %p.m4, align 1
  %b1 = load i8, i8* %p.m3, align 1
  %b2 = load i8, i8* %p.m2, align 1
  %b3 = load i8, i8* %p.m1, align 1
  %andmask = and i32 %widx, 15
  %isMult16 = icmp eq i32 %andmask, 0
  br i1 %isMult16, label %rot, label %no.rot

rot:
  ; rotate left by one byte
  %rb0 = %b1
  %rb1 = %b2
  %rb2 = %b3
  %rb3 = %b0
  ; SubWord via S-box
  %rb0.z = zext i8 %rb0 to i32
  %sb0 = call i8 @sbox_lookup(i32 %rb0.z)
  %rb1.z = zext i8 %rb1 to i32
  %sb1 = call i8 @sbox_lookup(i32 %rb1.z)
  %rb2.z = zext i8 %rb2 to i32
  %sb2 = call i8 @sbox_lookup(i32 %rb2.z)
  %rb3.z = zext i8 %rb3 to i32
  %sb3 = call i8 @sbox_lookup(i32 %rb3.z)
  ; rcon with old counter, then increment
  %rcon.arg8 = and i32 %rconcnt, 255
  %rc = call i8 @rcon(i32 %rcon.arg8)
  %sb0.rc = xor i8 %sb0, %rc
  %rconcnt.inc = add i32 %rconcnt, 1
  br label %merge

no.rot:
  br label %merge

merge:
  %f0 = phi i8 [ %sb0.rc, %rot ], [ %b0, %no.rot ]
  %f1 = phi i8 [ %sb1,     %rot ], [ %b1, %no.rot ]
  %f2 = phi i8 [ %sb2,     %rot ], [ %b2, %no.rot ]
  %f3 = phi i8 [ %sb3,     %rot ], [ %b3, %no.rot ]
  %rconcnt.out = phi i32 [ %rconcnt.inc, %rot ], [ %rconcnt, %no.rot ]
  ; XOR with word 16 bytes back and store
  %widx.m16 = add i64 %widx.i64, -16
  ; k = 0
  %p.m16.0 = getelementptr inbounds i8, i8* %out, i64 %widx.m16
  %prev0 = load i8, i8* %p.m16.0, align 1
  %new0 = xor i8 %prev0, %f0
  %p.cur.0 = getelementptr inbounds i8, i8* %out, i64 %widx.i64
  store i8 %new0, i8* %p.cur.0, align 1
  ; k = 1
  %widx.p1 = add i64 %widx.i64, 1
  %widx.m16.p1 = add i64 %widx.m16, 1
  %p.m16.1 = getelementptr inbounds i8, i8* %out, i64 %widx.m16.p1
  %prev1 = load i8, i8* %p.m16.1, align 1
  %new1 = xor i8 %prev1, %f1
  %p.cur.1 = getelementptr inbounds i8, i8* %out, i64 %widx.p1
  store i8 %new1, i8* %p.cur.1, align 1
  ; k = 2
  %widx.p2 = add i64 %widx.i64, 2
  %widx.m16.p2 = add i64 %widx.m16, 2
  %p.m16.2 = getelementptr inbounds i8, i8* %out, i64 %widx.m16.p2
  %prev2 = load i8, i8* %p.m16.2, align 1
  %new2 = xor i8 %prev2, %f2
  %p.cur.2 = getelementptr inbounds i8, i8* %out, i64 %widx.p2
  store i8 %new2, i8* %p.cur.2, align 1
  ; k = 3
  %widx.p3 = add i64 %widx.i64, 3
  %widx.m16.p3 = add i64 %widx.m16, 3
  %p.m16.3 = getelementptr inbounds i8, i8* %out, i64 %widx.m16.p3
  %prev3 = load i8, i8* %p.m16.3, align 1
  %new3 = xor i8 %prev3, %f3
  %p.cur.3 = getelementptr inbounds i8, i8* %out, i64 %widx.p3
  store i8 %new3, i8* %p.cur.3, align 1
  br label %outer.store

outer.store:
  %widx.next = add i32 %widx, 4
  %rconcnt.next = %rconcnt.out
  br label %outer.cond

exit:
  ret void
}