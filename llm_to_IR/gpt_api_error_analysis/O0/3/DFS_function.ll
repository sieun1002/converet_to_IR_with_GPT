; ModuleID = 'dfs_main'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  %header.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  ; Edge (0,1) and (1,0)
  %idx.0.1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %idx.0.1, align 4
  %idx.1.0 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %idx.1.0, align 4
  ; Edge (0,2) and (2,0)
  %idx.0.2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %idx.0.2, align 4
  %idx.2.0 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %idx.2.0, align 4
  ; Edge (1,3) and (3,1)
  %idx.1.3 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %idx.1.3, align 4
  %idx.3.1 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %idx.3.1, align 4
  ; Edge (1,4) and (4,1)
  %idx.1.4 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %idx.1.4, align 4
  %idx.4.1 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %idx.4.1, align 4
  ; Edge (2,5) and (5,2)
  %idx.2.5 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %idx.2.5, align 4
  %idx.5.2 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %idx.5.2, align 4
  ; Edge (4,5) and (5,4)
  %idx.4.5 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %idx.4.5, align 4
  %idx.5.4 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %idx.5.4, align 4
  ; Edge (5,6) and (6,5)
  %idx.5.6 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %idx.5.6, align 4
  %idx.6.5 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %idx.6.5, align 4
  %out.base = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %n.val, i64 %start.val, i64* %out.base, i64* %out_len)
  %call.header = call i32 (i8*, ...) @printf(i8* %header.ptr, i64 %start.val)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %i.plus1 = add i64 %i, 1
  %has.more = icmp ult i64 %i.plus1, %len
  %sep = select i1 %has.more, i8* %space.ptr, i8* %empty.ptr
  %out.elem.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i
  %out.elem = load i64, i64* %out.elem.ptr, align 8
  %call.item = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %out.elem, i8* %sep)
  %i.next = add i64 %i, 1
  br label %loop

after.loop:
  %newline = call i32 @putchar(i32 10)
  ret i32 0
}