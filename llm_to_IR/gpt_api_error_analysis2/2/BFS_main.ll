; ModuleID = 'bfs_main'
target triple = "x86_64-unknown-linux-gnu"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.pair = private unnamed_addr constant [5 x i8] c"%zu%s\00", align 1
@.str.sep = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4

  store i64 0, i64* %out_len, align 8

  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.ptr, i64 7, i64 0, i32* %dist.ptr, i64* %order.ptr, i64* %out_len)

  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 0)

  br label %loop

loop:                                             ; preds = %entry, %cont1
  %i = phi i64 [ 0, %entry ], [ %i.next, %cont1 ]
  %len = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %ip1 = add i64 %i, 1
  %len2 = load i64, i64* %out_len, align 8
  %islast = icmp uge i64 %ip1, %len2
  br i1 %islast, label %sel_empty, label %sel_space

sel_space:                                        ; preds = %body
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.sep, i64 0, i64 0
  br label %cont1

sel_empty:                                        ; preds = %body
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  br label %cont1

cont1:                                            ; preds = %sel_empty, %sel_space
  %sep = phi i8* [ %space.ptr, %sel_space ], [ %empty.ptr, %sel_empty ]
  %elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.pair, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %elem, i8* %sep)
  %i.next = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %pc = call i32 @putchar(i32 10)
  br label %dloop

dloop:                                            ; preds = %after, %dloop_body
  %j = phi i64 [ 0, %after ], [ %j.next, %dloop_body ]
  %cmpj = icmp ult i64 %j, 7
  br i1 %cmpj, label %dloop_body, label %ret

dloop_body:                                       ; preds = %dloop
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dval = load i32, i32* %dptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 0, i64 %j, i32 %dval)
  %j.next = add i64 %j, 1
  br label %dloop

ret:                                              ; preds = %dloop
  ret i32 0
}