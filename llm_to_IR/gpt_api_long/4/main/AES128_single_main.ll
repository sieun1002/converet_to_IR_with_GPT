; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1AA9
; Intent: Encrypt a single AES-128 block and print the ciphertext (confidence=1.00). Evidence: AES test-vector bytes (key=2b7e1516...09cf4f3c, in=3243f6a8...e0370734), prints "Ciphertext: ".
; Preconditions: aes128_encrypt(out, in, key) performs 1-block AES-128 encryption (ECB) with 16-byte buffers.
; Postconditions: Prints the computed ciphertext in hex and the known expected string.

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.hex = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str.exp = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key.i8 = bitcast [16 x i8]* %key to i8*
  %key.i64 = bitcast i8* %key.i8 to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key.i64, align 8
  %key.i64.hi = getelementptr inbounds i64, i64* %key.i64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key.i64.hi, align 8
  ; in = 3243f6a8885a308d313198a2e0370734
  %in.i8 = bitcast [16 x i8]* %in to i8*
  %in.i64 = bitcast i8* %in.i8 to i64*
  store i64 0x8D305A88A8F64332, i64* %in.i64, align 8
  %in.i64.hi = getelementptr inbounds i64, i64* %in.i64, i64 1
  store i64 0x340737E0A2983131, i64* %in.i64.hi, align 8
  ; call aes128_encrypt(out, in, key)
  %out.i8 = bitcast [16 x i8]* %out to i8*
  call void @aes128_encrypt(i8* %out.i8, i8* %in.i8, i8* %key.i8)
  ; print "Ciphertext: "
  %fmt = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt)
  br label %loop.cond

loop.cond:                                        ; preds = %entry, %loop.body
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %idx.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %b = load i8, i8* %elem.ptr, align 1
  %bz = zext i8 %b to i32
  %fmt.hex = getelementptr inbounds [4 x i8], [4 x i8]* @.str.hex, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.hex, i32 %bz)
  %inc = add nuw nsw i32 %i, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  %exp = getelementptr inbounds [45 x i8], [45 x i8]* @.str.exp, i64 0, i64 0
  %call2 = call i32 @puts(i8* %exp)
  ret i32 0
}