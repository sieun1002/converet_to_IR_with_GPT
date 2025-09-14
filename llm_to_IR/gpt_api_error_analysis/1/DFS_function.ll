; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

@.str0 = private unnamed_addr constant [25 x i8] c"DFS preorder from %zu: \00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %idx = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4

  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.ptr, i64 %n.val, i64 %start.val, i64* %out.ptr, i64* %out_len)

  %fmt0 = getelementptr inbounds [25 x i8], [25 x i8]* @.str0, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.val2)

  store i64 0, i64* %idx, align 8
  br label %loop

loop:
  %idx.cur = load i64, i64* %idx, align 8
  %len = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %idx.cur, %len
  br i1 %cond, label %body, label %done

body:
  %next = add i64 %idx.cur, 1
  %hasnext = icmp ult i64 %next, %len
  br i1 %hasnext, label %space, label %empty

space:
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  br label %select

empty:
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  br label %select

select:
  %sep = phi i8* [ %sep.space, %space ], [ %sep.empty, %empty ]
  %elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %idx.cur
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %elem, i8* %sep)
  %idx.next = add i64 %idx.cur, 1
  store i64 %idx.next, i64* %idx, align 8
  br label %loop

done:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}