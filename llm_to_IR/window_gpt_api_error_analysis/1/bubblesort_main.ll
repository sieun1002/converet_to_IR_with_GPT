; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @__main()

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %outer.loop

outer.loop:                                          ; preds = %entry, %outer.latch
  %i = phi i64 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nMinus1 = add i64 %n, -1
  %cond.outer = icmp ult i64 %i, %nMinus1
  br i1 %cond.outer, label %inner.init, label %ret

inner.init:                                          ; preds = %outer.loop, %inner.latch
  %limit = sub i64 %nMinus1, %i
  %j = phi i64 [ 0, %outer.loop ], [ %j.next, %inner.latch ]
  %cond.inner = icmp ult i64 %j, %limit
  br i1 %cond.inner, label %inner.body, label %outer.latch

inner.body:                                          ; preds = %inner.init
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j
  %a = load i32, i32* %ptrj, align 4
  %j1 = add i64 %j, 1
  %ptrj1 = getelementptr inbounds i32, i32* %arr, i64 %j1
  %b = load i32, i32* %ptrj1, align 4
  %cmp = icmp sgt i32 %a, %b
  br i1 %cmp, label %do.swap, label %inner.latch

do.swap:                                             ; preds = %inner.body
  store i32 %b, i32* %ptrj, align 4
  store i32 %a, i32* %ptrj1, align 4
  br label %inner.latch

inner.latch:                                         ; preds = %inner.body, %do.swap
  %j.next = add i64 %j, 1
  br label %inner.init

outer.latch:                                         ; preds = %inner.init
  %i.next = add i64 %i, 1
  br label %outer.loop

ret:                                                 ; preds = %outer.loop, %entry
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %elt0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %elt0, align 4
  %elt1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %elt1, align 4
  %elt2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %elt2, align 4
  %elt3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %elt3, align 4
  %elt4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %elt4, align 4
  %elt5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %elt5, align 4
  %elt6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %elt6, align 4
  %elt7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %elt7, align 4
  %elt8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %elt8, align 4
  %elt9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %elt9, align 4
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %len = add i64 10, 0
  call void @bubble_sort(i32* %base, i64 %len)
  br label %loop

loop:                                                ; preds = %entry, %after.printf
  %i = phi i64 [ 0, %entry ], [ %i.next, %after.printf ]
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %body, label %done

body:                                                ; preds = %loop
  %eltptr = getelementptr inbounds i32, i32* %base, i64 %i
  %val = load i32, i32* %eltptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  br label %after.printf

after.printf:                                        ; preds = %body
  %i.next = add i64 %i, 1
  br label %loop

done:                                                ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}