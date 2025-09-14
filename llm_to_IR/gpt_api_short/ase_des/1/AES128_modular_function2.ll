; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon ; Address: 0x11C5
; Intent: AES Rcon lookup for rounds 0..9 (confidence=0.95). Evidence: bounds check against 9 and byte lookup from RCON_0 table.
; Preconditions: @RCON_0 points to at least 10 bytes.
; Postconditions: returns zero-extended byte RCON_0[index] for index in [0,9], else 0.

; Only the necessary external declarations:
@RCON_0 = external dso_local global i8

define dso_local i32 @rcon(i32 %arg) local_unnamed_addr {
entry:
  %b = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %b, 9
  br i1 %cmp, label %ret_zero, label %in_bounds

in_bounds:
  %idx = zext i8 %b to i64
  %p = getelementptr inbounds i8, i8* @RCON_0, i64 %idx
  %v8 = load i8, i8* %p, align 1
  %v = zext i8 %v8 to i32
  br label %exit

ret_zero:
  br label %exit

exit:
  %rv = phi i32 [ 0, %ret_zero ], [ %v, %in_bounds ]
  ret i32 %rv
}