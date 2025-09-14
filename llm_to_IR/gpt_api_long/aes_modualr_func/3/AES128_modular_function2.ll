; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon  ; Address: 0x11C5
; Intent: AES round constant lookup (confidence=0.93). Evidence: name 'rcon', table access via RCON_0 with bounds check
; Preconditions: Index in low 8 bits of %x; valid lookup for 0..9
; Postconditions: Returns zero-extended byte from RCON_0[%x & 0xFF] for %x<=9, else 0

@RCON_0 = external constant [10 x i8]

define dso_local i32 @rcon(i32 %x) local_unnamed_addr {
entry:
  %x8 = trunc i32 %x to i8
  %xz = zext i8 %x8 to i32
  %cmp = icmp ugt i32 %xz, 9
  br i1 %cmp, label %ret_zero, label %in_range

in_range:                                         ; preds = %entry
  %idx64 = zext i8 %x8 to i64
  %eltptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx64
  %val8 = load i8, i8* %eltptr, align 1
  %val = zext i8 %val8 to i32
  ret i32 %val

ret_zero:                                         ; preds = %entry
  ret i32 0
}