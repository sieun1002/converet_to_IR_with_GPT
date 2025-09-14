; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a 7-vertex graph (adjacency matrix), run BFS from 0, then print visit order and distances (confidence=0.95). Evidence: call to bfs with adj/dist/order, prints "BFS order" and "dist(...)=..."
; Preconditions: bfs expects an n x n i32 adjacency matrix (row-major), dist buffer of n i32s, order buffer of at least n i64s, and writes out_len.
; Postconditions: Prints BFS visitation order and distances from start.

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\n\00", align 1

declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %i = alloca i64, align 8
  %k = alloca i64, align 8
  %j = alloca i64, align 8
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8
  store i64 0, i64* %i, align 8
  br label %zero.loop

zero.loop:                                        ; preds = %zero.body, %entry
  %iv = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %iv, 49
  br i1 %cmp, label %zero.body, label %zero.end

zero.body:                                        ; preds = %zero.loop
  %elem = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %iv
  store i32 0, i32* %elem, align 4
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %zero.loop

zero.end:                                         ; preds = %zero.loop
  ; set fixed edges
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %nv = load i64, i64* %n, align 8
  ; index = n
  %p_n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %nv
  store i32 1, i32* %p_n, align 4
  ; index = 2n
  %mul2 = add i64 %nv, %nv
  %p_2n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul2
  store i32 1, i32* %p_2n, align 4
  ; index = n + 3
  %n_plus_3 = add i64 %nv, 3
  %p_n_plus_3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n_plus_3
  store i32 1, i32* %p_n_plus_3, align 4
  ; index = 3n + 1
  %tmp2n = add i64 %nv, %nv
  %tmp3n = add i64 %tmp2n, %nv
  %i_3n_1 = add i64 %tmp3n, 1
  %p_3n_1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i_3n_1
  store i32 1, i32* %p_3n_1, align 4
  ; index = n + 4
  %n_plus_4 = add i64 %nv, 4
  %p_n_plus_4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n_plus_4
  store i32 1, i32* %p_n_plus_4, align 4
  ; index = 4n + 1
  %tmp4n = shl i64 %nv, 2
  %i_4n_1 = add i64 %tmp4n, 1
  %p_4n_1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i_4n_1
  store i32 1, i32* %p_4n_1, align 4
  ; index = 2n + 5
  %i_2n_5 = add i64 %mul2, 5
  %p_2n_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i_2n_5
  store i32 1, i32* %p_2n_5, align 4
  ; index = 5n + 2
  %tmp5n = add i64 %tmp4n, %nv
  %i_5n_2 = add i64 %tmp5n, 2
  %p_5n_2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i_5n_2
  store i32 1, i32* %p_5n_2, align 4
  ; index = 4n + 5
  %i_4n_5 = add i64 %tmp4n, 5
  %p_4n_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i_4n_5
  store i32 1, i32* %p_4n_5, align 4
  ; index = 5n + 4
  %i_5n_4 = add i64 %tmp5n, 4
  %p_5n_4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i_5n_4
  store i32 1, i32* %p_5n_4, align 4
  ; index = 5n + 6
  %i_5n_6 = add i64 %tmp5n, 6
  %p_5n_6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i_5n_6
  store i32 1, i32* %p_5n_6, align 4
  ; index = 6n + 5
  %tmp6n = add i64 %tmp3n, %tmp3n
  %i_6n_5 = add i64 %tmp6n, 5
  %p_6n_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i_6n_5
  store i32 1, i32* %p_6n_5, align 4

  ; call bfs(adj, n, start, dist, order, &out_len)
  %adjptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %distptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %orderptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %nv2 = load i64, i64* %n, align 8
  %startv = load i64, i64* %start, align 8
  call void @bfs(i32* %adjptr, i64 %nv2, i64 %startv, i32* %distptr, i64* %orderptr, i64* %out_len)

  ; print header
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.header, i64 0, i64 0
  %h = call i32 @printf(i8* %fmt1, i64 %startv)

  ; print order
  store i64 0, i64* %k, align 8
  br label %order.check

order.check:                                      ; preds = %order.body, %zero.end
  %kval = load i64, i64* %k, align 8
  %len = load i64, i64* %out_len, align 8
  %lt = icmp ult i64 %kval, %len
  br i1 %lt, label %order.body, label %order.end

order.body:                                       ; preds = %order.check
  %next = add i64 %kval, 1
  %len2 = load i64, i64* %out_len, align 8
  %has_more = icmp ult i64 %next, %len2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr
  %ovalptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %kval
  %oval = load i64, i64* %ovalptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  %p = call i32 @printf(i8* %fmt2, i64 %oval, i8* %sep)
  %kinc = add i64 %kval, 1
  store i64 %kinc, i64* %k, align 8
  br label %order.check

order.end:                                        ; preds = %order.check
  %c = call i32 @putchar(i32 10)

  ; print distances
  store i64 0, i64* %j, align 8
  br label %dist.check

dist.check:                                       ; preds = %dist.body, %order.end
  %jval = load i64, i64* %j, align 8
  %ncur = load i64, i64* %n, align 8
  %lt2 = icmp ult i64 %jval, %ncur
  br i1 %lt2, label %dist.body, label %done

dist.body:                                        ; preds = %dist.check
  %dp = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %jval
  %dval = load i32, i32* %dp, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %startv2 = load i64, i64* %start, align 8
  %pr = call i32 @printf(i8* %fmt3, i64 %startv2, i64 %jval, i32 %dval)
  %jinc = add i64 %jval, 1
  store i64 %jinc, i64* %j, align 8
  br label %dist.check

done:                                             ; preds = %dist.check
  ret i32 0
}