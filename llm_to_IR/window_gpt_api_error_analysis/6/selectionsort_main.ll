; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)

define dso_local void @__main() nounwind {
entry:
  ret void
}

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n_minus1 = add i32 %n, -1
  %cond.outer = icmp slt i32 %i, %n_minus1
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:
  %j.start = add i32 %i, 1
  br label %inner.header

inner.header:
  %j = phi i32 [ %j.start, %outer.body ], [ %j.next, %inner.latch ]
  %minIndex = phi i32 [ %i, %outer.body ], [ %min.sel, %inner.latch ]
  %cond.inner = icmp slt i32 %j, %n
  br i1 %cond.inner, label %compare, label %after.inner

compare:
  %j64 = sext i32 %j to i64
  %min64 = sext i32 %minIndex to i64
  %j.addr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %min.addr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %j.val = load i32, i32* %j.addr, align 4
  %min.val = load i32, i32* %min.addr, align 4
  %lt = icmp slt i32 %j.val, %min.val
  %min.sel = select i1 %lt, i32 %j, i32 %minIndex
  br label %inner.latch

inner.latch:
  %j.next = add i32 %j, 1
  br label %inner.header

after.inner:
  %needSwap = icmp ne i32 %minIndex, %i
  br i1 %needSwap, label %doSwap, label %outer.latch

doSwap:
  %i64 = sext i32 %i to i64
  %i.addr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %min64b = sext i32 %minIndex to i64
  %min.addr.b = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %ai = load i32, i32* %i.addr, align 4
  %amin = load i32, i32* %min.addr.b, align 4
  store i32 %amin, i32* %i.addr, align 4
  store i32 %ai, i32* %min.addr.b, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i32 %i, 1
  br label %outer.header

exit:
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  call void @__main()
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4ptr, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %arrptr, i32 5)
  %fmtptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, 5
  br i1 %cmp, label %loop.body, label %ret

loop.body:
  %i64b = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arrptr, i64 %i64b
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %inc = add i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

ret:
  ret i32 0
}