; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon  ; Address: 0x11C5
; Intent: AES Rcon constant lookup for round index 0..9 (confidence=0.95). Evidence: symbol name and bounds-checked byte table lookup
; Preconditions: Index outside [0,9] returns 0
; Postconditions: Returns zero-extended byte from RCON_0

@RCON_0 = external constant [10 x i8]

define dso_local i32 @rcon(i32 %idx) local_unnamed_addr {
entry:
  %idx8 = trunc i32 %idx to i8
  %cmp = icmp ugt i8 %idx8, 9
  br i1 %cmp, label %ret0, label %lookup

lookup:
  %idx64 = zext i8 %idx8 to i64
  %elem.ptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx64
  %val8 = load i8, i8* %elem.ptr, align 1
  %val32 = zext i8 %val8 to i32
  br label %ret

ret0:
  br label %ret

ret:
  %r = phi i32 [ 0, %ret0 ], [ %val32, %lookup ]
  ret i32 %r
}