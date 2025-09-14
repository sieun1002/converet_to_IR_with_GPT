; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon ; Address: 0x11C5
; Intent: AES Rcon byte lookup with bounds check (confidence=0.75). Evidence: index masked to byte, unsigned compare to 9, table read from RCON_0.

; Preconditions: none
; Postconditions: returns 0 if (uint8)arg > 9; otherwise returns zero-extended RCON_0[(uint8)arg].

@RCON_0 = external dso_local constant [10 x i8], align 1

; Only the necessary external declarations:
; (none)

define dso_local i32 @rcon(i32 %arg) local_unnamed_addr {
entry:
  %b = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %b, 9
  br i1 %cmp, label %ret0, label %inrange

inrange:                                          ; preds = %entry
  %idx.ext = zext i8 %b to i64
  %elem.ptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx.ext
  %val = load i8, i8* %elem.ptr, align 1
  %zext = zext i8 %val to i32
  ret i32 %zext

ret0:                                             ; preds = %entry
  ret i32 0
}