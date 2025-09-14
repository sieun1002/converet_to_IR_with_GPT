; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1935
; Intent: AES-128 test vector encryption and printing result (confidence=0.98). Evidence: calls aes128_encrypt with well-known NIST key/plaintext; prints hex bytes and reference string.
; Preconditions: aes128_encrypt implements AES-128: out[16] = AES128_E(key, in)
; Postconditions: Prints "Ciphertext: " + 16 hex bytes and a newline, then prints reference line via puts

@__stack_chk_guard = external global i64
@format = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@a02x = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@s = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

; Only the necessary external declarations:
declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare i32 @_puts(i8*)
declare void @___stack_chk_fail()

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %out = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; stack canary prologue
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c (stored little-endian in two i64s)
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key64, align 16
  %key64.hi.ptr = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key64.hi.ptr, align 8

  ; pt = 3243f6a8885a308d313198a2e0370734 (stored little-endian in two i64s)
  %pt64 = bitcast [16 x i8]* %pt to i64*
  store i64 0x8D305A88A8F64332, i64* %pt64, align 16
  %pt64.hi.ptr = getelementptr inbounds i64, i64* %pt64, i64 1
  store i64 0x340737E0A2983131, i64* %pt64.hi.ptr, align 8

  ; aes128_encrypt(out, pt, key)
  %out.i8 = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %pt.i8 = getelementptr inbounds [16 x i8], [16 x i8]* %pt, i64 0, i64 0
  %key.i8 = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.i8, i8* %pt.i8, i8* %key.i8)

  ; printf("Ciphertext: ")
  %fmt.ptr = getelementptr inbounds [13 x i8], [13 x i8]* @format, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @_printf(i8* %fmt.ptr)

  ; for (i = 0; i <= 0x0F; ++i) printf("%02x", out[i]);
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop
  %idx = sext i32 %iv to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %b = load i8, i8* %byte.ptr, align 1
  %b.z = zext i8 %b to i32
  %hex.ptr = getelementptr inbounds [5 x i8], [5 x i8]* @a02x, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @_printf(i8* %hex.ptr, i32 %b.z)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

loop.end:                                         ; preds = %loop
  %call.putc = call i32 @_putchar(i32 10)

  ; puts("Ciphertext: 3925841d02dc09fbdc118597196a0b32")
  %s.ptr = getelementptr inbounds [45 x i8], [45 x i8]* @s, i64 0, i64 0
  %call.puts = call i32 @_puts(i8* %s.ptr)

  ; stack canary epilogue
  %guard1 = load i64, i64* %canary.slot, align 8
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %guard1, %guard.cur
  br i1 %ok, label %ret, label %stackfail

stackfail:                                        ; preds = %loop.end
  call void @___stack_chk_fail()
  unreachable

ret:                                              ; preds = %loop.end
  ret i32 0
}