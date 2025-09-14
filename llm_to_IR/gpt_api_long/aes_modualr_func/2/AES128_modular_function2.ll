; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon  ; Address: 0x11C5
; Intent: AES Rcon lookup for first 10 rounds (confidence=0.95). Evidence: name 'rcon' and 10-byte table indexed by byte param
; Preconditions: @RCON_0 provides at least 10 bytes.
; Postconditions: returns zero-extended byte from RCON_0[i&0xFF] for i <= 9, else 0

@RCON_0 = external constant [10 x i8]

define dso_local i32 @rcon(i32 %i) local_unnamed_addr {
entry:
  %b = trunc i32 %i to i8
  %cmp = icmp ugt i8 %b, 9
  br i1 %cmp, label %ret_zero, label %in_range

in_range:
  %idx64 = zext i8 %b to i64
  %elem.ptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx64
  %val8 = load i8, i8* %elem.ptr, align 1
  %val32 = zext i8 %val8 to i32
  ret i32 %val32

ret_zero:
  ret i32 0
}