; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1
@key.const = private unnamed_addr constant [16 x i8] c"\a6\d2\ae\28\16\15\7e\2b\3c\4f\cf\09\88\15\f7\ab", align 16
@in.const = private unnamed_addr constant [16 x i8] c"\8d\30\5a\88\a8\f6\43\32\34\07\37\e0\a2\98\31\31", align 16

@__stack_chk_guard = external global i64

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local i32 @puts(i8*)
declare dso_local void @aes128_encrypt(i8*, i8*, i8*)
declare dso_local void @__stack_chk_fail() noreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary, align 8
  %key.p.init = bitcast [16 x i8]* %key to i8*
  %key.src = getelementptr inbounds [16 x i8], [16 x i8]* @key.const, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %key.p.init, i8* align 16 %key.src, i64 16, i1 false)
  %in.p.init = bitcast [16 x i8]* %in to i8*
  %in.src = getelementptr inbounds [16 x i8], [16 x i8]* @in.const, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %in.p.init, i8* align 16 %in.src, i64 16, i1 false)
  %out.p = bitcast [16 x i8]* %out to i8*
  %in.p = bitcast [16 x i8]* %in to i8*
  %key.p = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* %out.p, i8* %in.p, i8* %key.p)
  %fmt0 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %idx = zext i32 %iv to i64
  %bptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %b = load i8, i8* %bptr, align 1
  %bz = zext i8 %b to i32
  %fmt1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %bz)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  %call2 = call i32 @puts(i8* %s)
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guard1, %saved
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}