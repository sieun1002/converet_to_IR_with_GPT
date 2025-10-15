; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@unk_140004000 = constant [9 x i8] c"Before: \00"
@unk_140004009 = constant [4 x i8] c"%d \00"
@unk_14000400D = constant [8 x i8] c"After: \00"

declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @putchar(i32)

define void @sub_1400018F0() {
entry:
  ret void
}

define void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp.n = icmp ult i64 %n, 2
  br i1 %cmp.n, label %ret, label %outer.init

outer.init:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 0, %outer.init ], [ %i.next, %outer.inc ]
  %cond.outer = icmp ult i64 %i, %n
  br i1 %cond.outer, label %inner.init, label %ret

inner.init:
  %limit.tmp = sub i64 %n, 1
  %limit = sub i64 %limit.tmp, %i
  br label %inner.cond

inner.cond:
  %j = phi i64 [ 0, %inner.init ], [ %j.next, %inner.inc ]
  %cmp.inner = icmp ult i64 %j, %limit
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %elem.next.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %elem.next.idx = add i64 %j, 1
  %elem.next.ptr.real = getelementptr inbounds i32, i32* %arr, i64 %elem.next.idx
  %a = load i32, i32* %elem.ptr, align 4
  %b = load i32, i32* %elem.next.ptr.real, align 4
  %cmp.swap = icmp sgt i32 %a, %b
  br i1 %cmp.swap, label %do.swap, label %inner.inc

do.swap:
  store i32 %a, i32* %elem.next.ptr.real, align 4
  store i32 %b, i32* %elem.ptr, align 4
  br label %inner.inc

inner.inc:
  %j.next = add i64 %j, 1
  br label %inner.cond

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.cond

ret:
  ret void
}

define i32 @sub_14000171D() {
entry:
  call void @sub_1400018F0()
  %arr = alloca [9 x i32], align 16
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 5, i32* %p8, align 4
  %count = ptrtoint i32* %arr.base to i64
  %n = add i64 9, 0
  %fmt.before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @unk_140004000, i64 0, i64 0
  %fmt.num.ptr.entry = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %fmt.after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @unk_14000400D, i64 0, i64 0
  %call.before = call i32 (i8*, ...) @printf(i8* %fmt.before.ptr)
  br label %loop1.cond

loop1.cond:
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.inc ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %loop1.body, label %after.first.loop

loop1.body:
  %elem.ptr1 = getelementptr inbounds i32, i32* %arr.base, i64 %i1
  %val1 = load i32, i32* %elem.ptr1, align 4
  %call.print1 = call i32 (i8*, ...) @printf(i8* %fmt.num.ptr.entry, i32 %val1)
  br label %loop1.inc

loop1.inc:
  %i1.next = add i64 %i1, 1
  br label %loop1.cond

after.first.loop:
  %nl1 = call i32 @putchar(i32 10)
  call void @sub_140001450(i32* %arr.base, i64 9)
  %call.after = call i32 (i8*, ...) @printf(i8* %fmt.after.ptr)
  br label %loop2.cond

loop2.cond:
  %i2 = phi i64 [ 0, %after.first.loop ], [ %i2.next, %loop2.inc ]
  %cmp2 = icmp ult i64 %i2, 9
  br i1 %cmp2, label %loop2.body, label %after.second.loop

loop2.body:
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr.base, i64 %i2
  %val2 = load i32, i32* %elem.ptr2, align 4
  %call.print2 = call i32 (i8*, ...) @printf(i8* %fmt.num.ptr.entry, i32 %val2)
  br label %loop2.inc

loop2.inc:
  %i2.next = add i64 %i2, 1
  br label %loop2.cond

after.second.loop:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}