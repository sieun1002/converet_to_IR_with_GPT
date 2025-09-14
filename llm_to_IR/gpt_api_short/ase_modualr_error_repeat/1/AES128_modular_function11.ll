; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup ; Address: 0x11A9
; Intent: S-box table lookup: returns SBOX_1[(uint8_t)x] (confidence=0.90). Evidence: mask to AL then index into SBOX_1; movzx byte -> eax.
; Preconditions: SBOX_1 contains at least 256 entries.
; Postconditions: Return value in range [0,255].

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
@SBOX_1 = external global [256 x i8]

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @sbox_lookup(i32 %x) local_unnamed_addr {
entry:
  %idx8 = trunc i32 %x to i8
  %idx64 = zext i8 %idx8 to i64
  %elem.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx64
  %val8 = load i8, i8* %elem.ptr, align 1
  %val32 = zext i8 %val8 to i32
  ret i32 %val32
}