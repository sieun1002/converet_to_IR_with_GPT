; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@.str_fmt = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %outCount = alloca i64, align 8
  %out = alloca [64 x i64], align 16
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 192, i1 false)

  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  store i32 0, i32* %adj.base, align 4

  %idx1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %idx1.ptr, align 4

  %idx2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %idx2.ptr, align 4

  %n.val = load i64, i64* %n, align 8
  %gep.n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n.val
  store i32 1, i32* %gep.n, align 4

  %twon = add i64 %n.val, %n.val
  %gep.2n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twon
  store i32 1, i32* %gep.2n, align 4

  %n.plus3 = add i64 %n.val, 3
  %gep.np3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n.plus3
  store i32 1, i32* %gep.np3, align 4

  %threen = add i64 %twon, %n.val
  %threenp1 = add i64 %threen, 1
  %gep.3n1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %threenp1
  store i32 1, i32* %gep.3n1, align 4

  %n.plus4 = add i64 %n.val, 4
  %gep.np4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n.plus4
  store i32 1, i32* %gep.np4, align 4

  %fourn = shl i64 %n.val, 2
  %fournp1 = add i64 %fourn, 1
  %gep.4n1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fournp1
  store i32 1, i32* %gep.4n1, align 4

  %twonp5 = add i64 %twon, 5
  %gep.2n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twonp5
  store i32 1, i32* %gep.2n5, align 4

  %fiven = add i64 %fourn, %n.val
  %fivenp2 = add i64 %fiven, 2
  %gep.5n2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fivenp2
  store i32 1, i32* %gep.5n2, align 4

  %fournp5 = add i64 %fourn, 5
  %gep.4n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fournp5
  store i32 1, i32* %gep.4n5, align 4

  %fivenp4 = add i64 %fiven, 4
  %gep.5n4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fivenp4
  store i32 1, i32* %gep.5n4, align 4

  %sixn = shl i64 %threen, 1
  %sixnp5 = add i64 %sixn, 5
  %gep.6n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %sixnp5
  store i32 1, i32* %gep.6n5, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %outCount, align 8

  %out.base = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %adj.base, i64 %n.val, i64 0, i64* %out.base, i64* %outCount)

  %fmt.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_fmt, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %start.val)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %cnt = load i64, i64* %outCount, align 8
  %cmp = icmp ult i64 %i.cur, %cnt
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.plus1 = add i64 %i.cur, 1
  %cnt2 = load i64, i64* %outCount, align 8
  %is_last = icmp uge i64 %i.plus1, %cnt2
  %spc.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %is_last, i8* %empty.ptr, i8* %spc.ptr

  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %val.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 %i.cur
  %val = load i64, i64* %val.ptr, align 8
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %val, i8* %sep)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)