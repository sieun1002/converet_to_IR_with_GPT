; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@Format = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@byte_14000400D = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare dso_local i32 @printf(i8*, ...)
@sub_140002960 = alias i32 (i8*, ...), i32 (i8*, ...)* @printf
declare dso_local i32 @putchar(i32)

define dso_local void @sub_1400018F0() {
entry:
  ret void
}

define dso_local void @sub_140001450(i32* nocapture %p, i64 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %inner.end, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %inner.end ]
  %cmp.outer = icmp slt i64 %i, %n
  br i1 %cmp.outer, label %outer.body, label %outer.ret

outer.body:                                       ; preds = %outer.cond
  %n.minus1 = add i64 %n, -1
  %limit.tmp = sub i64 %n.minus1, %i
  %limit.pos = icmp sgt i64 %limit.tmp, 0
  br i1 %limit.pos, label %inner.cond, label %inner.end

inner.cond:                                       ; preds = %inner.body, %outer.body
  %j = phi i64 [ 0, %outer.body ], [ %j.next, %inner.body ]
  %cmp.inner = icmp slt i64 %j, %limit.tmp
  br i1 %cmp.inner, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.cond
  %j.next = add i64 %j, 1
  %ptr.j = getelementptr inbounds i32, i32* %p, i64 %j
  %ptr.j1 = getelementptr inbounds i32, i32* %p, i64 %j.next
  %val.j = load i32, i32* %ptr.j, align 4
  %val.j1 = load i32, i32* %ptr.j1, align 4
  %gt = icmp sgt i32 %val.j, %val.j1
  br i1 %gt, label %do.swap, label %no.swap

do.swap:                                          ; preds = %inner.body
  store i32 %val.j, i32* %ptr.j1, align 4
  store i32 %val.j1, i32* %ptr.j, align 4
  br label %no.swap

no.swap:                                          ; preds = %do.swap, %inner.body
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond, %outer.body
  %i.next = add i64 %i, 1
  br label %outer.cond

outer.ret:                                        ; preds = %outer.cond
  ret void
}

define dso_local i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  call void @sub_1400018F0()
  %arr.el0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.el0, align 4
  %arr.el1 = getelementptr inbounds i32, i32* %arr.el0, i64 1
  store i32 3, i32* %arr.el1, align 4
  %arr.el2 = getelementptr inbounds i32, i32* %arr.el0, i64 2
  store i32 9, i32* %arr.el2, align 4
  %arr.el3 = getelementptr inbounds i32, i32* %arr.el0, i64 3
  store i32 1, i32* %arr.el3, align 4
  %arr.el4 = getelementptr inbounds i32, i32* %arr.el0, i64 4
  store i32 4, i32* %arr.el4, align 4
  %arr.el5 = getelementptr inbounds i32, i32* %arr.el0, i64 5
  store i32 8, i32* %arr.el5, align 4
  %arr.el6 = getelementptr inbounds i32, i32* %arr.el0, i64 6
  store i32 2, i32* %arr.el6, align 4
  %arr.el7 = getelementptr inbounds i32, i32* %arr.el0, i64 7
  store i32 6, i32* %arr.el7, align 4
  %arr.el8 = getelementptr inbounds i32, i32* %arr.el0, i64 8
  store i32 5, i32* %arr.el8, align 4
  store i64 9, i64* %n, align 8
  %fmt.before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @Format, i64 0, i64 0
  %call.before = call i32 (i8*, ...) @sub_140002960(i8* %fmt.before.ptr)
  br label %print1.cond

print1.cond:                                      ; preds = %print1.body, %entry
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %print1.body ]
  %n.val1 = load i64, i64* %n, align 8
  %cmp1 = icmp ult i64 %i1, %n.val1
  br i1 %cmp1, label %print1.body, label %print1.end

print1.body:                                      ; preds = %print1.cond
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmt.num.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call.num1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt.num.ptr, i32 %elem1)
  %i1.next = add i64 %i1, 1
  br label %print1.cond

print1.end:                                       ; preds = %print1.cond
  %nl1 = call i32 @putchar(i32 10)
  %arr.base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val2 = load i64, i64* %n, align 8
  call void @sub_140001450(i32* %arr.base.ptr, i64 %n.val2)
  %fmt.after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @byte_14000400D, i64 0, i64 0
  %call.after = call i32 (i8*, ...) @sub_140002960(i8* %fmt.after.ptr)
  br label %print2.cond

print2.cond:                                      ; preds = %print2.body, %print1.end
  %i2 = phi i64 [ 0, %print1.end ], [ %i2.next, %print2.body ]
  %n.val3 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %i2, %n.val3
  br i1 %cmp2, label %print2.body, label %print2.end

print2.body:                                      ; preds = %print2.cond
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %call.num2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt.num.ptr, i32 %elem2)
  %i2.next = add i64 %i2, 1
  br label %print2.cond

print2.end:                                       ; preds = %print2.cond
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}