; ModuleID = 'dfs_preorder_windows'
target triple = "x86_64-pc-windows-msvc"

%struct.DFSContext = type { i32*, i8* }

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str.item   = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.str.space  = private unnamed_addr constant [2 x i8] c" \00"
@.str.empty  = private unnamed_addr constant [1 x i8] c"\00"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define void @dfs(%struct.DFSContext* %ctx, i64 %N, i64 %start, i64* %out, i64* %out_len) {
entry:
  %ctx_mat_ptr_ptr = getelementptr inbounds %struct.DFSContext, %struct.DFSContext* %ctx, i32 0, i32 0
  %ctx_vis_ptr_ptr = getelementptr inbounds %struct.DFSContext, %struct.DFSContext* %ctx, i32 0, i32 1
  %mat_ptr = load i32*, i32** %ctx_mat_ptr_ptr, align 8
  %vis_ptr = load i8*, i8** %ctx_vis_ptr_ptr, align 8
  %vis_gep = getelementptr inbounds i8, i8* %vis_ptr, i64 %start
  %vis_val = load i8, i8* %vis_gep, align 1
  %already = icmp ne i8 %vis_val, 0
  br i1 %already, label %ret, label %mark

mark:
  store i8 1, i8* %vis_gep, align 1
  %len0 = load i64, i64* %out_len, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %out_slot, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  br label %loop

loop:
  %i = phi i64 [ 0, %mark ], [ %i.next, %loop.inc ]
  %cond = icmp ult i64 %i, %N
  br i1 %cond, label %loop.body, label %ret

loop.body:
  %mul = mul i64 %start, %N
  %idx64 = add i64 %mul, %i
  %elem_ptr = getelementptr inbounds i32, i32* %mat_ptr, i64 %idx64
  %elem = load i32, i32* %elem_ptr, align 4
  %is_edge = icmp ne i32 %elem, 0
  br i1 %is_edge, label %recurse, label %loop.inc

recurse:
  call void @dfs(%struct.DFSContext* %ctx, i64 %N, i64 %i, i64* %out, i64* %out_len)
  br label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  br label %loop

ret:
  ret void
}

define i32 @main() {
entry:
  %N = alloca i64, align 8
  store i64 7, i64* %N, align 8

  %matrix = alloca [49 x i32], align 16
  %visited = alloca [49 x i8], align 16
  %out = alloca [49 x i64], align 16
  %out_len = alloca i64, align 8
  %ctx = alloca %struct.DFSContext, align 8
  %start = alloca i64, align 8

  store i64 0, i64* %out_len, align 8
  store i64 0, i64* %start, align 8

  %mat_i8 = bitcast [49 x i32]* %matrix to i8*
  call void @llvm.memset.p0i8.i64(i8* %mat_i8, i8 0, i64 196, i1 false)

  %vis_i8 = bitcast [49 x i8]* %visited to i8*
  call void @llvm.memset.p0i8.i64(i8* %vis_i8, i8 0, i64 49, i1 false)

  %out_i8 = bitcast [49 x i64]* %out to i8*
  call void @llvm.memset.p0i8.i64(i8* %out_i8, i8 0, i64 392, i1 false)

  %mat_base = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i32 0, i32 0

  ; Set edges for an undirected graph (N=7)
  ; (0,1) and (1,0)
  %idx_0_1 = getelementptr inbounds i32, i32* %mat_base, i64 1
  store i32 1, i32* %idx_0_1, align 4
  %idx_1_0 = getelementptr inbounds i32, i32* %mat_base, i64 7
  store i32 1, i32* %idx_1_0, align 4

  ; (0,2) and (2,0)
  %idx_0_2 = getelementptr inbounds i32, i32* %mat_base, i64 2
  store i32 1, i32* %idx_0_2, align 4
  %idx_2_0 = getelementptr inbounds i32, i32* %mat_base, i64 14
  store i32 1, i32* %idx_2_0, align 4

  ; (1,3) and (3,1)
  %idx_1_3 = getelementptr inbounds i32, i32* %mat_base, i64 10
  store i32 1, i32* %idx_1_3, align 4
  %idx_3_1 = getelementptr inbounds i32, i32* %mat_base, i64 22
  store i32 1, i32* %idx_3_1, align 4

  ; (1,4) and (4,1)
  %idx_1_4 = getelementptr inbounds i32, i32* %mat_base, i64 11
  store i32 1, i32* %idx_1_4, align 4
  %idx_4_1 = getelementptr inbounds i32, i32* %mat_base, i64 29
  store i32 1, i32* %idx_4_1, align 4

  ; (2,5) and (5,2)
  %idx_2_5 = getelementptr inbounds i32, i32* %mat_base, i64 19
  store i32 1, i32* %idx_2_5, align 4
  %idx_5_2 = getelementptr inbounds i32, i32* %mat_base, i64 37
  store i32 1, i32* %idx_5_2, align 4

  ; (4,5) and (5,4)
  %idx_4_5 = getelementptr inbounds i32, i32* %mat_base, i64 33
  store i32 1, i32* %idx_4_5, align 4
  %idx_5_4 = getelementptr inbounds i32, i32* %mat_base, i64 39
  store i32 1, i32* %idx_5_4, align 4

  ; (5,6) and (6,5)
  %idx_5_6 = getelementptr inbounds i32, i32* %mat_base, i64 41
  store i32 1, i32* %idx_5_6, align 4
  %idx_6_5 = getelementptr inbounds i32, i32* %mat_base, i64 47
  store i32 1, i32* %idx_6_5, align 4

  ; Build DFS context
  %vis_base = getelementptr inbounds [49 x i8], [49 x i8]* %visited, i32 0, i32 0
  %ctx_mat_slot = getelementptr inbounds %struct.DFSContext, %struct.DFSContext* %ctx, i32 0, i32 0
  %ctx_vis_slot = getelementptr inbounds %struct.DFSContext, %struct.DFSContext* %ctx, i32 0, i32 1
  store i32* %mat_base, i32** %ctx_mat_slot, align 8
  store i8* %vis_base, i8** %ctx_vis_slot, align 8

  ; Call dfs
  %Nval = load i64, i64* %N, align 8
  %startv = load i64, i64* %start, align 8
  %out_base = getelementptr inbounds [49 x i64], [49 x i64]* %out, i32 0, i32 0
  call void @dfs(%struct.DFSContext* %ctx, i64 %Nval, i64 %startv, i64* %out_base, i64* %out_len)

  ; Print header
  %fmt_hdr_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i32 0, i32 0
  %start_for_print = load i64, i64* %start, align 8
  %call_hdr = call i32 (i8*, ...) @printf(i8* %fmt_hdr_ptr, i64 %start_for_print)

  ; i = 0
  %i_it = alloca i64, align 8
  store i64 0, i64* %i_it, align 8
  br label %print.loop

print.loop:
  %i_cur = load i64, i64* %i_it, align 8
  %len_cur = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i_cur, %len_cur
  br i1 %cmp, label %print.body, label %print.done

print.body:
  %i_next = add i64 %i_cur, 1
  %has_more = icmp ult i64 %i_next, %len_cur
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i32 0, i32 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i32 0, i32 0
  %sep = select i1 %has_more, i8* %space_ptr, i8* %empty_ptr

  %val_ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i32 0, i64 %i_cur
  %val = load i64, i64* %val_ptr, align 8

  %fmt_item_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i32 0, i32 0
  %call_item = call i32 (i8*, ...) @printf(i8* %fmt_item_ptr, i64 %val, i8* %sep)

  store i64 %i_next, i64* %i_it, align 8
  br label %print.loop

print.done:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}