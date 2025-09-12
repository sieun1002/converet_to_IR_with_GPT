; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10E0
; Intent: Print DFS preorder traversal from node 0 on a fixed 7-node graph (confidence=0.95). Evidence: local 7x7 adjacency matrix with constants; iterative DFS using explicit stack and visited/next-index arrays
; Preconditions: None
; Postconditions: Prints traversal as "DFS preorder from 0: <nodes>\n"; returns 0

@.str_hdr = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Only the needed extern declarations:
declare noalias i8* @calloc(i64, i64)
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %out = alloca [7 x i64], align 16
  %sp = alloca i64, align 8
  %cur = alloca i64, align 8
  %outc = alloca i64, align 8
  ; zero adjacency matrix (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  ; set edges (undirected graph encoded asymmetrically where set)
  ; 0->1, 0->2
  %adj01 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj01, align 4
  %adj02 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj02, align 4
  ; 1->0, 1->3, 1->4
  %adj10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj10, align 4
  %adj13 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj13, align 4
  %adj14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj14, align 4
  ; 2->0, 2->5
  %adj20 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj20, align 4
  %adj25 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj25, align 4
  ; 3->1
  %adj31 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj31, align 4
  ; 4->1, 4->5
  %adj41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj41, align 4
  %adj45 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj45, align 4
  ; 5->2, 5->4, 5->6
  %adj52 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj52, align 4
  %adj54 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj54, align 4
  %adj56 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj56, align 4
  ; 6->5
  %adj65 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj65, align 4

  ; allocate runtime arrays
  %visited.raw = call noalias i8* @calloc(i64 28, i64 1)
  %nextidx.raw = call noalias i8* @calloc(i64 56, i64 1)
  %stack.raw = call noalias i8* @malloc(i64 56)
  %visited = bitcast i8* %visited.raw to i32*
  %nextidx = bitcast i8* %nextidx.raw to i64*
  %stack = bitcast i8* %stack.raw to i64*

  ; check allocation
  %ok.v = icmp ne i8* %visited.raw, null
  %ok.n = icmp ne i8* %nextidx.raw, null
  %ok.s = icmp ne i8* %stack.raw, null
  %ok.tmp = and i1 %ok.v, %ok.n
  %ok.all = and i1 %ok.tmp, %ok.s
  br i1 %ok.all, label %init_dfs, label %print_header_only

init_dfs:
  ; initialize visited[0]=1, stack[0]=0, out[0]=0, counts
  store i32 1, i32* %visited, align 4
  store i64 0, i64* %stack, align 8
  %out0 = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  store i64 0, i64* %out0, align 8
  store i64 1, i64* %outc, align 8
  store i64 1, i64* %sp, align 8
  store i64 0, i64* %cur, align 8
  br label %dfs_top

dfs_top:
  %curv.t = load i64, i64* %cur, align 8
  %ni.ptr.t = getelementptr inbounds i64, i64* %nextidx, i64 %curv.t
  %ni0 = load i64, i64* %ni.ptr.t, align 8
  br label %scan

scan:
  %scanvar = phi i64 [ %ni0, %dfs_top ], [ %scanvar.inc, %cont ]
  %lt7 = icmp ult i64 %scanvar, 7
  br i1 %lt7, label %check_adj, label %pop

check_adj:
  %curv.c = load i64, i64* %cur, align 8
  %mul7 = mul nuw nsw i64 %curv.c, 7
  %flat = add i64 %mul7, %scanvar
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %flat
  %adj.val = load i32, i32* %adj.ptr, align 4
  %is_edge = icmp ne i32 %adj.val, 0
  br i1 %is_edge, label %check_vis, label %cont

check_vis:
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %scanvar
  %vval = load i32, i32* %vptr, align 4
  %unvis = icmp eq i32 %vval, 0
  br i1 %unvis, label %found, label %cont

cont:
  %scanvar.inc = add nuw nsw i64 %scanvar, 1
  br label %scan

found:
  ; push neighbor onto stack
  %spv = load i64, i64* %sp, align 8
  %stk.pos = getelementptr inbounds i64, i64* %stack, i64 %spv
  store i64 %scanvar, i64* %stk.pos, align 8
  %sp.inc = add nuw nsw i64 %spv, 1
  store i64 %sp.inc, i64* %sp, align 8
  ; record output
  %oc = load i64, i64* %outc, align 8
  %out.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %oc
  store i64 %scanvar, i64* %out.ptr, align 8
  %oc.inc = add nuw nsw i64 %oc, 1
  store i64 %oc.inc, i64* %outc, align 8
  ; update next index for current
  %scan.plus = add nuw nsw i64 %scanvar, 1
  %curv.f = load i64, i64* %cur, align 8
  %ni.ptr.f = getelementptr inbounds i64, i64* %nextidx, i64 %curv.f
  store i64 %scan.plus, i64* %ni.ptr.f, align 8
  ; mark visited
  store i32 1, i32* %vptr, align 4
  ; descend
  store i64 %scanvar, i64* %cur, align 8
  br label %dfs_top

pop:
  %spv2 = load i64, i64* %sp, align 8
  %sp.dec = add nsw i64 %spv2, -1
  store i64 %sp.dec, i64* %sp, align 8
  %empty = icmp eq i64 %sp.dec, 0
  br i1 %empty, label %after_dfs, label %set_cur

set_cur:
  %idx.top = add nsw i64 %sp.dec, -1
  %top.ptr = getelementptr inbounds i64, i64* %stack, i64 %idx.top
  %top.val = load i64, i64* %top.ptr, align 8
  store i64 %top.val, i64* %cur, align 8
  br label %dfs_top

after_dfs:
  ; free resources
  call void @free(i8* %visited.raw)
  call void @free(i8* %nextidx.raw)
  call void @free(i8* %stack.raw)
  br label %print_all

print_header_only:
  ; free what we have (free is NULL-safe)
  call void @free(i8* %visited.raw)
  call void @free(i8* %nextidx.raw)
  call void @free(i8* %stack.raw)
  ; header then newline
  %hdr.ptr0 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_hdr, i64 0, i64 0
  %nl.ptr0 = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_hdr0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr.ptr0, i64 0)
  %call_nl0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr0)
  ret i32 0

print_all:
  ; print header
  %hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_hdr, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %call_hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr.ptr, i64 0)
  ; loop over out[0..outc-1]
  %cnt = load i64, i64* %outc, align 8
  %has_any = icmp ne i64 %cnt, 0
  br i1 %has_any, label %print_loop, label %after_print_loop

print_loop:
  %i = phi i64 [ 0, %print_all ], [ %i.next, %print_loop_tail ]
  %last.idx = add nsw i64 %cnt, -1
  %is_last = icmp eq i64 %i, %last.idx
  %sep = select i1 %is_last, i8* %empty.ptr, i8* %space.ptr
  %val.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %call_item = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i64 %val, i8* %sep)
  br label %print_loop_tail

print_loop_tail:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp ult i64 %i.next, %cnt
  br i1 %cond, label %print_loop, label %after_print_loop

after_print_loop:
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}