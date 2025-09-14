; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon ; Address: 0x00000000000011C5
; Intent: AES Rcon lookup (confidence=0.92). Evidence: bounds check against 9 and indexed byte load from RCON_0
; Preconditions: None
; Postconditions: Returns 0 if index > 9; otherwise returns zero-extended RCON_0[index] as i32

; Only the necessary external declarations:
@RCON_0 = external global [10 x i8]

define dso_local i32 @rcon(i32 %arg) local_unnamed_addr {
entry:
  %trunc = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %trunc, 9
  br i1 %cmp, label %ret_zero, label %in_bounds

in_bounds:                                        ; preds = %entry
  %idx.ext = zext i8 %trunc to i64
  %base = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 0
  %ptr = getelementptr inbounds i8, i8* %base, i64 %idx.ext
  %val8 = load i8, i8* %ptr, align 1
  %val32 = zext i8 %val8 to i32
  ret i32 %val32

ret_zero:                                         ; preds = %entry
  ret i32 0
}