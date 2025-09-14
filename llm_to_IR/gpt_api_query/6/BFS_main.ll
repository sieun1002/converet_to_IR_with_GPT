; ModuleID = 'main_from_disasm'
target triple = "x86_64-pc-linux-gnu"

@.str.bfs   = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.zus   = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist  = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  ; locals
  %adj        = alloca [49 x i32], align 16         ; adjacency matrix (7x7) row-major
  %dist       = alloca [7 x i32], align 16          ; distances
  %order      = alloca [7 x i64], align 16          ; BFS order (size_t)
  %order_len  = alloca i64, align 8
  %n          = alloca i64, align 8
  %src        = alloca i64, align 8
  %i          = alloca i64, align 8
  %v          = alloca i64, align 8

  ; n = 7, src = 0, order_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  ; memset adj to zero (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set undirected edges (flattened indices in row-major with n = 7)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p1  = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1,  align 4            ; (0,1)
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7,  align 4            ; (1,0)
  %p2  = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2,  align 4            ; (0,2)
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4            ; (2,0)
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4            ; (1,3)
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4            ; (3,1)
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4            ; (1,4)
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4            ; (4,1)
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4            ; (2,5)
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4            ; (5,2)
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4            ; (4,5)
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4            ; (5,4)
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4            ; (5,6)
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4            ; (6,5)

  ; bfs(adj, n, src, dist, order, &order_len)
  %adj.ptr   = getelementptr inbounds [49 x i32], [49 x i32]* %adj,  i64 0, i64 0
  %dist.ptr  = getelementptr inbounds [7 x i32],  [7 x i32]*  %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64],  [7 x i64]*  %order, i64 0, i64 0
  %n.val   = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 %n.val, i64 %src.val, i32* %dist.ptr, i64* %order.ptr, i64* %order_len)

  ; printf("BFS order from %zu: ", src)
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %src2 = load i64, i64* %src, align 8
  call i32 (i8*, ...) @printf(i8* %fmt1, i64 %src2)

  ; print order
  store i64 0, i64* %i, align 8
  br label %order.cond

order.cond:
  %i.cur = load i64, i64* %i, align 8
  %olen  = load i64, i64* %order_len, align 8
  %ok    = icmp ult i64 %i.cur, %olen
  br i1 %ok, label %order.body, label %order.end

order.body:
  %ip1 = add i64 %i.cur, 1
  %more = icmp ult i64 %ip1, %olen
  %sp.ptr  = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %emp.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep = select i1 %more, i8* %sp.ptr, i8* %emp.ptr

  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zus, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i64 %ord.elem, i8* %sep)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %order.cond

order.end:
  call i32 @putchar(i32 10)

  ; print distances
  store i64 0, i64* %v, align 8
  br label %dist.cond

dist.cond:
  %v.cur = load i64, i64* %v, align 8
  %n.cur = load i64, i64* %n, align 8
  %v.ok  = icmp ult i64 %v.cur, %n.cur
  br i1 %v.ok, label %dist.body, label %done

dist.body:
  %dptr = getelementptr inbounds i32, i32* %dist.ptr, i64 %v.cur
  %dval = load i32, i32* %dptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %src3 = load i64, i64* %src, align 8
  call i32 (i8*, ...) @printf(i8* %fmt3, i64 %src3, i64 %v.cur, i32 %dval)
  %v.next = add i64 %v.cur, 1
  store i64 %v.next, i64* %v, align 8
  br label %dist.cond

done:
  ret i32 0
}