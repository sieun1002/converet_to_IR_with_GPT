; ModuleID = 'rcon'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rcon  ; Address: 0x11C5
; Intent: AES Rcon byte lookup by round (0..9), else 0 (confidence=0.90). Evidence: function name "rcon"; bounds check against 9 with table lookup
; Preconditions: Only the low 8 bits of the input are considered.
; Postconditions: Returns 0 if (input & 0xFF) > 9; otherwise returns zero-extended table byte.

@RCON_0 = external constant [10 x i8], align 1

define dso_local i32 @rcon(i32 %arg) local_unnamed_addr {
entry:
  %t = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %t, 9
  br i1 %cmp, label %oob, label %inb

inb:
  %idxz = zext i8 %t to i64
  %gep = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idxz
  %val8 = load i8, i8* %gep, align 1
  %val32 = zext i8 %val8 to i32
  br label %ret

oob:
  br label %ret

ret:
  %res = phi i32 [ 0, %oob ], [ %val32, %inb ]
  ret i32 %res
}