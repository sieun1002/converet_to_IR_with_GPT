; ModuleID = 'ir_fixed'
target triple = "x86_64-pc-windows-msvc"

@.str_header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str_space  = private unnamed_addr constant [2 x i8] c" \00"
@.str_empty  = private unnamed_addr constant [1 x i8] c"\00"
@.str_val    = private unnamed_addr constant [6 x i8] c"%zu%s\00"

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local void @__main() {
entry:
  ret void
}

define internal void @dfs_visit(i32* noundef %adj, i64 noundef %n, i64 noundef %v, i64* noundef %out, i64* noundef %outlen, i8* noundef %visited) {
entry:
  %vis_ptr = getelementptr inbounds i8, i8* %visited, i64 %v
  %vis_val = load i8, i8* %vis_ptr, align 1
  %is_vis  = icmp ne i8 %vis_val, 0
  br i1 %is_vis, label %ret, label %not_vis

not_vis:
  store i8 1, i8* %vis_ptr, align 1
  %len0 = load i64, i64* %outlen, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %v, i64* %out_slot, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %outlen, align 8
  br label %loop

loop:
  %j = phi i64 [ 0, %not_vis ], [ %j.next, %loop.inc ]
  %cmp = icmp ult i64 %j, %n
  br i1 %cmp, label %loop.body, label %ret

loop.body:
  %vn   = mul i64 %v, %n
  %idx  = add i64 %vn, %j
  %adjp = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adjp, align 4
  %has  = icmp ne i32 %edge, 0
  br i1 %has, label %recurse, label %loop.inc

recurse:
  %j.vis.ptr = getelementptr inbounds i8, i8* %visited, i64 %j
  %j.vis.val = load i8, i8* %j.vis.ptr, align 1
  %j.is.vis  = icmp ne i8 %j.vis.val, 0
  br i1 %j.is.vis, label %loop.inc, label %do_call

do_call:
  call void @dfs_visit(i32* noundef %adj, i64 noundef %n, i64 noundef %j, i64* noundef %out, i64* noundef %outlen, i8* noundef %visited)
  br label %loop.inc

loop.inc:
  %j.next = add i64 %j, 1
  br label %loop

ret:
  ret void
}

