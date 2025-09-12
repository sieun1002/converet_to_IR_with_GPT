; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10E0
; Intent: Print DFS preorder of a fixed 7-node graph starting from 0 (confidence=0.92). Evidence: calloc/malloc for visited/stack/iter arrays; adjacency matrix built on stack and iterative DFS; prints "DFS preorder from %zu: ".
; Preconditions: None
; Postconditions: Prints traversal to stdout and returns 0

; Only the necessary external declarations:
declare void @free(i8*)
declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare i32 @__printf_chk(i32, i8*, ...)

@.str_header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.str_space = private unnamed_addr constant [2 x i8] c" \00"
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str_empty = private unnamed_addr constant [1 x i8] c"\00"

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [7 x [7 x i32]], align 16
  %path = alloca [7 x i64], align 16
  %pathCount = alloca i64, align 8
  %stackSize = alloca i64, align 8
  %curNode = alloca i64, align 8
  %i = alloca i64, align 8

  ; allocate visited (7 * 4), nextIdx (7 * 8), stack (7 * 8)
  %visited_i8 = call i8* @calloc(i64 28, i64 1)
  %nextidx_i8 = call i8* @calloc(i64 56, i64 1)
  %stack_i8 = call i8* @malloc(i64 56)

  ; null checks
  %v_ok = icmp ne i8* %visited_i8, null
  %n_ok = icmp ne i8* %nextidx_i8, null
  %s_ok = icmp ne i8* %stack_i8, null
  %tmp1 = and i1 %v_ok, %n_ok
  %ok = and i1 %tmp1, %s_ok
  br i1 %ok, label %init, label %fail

init:
  ; cast heap blocks
  %visited = bitcast i8* %visited_i8 to i32*
  %nextidx = bitcast i8* %nextidx_i8 to i64*
  %stack = bitcast i8* %stack_i8 to i64*

  ; zero adjacency matrix
  %adj_i8 = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  ; set edges = 1 (undirected edges encoded asymmetrically as in binary)
  ; Row 0: col1, col2
  %a0c1 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 1
  store i32 1, i32* %a0c1, align 4
  %a0c2 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 2
  store i32 1, i32* %a0c2, align 4
  ; Row 1: col0, col3, col4
  %a1c0 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 0
  store i32 1, i32* %a1c0, align 4
  %a1c3 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 3
  store i32 1, i32* %a1c3, align 4
  %a1c4 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 4
  store i32 1, i32* %a1c4, align 4
  ; Row 2: col0, col5
  %a2c0 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 0
  store i32 1, i32* %a2c0, align 4
  %a2c5 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 5
  store i32 1, i32* %a2c5, align 4
  ; Row 3: col1
  %a3c1 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 1
  store i32 1, i32* %a3c1, align 4
  ; Row 4: col1, col5
  %a4c1 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 1
  store i32 1, i32* %a4c1, align 4
  %a4c5 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 5
  store i32 1, i32* %a4c5, align 4
  ; Row 5: col2, col4, col6
  %a5c2 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 2
  store i32 1, i32* %a5c2, align 4
  %a5c4 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 4
  store i32 1, i32* %a5c4, align 4
  %a5c6 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 6
  store i32 1, i32* %a5c6, align 4
  ; Row 6: col5
  %a6c5 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 5
  store i32 1, i32* %a6c5, align 4

  ; init visited[0]=1, stack[0]=0, path[0]=0; sizes and current
  store i32 1, i32* %visited, align 4
  %path0 = getelementptr inbounds [7 x i64], [7 x i64]* %path, i64 0, i64 0
  store i64 0, i64* %path0, align 8
  store i64 1, i64* %pathCount, align 8
  store i64 1, i64* %stackSize, align 8
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 0, i64* %stack0, align 8
  store i64 0, i64* %curNode, align 8

  br label %loop

loop:
  %cur = load i64, i64* %curNode, align 8
  %ni_ptr = getelementptr inbounds i64, i64* %nextidx, i64 %cur
  %idx = load i64, i64* %ni_ptr, align 8
  %gt6 = icmp ugt i64 %idx, 6
  br i1 %gt6, label %pop, label %pre_neighbors

