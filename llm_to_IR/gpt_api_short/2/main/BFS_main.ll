; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: demonstrate BFS on a hardcoded 7-node graph and print traversal and distances (confidence=0.85). Evidence: calls bfs(adj, n, src, ...) and prints "BFS order from %zu", "dist(%zu -> %zu) = %d\n"
; Preconditions: none
; Postconditions: returns 0

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare dso_local void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare dso_local i32 @_printf(i8*, ...)
declare dso_local i32 @_putchar(i32)

@.str_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %out_count = alloca i64, align 8
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %v = alloca i64, align 8
  %j = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %out_count, align 8

  ; zero adj[49]
  store i64 0, i64* %j, align 8
  br label %zero.loop

zero.loop:                                        ; preds = %zero.body, %entry
  %jv = load i64, i64* %j, align 8
  %zero.cmp = icmp ult i64 %jv, 49
  br i1 %zero.cmp, label %zero.body, label %zero.end

zero.body:                                        ; preds = %zero.loop
  %adj.ptr.j = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %jv
  store i32 0, i32* %adj.ptr.j, align 4
  %j.next = add i64 %jv, 1
  store i64 %j.next, i64* %j, align 8
  br label %zero.loop

zero.end:                                         ; preds = %zero.loop
  ; set symmetric undirected edges as per disassembly
  %adj.1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.1, align 4
  %adj.2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.2, align 4
  %adj.7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.7, align 4
  %adj.10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.10, align 4
  %adj.11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.11, align 4
  %adj.14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.14, align 4
  %adj.19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.19, align 4
  %adj.22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.22, align 4
  %adj.29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.29, align 4
  %adj.33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.33, align 4
  %adj.37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.37, align 4
  %adj.39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.39, align 4
  %adj.41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.41, align 4
  %adj.47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.47, align 4

  ; call bfs(adj, n=7, src=0, dist, order, &out_count)
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 %n.val, i64 %src.val, i32* %dist.ptr, i64* %order.ptr, i64* %out_count)

  ; print header
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %call.hdr = call i32 (i8*, ...) @_printf(i8* %hdr.ptr, i64 %src.val)

  ; print BFS order
  store i64 0, i64* %i, align 8
  br label %order.loop

order.loop:                                       ; preds = %order.body, %zero.end
  %i.val = load i64, i64* %i, align 8
  %cnt = load i64, i64* %out_count, align 8
  %cond = icmp ult i64 %i.val, %cnt
  br i1 %cond, label %order.body, label %order.end

order.body:                                       ; preds = %order.loop
  %i.plus1 = add i64 %i.val, 1
  %has_space = icmp ult i64 %i.plus1, %cnt
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %delim = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.val
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %fmt.pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call.pair = call i32 (i8*, ...) @_printf(i8* %fmt.pair, i64 %ord.elem, i8* %delim)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %order.loop

order.end:                                        ; preds = %order.loop
  %putc = call i32 @_putchar(i32 10)

  ; print distances
  store i64 0, i64* %v, align 8
  br label %dist.loop

dist.loop:                                        ; preds = %dist.body, %order.end
  %v.val = load i64, i64* %v, align 8
  %n.val2 = load i64, i64* %n, align 8
  %dist.cond = icmp ult i64 %v.val, %n.val2
  br i1 %dist.cond, label %dist.body, label %done

dist.body:                                        ; preds = %dist.loop
  %d.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.val
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %src2 = load i64, i64* %src, align 8
  %call.dist = call i32 (i8*, ...) @_printf(i8* %fmt.dist, i64 %src2, i64 %v.val, i32 %d.val)
  %v.next = add i64 %v.val, 1
  store i64 %v.next, i64* %v, align 8
  br label %dist.loop

done:                                             ; preds = %dist.loop
  ret i32 0
}