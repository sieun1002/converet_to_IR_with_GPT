; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %outer.header

outer.header:                                      ; preds = %entry, %outer.latch
  %i = phi i64 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nsub1 = add i64 %n, -1
  %cond.outer = icmp ult i64 %i, %nsub1
  br i1 %cond.outer, label %inner.header, label %ret

inner.header:                                      ; preds = %outer.header, %inner.latch
  %j = phi i64 [ 0, %outer.header ], [ %j.next, %inner.latch ]
  %tmp0 = sub i64 %n, %i
  %limit = add i64 %tmp0, -1
  %cond.inner = icmp ult i64 %j, %limit
  br i1 %cond.inner, label %inner.body, label %outer.latch

inner.body:                                        ; preds = %inner.header
  %p_j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val_j = load i32, i32* %p_j, align 4
  %j1 = add i64 %j, 1
  %p_j1 = getelementptr inbounds i32, i32* %arr, i64 %j1
  %val_j1 = load i32, i32* %p_j1, align 4
  %cmp.swap = icmp sgt i32 %val_j, %val_j1
  br i1 %cmp.swap, label %do.swap, label %inner.latch

do.swap:                                           ; preds = %inner.body
  store i32 %val_j1, i32* %p_j, align 4
  store i32 %val_j, i32* %p_j1, align 4
  br label %inner.latch

inner.latch:                                       ; preds = %do.swap, %inner.body
  %j.next = add i64 %j, 1
  br label %inner.header

outer.latch:                                       ; preds = %inner.header
  %i.next = add i64 %i, 1
  br label %outer.header

ret:                                               ; preds = %outer.header, %entry
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  call void @__main()
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
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @bubble_sort(i32* %arr.ptr, i64 10)
  br label %loop.header

loop.header:                                       ; preds = %entry, %loop.latch
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %loop.body, label %after.loop

loop.body:                                         ; preds = %loop.header
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  br label %loop.latch

loop.latch:                                        ; preds = %loop.body
  %i.next = add i64 %i, 1
  br label %loop.header

after.loop:                                        ; preds = %loop.header
  %newline = call i32 @putchar(i32 10)
  ret i32 0
}