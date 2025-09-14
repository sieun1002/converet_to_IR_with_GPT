; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1935
; Intent: AES-128 demo: encrypt known plaintext with known key and print ciphertext (confidence=0.95). Evidence: calls aes128_encrypt with 16-byte constants; prints hex and an expected ciphertext string.
; Preconditions: aes128_encrypt(out,in,key) processes a single 16-byte block.
; Postconditions: returns 0 on success.

@__stack_chk_guard = external global i64
@format = external constant [13 x i8]
@a02x = external constant [5 x i8]
@s = external constant [45 x i8]

; Only the needed extern declarations:
declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %plain = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4
  %canary = alloca i64, align 8
  %guard.ld = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.ld, i64* %canary, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c (little-endian 64-bit chunks)
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 11912021205705917099, i64* %key64, align 16           ; 0xA6D2AE2816157E2B
  %key64.hi = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 4349764310606096299, i64* %key64.hi, align 8          ; 0x3C4FCF098815F7AB

  ; plaintext = 3243f6a8885a308d313198a2e0370734 (little-endian 64-bit chunks)
  %plain64 = bitcast [16 x i8]* %plain to i64*
  store i64 -8226295807567348014, i64* %plain64, align 16         ; 0x8D305A88A8F64332
  %plain64.hi = getelementptr inbounds i64, i64* %plain64, i64 1
  store i64 3755483230882527281, i64* %plain64.hi, align 8        ; 0x340737E0A2983131

  ; aes128_encrypt(out, plain, key)
  %out.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %plain.p = getelementptr inbounds [16 x i8], [16 x i8]* %plain, i64 0, i64 0
  %key.p = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.p, i8* %plain.p, i8* %key.p)

  ; printf("Ciphertext: ")
  %fmt.p = getelementptr inbounds [13 x i8], [13 x i8]* @format, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.p)

  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.val, 15
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %idx = sext i32 %i.val to i64
  %byte.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %byte = load i8, i8* %byte.p, align 1
  %byte.z = zext i8 %byte to i32
  %a02x.p = getelementptr inbounds [5 x i8], [5 x i8]* @a02x, i64 0, i64 0
  %call.printf.byte = call i32 (i8*, ...) @printf(i8* %a02x.p, i32 %byte.z)
  %inc = add i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  %call.putchar = call i32 @putchar(i32 10)
  %s.p = getelementptr inbounds [45 x i8], [45 x i8]* @s, i64 0, i64 0
  %call.puts = call i32 @puts(i8* %s.p)

  %guard.ld2 = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary, align 8
  %guard.ok = icmp eq i64 %guard.saved, %guard.ld2
  br i1 %guard.ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}