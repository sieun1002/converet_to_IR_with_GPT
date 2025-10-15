; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

@.str_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_sep = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_spc = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_emp = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...) #1
declare i32 @putchar(i32) #1

define void @bfs(i32* nocapture readonly %adj, i64 %n, i64 %src, i32* nocapture %dist, i64* nocapture %out_len, i64* nocapture %order) local_unnamed_addr {
entry:
  %cmp.src = icmp ult i64 %src, %n
  br i1 %cmp.src, label %init, label %ret.zero

init:
  %nn = mul i64 %n, %n
  %i0 = alloca i64, align 8
  %q = alloca i64, align 8
  %visited = alloca i8, align 1
  %qi = alloca i64, align 8
  %qt = alloca i64, align 8
  %len = alloca i64, align 8
  %vis.ptr = bitcast i8* %visited to i8*
  br label %zero_adj

zero_adj:
  %idx0 = phi i64 [ 0, %init ], [ %idx0.next, %zero_adj.body ]
  %cond0 = icmp ult i64 %idx0, %n
  br i1 %cond0, label %zero_adj.body, label %zero_adj.done

zero_adj.body:
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %idx0
  store i32 -1, i32* %dist.gep, align 4
  %vis.gep = getelementptr inbounds i8, i8* %visited, i64 %idx0
  store i8 0, i8* %vis.gep, align 1
  %idx0.next = add i64 %idx0, 1
  br label %zero_adj

zero_adj.done:
  store i64 0, i64* %qi, align 8
  store i64 0, i64* %qt, align 8
  store i64 0, i64* %len, align 8
  %vis.src.gep = getelementptr inbounds i8, i8* %visited, i64 %src
  store i8 1, i8* %vis.src.gep, align 1
  %dist.src.gep = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist.src.gep, align 4
  %qbuf = alloca i64, i64 %n, align 8
  %q.head = load i64, i64* %qt, align 8
  %q.enq.ptr = getelementptr inbounds i64, i64* %qbuf, i64 %q.head
  store i64 %src, i64* %q.enq.ptr, align 8
  %q.head.next = add i64 %q.head, 1
  store i64 %q.head.next, i64* %qt, align 8
  br label %bfs.loop

bfs.loop:
  %qh = load i64, i64* %qi, align 8
  %qtv = load i64, i64* %qt, align 8
  %nonempty = icmp ult i64 %qh, %qtv
  br i1 %nonempty, label %bfs.body, label %bfs.done

bfs.body:
  %deq.ptr = getelementptr inbounds i64, i64* %qbuf, i64 %qh
  %u = load i64, i64* %deq.ptr, align 8
  %qh.next = add i64 %qh, 1
  store i64 %qh.next, i64* %qi, align 8
  %olen = load i64, i64* %len, align 8
  %ord.ptr = getelementptr inbounds i64, i64* %order, i64 %olen
  store i64 %u, i64* %ord.ptr, align 8
  %olen.next = add i64 %olen, 1
  store i64 %olen.next, i64* %len, align 8
  store i64 0, i64* %i0, align 8
  br label %inner.for

inner.for:
  %v = load i64, i64* %i0, align 8
  %cnd = icmp ult i64 %v, %n
  br i1 %cnd, label %inner.body, label %inner.done

inner.body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.gep = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj.gep, align 4
  %has = icmp ne i32 %edge, 0
  br i1 %has, label %check.vis, label %step.v

check.vis:
  %visv.gep = getelementptr inbounds i8, i8* %visited, i64 %v
  %visv = load i8, i8* %visv.gep, align 1
  %notvis = icmp eq i8 %visv, 0
  br i1 %notvis, label %visit.v, label %step.v

visit.v:
  store i8 1, i8* %visv.gep, align 1
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %dist.u.ptr, align 4
  %du1 = add i32 %du, 1
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  store i32 %du1, i32* %dist.v.ptr, align 4
  %qt.cur = load i64, i64* %qt, align 8
  %enq.ptr2 = getelementptr inbounds i64, i64* %qbuf, i64 %qt.cur
  store i64 %v, i64* %enq.ptr2, align 8
  %qt.next2 = add i64 %qt.cur, 1
  store i64 %qt.next2, i64* %qt, align 8
  br label %step.v

step.v:
  %v.next = add i64 %v, 1
  store i64 %v.next, i64* %i0, align 8
  br label %inner.for

inner.done:
  br label %bfs.loop

bfs.done:
  %final.len = load i64, i64* %len, align 8
  store i64 %final.len, i64* %out_len, align 8
  ret void

ret.zero:
  store i64 0, i64* %out_len, align 8
  ret void
}

