; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1AA9
; Intent: Encrypt a single AES-128 test vector, print ciphertext bytes and the expected value (confidence=0.95). Evidence: aes128_encrypt(out,in,key) call; known FIPS-197 key/plaintext/ciphertext constants.
; Preconditions: None
; Postconditions: Returns 0 on success

@.str0 = private unnamed_addr constant [13 x i8] c"Ciphertext: \00"
@.str1 = private unnamed_addr constant [4 x i8] c"%02x\00"
@.str2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00"
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard.slot = alloca i64, align 8
  %out = alloca [16 x i8], align 16
  %plain = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %guard.slot, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key.i64 = bitcast [16 x i8]* %key to i64*
  store i64 11912055628808497707, i64* %key.i64, align 8            ; 0xA6D2AE2816157E2B
  %key.i64.hi = getelementptr inbounds i64, i64* %key.i64, i64 1
  store i64 4340411372332858155, i64* %key.i64.hi, align 8          ; 0x3C4FCF098815F7AB

  ; plaintext = 3243f6a8885a308d313198a2e0370734
  %plain.i64 = bitcast [16 x i8]* %plain to i64*
  store i64 -8515953586195536878, i64* %plain.i64, align 8          ; 0x8D305A88A8F64332
  %plain.i64.hi = getelementptr inbounds i64, i64* %plain.i64, i64 1
  store i64 3757972869782553393, i64* %plain.i64.hi, align 8        ; 0x340737E0A2983131

  ; call aes128_encrypt(out, in, key)
  %out.i8 = bitcast [16 x i8]* %out to i8*
  %plain.i8 = bitcast [16 x i8]* %plain to i8*
  %key.i8 = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* %out.i8, i8* %plain.i8, i8* %key.i8)

  ; print header
  %fmt0 = getelementptr inbounds [13 x i8], [13 x i8]* @.str0, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0)

  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %after_loop

body:
  %idx64 = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx64
  %b = load i8, i8* %elem.ptr, align 1
  %bz = zext i8 %b to i32
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str1, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %bz)
  %inc = add i32 %i, 1
  br label %loop

after_loop:
  %putc = call i32 @putchar(i32 10)
  %s2 = getelementptr inbounds [45 x i8], [45 x i8]* @.str2, i64 0, i64 0
  %call.puts = call i32 @puts(i8* %s2)

  ; stack check
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %guard.slot, align 8
  %eq = icmp eq i64 %guard1, %guard.saved
  br i1 %eq, label %ret, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}