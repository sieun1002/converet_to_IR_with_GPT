; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon  ; Address: 0x11C5
; Intent: Lookup AES RCON byte by round index, return 0 if out of range (confidence=0.90). Evidence: access to RCON_0 table; unsigned compare against 9
; Preconditions: Only the low 8 bits of %idx are considered
; Postconditions: Returns 0 for idx > 9

@RCON_0 = external local_unnamed_addr global [10 x i8]

define dso_local i32 @rcon(i32 %idx) local_unnamed_addr {
entry:
  %t8 = trunc i32 %idx to i8
  %cmp = icmp ugt i8 %t8, 9
  br i1 %cmp, label %ret_zero, label %lookup

lookup:
  %idx_z = zext i8 %t8 to i64
  %elem.ptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx_z
  %val8 = load i8, i8* %elem.ptr, align 1
  %val32 = zext i8 %val8 to i32
  br label %ret

ret_zero:
  br label %ret

ret:
  %r = phi i32 [ 0, %ret_zero ], [ %val32, %lookup ]
  ret i32 %r
}