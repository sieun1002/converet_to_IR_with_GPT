; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@fmtBefore = private unnamed_addr constant [19 x i8] c"Before heap sort:\0A\00", align 1
@fmtAfter  = private unnamed_addr constant [18 x i8] c"After heap sort:\0A\00", align 1
@fmtInt    = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @heap_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %cmp.n1 = icmp ule i64 %n, 1
  br i1 %cmp.n1, label %ret, label %outer.alloc

outer.alloc:
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %outer.cond

outer.cond:
  %i.val = load i64, i64* %i, align 8
  %n.minus1 = sub i64 %n, 1
  %i.lt = icmp ult i64 %i.val, %n.minus1
  br i1 %i.lt, label %inner.init, label %ret

inner.init:
  store i64 0, i64* %j, align 8
  br label %inner.cond

inner.cond:
  %j.val = load i64, i64* %j, align 8
  %limit.base = sub i64 %n, 1
  %limit = sub i64 %limit.base, %i.val
  %j.lt = icmp ult i64 %j.val, %limit
  br i1 %j.lt, label %inner.body, label %outer.inc

inner.body:
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.val
  %v.j = load i32, i32* %gep.j, align 4
  %j.plus1 = add i64 %j.val, 1
  %gep.j1 = getelementptr inbounds i32, i32* %arr, i64 %j.plus1
  %v.j1 = load i32, i32* %gep.j1, align 4
  %cmp.swap = icmp sgt i32 %v.j, %v.j1
  br i1 %cmp.swap, label %do.swap, label %inner.inc

do.swap:
  store i32 %v.j1, i32* %gep.j, align 4
  store i32 %v.j, i32* %gep.j1, align 4
  br label %inner.inc

inner.inc:
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %inner.cond

outer.inc:
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %outer.cond

ret:
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %idx0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %idx0, align 4
  %idx1 = getelementptr inbounds i32, i32* %idx0, i64 1
  store i32 3, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %idx0, i64 2
  store i32 9, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %idx0, i64 3
  store i32 1, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %idx0, i64 4
  store i32 4, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %idx0, i64 5
  store i32 8, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %idx0, i64 6
  store i32 2, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %idx0, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %idx0, i64 8
  store i32 5, i32* %idx8, align 4
  %before.ptr = getelementptr inbounds [19 x i8], [19 x i8]* @fmtBefore, i64 0, i64 0
  %call.printf.before = call i32 (i8*, ...) @printf(i8* noundef %before.ptr)
  %i.var = alloca i64, align 8
  store i64 0, i64* %i.var, align 8
  br label %loop.print.cond

loop.print.cond:
  %i.cur = load i64, i64* %i.var, align 8
  %cmp.len = icmp ult i64 %i.cur, 9
  br i1 %cmp.len, label %loop.print.body, label %loop.print.end

loop.print.body:
  %elem.ptr = getelementptr inbounds i32, i32* %idx0, i64 %i.cur
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @fmtInt, i64 0, i64 0
  %call.printf.elem = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem.val)
  %i.next0 = add i64 %i.cur, 1
  store i64 %i.next0, i64* %i.var, align 8
  br label %loop.print.cond

loop.print.end:
  %nl1 = call i32 @putchar(i32 noundef 10)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* noundef %arr.ptr, i64 noundef 9)
  %after.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @fmtAfter, i64 0, i64 0
  %call.printf.after = call i32 (i8*, ...) @printf(i8* noundef %after.ptr)
  %j.var = alloca i64, align 8
  store i64 0, i64* %j.var, align 8
  br label %loop.print2.cond

loop.print2.cond:
  %j.cur = load i64, i64* %j.var, align 8
  %cmp2.len = icmp ult i64 %j.cur, 9
  br i1 %cmp2.len, label %loop.print2.body, label %loop.print2.end

loop.print2.body:
  %elem2.ptr = getelementptr inbounds i32, i32* %idx0, i64 %j.cur
  %elem2.val = load i32, i32* %elem2.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @fmtInt, i64 0, i64 0
  %call.printf.elem2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2.ptr, i32 noundef %elem2.val)
  %j.next0 = add i64 %j.cur, 1
  store i64 %j.next0, i64* %j.var, align 8
  br label %loop.print2.cond

loop.print2.end:
  %nl2 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}