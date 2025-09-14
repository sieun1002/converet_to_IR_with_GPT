; ModuleID = 'recovered_main'
source_filename = "recovered_main"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_hdr  = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  ; locals
  %adj      = alloca [49 x i32], align 16
  %out      = alloca [8 x i64], align 16
  %n        = alloca i64, align 8
  %start    = alloca i64, align 8
  %out_len  = alloca i64, align 8
  %i        = alloca i64, align 8

  ; n = 7
  store i64 7, i64* %n, align 8

  ; memset adj[49] = {0}
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %adj.i8, i8 0, i64 196, i1 false)

  ; Initialize adjacency matrix entries to 1:
  ; indices: 1, 2, 7, 10, 11, 14, 19, 22, 29, 33, 37, 39, 41, 47
  %p1  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %p7  = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
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
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4

  ; start = 0; out_len = 0
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; call dfs(adj, n, start, out, &out_len)
  %graph.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val0 = load i64, i64* %start, align 8
  %out.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %graph.ptr, i64 %n.val, i64 %start.val0, i64* %out.ptr, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_hdr, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  call i32 (i8*, ...) @printf(i8* %hdr.ptr, i64 %start.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cont = icmp ult i64 %i.cur, %len.cur
  br i1 %cont, label %body, label %done

body:                                             ; preds = %loop
  ; choose separator: " " if i+1 < len else ""
  %i.plus1 = add i64 %i.cur, 1
  %has_more = icmp ult i64 %i.plus1, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep.ptr = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr

  ; load out[i]
  %elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i.cur
  %elem.val = load i64, i64* %elem.ptr, align 8

  ; printf("%zu%s", out[i], sep)
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_elem, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %elem.val, i8* %sep.ptr)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:                                             ; preds = %loop
  call i32 @putchar(i32 10)
  ret i32 0
}