; ModuleID = 'bfs_main'
target triple = "x86_64-unknown-linux-gnu"

@.str_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %out_len)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %outlen = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %outlen, align 8
  %adj.bc = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.bc, i8 0, i64 196, i1 false)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val0 = load i64, i64* %n, align 8
  %start.val0 = load i64, i64* %start, align 8
  call void @bfs(i32* %adj.base, i64 %n.val0, i64 %start.val0, i32* %dist.base, i64* %order.base, i64* %outlen)
  %fmt.hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %start.val1 = load i64, i64* %start, align 8
  %call.hdr = call i32 (i8*, ...) @printf(i8* %fmt.hdr.ptr, i64 %start.val1)
  store i64 0, i64* %i, align 8
  br label %loop_check

loop_check:
  %idx0 = load i64, i64* %i, align 8
  %len0 = load i64, i64* %outlen, align 8
  %cmp0 = icmp ult i64 %idx0, %len0
  br i1 %cmp0, label %loop_body, label %loop_end

loop_body:
  %next = add i64 %idx0, 1
  %len1 = load i64, i64* %outlen, align 8
  %cmp1 = icmp ult i64 %next, %len1
  br i1 %cmp1, label %sep_space, label %sep_empty

sep_space:
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  br label %sep_join

sep_empty:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  br label %sep_join

sep_join:
  %sep = phi i8* [ %space.ptr, %sep_space ], [ %empty.ptr, %sep_empty ]
  %ord.elem.ptr = getelementptr inbounds i64, i64* %order.base, i64 %idx0
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %fmt.pair.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call.pair = call i32 (i8*, ...) @printf(i8* %fmt.pair.ptr, i64 %ord.elem, i8* %sep)
  %idx1 = add i64 %idx0, 1
  store i64 %idx1, i64* %i, align 8
  br label %loop_check

loop_end:
  %nl = call i32 @putchar(i32 10)
  store i64 0, i64* %j, align 8
  br label %loop2_check

loop2_check:
  %j0 = load i64, i64* %j, align 8
  %n.val1 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j0, %n.val1
  br i1 %cmp2, label %loop2_body, label %loop2_end

loop2_body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j0
  %dist.val = load i32, i32* %dist.ptr, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i64 %start.val2, i64 %j0, i32 %dist.val)
  %j1 = add i64 %j0, 1
  store i64 %j1, i64* %j, align 8
  br label %loop2_check

loop2_end:
  ret i32 0
}