define dso_local void @dfs(i32* noundef %adj, i64 noundef %n, i64 noundef %start, i64* noundef %out, i64* noundef %outlen) {
entry:
  store i64 0, i64* %outlen, align 8
  %vis = alloca i8, i64 %n, align 1
  %vis.i8 = bitcast i8* %vis to i8*
  %n.bytes = trunc i64 %n to i64
  call void @llvm.memset.p0i8.i64(i8* noundef %vis.i8, i8 0, i64 %n.bytes, i1 false)
  call void @dfs_visit(i32* noundef %adj, i64 noundef %n, i64 noundef %start, i64* noundef %out, i64* noundef %outlen, i8* noundef %vis)
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %adj = alloca [49 x i32], align 16
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %adj.i8 = bitcast i32* %adj.base to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef %adj.i8, i8 0, i64 196, i1 false)
  %out = alloca [7 x i64], align 16
  %out.base = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  %outlen = alloca i64, align 8
  store i64 0, i64* %outlen, align 8

  ; n = 7, start = 0
  ; Set undirected edges:
  ; 0-1
  %idx01_m = mul i64 0, 7
  %idx01   = add i64 %idx01_m, 1
  %ptr01   = getelementptr inbounds i32, i32* %adj.base, i64 %idx01
  store i32 1, i32* %ptr01, align 4
  %idx10_m = mul i64 1, 7
  %idx10   = add i64 %idx10_m, 0
  %ptr10   = getelementptr inbounds i32, i32* %adj.base, i64 %idx10
  store i32 1, i32* %ptr10, align 4

  ; 0-2
  %idx02_m = mul i64 0, 7
  %idx02   = add i64 %idx02_m, 2
  %ptr02   = getelementptr inbounds i32, i32* %adj.base, i64 %idx02
  store i32 1, i32* %ptr02, align 4
  %idx20_m = mul i64 2, 7
  %idx20   = add i64 %idx20_m, 0
  %ptr20   = getelementptr inbounds i32, i32* %adj.base, i64 %idx20
  store i32 1, i32* %ptr20, align 4

  ; 1-3
  %idx13_m = mul i64 1, 7
  %idx13   = add i64 %idx13_m, 3
  %ptr13   = getelementptr inbounds i32, i32* %adj.base, i64 %idx13
  store i32 1, i32* %ptr13, align 4
  %idx31_m = mul i64 3, 7
  %idx31   = add i64 %idx31_m, 1
  %ptr31   = getelementptr inbounds i32, i32* %adj.base, i64 %idx31
  store i32 1, i32* %ptr31, align 4

  ; 1-4
  %idx14_m = mul i64 1, 7
  %idx14   = add i64 %idx14_m, 4
  %ptr14   = getelementptr inbounds i32, i32* %adj.base, i64 %idx14
  store i32 1, i32* %ptr14, align 4
  %idx41_m = mul i64 4, 7
  %idx41   = add i64 %idx41_m, 1
  %ptr41   = getelementptr inbounds i32, i32* %adj.base, i64 %idx41
  store i32 1, i32* %ptr41, align 4

  ; 2-5
  %idx25_m = mul i64 2, 7
  %idx25   = add i64 %idx25_m, 5
  %ptr25   = getelementptr inbounds i32, i32* %adj.base, i64 %idx25
  store i32 1, i32* %ptr25, align 4
  %idx52_m = mul i64 5, 7
  %idx52   = add i64 %idx52_m, 2
  %ptr52   = getelementptr inbounds i32, i32* %adj.base, i64 %idx52
  store i32 1, i32* %ptr52, align 4

  ; 4-5
  %idx45_m = mul i64 4, 7
  %idx45   = add i64 %idx45_m, 5
  %ptr45   = getelementptr inbounds i32, i32* %adj.base, i64 %idx45
  store i32 1, i32* %ptr45, align 4
  %idx54_m = mul i64 5, 7
  %idx54   = add i64 %idx54_m, 4
  %ptr54   = getelementptr inbounds i32, i32* %adj.base, i64 %idx54
  store i32 1, i32* %ptr54, align 4

  ; 5-6
  %idx56_m = mul i64 5, 7
  %idx56   = add i64 %idx56_m, 6
  %ptr56   = getelementptr inbounds i32, i32* %adj.base, i64 %idx56
  store i32 1, i32* %ptr56, align 4
  %idx65_m = mul i64 6, 7
  %idx65   = add i64 %idx65_m, 5
  %ptr65   = getelementptr inbounds i32, i32* %adj.base, i64 %idx65
  store i32 1, i32* %ptr65, align 4

  call void @dfs(i32* noundef %adj.base, i64 noundef 7, i64 noundef 0, i64* noundef %out.base, i64* noundef %outlen)

  %fmt_hdr_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %call_hdr = call i32 (i8*, ...) @printf(i8* noundef %fmt_hdr_ptr, i64 noundef 0)

  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %loop_print.cond

loop_print.cond:
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %outlen, align 8
  %lt = icmp ult i64 %i.cur, %len
  br i1 %lt, label %loop_print.body, label %after_print

loop_print.body:
  %i.next = add i64 %i.cur, 1
  %is_last = icmp uge i64 %i.next, %len
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %is_last, i8* %empty_ptr, i8* %space_ptr

  %val_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i.cur
  %val = load i64, i64* %val_ptr, align 8

  %fmt_val_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_val, i64 0, i64 0
  %call_val = call i32 (i8*, ...) @printf(i8* noundef %fmt_val_ptr, i64 noundef %val, i8* noundef %sep)

  store i64 %i.next, i64* %i, align 8
  br label %loop_print.cond

after_print:
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}