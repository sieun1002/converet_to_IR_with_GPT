; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a 7-vertex undirected graph (adjacency matrix), run BFS from 0, print visit order and distances (confidence=0.95). Evidence: n=7, stores into n*n matrix at symmetric indices; call to bfs followed by formatted order/dist printing.
; Preconditions: bfs expects a 0/1 adjacency matrix of size n*n (row-major), dist buffer of n i32s, order buffer of at least n i64s, and an i64 order length out-parameter.
; Postconditions: Prints BFS order and per-vertex distances from source 0.

@.str_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; Locals
  %adjarr = alloca [49 x i32], align 16
  %distarr = alloca [7 x i32], align 16
  %orderarr = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8

  ; Initialize adjacency matrix to zero (49 * 4 = 196 bytes)
  %adj_i8 = bitcast [49 x i32]* %adjarr to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  ; Set undirected edges: (0,1),(1,0); (0,2),(2,0); (1,3),(3,1); (1,4),(4,1);
  ; (2,5),(5,2); (4,5),(5,4); (5,6),(6,5)
  %adjp = getelementptr inbounds [49 x i32], [49 x i32]* %adjarr, i64 0, i64 0
  ; indices: 1,7,2,14,10,22,11,29,19,37,33,39,41,47
  %p1  = getelementptr inbounds i32, i32* %adjp, i64 1
  store i32 1, i32* %p1, align 4
  %p7  = getelementptr inbounds i32, i32* %adjp, i64 7
  store i32 1, i32* %p7, align 4
  %p2  = getelementptr inbounds i32, i32* %adjp, i64 2
  store i32 1, i32* %p2, align 4
  %p14 = getelementptr inbounds i32, i32* %adjp, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds i32, i32* %adjp, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds i32, i32* %adjp, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds i32, i32* %adjp, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds i32, i32* %adjp, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds i32, i32* %adjp, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds i32, i32* %adjp, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds i32, i32* %adjp, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds i32, i32* %adjp, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adjp, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adjp, i64 47
  store i32 1, i32* %p47, align 4

  ; Prepare other buffers/values
  store i64 0, i64* %order_len, align 8
  %distp = getelementptr inbounds [7 x i32], [7 x i32]* %distarr, i64 0, i64 0
  %orderp = getelementptr inbounds [7 x i64], [7 x i64]* %orderarr, i64 0, i64 0

  ; Call bfs(adj, n=7, src=0, dist, order, order_len)
  call void @bfs(i32* %adjp, i64 7, i64 0, i32* %distp, i64* %orderp, i64* %order_len)

  ; printf("BFS order from %zu: ", 0)
  %hdrptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %_hdr = bitcast i8* %hdrptr to i8*
  call i32 @_printf(i8* %_hdr, i64 0)

  ; Print order: for (i=0; i<order_len; ++i) printf("%zu%s", order[i], (i+1 < order_len) ? " " : "")
  %len0 = load i64, i64* %order_len, align 8
  br label %order_loop

order_loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %order_body ]
  %len = phi i64 [ %len0, %entry ], [ %len, %order_body ]
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %order_body, label %order_done

order_body:
  %i1 = add i64 %i, 1
  %spcptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %emptyptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %use_space = icmp ult i64 %i1, %len
  %sep = select i1 %use_space, i8* %spcptr, i8* %emptyptr
  %elem_ptr = getelementptr inbounds i64, i64* %orderp, i64 %i
  %elem = load i64, i64* %elem_ptr, align 8
  %fmt_zu_s = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  call i32 @_printf(i8* %fmt_zu_s, i64 %elem, i8* %sep)
  %i.next = add i64 %i, 1
  br label %order_loop

order_done:
  call i32 @_putchar(i32 10)

  ; Print distances: for (v=0; v<7; ++v) printf("dist(%zu -> %zu) = %d\n", 0, v, dist[v])
  br label %dist_loop

dist_loop:
  %v = phi i64 [ 0, %order_done ], [ %v.next, %dist_body ]
  %vcond = icmp ult i64 %v, 7
  br i1 %vcond, label %dist_body, label %ret

dist_body:
  %dptr = getelementptr inbounds i32, i32* %distp, i64 %v
  %d = load i32, i32* %dptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  call i32 @_printf(i8* %fmt_dist, i64 0, i64 %v, i32 %d)
  %v.next = add i64 %v, 1
  br label %dist_loop

ret:
  ret i32 0
}