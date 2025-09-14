; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1
@key.const = private unnamed_addr constant [16 x i8] c"\2B\7E\15\16\28\AE\D2\A6\AB\F7\15\88\09\CF\4F\3C", align 16
@pt.const = private unnamed_addr constant [16 x i8] c"\32\43\F6\A8\88\5A\30\8D\31\31\98\A2\E0\37\07\34", align 16

@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @aes128_encrypt(i8*, i8*, i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard0 = load i64, i64* @__stack_chk_guard
  %out = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16

  %kval = load [16 x i8], [16 x i8]* @key.const, align 16
  store [16 x i8] %kval, [16 x i8]* %key, align 16
  %pval = load [16 x i8], [16 x i8]* @pt.const, align 16
  store [16 x i8] %pval, [16 x i8]* %pt, align 16

  %outp = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %ptp = getelementptr inbounds [16 x i8], [16 x i8]* %pt, i64 0, i64 0
  %keyp = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %outp, i8* %ptp, i8* %keyp)

  %0 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %0)

  br label %loop

loop:                                             ; preds = %entry, %loop_body_end
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop_body_end ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop_body, label %after_loop

loop_body:                                        ; preds = %loop
  %idx64 = sext i32 %i to i64
  %byteptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx64
  %byte = load i8, i8* %byteptr, align 1
  %byteext = zext i8 %byte to i32
  %1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %1, i32 %byteext)
  %i.next = add nsw i32 %i, 1
  br label %loop_body_end

loop_body_end:                                    ; preds = %loop_body
  br label %loop

after_loop:                                       ; preds = %loop
  %call3 = call i32 @putchar(i32 10)
  %2 = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  %call4 = call i32 @puts(i8* %2)

  %guard1 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard0, %guard1
  br i1 %ok, label %ret, label %stackfail

stackfail:                                        ; preds = %after_loop
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after_loop
  ret i32 0
}