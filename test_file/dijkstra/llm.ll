; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x00000000000010C0
; Intent: Dijkstra shortest paths on a fixed 6-node graph; print dist(0→i) and path 0→5 (confidence=0.95). Evidence: 0x3F3F3F3F INF sentinel; min-unvisited selection/relax loops.
; Preconditions: Graph is encoded as a 6x6 adjacency matrix with -1 for no edge, 0 on diagonals.
; Postconditions: Prints distances and either the path 0→5 or "no path" message.

@adj = internal constant [6 x [6 x i32]] [
[6 x i32] [i32 0, i32 7, i32 9, i32 10, i32 -1, i32 -1],
[6 x i32] [i32 7, i32 0, i32 -1, i32 15, i32 -1, i32 -1],
[6 x i32] [i32 9, i32 -1, i32 0, i32 11, i32 -1, i32 -1],
[6 x i32] [i32 10, i32 15, i32 11, i32 0, i32 6, i32 -1],
[6 x i32] [i32 -1, i32 -1, i32 -1, i32 6, i32 0, i32 9],
[6 x i32] [i32 -1, i32 -1, i32 -1, i32 -1, i32 9, i32 0]
]

@.fmt_dist_inf = internal constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00"
@.fmt_dist_d = internal constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"
@.fmt_no_path = internal constant [25 x i8] c"no path from %zu to %zu\0A\00"
@.fmt_path_hdr = internal constant [17 x i8] c"path %zu -> %zu:\00"
@.fmt_node_sep = internal constant [7 x i8] c" %zu%s\00"
@.arrow = internal constant [4 x i8] c" ->\00"
@.empty = internal constant [1 x i8] c"\00"
@.nl = internal constant [2 x i8] c"\0A\00"

; Only the needed extern declarations:
declare i8* @calloc(i64, i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
%dist = alloca [6 x i32], align 16
%prev = alloca [6 x i32], align 16
%path = alloca [6 x i64], align 16

; Conservative repair: initialize dist/prev even if calloc fails.
br label %init_loop

init_loop: ; i in [0..6)
%i = phi i64 [ 0, %entry ], [ %i.next, %init_loop.body ]
%cmp.i = icmp ult i64 %i, 6
br i1 %cmp.i, label %init_loop.body, label %after_init

init_loop.body:
%dist.gep = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %i
store i32 1061109567, i32* %dist.gep, align 4 ; INF = 0x3F3F3F3F
%prev.gep = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 %i
store i32 -1, i32* %prev.gep, align 4
%i.next = add nuw nsw i64 %i, 1
br label %init_loop

after_init:
; dist[0] = 0
%dist0 = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 0
store i32 0, i32* %dist0, align 4

; visited = calloc(24,1) -> 6 * sizeof(i32)
%vis.raw = call i8* @calloc(i64 24, i64 1)
%vis.null = icmp eq i8* %vis.raw, null
br i1 %vis.null, label %skip_dijk, label %have_vis

have_vis:
%vis = bitcast i8* %vis.raw to i32*

; outer iteration t=0..5
br label %outer.loop

outer.loop:
%t = phi i64 [ 0, %have_vis ], [ %t.next, %outer.after ]
%t.cmp = icmp ult i64 %t, 6
br i1 %t.cmp, label %select.min, label %after_outer

select.min:
; min = INF, u = -1
%min = alloca i32, align 4
store i32 1061109567, i32* %min, align 4
%u = alloca i32, align 4
store i32 -1, i32* %u, align 4

br label %sel.loop

sel.loop:
%j = phi i64 [ 0, %select.min ], [ %j.next, %sel.loop ]
%j.cmp = icmp ult i64 %j, 6
br i1 %j.cmp, label %sel.body, label %sel.done

sel.body:
; if visited[j]==0 and dist[j] < min -> update
%vis.j.ptr = getelementptr inbounds i32, i32* %vis, i64 %j
%vis.j = load i32, i32* %vis.j.ptr, align 4
%is.unvisited = icmp eq i32 %vis.j, 0
br i1 %is.unvisited, label %check.min, label %sel.inc

check.min:
%dj.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %j
%dj = load i32, i32* %dj.ptr, align 4
%curmin = load i32, i32* %min, align 4
%lt = icmp slt i32 %dj, %curmin
br i1 %lt, label %update.min, label %sel.inc

update.min:
store i32 %dj, i32* %min, align 4
%j.trunc = trunc i64 %j to i32
store i32 %j.trunc, i32* %u, align 4
br label %sel.inc

sel.inc:
%j.next = add nuw nsw i64 %j, 1
br label %sel.loop

sel.done:
%u.val = load i32, i32* %u, align 4
%u.neg = icmp slt i32 %u.val, 0
br i1 %u.neg, label %after_outer, label %relax

relax:
; visited[u] = 1
%u.idx = sext i32 %u.val to i64
%vis.u.ptr = getelementptr inbounds i32, i32* %vis, i64 %u.idx
store i32 1, i32* %vis.u.ptr, align 4

; du = dist[u]
%du.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %u.idx
%du = load i32, i32* %du.ptr, align 4
%du.is.inf = icmp eq i32 %du, 1061109567
br i1 %du.is.inf, label %outer.after, label %relax.loop

relax.loop:
%k = phi i64 [ 0, %relax ], [ %k.next, %relax.loop ]
%k.cmp = icmp ult i64 %k, 6
br i1 %k.cmp, label %relax.body, label %outer.after

relax.body:
; w = adj[u][k]
%row.ptr = getelementptr inbounds [6 x [6 x i32]], [6 x [6 x i32]]* @adj, i64 0, i64 %u.idx
%w.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %row.ptr, i64 0, i64 %k
%w = load i32, i32* %w.ptr, align 4
%w.neg = icmp slt i32 %w, 0
br i1 %w.neg, label %relax.inc, label %chk.unvisited2

chk.unvisited2:
%vis.k.ptr = getelementptr inbounds i32, i32* %vis, i64 %k
%vis.k = load i32, i32* %vis.k.ptr, align 4
%k.unvisited = icmp eq i32 %vis.k, 0
br i1 %k.unvisited, label %try.update, label %relax.inc

try.update:
%cand = add nsw i32 %du, %w
%dk.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %k
%dk = load i32, i32* %dk.ptr, align 4
%improve = icmp slt i32 %cand, %dk
br i1 %improve, label %do.update, label %relax.inc

do.update:
store i32 %cand, i32* %dk.ptr, align 4
%prev.k.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 %k
%u32 = trunc i64 %u.idx to i32
store i32 %u32, i32* %prev.k.ptr, align 4
br label %relax.inc

relax.inc:
%k.next = add nuw nsw i64 %k, 1
br label %relax.loop

outer.after:
%t.next = add nuw nsw i64 %t, 1
br label %outer.loop

after_outer:
; free(visited)
call void @free(i8* %vis.raw)
br label %skip_dijk

skip_dijk:
; Print distances
br label %print.loop

print.loop:
%pi = phi i64 [ 0, %skip_dijk ], [ %pi.next, %print.loop ]
%pi.cmp = icmp ult i64 %pi, 6
br i1 %pi.cmp, label %print.body, label %after_print

print.body:
%di.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %pi
%di = load i32, i32* %di.ptr, align 4
%is.inf = icmp eq i32 %di, 1061109567
%fmt.inf.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.fmt_dist_inf, i64 0, i64 0
%fmt.d.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.fmt_dist_d, i64 0, i64 0
%dst.z = trunc i64 %pi to i64
%src.z = zext i32 0 to i64
br i1 %is.inf, label %do_inf, label %do_num

do_inf:
%call.inf = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.inf.ptr, i64 %src.z, i64 %dst.z)
br label %print.inc

