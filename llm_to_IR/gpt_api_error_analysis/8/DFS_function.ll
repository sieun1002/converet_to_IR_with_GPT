; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space  = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty  = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.item   = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare void @dfs(i32* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define i32 @main() {
entry:
  %graph = alloca [49 x i32], align 16
  %out = alloca [49 x i64], align 16
  %out_len = alloca i64, align 8

  %graph.i8 = bitcast [49 x i32]* %graph to i8*
  call void @llvm.memset.p0i8.i64(i8* %graph.i8, i8 0, i64 196, i1 false)

  %g0 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 1
  store i32 1, i32* %g0, align 4
  %g1 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 2
  store i32 1, i32* %g1, align 4
  %g2 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 7
  store i32 1, i32* %g2, align 4
  %g3 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 14
  store i32 1, i32* %g3, align 4
  %g4 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 10
  store i32 1, i32* %g4, align 4
  %g5 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 22
  store i32 1, i32* %g5, align 4
  %g6 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 11
  store i32 1, i32* %g6, align 4
  %g7 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 29
  store i32 1, i32* %g7, align 4
  %g8 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 19
  store i32 1, i32* %g8, align 4
  %g9 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 37
  store i32 1, i32* %g9, align 4
  %g10 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 33
  store i32 1, i32* %g10, align 4
  %g11 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 39
  store i32 1, i32* %g11, align 4
  %g12 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 41
  store i32 1, i32* %g12, align 4
  %g13 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 47
  store i32 1, i32* %g13, align 4

  store i64 0, i64* %out_len, align 8

  %graph.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 0
  %out.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %graph.ptr, i64 7, i64 0, i64* %out.ptr, i64* %out_len)

  %fmt.header.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %call.printf.header = call i32 (i8*, ...) @printf(i8* %fmt.header.ptr, i64 0)

  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %loop.body, label %after

loop.body:
  %ip1 = add i64 %i, 1
  %len2 = load i64, i64* %out_len, align 8
  %has_space = icmp ult i64 %ip1, %len2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim.ptr = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr

  %elem.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 %i
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %elem, i8* %delim.ptr)

  %i.next = add i64 %i, 1
  br label %loop

after:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}