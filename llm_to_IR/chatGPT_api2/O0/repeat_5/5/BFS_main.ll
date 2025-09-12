; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a 7x7 adjacency matrix, run BFS from node 0, then print BFS order and distances (confidence=0.95). Evidence: initializes 7*7 int matrix and calls bfs(adj, 7, 0, dist, order, len); formatted prints of order and dist.

@.str0 = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str2 = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  ; n = 7, src = 0
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)
  ; set adjacency entries to 1 (indices: 7, 10, 11, 14, 19, 22, 29, 33, 37, 39, 41, 47)
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj0, align 4
  %adj1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj1, align 4
  %adj2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj2, align 4
  %adj3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj3, align 4
  %adj4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj4, align 4
  %adj5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj5, align 4
  %adj6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj6, align 4
  %adj7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj7, align 4
  %adj8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj8, align 4
  %adj9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj9, align 4
  %adj10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj10, align 4
  %adj11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj11, align 4
  store i64 0, i64* %order_len, align 8
  %adj_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj_ptr, i64 7, i64 0, i32* %dist_ptr, i64* %order_ptr, i64* %order_len)
  ; print BFS order header
  %fmt0 = getelementptr inbounds [21 x i8], [21 x i8]* @.str0, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @_printf(i8* %fmt0, i64 0)
  ; loop over order
  br label %order_loop.check

order_loop.check:                                   ; preds = %order_loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %order_loop.body ]
  %len = load i64, i64* %order_len, align 8
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %order_loop.body, label %after_order_loop

order_loop.body:                                    ; preds = %order_loop.check
  %i.plus1 = add i64 %i, 1
  %has_space = icmp ult i64 %i.plus1, %len
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %sep = select i1 %has_space, i8* %sep.space, i8* %sep.empty
  %ord.gep = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %ord.val = load i64, i64* %ord.gep, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @_printf(i8* %fmt1, i64 %ord.val, i8* %sep)
  %i.next = add i64 %i, 1
  br label %order_loop.check

after_order_loop:                                   ; preds = %order_loop.check
  %call2 = call i32 @_putchar(i32 10)
  br label %dist_loop.check

dist_loop.check:                                    ; preds = %dist_loop.body, %after_order_loop
  %j = phi i64 [ 0, %after_order_loop ], [ %j.next, %dist_loop.body ]
  %j.cond = icmp ult i64 %j, 7
  br i1 %j.cond, label %dist_loop.body, label %ret

dist_loop.body:                                     ; preds = %dist_loop.check
  %d.gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %d.val = load i32, i32* %d.gep, align 4
  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @.str2, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @_printf(i8* %fmt2, i64 0, i64 %j, i32 %d.val)
  %j.next = add i64 %j, 1
  br label %dist_loop.check

ret:                                                ; preds = %dist_loop.check
  ret i32 0
}