; ModuleID = 'recovered'
source_filename = "recovered"
target triple = "x86_64-pc-linux-gnu"

@.str_header = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str_hex = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str_line = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8* noundef, i8* noundef, i8* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare i32 @puts(i8* noundef)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %out = alloca [16 x i8], align 16
  %key = alloca [2 x i64], align 16
  %in = alloca [2 x i64], align 16

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key0 = getelementptr inbounds [2 x i64], [2 x i64]* %key, i64 0, i64 0
  store i64 0xA6D2AE2816157E2B, i64* %key0, align 16
  %key1 = getelementptr inbounds [2 x i64], [2 x i64]* %key, i64 0, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key1, align 8

  ; in = 3243f6a8885a308d313198a2e0370734
  %in0 = getelementptr inbounds [2 x i64], [2 x i64]* %in, i64 0, i64 0
  store i64 0x8D305A88A8F64332, i64* %in0, align 16
  %in1 = getelementptr inbounds [2 x i64], [2 x i64]* %in, i64 0, i64 1
  store i64 0x340737E0A2983131, i64* %in1, align 8

  ; call aes128_encrypt(out, in, key)
  %out8 = bitcast [16 x i8]* %out to i8*
  %in8 = bitcast [2 x i64]* %in to i8*
  %key8 = bitcast [2 x i64]* %key to i8*
  call void @aes128_encrypt(i8* noundef %out8, i8* noundef %in8, i8* noundef %key8)

  ; print header
  %hdr = getelementptr inbounds [13 x i8], [13 x i8]* @.str_header, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %hdr)

  ; loop print each byte as %02x
  %hex = getelementptr inbounds [5 x i8], [5 x i8]* @.str_hex, i64 0, i64 0
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %done

body:
  %idx.ext = zext i32 %i to i64
  %p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %b = load i8, i8* %p, align 1
  %b.ext = zext i8 %b to i32
  call i32 (i8*, ...) @printf(i8* noundef %hex, i32 noundef %b.ext)
  %inc = add nuw nsw i32 %i, 1
  br label %loop

done:
  call i32 @putchar(i32 noundef 10)
  %line = getelementptr inbounds [45 x i8], [45 x i8]* @.str_line, i64 0, i64 0
  call i32 @puts(i8* noundef %line)
  ret i32 0
}