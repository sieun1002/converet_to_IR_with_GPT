; LLVM IR for function: main (LLVM 14)
; Target: x86_64-linux

source_filename = "binary_to_ir"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @aes128_encrypt(i8*, i8*, i8*)

define i32 @main() {
entry:
  %out = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  store [16 x i8] [i8 43, i8 126, i8 21, i8 22, i8 40, i8 174, i8 210, i8 166, i8 171, i8 247, i8 21, i8 136, i8 9, i8 207, i8 79, i8 60], [16 x i8]* %key, align 16

  ; plaintext = 3243f6a8885a308d313198a2e0370734
  store [16 x i8] [i8 50, i8 67, i8 246, i8 168, i8 136, i8 90, i8 48, i8 141, i8 49, i8 49, i8 152, i8 162, i8 224, i8 55, i8 7, i8 52], [16 x i8]* %pt, align 16

  ; aes128_encrypt(out, plaintext, key)
  %out.i8 = bitcast [16 x i8]* %out to i8*
  %pt.i8 = bitcast [16 x i8]* %pt to i8*
  %key.i8 = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* %out.i8, i8* %pt.i8, i8* %key.i8)

  ; printf("Ciphertext: ")
  %fmt = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt)

  ; for (i = 0; i <= 15; i++) printf("%02x", out[i]);
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.val, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx = sext i32 %i.val to i64
  %out.elem.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %byte = load i8, i8* %out.elem.ptr, align 1
  %byte.z = zext i8 %byte to i32
  %fmt2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %byte.z)
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

loop.end:
  ; putchar('\n')
  call i32 @putchar(i32 10)

  ; puts("Ciphertext: 3925841d02dc09fbdc118597196a0b32")
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  call i32 @puts(i8* %s)

  ret i32 0
}