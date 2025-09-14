; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: Build 7x7 adjacency matrix, run bfs from 0, then print BFS order and per-node distances (confidence=0.92). Evidence: 49-int zeroing pattern (7x7), indices using multiples of N=7; printf formats for BFS order and dist.
; Preconditions: bfs expects: (i32* adj_matrix, i64 n, i64 src, i32* dist_out, i64* order_out, i64* order_len_out) with arrays sized for n.
; Postconditions: Prints BFS visitation order and distances from source; returns 0.

; Only the necessary external declarations:
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

@.str_header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_space  = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty  = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_zus    = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_dist   = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %matrix = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %n = alloca i64, align 8
  %src = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %len, align 8

  ; zero matrix[49]
  %m_base0 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 0
  br label %zero.loop

zero.loop:
  %z.idx = phi i64 [ 0, %entry ], [ %z.next, %zero.loop ]
  %z.ptr = getelementptr inbounds i32, i32* %m_base0, i64 %z.idx
  store i32 0, i32* %z.ptr, align 4
  %z.next = add nuw nsw i64 %z.idx, 1
  %z.done = icmp eq i64 %z.next, 49
  br i1 %z.done, label %after.zero, label %zero.loop

after.zero:
  ; set specific edges to 1 (undirected)
  %m_base = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 0
  ; arr[1] = 1
  %p1 = getelementptr inbounds i32, i32* %m_base, i64 1
  store i32 1, i32* %p1, align 4
  ; arr[7] = 1
  %p7 = getelementptr inbounds i32, i32* %m_base, i64 7
  store i32 1, i32* %p7, align 4
  ; arr[2] = 1
  %p2 = getelementptr inbounds i32, i32* %m_base, i64 2
  store i32 1, i32* %p2, align 4
  ; arr[14] = 1
  %p14 = getelementptr inbounds i32, i32* %m_base, i64 14
  store i32 1, i32* %p14, align 4
  ; arr[10] = 1
  %p10 = getelementptr inbounds i32, i32* %m_base, i64 10
  store i32 1, i32* %p10, align 4
  ; arr[22] = 1
  %p22 = getelementptr inbounds i32, i32* %m_base, i64 22
  store i32 1, i32* %p22, align 4
  ; arr[11] = 1
  %p11 = getelementptr inbounds i32, i32* %m_base, i64 11
  store i32 1, i32* %p11, align 4
  ; arr[29] = 1
  %p29 = getelementptr inbounds i32, i32* %m_base, i64 29
  store i32 1, i32* %p29, align 4
  ; arr[19] = 1
  %p19 = getelementptr inbounds i32, i32* %m_base, i64 19
  store i32 1, i32* %p19, align 4
  ; arr[37] = 1
  %p37 = getelementptr inbounds i32, i32* %m_base, i64 37
  store i32 1, i32* %p37, align 4
  ; arr[33] = 1
  %p33 = getelementptr inbounds i32, i32* %m_base, i64 33
  store i32 1, i32* %p33, align 4
  ; arr[39] = 1
  %p39 = getelementptr inbounds i32, i32* %m_base, i64 39
  store i32 1, i32* %p39, align 4
  ; arr[41] = 1
  %p41 = getelementptr inbounds i32, i32* %m_base, i64 41
  store i32 1, i32* %p41, align 4
  ; arr[47] = 1
  %p47 = getelementptr inbounds i32, i32* %m_base, i64 47
  store i32 1, i32* %p47, align 4

  ; call bfs(matrix, n, src, dist, order, &len)
  %dist_base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order_base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %m_base, i64 %n.val, i64 %src.val, i32* %dist_base, i64* %order_base, i64* %len)

  ; printf("BFS order from %zu: ", src)
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_header, i64 0, i64 0
  %call.hdr = call i32 (i8*, ...) @printf(i8* %hdr.ptr, i64 %src.val)

  ; for (i = 0; i < len; ++i) printf("%zu%s", order[i], (i+1 < len) ? " " : "")
  store i64 0, i64* %i, align 8
  br label %order.loop

order.loop:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp.ol = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp.ol, label %order.body, label %order.end

order.body:
  %i.next1 = add nuw nsw i64 %i.cur, 1
  %has.space = icmp ult i64 %i.next1, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suffix = select i1 %has.space, i8* %space.ptr, i8* %empty.ptr
  %ord.elem.ptr = getelementptr inbounds i64, i64* %order_base, i64 %i.cur
  %ord.val = load i64, i64* %ord.elem.ptr, align 8
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %call.ord = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %ord.val, i8* %suffix)
  %i.inc = add nuw nsw i64 %i.cur, 1
  store i64 %i.inc, i64* %i, align 8
  br label %order.loop

order.end:
  ; putchar('\n')
  %nl = call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", src, j, dist[j])
  store i64 0, i64* %j, align 8
  br label %dist.loop

dist.loop:
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp.dl = icmp ult i64 %j.cur, %n.cur
  br i1 %cmp.dl, label %dist.body, label %dist.end

dist.body:
  %d.ptr = getelementptr inbounds i32, i32* %dist_base, i64 %j.cur
  %d.val = load i32, i32* %d.ptr, align 4
  %dist.fmt = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call.dist = call i32 (i8*, ...) @printf(i8* %dist.fmt, i64 %src.val, i64 %j.cur, i32 %d.val)
  %j.inc = add nuw nsw i64 %j.cur, 1
  store i64 %j.inc, i64* %j, align 8
  br label %dist.loop

dist.end:
  ret i32 0
}