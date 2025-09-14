; ModuleID = 'main_module'
source_filename = "main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@s = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8* noundef, i8* noundef, i8* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare i32 @puts(i8* noundef)
declare void @__stack_chk_fail()
declare external global i64 @__stack_chk_guard

define dso_local i32 @main() local_unnamed_addr {
entry:
  %ssp = alloca i64, align 8
  %out = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %ssp, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key.base = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  %key.lo64 = bitcast i8* %key.base to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key.lo64, align 16
  %key.hi.ptr.i8 = getelementptr inbounds i8, i8* %key.base, i64 8
  %key.hi64 = bitcast i8* %key.hi.ptr.i8 to i64*
  store i64 0x3C4FCF098815F7AB, i64* %key.hi64, align 8

  ; pt = 3243f6a8885a308d313198a2e0370734
  %pt.base = getelementptr inbounds [16 x i8], [16 x i8]* %pt, i64 0, i64 0
  %pt.lo64 = bitcast i8* %pt.base to i64*
  store i64 0x8D305A88A8F64332, i64* %pt.lo64, align 16
  %pt.hi.ptr.i8 = getelementptr inbounds i8, i8* %pt.base, i64 8
  %pt.hi64 = bitcast i8* %pt.hi.ptr.i8 to i64*
  store i64 0x340737E0A2983131, i64* %pt.hi64, align 8

  ; aes128_encrypt(out, pt, key)
  %out.base = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  call void @aes128_encrypt(i8* noundef %out.base, i8* noundef %pt.base, i8* noundef %key.base)

  ; printf("Ciphertext: ")
  %fmt.ptr = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr)

  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.val, 15
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idx.ext = sext i32 %i.val to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %byte = load i8, i8* %byte.ptr, align 1
  %byte.z = zext i8 %byte to i32
  %fmt2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt2.ptr, i32 noundef %byte.z)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call i32 @putchar(i32 noundef 10)
  %s.ptr = getelementptr inbounds [45 x i8], [45 x i8]* @s, i64 0, i64 0
  call i32 @puts(i8* noundef %s.ptr)

  ; stack canary check and return 0
  %loaded = load i64, i64* %ssp, align 8
  %current = load i64, i64* @__stack_chk_guard
  %neq = icmp ne i64 %loaded, %current
  br i1 %neq, label %fail, label %ret

fail:                                             ; preds = %for.end
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %for.end
  ret i32 0
}