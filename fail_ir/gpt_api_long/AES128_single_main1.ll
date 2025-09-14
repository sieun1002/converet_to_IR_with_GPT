; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1AA9
; Intent: AES-128 encrypt a fixed plaintext with a fixed key, print ciphertext bytes and a known reference line (confidence=0.93). Evidence: Constants match NIST AES-128 test vector; calls aes128_encrypt and prints hex bytes.
; Preconditions: aes128_encrypt expects 16-byte buffers for output, plaintext, and key.
; Postconditions: Prints the computed ciphertext in hex, a newline, and a reference ciphertext line; returns 0.

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1
@.key = private unnamed_addr constant [16 x i8] c"\2B\7E\15\16\28\AE\D2\A6\AB\F7\15\88\09\CF\4F\3C", align 16
@.pt = private unnamed_addr constant [16 x i8] c"\32\43\F6\A8\88\5A\30\8D\31\31\98\A2\E0\37\07\34", align 16

; Only the needed extern declarations:
declare void @aes128_encrypt(i8*, i8*, i8*) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr
declare i32 @puts(i8*) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16

  %out.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %pt.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.pt, i64 0, i64 0
  %key.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.ptr, i8* %pt.ptr, i8* %key.ptr)

  %fmt0 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0)

  br label %loop

loop:                                             ; preds = %entry, %body
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cond = icmp sle i32 %i, 15
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %idx64 = sext i32 %i to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx64
  %b = load i8, i8* %byte.ptr, align 1
  %bz = zext i8 %b to i32
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %bz)
  %inc = add i32 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  %call.puts = call i32 @puts(i8* %s)
  ret i32 0
}