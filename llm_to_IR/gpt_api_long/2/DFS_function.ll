; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix, run DFS preorder from 0, and print the order (confidence=0.90). Evidence: adjacency matrix indices formed as r*n+c with n=7; call to dfs(adj, n, start, order, &count) and printing "%zu%s".
; Preconditions: dfs expects a row-major i32 adjacency matrix of size n*n, an order buffer with capacity >= n (i64 entries), and a valid out_count pointer (i64).
; Postconditions: Prints "DFS preorder from %zu: " followed by the preorder vertex sequence separated by spaces and a trailing newline.

@str_header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %order = alloca [8 x i64], align 16
  %count = alloca i64, align 8
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %order.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 0

  ; n = 7, start = 0, count = 0
  %n = add i64 0, 7
  %start = add i64 0, 0
  store i64 0, i64* %count, align 8

  ; zero adj[0..48]
  br label %zero.loop

zero.loop:                                           ; preds = %zero.loop, %entry
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.loop ]
  %zcmp = icmp ult i64 %zi, 49
  br i1 %zcmp, label %zero.body, label %zero.done

zero.body:                                           ; preds = %zero.loop
  %zgep = getelementptr inbounds i32, i32* %adj.ptr, i64 %zi
  store i32 0, i32* %zgep, align 4
  %zi.next = add i64 %zi, 1
  br label %zero.loop

zero.done:                                           ; preds = %zero.loop
  ; set specific edges to 1
  ; idx 1
  %gep1 = getelementptr inbounds i32, i32* %adj.ptr, i64 1
  store i32 1, i32* %gep1, align 4
  ; idx n
  %gep_n = getelementptr inbounds i32, i32* %adj.ptr, i64 %n
  store i32 1, i32* %gep_n, align 4
  ; idx 2
  %gep2 = getelementptr inbounds i32, i32* %adj.ptr, i64 2
  store i32 1, i32* %gep2, align 4
  ; idx 2n
  %i2n = mul i64 %n, 2
  %gep2n = getelementptr inbounds i32, i32* %adj.ptr, i64 %i2n
  store i32 1, i32* %gep2n, align 4
  ; idx n+3
  %in3 = add i64 %n, 3
  %gepn3 = getelementptr inbounds i32, i32* %adj.ptr, i64 %in3
  store i32 1, i32* %gepn3, align 4
  ; idx 3n+1
  %i3n = mul i64 %n, 3
  %i3n1 = add i64 %i3n, 1
  %gep3n1 = getelementptr inbounds i32, i32* %adj.ptr, i64 %i3n1
  store i32 1, i32* %gep3n1, align 4
  ; idx n+4
  %in4 = add i64 %n, 4
  %gepn4 = getelementptr inbounds i32, i32* %adj.ptr, i64 %in4
  store i32 1, i32* %gepn4, align 4
  ; idx 4n+1
  %i4n = mul i64 %n, 4
  %i4n1 = add i64 %i4n, 1
  %gep4n1 = getelementptr inbounds i32, i32* %adj.ptr, i64 %i4n1
  store i32 1, i32* %gep4n1, align 4
  ; idx 2n+5
  %i2n5 = add i64 %i2n, 5
  %gep2n5 = getelementptr inbounds i32, i32* %adj.ptr, i64 %i2n5
  store i32 1, i32* %gep2n5, align 4
  ; idx 5n+2
  %i5n = mul i64 %n, 5
  %i5n2 = add i64 %i5n, 2
  %gep5n2 = getelementptr inbounds i32, i32* %adj.ptr, i64 %i5n2
  store i32 1, i32* %gep5n2, align 4
  ; idx 4n+5
  %i4n5 = add i64 %i4n, 5
  %gep4n5 = getelementptr inbounds i32, i32* %adj.ptr, i64 %i4n5
  store i32 1, i32* %gep4n5, align 4
  ; idx 5n+4
  %i5n4 = add i64 %i5n, 4
  %gep5n4 = getelementptr inbounds i32, i32* %adj.ptr, i64 %i5n4
  store i32 1, i32* %gep5n4, align 4
  ; idx 5n+6
  %i5n6 = add i64 %i5n, 6
  %gep5n6 = getelementptr inbounds i32, i32* %adj.ptr, i64 %i5n6
  store i32 1, i32* %gep5n6, align 4
  ; idx 6n+5
  %i6n = mul i64 %n, 6
  %i6n5 = add i64 %i6n, 5
  %gep6n5 = getelementptr inbounds i32, i32* %adj.ptr, i64 %i6n5
  store i32 1, i32* %gep6n5, align 4

  ; call dfs(adj, n, start, order, &count)
  call void @dfs(i32* %adj.ptr, i64 %n, i64 %start, i64* %order.ptr, i64* %count)

  ; printf("DFS preorder from %zu: ", start)
  %hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @str_header, i64 0, i64 0
  %call_hdr = call i32 (i8*, ...) @printf(i8* %hdr.ptr, i64 %start)

  ; loop to print order
  %count.val = load i64, i64* %count, align 8
  br label %loop

loop:                                                ; preds = %loop, %zero.done
  %i = phi i64 [ 0, %zero.done ], [ %i.next, %loop ]
  %cmp = icmp ult i64 %i, %count.val
  br i1 %cmp, label %body, label %done

body:                                                ; preds = %loop
  %next = add i64 %i, 1
  %has_more = icmp ult i64 %next, %count.val
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @str_empty, i64 0, i64 0
  %sep = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr
  %ord.gep = getelementptr inbounds i64, i64* %order.ptr, i64 %i
  %ord.val = load i64, i64* %ord.gep, align 8
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @str_fmt, i64 0, i64 0
  %call_item = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %ord.val, i8* %sep)
  %i.next = add i64 %i, 1
  br label %loop

done:                                                ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}