do_num:
%di.ext = sext i32 %di to i32
%call.num = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.d.ptr, i64 %src.z, i64 %dst.z, i32 %di.ext)
br label %print.inc

print.inc:
%pi.next = add nuw nsw i64 %pi, 1
br label %print.loop

after_print:
; If dist[5] is INF -> "no path", else print path
%d5.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 5
%d5 = load i32, i32* %d5.ptr, align 4
%d5.inf = icmp eq i32 %d5, 1061109567
br i1 %d5.inf, label %no_path, label %have_path

no_path:
%fmt.np = getelementptr inbounds [25 x i8], [25 x i8]* @.fmt_no_path, i64 0, i64 0
%call.np = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.np, i64 0, i64 5)
br label %ret0

have_path:
; Build path by following prev from 5 back to -1
%cnt = alloca i64, align 8
store i64 0, i64* %cnt, align 8
%v.cur = alloca i32, align 4
store i32 5, i32* %v.cur, align 4
br label %path.build

path.build:
%v = load i32, i32* %v.cur, align 4
%cnt.val = load i64, i64* %cnt, align 8
; path[cnt] = v
%path.slot = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %cnt.val
%v.z = sext i32 %v to i64
store i64 %v.z, i64* %path.slot, align 8
; cnt++
%cnt.next = add nuw nsw i64 %cnt.val, 1
store i64 %cnt.next, i64* %cnt, align 8
; v = prev[v]
%pv.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 %v.z
%pv = load i32, i32* %pv.ptr, align 4
store i32 %pv, i32* %v.cur, align 4
%done = icmp eq i32 %pv, -1
br i1 %done, label %path.header, label %path.build

path.header:
; print "path 0 -> 5:"
%fmt.ph = getelementptr inbounds [17 x i8], [17 x i8]* @.fmt_path_hdr, i64 0, i64 0
%call.h = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ph, i64 0, i64 5)
; iterate i = cnt-1 .. 0
%cnt.fin = load i64, i64* %cnt, align 8
%i.start = add i64 %cnt.fin, -1
br label %path.print

path.print:
%idx = phi i64 [ %i.start, %path.header ], [ %idx.next, %path.print ]
%cond = icmp sge i64 %idx, 0
br i1 %cond, label %path.body, label %path.done

path.body:
%node.ptr = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %idx
%node = load i64, i64* %node.ptr, align 8
; choose arrow or empty based on idx != 0
%is.last = icmp eq i64 %idx, 0
%arrow.sel = select i1 %is.last, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.empty, i64 0, i64 0),
i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.arrow, i64 0, i64 0)
%fmt.ns = getelementptr inbounds [7 x i8], [7 x i8]* @.fmt_node_sep, i64 0, i64 0
%call.nd = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ns, i64 %node, i8* %arrow.sel)
%idx.next = add nsw i64 %idx, -1
br label %path.print

path.done:
; print newline
%nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
%call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
br label %ret0

ret0:
ret i32 0
}