; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1AA9
; Intent: Demonstrate AES-128 encryption and print ciphertext (confidence=0.95). Evidence: aes128_encrypt call with 16-byte constants; prints bytes and known expected ciphertext string.
; Preconditions: None
; Postconditions: Prints computed ciphertext bytes and the expected ciphertext line; returns 0.

@__stack_chk_guard = external global i64

@str_hdr = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@str_hex = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@str_expect = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key_i64 = bitcast [16 x i8]* %key to i64*
  store i64 12018118338662220395, i64* %key_i64, align 8           ; 0xA6D2AE2816157E2B
  %key_i64_hi = getelementptr inbounds i64, i64* %key_i64, i64 1
  store i64 4349834774810499499, i64* %key_i64_hi, align 8         ; 0x3C4FCF098815F7AB

  ; in = 3243f6a8885a308d313198a2e0370734
  %in_i64 = bitcast [16 x i8]* %in to i64*
  store i64 -8364053826329396398, i64* %in_i64, align 8            ; 0x8D305A88A8F64332
  %in_i64_hi = getelementptr inbounds i64, i64* %in_i64, i64 1
  store i64 3755315461553173041, i64* %in_i64_hi, align 8          ; 0x340737E0A2983131

  %out_i8 = bitcast [16 x i8]* %out to i8*
  %in_i8 = bitcast [16 x i8]* %in to i8*
  %key_i8 = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* %out_i8, i8* %in_i8, i8* %key_i8)

  %hdr_ptr = getelementptr inbounds [13 x i8], [13 x i8]* @str_hdr, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %hdr_ptr)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %idx = zext i32 %i to i64
  %byte_ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %byte = load i8, i8* %byte_ptr, align 1
  %val = zext i8 %byte to i32
  %hex_ptr = getelementptr inbounds [5 x i8], [5 x i8]* @str_hex, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %hex_ptr, i32 %val)
  %i.next = add i32 %i, 1
  %cont = icmp sle i32 %i.next, 15
  br i1 %cont, label %loop, label %after_loop

after_loop:
  call i32 @putchar(i32 10)
  %exp_ptr = getelementptr inbounds [45 x i8], [45 x i8]* @str_expect, i64 0, i64 0
  call i32 @puts(i8* %exp_ptr)
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}