; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon ; Address: 0x11C5
; Intent: AES round constant lookup (rcon) (confidence=0.83). Evidence: Bounds check 0..9 then byte lookup from RCON_0.
; Preconditions: Input index is truncated to 8 bits before bounds check.
; Postconditions: Returns 0 if (idx&0xFF) > 9; otherwise returns zero-extended RCON_0[(idx&0xFF)].

; Only the necessary external declarations:
@RCON_0 = external global [10 x i8], align 1

define dso_local i32 @rcon(i32 %0) local_unnamed_addr {
entry:
  %1 = trunc i32 %0 to i8
  %2 = icmp ugt i8 %1, 9
  br i1 %2, label %ret0, label %inrange

inrange:
  %idx.ext = zext i8 %1 to i64
  %gep = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx.ext
  %val = load i8, i8* %gep, align 1
  %val.z = zext i8 %val to i32
  ret i32 %val.z

ret0:
  ret i32 0
}