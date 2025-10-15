; ModuleID = 'dfs_preorder_module'
target triple = "x86_64-pc-windows-msvc"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__main()
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define void @dfs_visit(i32* nocapture readonly %adj, i64 %n, i64 %v, i8* nocapture %vis, i64* nocapture %out, i64* nocapture %out_len) {
entry:
  %len0 = load i64, i64* %out_len, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %v, i64* %out_ptr0, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  %v_byte_ptr = getelementptr inbounds i8, i8* %vis, i64 %v
  store i8 1, i8* %v_byte_ptr, align 1
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %body.end ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %body, label %ret

body:
  %rowMul = mul i64 %v, %n
  %idx = add i64 %rowMul, %i
  %adj_i_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj_i_ptr, align 4
  %has_edge = icmp ne i32 %edge, 0
  br i1 %has_edge, label %check.vis, label %body.end

check.vis:
  %vis_i_ptr = getelementptr inbounds i8, i8* %vis, i64 %i
  %vis_i = load i8, i8* %vis_i_ptr, align 1
  %is_unvisited = icmp eq i8 %vis_i, 0
  br i1 %is_unvisited, label %recurse, label %body.end

recurse:
  call void @dfs_visit(i32* %adj, i64 %n, i64 %i, i8* %vis, i64* %out, i64* %out_len)
  br label %body.end

body.end:
  %i.next = add i64 %i, 1
  br label %loop

ret:
  ret void
}

define void @dfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %out_len) {
entry:
  %vis = alloca i8, i64 %n, align 1
  %vis.i8 = bitcast i8* %vis to i8*
  call void @llvm.memset.p0i8.i64(i8* %vis.i8, i8 0, i64 %n, i1 false)
  call void @dfs_visit(i32* %adj, i64 %n, i64 %start, i8* %vis, i64* %out, i64* %out_len)
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %n = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %adj = alloca [49 x i32], align 16
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0

  ; set edges for N=7 as per decoded matrix
  ; 0 -> 1
  %idx01.mul = mul i64 0, 7
  %idx01 = add i64 %idx01.mul, 1
  %ptr01 = getelementptr inbounds i32, i32* %adj.base, i64 %idx01
  store i32 1, i32* %ptr01, align 4
  ; 0 -> 2
  %idx02.mul = mul i64 0, 7
  %idx02 = add i64 %idx02.mul, 2
  %ptr02 = getelementptr inbounds i32, i32* %adj.base, i64 %idx02
  store i32 1, i32* %ptr02, align 4

  ; 1 -> 0
  %idx10.mul = mul i64 1, 7
  %idx10 = add i64 %idx10.mul, 0
  %ptr10 = getelementptr inbounds i32, i32* %adj.base, i64 %idx10
  store i32 1, i32* %ptr10, align 4
  ; 1 -> 3
  %idx13.mul = mul i64 1, 7
  %idx13 = add i64 %idx13.mul, 3
  %ptr13 = getelementptr inbounds i32, i32* %adj.base, i64 %idx13
  store i32 1, i32* %ptr13, align 4
  ; 1 -> 4
  %idx14.mul = mul i64 1, 7
  %idx14 = add i64 %idx14.mul, 4
  %ptr14 = getelementptr inbounds i32, i32* %adj.base, i64 %idx14
  store i32 1, i32* %ptr14, align 4

  ; 2 -> 0
  %idx20.mul = mul i64 2, 7
  %idx20 = add i64 %idx20.mul, 0
  %ptr20 = getelementptr inbounds i32, i32* %adj.base, i64 %idx20
  store i32 1, i32* %ptr20, align 4
  ; 2 -> 5
  %idx25.mul = mul i64 2, 7
  %idx25 = add i64 %idx25.mul, 5
  %ptr25 = getelementptr inbounds i32, i32* %adj.base, i64 %idx25
  store i32 1, i32* %ptr25, align 4

  ; 3 -> 1
  %idx31.mul = mul i64 3, 7
  %idx31 = add i64 %idx31.mul, 1
  %ptr31 = getelementptr inbounds i32, i32* %adj.base, i64 %idx31
  store i32 1, i32* %ptr31, align 4

  ; 4 -> 1
  %idx41.mul = mul i64 4, 7
  %idx41 = add i64 %idx41.mul, 1
  %ptr41 = getelementptr inbounds i32, i32* %adj.base, i64 %idx41
  store i32 1, i32* %ptr41, align 4
  ; 4 -> 5
  %idx45.mul = mul i64 4, 7
  %idx45 = add i64 %idx45.mul, 5
  %ptr45 = getelementptr inbounds i32, i32* %adj.base, i64 %idx45
  store i32 1, i32* %ptr45, align 4

  ; 5 -> 2
  %idx52.mul = mul i64 5, 7
  %idx52 = add i64 %idx52.mul, 2
  %ptr52 = getelementptr inbounds i32, i32* %adj.base, i64 %idx52
  store i32 1, i32* %ptr52, align 4
  ; 5 -> 4
  %idx54.mul = mul i64 5, 7
  %idx54 = add i64 %idx54.mul, 4
  %ptr54 = getelementptr inbounds i32, i32* %adj.base, i64 %idx54
  store i32 1, i32* %ptr54, align 4
  ; 5 -> 6
  %idx56.mul = mul i64 5, 7
  %idx56 = add i64 %idx56.mul, 6
  %ptr56 = getelementptr inbounds i32, i32* %adj.base, i64 %idx56
  store i32 1, i32* %ptr56, align 4

  ; 6 -> 5
  %idx65.mul = mul i64 6, 7
  %idx65 = add i64 %idx65.mul, 5
  %ptr65 = getelementptr inbounds i32, i32* %adj.base, i64 %idx65
  store i32 1, i32* %ptr65, align 4

  %start = alloca i64, align 8
  store i64 0, i64* %start, align 8

  %out = alloca [64 x i64], align 16
  %out.base = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  %out_len = alloca i64, align 8
  store i64 0, i64* %out_len, align 8

  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %n.val, i64 %start.val, i64* %out.base, i64* %out_len)

  %fmt.header.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call.printf.header = call i32 (i8*, ...) @printf(i8* %fmt.header.ptr, i64 %start.print)

  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %print.loop

print.loop:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %i.cur, %len.cur
  br i1 %cond, label %print.body, label %print.end

print.body:
  %next = add i64 %i.cur, 1
  %has_more = icmp ult i64 %next, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sel = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr

  %val.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i.cur
  %val = load i64, i64* %val.ptr, align 8

  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %val, i8* %sel)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %print.loop

print.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}