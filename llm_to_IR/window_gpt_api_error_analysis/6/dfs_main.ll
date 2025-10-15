; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@asc_140004018 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_14000401A = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local i32 @__main() {
entry:
  ret i32 0
}

define internal void @dfs_visit(i64 %u, i64 %n, i8* %visited, i64* %out, i64* %out_count) {
entry:
  %cmp.u.n = icmp uge i64 %u, %n
  br i1 %cmp.u.n, label %ret, label %cont

cont:
  %vis.ptr = getelementptr inbounds i8, i8* %visited, i64 %u
  %vis.val = load i8, i8* %vis.ptr, align 1
  %already = icmp ne i8 %vis.val, 0
  br i1 %already, label %ret, label %mark

mark:
  store i8 1, i8* %vis.ptr, align 1
  %cnt0 = load i64, i64* %out_count, align 8
  %out.elem.ptr = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %u, i64* %out.elem.ptr, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  switch i64 %u, label %after [
    i64 0, label %case0
    i64 1, label %case1
    i64 2, label %case2
    i64 3, label %case3
    i64 4, label %case4
    i64 5, label %case5
    i64 6, label %case6
  ]

case0:
  call void @dfs_visit(i64 1, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  call void @dfs_visit(i64 2, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  br label %after

case1:
  call void @dfs_visit(i64 0, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  call void @dfs_visit(i64 3, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  call void @dfs_visit(i64 4, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  br label %after

case2:
  call void @dfs_visit(i64 0, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  call void @dfs_visit(i64 5, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  br label %after

case3:
  call void @dfs_visit(i64 1, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  br label %after

case4:
  call void @dfs_visit(i64 1, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  call void @dfs_visit(i64 5, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  br label %after

case5:
  call void @dfs_visit(i64 2, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  call void @dfs_visit(i64 4, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  call void @dfs_visit(i64 6, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  br label %after

case6:
  call void @dfs_visit(i64 5, i64 %n, i8* %visited, i64* %out, i64* %out_count)
  br label %after

after:
  br label %ret

ret:
  ret void
}

define dso_local void @dfs(i8* %base, i64 %n, i64 %start, i64* %out, i64* %out_count) {
entry:
  %visited.arr = alloca [7 x i8], align 1
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %zero.loop

zero.loop:
  %i.val = load i64, i64* %i, align 8
  %cond = icmp ult i64 %i.val, 7
  br i1 %cond, label %zero.body, label %zero.end

zero.body:
  %vis.elem.ptr = getelementptr inbounds [7 x i8], [7 x i8]* %visited.arr, i64 0, i64 %i.val
  store i8 0, i8* %vis.elem.ptr, align 1
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %zero.loop

zero.end:
  %vis.base = getelementptr inbounds [7 x i8], [7 x i8]* %visited.arr, i64 0, i64 0
  call void @dfs_visit(i64 %start, i64 %n, i8* %vis.base, i64* %out, i64* %out_count)
  ret void
}

define dso_local i32 @main() {
entry:
  %call_init = call i32 @__main()
  %N = alloca i64, align 8
  store i64 7, i64* %N, align 8
  %out = alloca [7 x i64], align 8
  %out_count = alloca i64, align 8
  store i64 0, i64* %out_count, align 8
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 8
  %base.stub = alloca i8, align 1
  %N.val = load i64, i64* %N, align 8
  %start.val = load i64, i64* %start, align 8
  %out.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  %base.ptr = getelementptr inbounds i8, i8* %base.stub, i64 0
  call void @dfs(i8* %base.ptr, i64 %N.val, i64 %start.val, i64* %out.ptr, i64* %out_count)
  %fmt.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call.printf.header = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %start.print)
  %i2 = alloca i64, align 8
  store i64 0, i64* %i2, align 8
  br label %loop.cond

loop.cond:
  %i2.val = load i64, i64* %i2, align 8
  %count.cur = load i64, i64* %out_count, align 8
  %has.more = icmp ult i64 %i2.val, %count.cur
  br i1 %has.more, label %loop.body, label %loop.end

loop.body:
  %next.idx = add i64 %i2.val, 1
  %count.cur2 = load i64, i64* %out_count, align 8
  %is.last = icmp uge i64 %next.idx, %count.cur2
  br i1 %is.last, label %sel.empty, label %sel.space

sel.space:
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  br label %sel.join

sel.empty:
  %emp.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  br label %sel.join

sel.join:
  %sep = phi i8* [ %sp.ptr, %sel.space ], [ %emp.ptr, %sel.empty ]
  %val.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i2.val
  %val = load i64, i64* %val.ptr, align 8
  %fmt.items = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.items, i64 %val, i8* %sep)
  %i2.next = add i64 %i2.val, 1
  store i64 %i2.next, i64* %i2, align 8
  br label %loop.cond

loop.end:
  %lf = call i32 @putchar(i32 10)
  ret i32 0
}