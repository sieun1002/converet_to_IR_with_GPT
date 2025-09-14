; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.elem   = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space  = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty  = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %graph = alloca [48 x i32], align 16
  %out = alloca [48 x i64], align 16
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8

  %graph.i8 = bitcast [48 x i32]* %graph to i8*
  call void @llvm.memset.p0i8.i64(i8* %graph.i8, i8 0, i64 192, i1 false)

  %graph.idx1 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 1
  store i32 1, i32* %graph.idx1, align 4

  %n.val1 = load i64, i64* %n, align 8
  %graph.idxn = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %n.val1
  store i32 1, i32* %graph.idxn, align 4

  %graph.idx2 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 2
  store i32 1, i32* %graph.idx2, align 4

  %n.val2 = load i64, i64* %n, align 8
  %twon = shl i64 %n.val2, 1
  %graph.idx2n = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %twon
  store i32 1, i32* %graph.idx2n, align 4

  %n.val3 = load i64, i64* %n, align 8
  %n.plus3 = add i64 %n.val3, 3
  %graph.idx.np3 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %n.plus3
  store i32 1, i32* %graph.idx.np3, align 4

  %n.val4 = load i64, i64* %n, align 8
  %twon.b = shl i64 %n.val4, 1
  %threen = add i64 %twon.b, %n.val4
  %threenp1 = add i64 %threen, 1
  %graph.idx3n1 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %threenp1
  store i32 1, i32* %graph.idx3n1, align 4

  %n.val5 = load i64, i64* %n, align 8
  %n.plus4 = add i64 %n.val5, 4
  %graph.idx.np4 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %n.plus4
  store i32 1, i32* %graph.idx.np4, align 4

  %n.val6 = load i64, i64* %n, align 8
  %fourn = shl i64 %n.val6, 2
  %fournp1 = add i64 %fourn, 1
  %graph.idx4n1 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %fournp1
  store i32 1, i32* %graph.idx4n1, align 4

  %n.val7 = load i64, i64* %n, align 8
  %twon.c = shl i64 %n.val7, 1
  %twonp5 = add i64 %twon.c, 5
  %graph.idx2n5 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %twonp5
  store i32 1, i32* %graph.idx2n5, align 4

  %n.val8 = load i64, i64* %n, align 8
  %fourn.b = shl i64 %n.val8, 2
  %fiven = add i64 %fourn.b, %n.val8
  %fivenp2 = add i64 %fiven, 2
  %graph.idx5n2 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %fivenp2
  store i32 1, i32* %graph.idx5n2, align 4

  %n.val9 = load i64, i64* %n, align 8
  %fourn.c = shl i64 %n.val9, 2
  %fournp5 = add i64 %fourn.c, 5
  %graph.idx4n5 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %fournp5
  store i32 1, i32* %graph.idx4n5, align 4

  %n.val10 = load i64, i64* %n, align 8
  %fourn.d = shl i64 %n.val10, 2
  %fiven.d = add i64 %fourn.d, %n.val10
  %fivenp4 = add i64 %fiven.d, 4
  %graph.idx5n4 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %fivenp4
  store i32 1, i32* %graph.idx5n4, align 4

  %n.val11 = load i64, i64* %n, align 8
  %fourn.e = shl i64 %n.val11, 2
  %fiven.e = add i64 %fourn.e, %n.val11
  %fivenp6 = add i64 %fiven.e, 6
  %graph.idx5n6 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %fivenp6
  store i32 1, i32* %graph.idx5n6, align 4

  %n.val12 = load i64, i64* %n, align 8
  %twon.d = shl i64 %n.val12, 1
  %threen.c = add i64 %twon.d, %n.val12
  %sixn = shl i64 %threen.c, 1
  %sixnp5 = add i64 %sixn, 5
  %graph.idx6n5 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %sixnp5
  store i32 1, i32* %graph.idx6n5, align 4

  store i64 0, i64* %src, align 8
  store i64 0, i64* %out_len, align 8

  %graph.base = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 0
  %out.base = getelementptr inbounds [48 x i64], [48 x i64]* %out, i64 0, i64 0
  %n.call = load i64, i64* %n, align 8
  %src.call = load i64, i64* %src, align 8
  call void @dfs(i32* %graph.base, i64 %n.call, i64 %src.call, i64* %out.base, i64* %out_len)

  %hdr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %src.print = load i64, i64* %src, align 8
  %printf.hdr = call i32 (i8*, ...) @printf(i8* %hdr, i64 %src.print)

  store i64 0, i64* %i, align 8
  br label %loop.header

loop.header:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %i.cur, %len.cur
  br i1 %cond, label %loop.body, label %loop.end

loop.body:
  %i.next1 = add i64 %i.cur, 1
  %more = icmp ult i64 %i.next1, %len.cur
  %space = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep = select i1 %more, i8* %space, i8* %empty

  %out.i.ptr = getelementptr inbounds [48 x i64], [48 x i64]* %out, i64 0, i64 %i.cur
  %out.i.val = load i64, i64* %out.i.ptr, align 8

  %fmt.elem = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  %printf.elem = call i32 (i8*, ...) @printf(i8* %fmt.elem, i64 %out.i.val, i8* %sep)

  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop.header

loop.end:
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}