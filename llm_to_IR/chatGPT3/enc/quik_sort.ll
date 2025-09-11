; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10A0
; Intent: Entry point for quicksort and printing sorted integers (confidence=1.00). Evidence: Function name 'main', looping over and printing integers.
; Preconditions: argc >= 1, argv[] is an array of integer strings
; Postconditions: Prints sorted integers followed by newline

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32* %arr, i32 %low, i32 %high)

@format = private unnamed_addr constant [4 x i8] c"%d\00A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %format = alloca [4 x i8], align 1
  %array = alloca [10 x i32], align 16
  %i = alloca i32, align 4
  %endptr = alloca i8*, align 8
  %0 = getelementptr [4 x i8], [4 x i8]* %format, i32 0, i32 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %0, i8* getelementptr ([4 x i8], [4 x i8]* @format, i32 0, i32 0), i64 4, i32 1, i1 false)
  %argc.addr.0 = alloca i32, align 4
  store i32 %argc, i32* %argc.addr.0, align 4
  %argc1 = load i32, i32* %argc.addr.0, align 4
  %argc_to_use = sub i32 %argc1, 1
  call void @quick_sort(i32* getelementptr ([10 x i32], [10 x i32]* %array, i32 0, i32 0), i32 0, i32 9)
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, i32* %i, align 4
  %2 = icmp slt i32 %1, 10
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load i32, i32* %i, align 4
  %idxprom = sext i32 %3 to i64
  %arrayidx = getelementptr inbounds [10 x i32], [10 x i32]* %array, i64 0, i64 %idxprom
  %4 = load i32, i32* %arrayidx, align 4
  %conv = sext i32 %4 to i64
  %call = call i32 (i8*, ...) @printf(i8* %0, i64 %conv)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %5 = load i32, i32* %i, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call i32 @putchar(i32 10)
  ret i32 0
}

; Use of memcpy intrinsic for string copying
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) unnamed_addr #1

attributes #1 = { nounwind }