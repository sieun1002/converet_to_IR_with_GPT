; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon  ; Address: 0x11C5
; Intent: AES Rcon byte lookup by round index 0..9 (confidence=0.90). Evidence: bounds check >9 then table byte fetch from RCON_0
; Preconditions: Index is taken modulo 256 (low 8 bits used).
; Postconditions: Returns 0 if index > 9; otherwise returns zero-extended byte from RCON_0[index].

@RCON_0 = external constant [10 x i8], align 1

define dso_local i32 @rcon(i32 %x) local_unnamed_addr {
entry:
  %t8 = trunc i32 %x to i8
  %cmp = icmp ugt i8 %t8, 9
  br i1 %cmp, label %ret_zero, label %in_range

in_range:                                         ; preds = %entry
  %idx = zext i8 %t8 to i64
  %p = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx
  %v8 = load i8, i8* %p, align 1
  %v32 = zext i8 %v8 to i32
  ret i32 %v32

ret_zero:                                         ; preds = %entry
  ret i32 0
}