; ModuleID = 'recovered_main.ll'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.fmt = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.expect = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8* noundef, i8* noundef, i8* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare i32 @puts(i8* noundef)

define i32 @main() sspstrong {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key64, align 16
  %key64hi = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key64hi, align 8

  ; in = 3243f6a8885a308d313198a2e0370734
  %in64 = bitcast [16 x i8]* %in to i64*
  store i64 0x8D305A88A8F64332, i64* %in64, align 16
  %in64hi = getelementptr inbounds i64, i64* %in64, i64 1
  store i64 0x340737E0A2983131, i64* %in64hi, align 8

  ; call aes128_encrypt(out, in, key)
  %outp = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %inp = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  %keyp = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* noundef %outp, i8* noundef %inp, i8* noundef %keyp)

  ; print "Ciphertext: "
  %pfx = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %pfx)

  ; loop i=0..15 printing each byte as %02x
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %iv64 = zext i32 %iv to i64
  %byteptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %iv64
  %b = load i8, i8* %byteptr, align 1
  %bz = zext i8 %b to i32
  %fmtptr = getelementptr inbounds [5 x i8], [5 x i8]* @.fmt, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %bz)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  call i32 @putchar(i32 noundef 10)
  %exp = getelementptr inbounds [45 x i8], [45 x i8]* @.expect, i64 0, i64 0
  call i32 @puts(i8* noundef %exp)
  ret i32 0
}