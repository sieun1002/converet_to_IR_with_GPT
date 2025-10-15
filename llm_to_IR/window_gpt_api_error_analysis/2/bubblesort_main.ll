; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %tmp = alloca i32, align 4
  store i64 0, i64* %i, align 8
  br label %outer.cond

outer.cond:                                       ; preds = %inner.end, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp.i = icmp ult i64 %i.val, %n
  br i1 %cmp.i, label %outer.body, label %outer.end

outer.body:                                       ; preds = %outer.cond
  store i64 0, i64* %j, align 8
  br label %inner.cond

inner.cond:                                       ; preds = %after.swap, %outer.body
  %j.val = load i64, i64* %j, align 8
  %n.minus.i = sub i64 %n, %i.val
  %limit = sub i64 %n.minus.i, 1
  %cmp.j = icmp ult i64 %j.val, %limit
  br i1 %cmp.j, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.cond
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.val
  %j.plus1 = add i64 %j.val, 1
  %ptr.j1 = getelementptr inbounds i32, i32* %arr, i64 %j.plus1
  %val.j = load i32, i32* %ptr.j, align 4
  %val.j1 = load i32, i32* %ptr.j1, align 4
  %cmp.swap = icmp sgt i32 %val.j, %val.j1
  br i1 %cmp.swap, label %swap, label %noswap

swap:                                             ; preds = %inner.body
  store i32 %val.j, i32* %tmp, align 4
  store i32 %val.j1, i32* %ptr.j, align 4
  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %ptr.j1, align 4
  br label %after.swap

noswap:                                           ; preds = %inner.body
  br label %after.swap

after.swap:                                       ; preds = %noswap, %swap
  %j.inc = add i64 %j.val, 1
  store i64 %j.inc, i64* %j, align 8
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond
  %i.inc = add i64 %i.val, 1
  store i64 %i.inc, i64* %i, align 8
  br label %outer.cond

outer.end:                                        ; preds = %outer.cond
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %len = alloca i64, align 8
  call void @__main()
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %idx0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %idx0, align 4
  %idx1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %idx9, align 4
  store i64 10, i64* %len, align 8
  %len.val0 = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arr.ptr, i64 %len.val0)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.val, %len.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr.ptr, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}