; ModuleID = 'sorted_array_module'
target triple = "x86_64-pc-windows-msvc"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                      ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nminus1 = add i32 %n, -1
  %cond = icmp slt i32 %i, %nminus1
  br i1 %cond, label %outer.header, label %exit

outer.header:                                    ; preds = %outer.cond
  %i.plus1 = add i32 %i, 1
  br label %inner.cond

inner.cond:                                      ; preds = %inner.body, %outer.header
  %min.phi = phi i32 [ %i, %outer.header ], [ %min.next, %inner.body ]
  %j.phi = phi i32 [ %i.plus1, %outer.header ], [ %j.next, %inner.body ]
  %cmpJ = icmp slt i32 %j.phi, %n
  br i1 %cmpJ, label %inner.body, label %after.inner

inner.body:                                      ; preds = %inner.cond
  %j64 = zext i32 %j.phi to i64
  %min64 = zext i32 %min.phi to i64
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %pmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %vj = load i32, i32* %pj, align 4
  %vmin = load i32, i32* %pmin, align 4
  %lt = icmp slt i32 %vj, %vmin
  %min.next = select i1 %lt, i32 %j.phi, i32 %min.phi
  %j.next = add i32 %j.phi, 1
  br label %inner.cond

after.inner:                                     ; preds = %inner.cond
  %neq = icmp ne i32 %min.phi, %i
  br i1 %neq, label %do.swap, label %outer.latch

do.swap:                                         ; preds = %after.inner
  %i64 = zext i32 %i to i64
  %min64b = zext i32 %min.phi to i64
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i64
  %pmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %vi = load i32, i32* %pi, align 4
  %vmin2 = load i32, i32* %pmin2, align 4
  store i32 %vi, i32* %pmin2, align 4
  store i32 %vmin2, i32* %pi, align 4
  br label %outer.latch

outer.latch:                                     ; preds = %do.swap, %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:                                            ; preds = %outer.cond
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 29, i32* %arr0, align 4
  store i32 10, i32* %arr1, align 4
  store i32 14, i32* %arr2, align 4
  store i32 37, i32* %arr3, align 4
  store i32 13, i32* %arr4, align 4
  call void @selection_sort(i32* %arr0, i32 5)
  %fmtptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call1 = call i32 @printf(i8* %fmtptr)
  br label %loop.cond

loop.cond:                                       ; preds = %loop.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                       ; preds = %loop.cond
  %i64 = zext i32 %i to i64
  %pelem = getelementptr inbounds i32, i32* %arr0, i64 %i64
  %val = load i32, i32* %pelem, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call2 = call i32 @printf(i8* %fmtptr2, i32 %val)
  br label %loop.latch

loop.latch:                                      ; preds = %loop.body
  %i.next = add i32 %i, 1
  br label %loop.cond

loop.end:                                        ; preds = %loop.cond
  ret i32 0
}