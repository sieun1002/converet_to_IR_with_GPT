; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a small graph, run dfs from start vertex, and print DFS preorder. (confidence=0.92). Evidence: call to dfs; printf strings "DFS preorder from %zu: " and "%zu%s"
; Preconditions: dfs treats %graph as a flattened i32 adjacency structure of length 48; %out has capacity for at least 64 vertices.
; Postconditions: Prints the DFS preorder from start, space-separated, then a newline.

@.str = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str2 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.spc = private unnamed_addr constant [2 x i8] c" \00", align 1
@.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %graph = alloca [48 x i32], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out = alloca [64 x i64], align 16
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %graph_i8 = bitcast [48 x i32]* %graph to i8*
  call void @llvm.memset.p0i8.i64(i8* %graph_i8, i8 0, i64 192, i1 false)

  ; graph[1] = 1
  %g1 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 1
  store i32 1, i32* %g1, align 4
  ; graph[2] = 1
  %g2 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 2
  store i32 1, i32* %g2, align 4

  %nval = load i64, i64* %n, align 8

  ; graph[n] = 1
  %g_n = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %nval
  store i32 1, i32* %g_n, align 4

  ; graph[2n] = 1
  %two_n = add i64 %nval, %nval
  %g_2n = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %two_n
  store i32 1, i32* %g_2n, align 4

  ; graph[n+3] = 1
  %n_plus_3 = add i64 %nval, 3
  %g_n3 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %n_plus_3
  store i32 1, i32* %g_n3, align 4

  ; graph[3n+1] = 1
  %three_n = add i64 %two_n, %nval
  %three_n_plus_1 = add i64 %three_n, 1
  %g_3n1 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %three_n_plus_1
  store i32 1, i32* %g_3n1, align 4

  ; graph[n+4] = 1
  %n_plus_4 = add i64 %nval, 4
  %g_n4 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %n_plus_4
  store i32 1, i32* %g_n4, align 4

  ; graph[4n+1] = 1
  %four_n = mul i64 %nval, 4
  %four_n_plus_1 = add i64 %four_n, 1
  %g_4n1 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %four_n_plus_1
  store i32 1, i32* %g_4n1, align 4

  ; graph[2n+5] = 1
  %two_n_plus_5 = add i64 %two_n, 5
  %g_2n5 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %two_n_plus_5
  store i32 1, i32* %g_2n5, align 4

  ; graph[5n+2] = 1
  %five_n = add i64 %four_n, %nval
  %five_n_plus_2 = add i64 %five_n, 2
  %g_5n2 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %five_n_plus_2
  store i32 1, i32* %g_5n2, align 4

  ; graph[4n+5] = 1
  %four_n_plus_5 = add i64 %four_n, 5
  %g_4n5 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %four_n_plus_5
  store i32 1, i32* %g_4n5, align 4

  ; graph[5n+4] = 1
  %five_n_plus_4 = add i64 %five_n, 4
  %g_5n4 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %five_n_plus_4
  store i32 1, i32* %g_5n4, align 4

  ; graph[5n+6] = 1
  %five_n_plus_6 = add i64 %five_n, 6
  %g_5n6 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %five_n_plus_6
  store i32 1, i32* %g_5n6, align 4

  ; graph[6n+5] = 1
  %six_n = add i64 %two_n, %four_n
  %six_n_plus_5 = add i64 %six_n, 5
  %g_6n5 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 %six_n_plus_5
  store i32 1, i32* %g_6n5, align 4

  ; call dfs(graph, n, start, out, out_len)
  %graph_ptr = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 0
  %out_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  %start_val = load i64, i64* %start, align 8
  call void @dfs(i32* %graph_ptr, i64 %nval, i64 %start_val, i64* %out_ptr, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %start_val)

  ; for (i = 0; i < out_len; ++i) printf("%zu%s", out[i], (i+1 < out_len) ? " " : "");
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %sel, %entry
  %i_val = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i_val, %len
  br i1 %cmp, label %loop_body, label %loop_end

loop_body:                                        ; preds = %loop
  %next = add i64 %i_val, 1
  %cond = icmp ult i64 %next, %len
  br i1 %cond, label %space, label %empty

space:                                            ; preds = %loop_body
  %sp = getelementptr inbounds [2 x i8], [2 x i8]* @.spc, i64 0, i64 0
  br label %sel

empty:                                            ; preds = %loop_body
  %em = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  br label %sel

sel:                                              ; preds = %empty, %space
  %suffix = phi i8* [ %sp, %space ], [ %em, %empty ]
  %out_i_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 %i_val
  %val = load i64, i64* %out_i_ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %suffix)
  %inc = add i64 %i_val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

loop_end:                                         ; preds = %loop
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}