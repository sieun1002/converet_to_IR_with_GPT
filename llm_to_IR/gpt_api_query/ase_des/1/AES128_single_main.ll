; ModuleID = 'recovered_from_disassembly'
source_filename = "recovered_from_disassembly.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str_ciphertext = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.fmt_hex        = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.expected_str   = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

@__stack_chk_guard = external global i64

declare void @aes128_encrypt(i8* nocapture, i8* nocapture readonly, i8* nocapture readonly)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail() noreturn

define dso_local i32 @main() {
entry:
  ; allocas
  %canary.slot = alloca i64, align 8
  %out         = alloca [16 x i8], align 16
  %key         = alloca [16 x i8], align 16
  %inp         = alloca [16 x i8], align 16
  %i           = alloca i32, align 4

  ; stack canary prologue
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

  ; key: 2b7e151628aed2a6abf7158809cf4f3c (stored as two i64s)
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key64, align 16
  %key64_hi = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key64_hi, align 8

  ; input: 3243f6a8885a308d313198a2e0370734 (stored as two i64s)
  %inp64 = bitcast [16 x i8]* %inp to i64*
  store i64 0x8D305A88A8F64332, i64* %inp64, align 16
  %inp64_hi = getelementptr inbounds i64, i64* %inp64, i64 1
  store i64 0x340737E0A2983131, i64* %inp64_hi, align 8

  ; call aes128_encrypt(out, inp, key)
  %out_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %inp_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %inp, i64 0, i64 0
  %key_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out_i8, i8* %inp_i8, i8* %key_i8)

  ; printf("Ciphertext: ")
  %fmt_ct = getelementptr inbounds [13 x i8], [13 x i8]* @.str_ciphertext, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt_ct)

  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %loop, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop
  %idx.ext = zext i32 %iv to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %byte = load i8, i8* %byte.ptr, align 1
  %byte.z = zext i8 %byte to i32
  %fmt_hex_ptr = getelementptr inbounds [5 x i8], [5 x i8]* @.fmt_hex, i64 0, i64 0
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmt_hex_ptr, i32 %byte.z)
  %inc = add i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

loop.end:                                         ; preds = %loop
  ; putchar('\n')
  %call_putchar = call i32 @putchar(i32 10)

  ; puts("Ciphertext: 3925841d02dc09fbdc118597196a0b32")
  %exp_ptr = getelementptr inbounds [45 x i8], [45 x i8]* @.expected_str, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %exp_ptr)

  ; epilogue / stack canary check and return 0
  %loaded_canary = load i64, i64* %canary.slot, align 8
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  %canary_ok = icmp eq i64 %loaded_canary, %guard_now
  br i1 %canary_ok, label %ret.ok, label %ret.fail

ret.fail:                                         ; preds = %loop.end
  call void @__stack_chk_fail()
  unreachable

ret.ok:                                           ; preds = %loop.end
  ret i32 0
}