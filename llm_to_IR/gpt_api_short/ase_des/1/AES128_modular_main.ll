; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1935
; Intent: AES-128 encrypt test vector and print ciphertext (confidence=0.95). Evidence: constants match FIPS-197 key/plaintext; prints "Ciphertext: ...".
; Preconditions: none
; Postconditions: prints ciphertext bytes and a known-answer string

; Only the necessary external declarations:
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare i32 @_puts(i8*)
declare void @aes128_encrypt(i8*, i8*, i8*)
declare void @___stack_chk_fail()
@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [13 x i8] c"Ciphertext: \00"
@a02x = private unnamed_addr constant [4 x i8] c"%02x\00"
@s = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4
  %canary.slot = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key_i64_0.p = bitcast [16 x i8]* %key to i64*, align 16
  store i64 0xA6D2AE2816157E2B, i64* %key_i64_0.p, align 8
  %key_i64_1.p = getelementptr inbounds i64, i64* %key_i64_0.p, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key_i64_1.p, align 8

  ; pt = 3243f6a8885a308d313198a2e0370734
  %pt_i64_0.p = bitcast [16 x i8]* %pt to i64*, align 16
  store i64 0x8D305A88A8F64332, i64* %pt_i64_0.p, align 8
  %pt_i64_1.p = getelementptr inbounds i64, i64* %pt_i64_0.p, i64 1
  store i64 0x340737E0A2983131, i64* %pt_i64_1.p, align 8

  ; call aes128_encrypt(out, pt, key)
  %out.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %pt.p = getelementptr inbounds [16 x i8], [16 x i8]* %pt, i64 0, i64 0
  %key.p = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.p, i8* %pt.p, i8* %key.p)

  ; printf("Ciphertext: ")
  %fmt.p = getelementptr inbounds [13 x i8], [13 x i8]* @format, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @_printf(i8* %fmt.p)

  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                         ; preds = %loop.body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                         ; preds = %loop.cond
  %idx.ext = sext i32 %iv to i64
  %byte.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %byte = load i8, i8* %byte.p, align 1
  %byte.z = zext i8 %byte to i32
  %a02x.p = getelementptr inbounds [4 x i8], [4 x i8]* @a02x, i64 0, i64 0
  %call.printf.hex = call i32 (i8*, ...) @_printf(i8* %a02x.p, i32 %byte.z)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:                                          ; preds = %loop.cond
  %call.putchar = call i32 @_putchar(i32 10)
  %s.p = getelementptr inbounds [45 x i8], [45 x i8]* @s, i64 0, i64 0
  %call.puts = call i32 @_puts(i8* %s.p)

  ; stack canary check
  %canary.saved = load i64, i64* %canary.slot, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %canary.saved, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:                                         ; preds = %loop.end
  call void @___stack_chk_fail()
  br label %ret

ret:                                               ; preds = %stackfail, %loop.end
  ret i32 0
}