; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1AA9
; Intent: AES-128 test vector encryption and formatted printing (confidence=0.98). Evidence: constants match FIPS-197 key/plaintext; prints expected ciphertext string.
; Preconditions: aes128_encrypt(out, in, key) must implement AES-128 ECB for a single block.
; Postconditions: Writes 16-byte ciphertext to out buffer and prints it twice (per-byte hex, then full reference string).

; Only the necessary external declarations:
declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)

@.str.cipher = private unnamed_addr constant [13 x i8] c"Ciphertext: \00"
@.str.hex = private unnamed_addr constant [5 x i8] c"%02x\00"
@.str.full = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key64, align 16
  %key64.hi = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key64.hi, align 8

  ; in = 3243f6a8885a308d313198a2e0370734
  %in64 = bitcast [16 x i8]* %in to i64*
  store i64 0x8D305A88A8F64332, i64* %in64, align 16
  %in64.hi = getelementptr inbounds i64, i64* %in64, i64 1
  store i64 0x340737E0A2983131, i64* %in64.hi, align 8

  ; call aes128_encrypt(out, in, key)
  %out.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %in.p = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  %key.p = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.p, i8* %in.p, i8* %key.p)

  ; printf("Ciphertext: ")
  %fmt.ciph = getelementptr inbounds [13 x i8], [13 x i8]* @.str.cipher, i64 0, i64 0
  %call.print = call i32 (i8*, ...) @printf(i8* %fmt.ciph)

  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %iv.zext = zext i32 %iv to i64
  %byte.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %iv.zext
  %byte = load i8, i8* %byte.p, align 1
  %byte.i32 = zext i8 %byte to i32
  %fmt.hex = getelementptr inbounds [5 x i8], [5 x i8]* @.str.hex, i64 0, i64 0
  %call.hex = call i32 (i8*, ...) @printf(i8* %fmt.hex, i32 %byte.i32)
  %inc = add i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  %ref = getelementptr inbounds [45 x i8], [45 x i8]* @.str.full, i64 0, i64 0
  %call.puts = call i32 @puts(i8* %ref)
  ret i32 0
}