; ModuleID = 'dfs_main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item   = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.sep    = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty  = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %matrix = alloca [49 x i32], align 16
  %out = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8

  store i64 7, i64* %n, align 8

  %matrix.i8 = bitcast [49 x i32]* %matrix to i8*
  call void @llvm.memset.p0i8.i64(i8* %matrix.i8, i8 0, i64 196, i1 false)

  %gepa1 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 1
  store i32 1, i32* %gepa1, align 4
  %gepa7 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 7
  store i32 1, i32* %gepa7, align 4
  %gepa2 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 2
  store i32 1, i32* %gepa2, align 4
  %gepa14 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 14
  store i32 1, i32* %gepa14, align 4
  %gepa10 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 10
  store i32 1, i32* %gepa10, align 4
  %gepa22 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 22
  store i32 1, i32* %gepa22, align 4
  %gepa11 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 11
  store i32 1, i32* %gepa11, align 4
  %gepa29 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 29
  store i32 1, i32* %gepa29, align 4
  %gepa19 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 19
  store i32 1, i32* %gepa19, align 4
  %gepa37 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 37
  store i32 1, i32* %gepa37, align 4
  %gepa33 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 33
  store i32 1, i32* %gepa33, align 4
  %gepa39 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 39
  store i32 1, i32* %gepa39, align 4
  %gepa41 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 41
  store i32 1, i32* %gepa41, align 4
  %gepa47 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 47
  store i32 1, i32* %gepa47, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %mat.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  %out.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %mat.ptr, i64 %n.val, i64 %start.val, i64* %out.ptr, i64* %out_len)

  %fmt.header.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %printf.hdr = call i32 (i8*, ...) @printf(i8* %fmt.header.ptr, i64 %start.val)

  br label %loop.cond

loop.cond:
  %i.ph = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp.more = icmp ult i64 %i.ph, %len.cur
  br i1 %cmp.more, label %loop.body, label %loop.end

loop.body:
  %next.idx = add i64 %i.ph, 1
  %len.again = load i64, i64* %out_len, align 8
  %has.sep = icmp ult i64 %next.idx, %len.again
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.sep, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %has.sep, i8* %sep.space.ptr, i8* %sep.empty.ptr
  %out.elem.ptr2 = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i.ph
  %out.val = load i64, i64* %out.elem.ptr2, align 8
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %printf.it = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %out.val, i8* %sep.ptr)
  %i.next = add i64 %i.ph, 1
  br label %loop.cond

loop.end:
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}