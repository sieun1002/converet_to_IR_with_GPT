; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon ; Address: 0x000011C5
; Intent: AES Rcon byte lookup for round index (confidence=0.86). Evidence: bounds check against 9 and indexed load from RCON_0
; Preconditions: none
; Postconditions: returns 0 if (idx & 0xFF) > 9; otherwise returns zero-extended RCON_0[(idx & 0xFF)]

@RCON_0 = dso_local constant [10 x i8] c"\01\02\04\08\10\20\40\80\1B\36", align 1

define dso_local i32 @rcon(i32 %idx) local_unnamed_addr {
entry:
  %idx8 = trunc i32 %idx to i8
  %cmp = icmp ugt i8 %idx8, 9
  br i1 %cmp, label %ret_zero, label %in_range

in_range:
  %idx64 = zext i8 %idx8 to i64
  %elt.ptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx64
  %val8 = load i8, i8* %elt.ptr, align 1
  %val32 = zext i8 %val8 to i32
  ret i32 %val32

ret_zero:
  ret i32 0
}