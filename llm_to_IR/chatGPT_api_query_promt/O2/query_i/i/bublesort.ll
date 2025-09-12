; ModuleID = 'bubblesort.ll'
source_filename = "bubblesort.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i32, align 4
  %last = alloca i32, align 4
  %i = alloca i32, align 4
  %prev = alloca i32, align 4

  ; initialize array: [9,16,5,3,7,2,8,6,4,0]
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 16, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  store i32 10, i32* %n, align 4
  br label %outer

outer:                                            ; preds = %after.inner, %entry
  store i32 0, i32* %last, align 4
  %p0.reload = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %v0 = load i32, i32* %p0.reload, align 4
  store i32 %v0, i32* %prev, align 4
  store i32 1, i32* %i, align 4
  br label %inner.cond

inner.cond:                                      ; preds = %inc, %outer
  %i.val = load i32, i32* %i, align 4
  %n.val = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.val, %n.val
  br i1 %cmp, label %inner.body, label %after.inner

inner.body:                                      ; preds = %inner.cond
  %idx64 = sext i32 %i.val to i64
  %pi = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx64
  %cur = load i32, i32* %pi, align 4
  %prev.val = load i32, i32* %prev, align 4
  %lt = icmp slt i32 %cur, %prev.val
  br i1 %lt, label %do.swap, label %no.swap

do.swap:                                         ; preds = %inner.body
  %im1 = add nsw i32 %i.val, -1
  %im1_64 = sext i32 %im1 to i64
  %pim1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %im1_64
  store i32 %cur, i32* %pim1, align 4
  store i32 %i.val, i32* %last, align 4
  store i32 %prev.val, i32* %pi, align 4
  br label %inc

no.swap:                                         ; preds = %inner.body
  store i32 %cur, i32* %prev, align 4
  br label %inc

inc:                                             ; preds = %no.swap, %do.swap
  %i.val2 = load i32, i32* %i, align 4
  %incv = add nsw i32 %i.val2, 1
  store i32 %incv, i32* %i, align 4
  br label %inner.cond

after.inner:                                     ; preds = %inner.cond
  %last.val = load i32, i32* %last, align 4
  store i32 %last.val, i32* %n, align 4
  %cond = icmp sgt i32 %last.val, 1
  br i1 %cond, label %outer, label %print

print:                                           ; preds = %after.inner
  store i32 0, i32* %i, align 4
  br label %print.cond

print.cond:                                      ; preds = %print.body, %print
  %i3 = load i32, i32* %i, align 4
  %cmpprint = icmp slt i32 %i3, 10
  br i1 %cmpprint, label %print.body, label %after.print

print.body:                                      ; preds = %print.cond
  %i64 = sext i32 %i3 to i64
  %pcur = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i64
  %val = load i32, i32* %pcur, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %val)
  %i.next = add nsw i32 %i3, 1
  store i32 %i.next, i32* %i, align 4
  br label %print.cond

after.print:                                     ; preds = %print.cond
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}