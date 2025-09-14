; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1935
; Intent: AES-128 ECB encrypt demo: encrypt a 16-byte block and print the ciphertext as hex (confidence=0.90). Evidence: call to aes128_encrypt; hex loop with "%02x" and "Ciphertext: " strings
; Preconditions:
; Postconditions:

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1
@key.bytes = private unnamed_addr constant [16 x i8] [i8 43, i8 126, i8 21, i8 22, i8 40, i8 174, i8 210, i8 166, i8 171, i8 247, i8 21, i8 136, i8 9, i8 207, i8 79, i8 60], align 16
@in.bytes = private unnamed_addr constant [16 x i8] [i8 50, i8 67, i8 246, i8 168, i8 136, i8 90, i8 48, i8 141, i8 49, i8 49, i8 152, i8 162, i8 224, i8 55, i8 7, i8 52], align 16

declare void @aes128_encrypt(i8*, i8*, i8*) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr
declare i32 @puts(i8*) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %out_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %in_i8 = getelementptr inbounds [16 x i8], [16 x i8]* @in.bytes, i64 0, i64 0
  %key_i8 = getelementptr inbounds [16 x i8], [16 x i8]* @key.bytes, i64 0, i64 0
  call void @aes128_encrypt(i8* %out_i8, i8* %in_i8, i8* %key_i8)
  %fmt_ptr = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_ptr)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %idx64 = zext i32 %i to i64
  %p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx64
  %b = load i8, i8* %p, align 1
  %bv = zext i8 %b to i32
  %fmt_hex = getelementptr inbounds [5 x i8], [5 x i8]* @.str.1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_hex, i32 %bv)
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

after:
  %putc = call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  %call2 = call i32 @puts(i8* %s)
  ret i32 0
}