define i32 @main() local_unnamed_addr {
entry:
  %n = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %nval = load i64, i64* %n, align 8
  %n2 = mul i64 %nval, %nval
  %adj = alloca i32, i64 %n2, align 4
  %dist = alloca i32, i64 %nval, align 4
  %order = alloca i64, i64 %nval, align 8
  %out_len = alloca i64, align 8

  ; zero adjacency matrix
  %zi = alloca i64, align 8
  store i64 0, i64* %zi, align 8
  br label %zloop

zloop:
  %i = load i64, i64* %zi, align 8
  %ok = icmp ult i64 %i, %n2
  br i1 %ok, label %zbody, label %zdone

zbody:
  %adj.gep = getelementptr inbounds i32, i32* %adj, i64 %i
  store i32 0, i32* %adj.gep, align 4
  %i.next = add i64 %i, 1
  store i64 %i.next, i64* %zi, align 8
  br label %zloop

zdone:
  ; set edges for a directed graph
  ; 0 -> 1,2,4
  %e01 = getelementptr inbounds i32, i32* %adj, i64 7
  store i32 1, i32* %e01, align 4
  %e02 = getelementptr inbounds i32, i32* %adj, i64 14
  store i32 1, i32* %e02, align 4
  %e04 = getelementptr inbounds i32, i32* %adj, i64 28
  store i32 1, i32* %e04, align 4
  ; 1 -> 3
  %e13 = getelementptr inbounds i32, i32* %adj, i64 10
  store i32 1, i32* %e13, align 4
  ; 2 -> 3,5
  %e23 = getelementptr inbounds i32, i32* %adj, i64 17
  store i32 1, i32* %e23, align 4
  %e25 = getelementptr inbounds i32, i32* %adj, i64 19
  store i32 1, i32* %e25, align 4
  ; 3 -> 4,6
  %e34 = getelementptr inbounds i32, i32* %adj, i64 25
  store i32 1, i32* %e34, align 4
  %e36 = getelementptr inbounds i32, i32* %adj, i64 27
  store i32 1, i32* %e36, align 4
  ; 4 -> 5
  %e45 = getelementptr inbounds i32, i32* %adj, i64 33
  store i32 1, i32* %e45, align 4
  ; 5 -> 6
  %e56 = getelementptr inbounds i32, i32* %adj, i64 41
  store i32 1, i32* %e56, align 4

  ; call bfs with src = 0
  %src = alloca i64, align 8
  store i64 0, i64* %src, align 8
  %srcv = load i64, i64* %src, align 8
  call void @bfs(i32* %adj, i64 %nval, i64 %srcv, i32* %dist, i64* %out_len, i64* %order)

  ; print header
  %fmt_hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %srcv2 = load i64, i64* %src, align 8
  %ph = call i32 (i8*, ...) @printf(i8* %fmt_hdr.ptr, i64 %srcv2)

  ; print BFS order
  %olen = load i64, i64* %out_len, align 8
  %oi = alloca i64, align 8
  store i64 0, i64* %oi, align 8
  br label %ord.loop

ord.loop:
  %ci = load i64, i64* %oi, align 8
  %cond = icmp ult i64 %ci, %olen
  br i1 %cond, label %ord.body, label %ord.done

ord.body:
  %next = add i64 %ci, 1
  %islast = icmp uge i64 %next, %olen
  %spc.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_spc, i64 0, i64 0
  %emp.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_emp, i64 0, i64 0
  %sel = select i1 %islast, i8* %emp.ptr, i8* %spc.ptr
  %ov.gep = getelementptr inbounds i64, i64* %order, i64 %ci
  %ov = load i64, i64* %ov.gep, align 8
  %fmt_sep.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_sep, i64 0, i64 0
  %po = call i32 (i8*, ...) @printf(i8* %fmt_sep.ptr, i64 %ov, i8* %sel)
  %ci.next = add i64 %ci, 1
  store i64 %ci.next, i64* %oi, align 8
  br label %ord.loop

ord.done:
  %nl = call i32 @putchar(i32 10)

  ; print distances
  %vi = alloca i64, align 8
  store i64 0, i64* %vi, align 8
  br label %dist.loop

dist.loop:
  %vj = load i64, i64* %vi, align 8
  %cndv = icmp ult i64 %vj, %nval
  br i1 %cndv, label %dist.body, label %dist.done

dist.body:
  %dptr = getelementptr inbounds i32, i32* %dist, i64 %vj
  %dv = load i32, i32* %dptr, align 4
  %fmt_dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %srcv3 = load i64, i64* %src, align 8
  %pd = call i32 (i8*, ...) @printf(i8* %fmt_dist.ptr, i64 %srcv3, i64 %vj, i32 %dv)
  %vj.next = add i64 %vj, 1
  store i64 %vj.next, i64* %vi, align 8
  br label %dist.loop

dist.done:
  ret i32 0
}

attributes #1 = { "disable-tail-calls"="false" }