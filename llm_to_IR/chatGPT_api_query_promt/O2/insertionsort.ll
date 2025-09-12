; ModuleID = 'insertionsort.ll'
source_filename = "insertionsort"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) #0 {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 16, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i32 [ 1, %entry ], [ %inc, %for.inc ]
  %cmp = icmp sle i32 %i, 9
  br i1 %cmp, label %for.body, label %print.cond

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i to i64
  %gep.i = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom
  %key = load i32, i32* %gep.i, align 4
  %j.init = add nsw i32 %i, -1
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j = phi i32 [ %j.init, %for.body ], [ %j.next, %while.body ]
  %j.ge.0 = icmp sge i32 %j, 0
  br i1 %j.ge.0, label %while.check, label %while.end

while.check:                                      ; preds = %while.cond
  %j.idx = sext i32 %j to i64
  %aj.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j.idx
  %aj = load i32, i32* %aj.ptr, align 4
  %cmp.move = icmp sgt i32 %aj, %key
  br i1 %cmp.move, label %while.body, label %while.end

while.body:                                       ; preds = %while.check
  %jp1 = add nsw i32 %j, 1
  %jp1.idx = sext i32 %jp1 to i64
  %dest = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %jp1.idx
  store i32 %aj, i32* %dest, align 4
  %j.next = add nsw i32 %j, -1
  br label %while.cond

while.end:                                        ; preds = %while.check, %while.cond
  %j.lcssa = phi i32 [ %j, %while.check ], [ %j, %while.cond ]
  %ins.pos = add nsw i32 %j.lcssa, 1
  %ins.idx = sext i32 %ins.pos to i64
  %ins.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %ins.idx
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:                                          ; preds = %while.end
  %inc = add nsw i32 %i, 1
  br label %for.cond

print.cond:                                       ; preds = %for.cond
  %p = phi i32 [ 0, %for.cond ], [ %p.next, %print.body ]
  %pcmp = icmp slt i32 %p, 10
  br i1 %pcmp, label %print.body, label %print.end

print.body:                                       ; preds = %print.cond
  %p.idx = sext i32 %p to i64
  %p.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %p.idx
  %val = load i32, i32* %p.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %val)
  %p.next = add nsw i32 %p, 1
  br label %print.cond

print.end:                                        ; preds = %print.cond
  %fmt1 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt1)
  ret i32 0
}

attributes #0 = { sspstrong }