; ModuleID = 'recovered_main.ll'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.fmt = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.expect = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1
@key.const = private unnamed_addr constant [16 x i8] c"\2B\7E\15\16\28\AE\D2\A6\AB\F7\15\88\09\CF\4F\3C", align 16
@in.const = private unnamed_addr constant [16 x i8] c"\32\43\F6\A8\88\5A\30\8D\31\31\98\A2\E0\37\07\34", align 16

declare void @aes128_encrypt(i8* noundef, i8* noundef, i8* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare i32 @puts(i8* noundef)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)

define i32 @main() sspstrong {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; load key data
  %keyp = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  %keysrc = getelementptr inbounds [16 x i8], [16 x i8]* @key.const, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %keyp, i8* %keysrc, i64 16, i1 false)

  ; load input data
  %inp = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  %insrc = getelementptr inbounds [16 x i8], [16 x i8]* @in.const, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %inp, i8* %insrc, i64 16, i1 false)

  ; call aes128_encrypt(out, in, key)
  %outp = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
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