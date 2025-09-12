; ModuleID = 'insertionsort'
source_filename = "insertionsort.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 16
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 8
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 16
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 8
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 16
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %outer.body.end, %entry
  %i = phi i32 [ 1, %entry ], [ %i.next, %outer.body.end ]
  %cmp = icmp slt i32 %i, 10
  br i1 %cmp, label %outer.body, label %print

outer.body:                                       ; preds = %outer.cond
  %idxprom = sext i32 %i to i64
  %key.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom
  %key = load i32, i32* %key.ptr, align 4
  %j0 = add nsw i32 %i, -1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body, %outer.body
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.body ]
  %ok1 = icmp sge i32 %j, 0
  br i1 %ok1, label %inner.check, label %inner.end

inner.check:                                      ; preds = %inner.cond
  %jidx = sext i32 %j to i64
  %aj.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %jidx
  %aj = load i32, i32* %aj.ptr, align 4
  %cmp2 = icmp sgt i32 %aj, %key
  br i1 %cmp2, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.check
  %j1 = add nsw i32 %j, 1
  %j1idx = sext i32 %j1 to i64
  %dst.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j1idx
  store i32 %aj, i32* %dst.ptr, align 4
  %j.next = add nsw i32 %j, -1
  br label %inner.cond

inner.end:                                        ; preds = %inner.check, %inner.cond
  %inspos = add nsw i32 %j, 1
  %insidx = sext i32 %inspos to i64
  %ins.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %insidx
  store i32 %key, i32* %ins.ptr, align 4
  %i.next = add nsw i32 %i, 1
  br label %outer.body.end

outer.body.end:                                   ; preds = %inner.end
  br label %outer.cond

print:                                            ; preds = %outer.cond
  %p = alloca i32, align 4
  store i32 0, i32* %p, align 4
  br label %print.cond

print.cond:                                       ; preds = %print.body, %print
  %pi = load i32, i32* %p, align 4
  %cmp.p = icmp slt i32 %pi, 10
  br i1 %cmp.p, label %print.body, label %after.print

print.body:                                       ; preds = %print.cond
  %pi64 = sext i32 %pi to i64
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %pi64
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %val)
  %pi.next = add nsw i32 %pi, 1
  store i32 %pi.next, i32* %p, align 4
  br label %print.cond

after.print:                                      ; preds = %print.cond
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}