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
  %key = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16

  store [16 x i8] [i8 43, i8 126, i8 21, i8 22, i8 40, i8 174, i8 210, i8 166, i8 171, i8 247, i8 21, i8 136, i8 9, i8 207, i8 79, i8 60], [16 x i8]* %key, align 16
  store [16 x i8] [i8 50, i8 67, i8 246, i8 168, i8 136, i8 90, i8 48, i8 141, i8 49, i8 49, i8 152, i8 162, i8 224, i8 55, i8 7, i8 52], [16 x i8]* %in, align 16

  %out8 = bitcast [16 x i8]* %out to i8*
  %in8 = bitcast [16 x i8]* %in to i8*
  %key8 = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* noundef %out8, i8* noundef %in8, i8* noundef %key8)

  %hdr = getelementptr inbounds [13 x i8], [13 x i8]* @.str_header, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %hdr)

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