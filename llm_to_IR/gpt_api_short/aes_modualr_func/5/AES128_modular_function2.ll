; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon ; Address: 0x11C5
; Intent: AES Rcon lookup for rounds 0..9 (confidence=0.86). Evidence: bounds check against 9; index into 10-byte table RCON_0
; Preconditions: None
; Postconditions: Returns 0 if index > 9 (unsigned) after truncating to 8 bits; otherwise returns zero-extended byte from RCON_0[index]

; Only the necessary external declarations:
; (no external functions)

@RCON_0 = external constant [10 x i8], align 1

define dso_local i32 @rcon(i32 %arg) local_unnamed_addr {
entry:
  %idx8 = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %idx8, 9
  br i1 %cmp, label %ret0, label %inbounds

inbounds:                                         ; preds = %entry
  %idx64 = zext i8 %idx8 to i64
  %ptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx64
  %val8 = load i8, i8* %ptr, align 1
  %val32 = zext i8 %val8 to i32
  ret i32 %val32

ret0:                                             ; preds = %entry
  ret i32 0
}