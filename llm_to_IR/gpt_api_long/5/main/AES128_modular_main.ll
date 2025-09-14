; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1935
; Intent: AES-128 block encryption demo and output (confidence=0.95). Evidence: constants match NIST AES-128 test vectors; printf loop printing 16 bytes as %02x.
; Preconditions: aes128_encrypt(out, in, key) performs AES-128 block encryption on 16-byte buffers.
; Postconditions: Prints the computed ciphertext and an expected known-answer string.

@.str_ct = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str_hex = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str_expect = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1
@.pt = private unnamed_addr constant [16 x i8] [i8 50, i8 67, i8 246, i8 168, i8 136, i8 90, i8 48, i8 141, i8 49, i8 49, i8 152, i8 162, i8 224, i8 55, i8 7, i8 52], align 1
@.key = private unnamed_addr constant [16 x i8] [i8 43, i8 126, i8 21, i8 22, i8 40, i8 174, i8 210, i8 166, i8 171, i8 247, i8 21, i8 136, i8 9, i8 207, i8 79, i8 60], align 1

; Only the needed extern declarations:
declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %out.i8 = bitcast [16 x i8]* %out to i8*
  %pt.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.pt, i64 0, i64 0
  %key.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.i8, i8* %pt.ptr, i8* %key.ptr)

  %ct.str = getelementptr inbounds [13 x i8], [13 x i8]* @.str_ct, i64 0, i64 0
  %call.printf.ct = call i32 (i8*, ...) @printf(i8* %ct.str)

  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.ext = zext i32 %i to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %i.ext
  %b = load i8, i8* %byte.ptr, align 1
  %b.z = zext i8 %b to i32
  %hex.str = getelementptr inbounds [4 x i8], [4 x i8]* @.str_hex, i64 0, i64 0
  %call.printf.hex = call i32 (i8*, ...) @printf(i8* %hex.str, i32 %b.z)
  %inc = add nuw nsw i32 %i, 1
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  %exp.str = getelementptr inbounds [45 x i8], [45 x i8]* @.str_expect, i64 0, i64 0
  %call.puts = call i32 @puts(i8* %exp.str)
  ret i32 0
}