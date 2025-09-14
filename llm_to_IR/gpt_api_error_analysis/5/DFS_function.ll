; ModuleID = 'main_module'
source_filename = "main_module"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare dso_local void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define dso_local i32 @main() {
entry:
  %graph = alloca [48 x i32], align 16
  %order = alloca [64 x i64], align 16
  %len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %i = alloca i64, align 8

  %g0 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 0
  %g0i8 = bitcast i32* %g0 to i8*
  call void @llvm.memset.p0i8.i64(i8* %g0i8, i8 0, i64 192, i1 false)

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %len, align 8

  %p1 = getelementptr inbounds i32, i32* %g0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %g0, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %g0, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %g0, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %g0, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %g0, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %g0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %g0, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %g0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %g0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %g0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %g0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %g0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %g0, i64 47
  store i32 1, i32* %p47, align 4

  %ord0 = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 0
  %startv = load i64, i64* %start, align 8
  %nv = load i64, i64* %n, align 8
  call void @dfs(i32* %g0, i64 %nv, i64 %startv, i64* %ord0, i64* %len)

  %fmt_pre_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %startv2 = load i64, i64* %start, align 8
  %call_pre = call i32 (i8*, ...) @printf(i8* %fmt_pre_ptr, i64 %startv2)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %next = add i64 %i.cur, 1
  %len.cur2 = load i64, i64* %len, align 8
  %ge = icmp uge i64 %next, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim = select i1 %ge, i8* %empty.ptr, i8* %space.ptr

  %val.ptr = getelementptr inbounds i64, i64* %ord0, i64 %i.cur
  %val = load i64, i64* %val.ptr, align 8
  %fmt_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %call_item = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i64 %val, i8* %delim)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}