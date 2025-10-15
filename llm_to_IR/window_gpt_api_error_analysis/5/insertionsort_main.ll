; ModuleID = 'insertion_sort_module'
source_filename = "insertion_sort.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer

outer:                                            ; preds = %outer.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp ult i64 %i, %n
  br i1 %cmp.outer, label %outer.body, label %outer.end

outer.body:                                       ; preds = %outer
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %ptr.i, align 4
  %j.init = add i64 %i, -1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body, %outer.body
  %j = phi i64 [ %j.init, %outer.body ], [ %j.dec, %inner.body ]
  %key.phi = phi i32 [ %key, %outer.body ], [ %key.phi, %inner.body ]
  %j.nonneg = icmp sge i64 %j, 0
  br i1 %j.nonneg, label %inner.check, label %inner.end

inner.check:                                      ; preds = %inner.cond
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val.j = load i32, i32* %ptr.j, align 4
  %cmp.move = icmp sgt i32 %val.j, %key.phi
  br i1 %cmp.move, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.check
  %j.plus1 = add i64 %j, 1
  %ptr.jp1 = getelementptr inbounds i32, i32* %arr, i64 %j.plus1
  store i32 %val.j, i32* %ptr.jp1, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.end:                                        ; preds = %inner.check, %inner.cond
  %j.exit = phi i64 [ %j, %inner.cond ], [ %j, %inner.check ]
  %key.out = phi i32 [ %key.phi, %inner.cond ], [ %key.phi, %inner.check ]
  %j1 = add i64 %j.exit, 1
  %ptr.dest = getelementptr inbounds i32, i32* %arr, i64 %j1
  store i32 %key.out, i32* %ptr.dest, align 4
  br label %outer.inc

outer.inc:                                        ; preds = %inner.end
  %i.next = add i64 %i, 1
  br label %outer

outer.end:                                        ; preds = %outer
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
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
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @insertion_sort(i32* %arrdecay, i64 10)
  br label %loop.header

loop.header:                                      ; preds = %loop.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.header
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  br label %loop.inc

loop.inc:                                         ; preds = %loop.body
  %i.next = add i64 %i, 1
  br label %loop.header

after:                                            ; preds = %loop.header
  %pcall = call i32 @putchar(i32 10)
  ret i32 0
}