pre_neighbors:
  %rowptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur
  br label %neighbor_loop

neighbor_loop:
  %phi_idx = phi i64 [ %idx, %pre_neighbors ], [ %idx_next, %neighbor_next ]
  %end = icmp eq i64 %phi_idx, 7
  br i1 %end, label %pop, label %check_row

check_row:
  %elem_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %rowptr, i64 0, i64 %phi_idx
  %adjVal = load i32, i32* %elem_ptr, align 4
  %isZero = icmp eq i32 %adjVal, 0
  br i1 %isZero, label %neighbor_next, label %check_visit

check_visit:
  %v_ptr = getelementptr inbounds i32, i32* %visited, i64 %phi_idx
  %v_val = load i32, i32* %v_ptr, align 4
  %unvisited = icmp eq i32 %v_val, 0
  br i1 %unvisited, label %push_neighbor, label %neighbor_next

push_neighbor:
  ; push neighbor
  %sz = load i64, i64* %stackSize, align 8
  %st_ptr = getelementptr inbounds i64, i64* %stack, i64 %sz
  store i64 %phi_idx, i64* %st_ptr, align 8
  %sz1 = add i64 %sz, 1
  store i64 %sz1, i64* %stackSize, align 8

  ; record path
  %pc = load i64, i64* %pathCount, align 8
  %path_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %path, i64 0, i64 %pc
  store i64 %phi_idx, i64* %path_ptr, align 8
  %pc1 = add i64 %pc, 1
  store i64 %pc1, i64* %pathCount, align 8

  ; update iterator for current node
  %phi_idx1 = add i64 %phi_idx, 1
  store i64 %phi_idx1, i64* %ni_ptr, align 8

  ; mark visited and go deeper
  store i32 1, i32* %v_ptr, align 4
  store i64 %phi_idx, i64* %curNode, align 8
  br label %loop

neighbor_next:
  %idx_next = add i64 %phi_idx, 1
  br label %neighbor_loop

pop:
  ; pop stack
  %sz2 = load i64, i64* %stackSize, align 8
  %sz3 = sub i64 %sz2, 1
  store i64 %sz3, i64* %stackSize, align 8
  %is_empty = icmp eq i64 %sz3, 0
  br i1 %is_empty, label %done, label %resume

resume:
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %sz3
  %top_val = load i64, i64* %top_ptr, align 8
  store i64 %top_val, i64* %curNode, align 8
  br label %loop

done:
  ; free allocations before printing
  call void @free(i8* %visited_i8)
  call void @free(i8* %nextidx_i8)
  call void @free(i8* %stack_i8)

  ; print header with start node 0
  %hdr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr, i64 0)

  ; print path elements
  %pc2 = load i64, i64* %pathCount, align 8
  %pc_zero = icmp eq i64 %pc2, 0
  br i1 %pc_zero, label %print_nl, label %print_start

print_start:
  store i64 0, i64* %i, align 8
  br label %print_cond

print_cond:
  %iv = load i64, i64* %i, align 8
  %cont = icmp ult i64 %iv, %pc2
  br i1 %cont, label %print_body, label %print_nl

print_body:
  %item_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %path, i64 0, i64 %iv
  %item = load i64, i64* %item_ptr, align 8
  %iv1 = add i64 %iv, 1
  %is_last = icmp eq i64 %iv1, %pc2
  %space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %is_last, i8* %empty, i8* %space
  %fmt = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %__ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i64 %item, i8* %sep)
  %iv_next = add i64 %iv, 1
  store i64 %iv_next, i64* %i, align 8
  br label %print_cond

print_nl:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %___ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
  ret i32 0

fail:
  ; free any (possibly null) pointers and print minimal output
  call void @free(i8* %visited_i8)
  call void @free(i8* %nextidx_i8)
  call void @free(i8* %stack_i8)
  %hdrf = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %f1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdrf, i64 0)
  %nlf = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %f2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlf)
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)