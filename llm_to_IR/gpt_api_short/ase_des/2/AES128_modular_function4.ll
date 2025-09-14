; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key ; Address: 0x121A
; Intent: XOR 16 bytes from src into dest in-place (confidence=0.93). Evidence: loop i=0..15, load dest[i], load src[i], xor, store to dest[i].
; Preconditions: dest and src each point to at least 16 readable bytes; dest at least 16 writable bytes.
; Postconditions: for i in [0,15], dest[i] := dest[i] XOR src[i].

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @add_round_key(i8* nocapture %dest, i8* nocapture readonly %src) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; top-test loop: i from 0 to 15 inclusive
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx = zext i32 %i to i64
  %pd = getelementptr inbounds i8, i8* %dest, i64 %idx
  %ps = getelementptr inbounds i8, i8* %src, i64 %idx
  %d = load i8, i8* %pd, align 1
  %s = load i8, i8* %ps, align 1
  %x = xor i8 %d, %s
  store i8 %x, i8* %pd, align 1
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:
  ret void
}