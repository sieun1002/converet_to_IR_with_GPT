; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @__main()
declare void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %out_len, i64* %out_order)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %src = alloca i64, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  call void @__main()
  store i64 7, i64* %n, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 192, i1 false)
  %adj.gep48 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 48
  store i32 0, i32* %adj.gep48, align 4
  %adj.gep1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.gep1, align 4
  %adj.gep2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.gep2, align 4
  %adj.gep7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.gep7, align 4
  %adj.gep14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.gep14, align 4
  %adj.gep10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.gep10, align 4
  %adj.gep22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.gep22, align 4
  %adj.gep11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.gep11, align 4
  %adj.gep29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.gep29, align 4
  %adj.gep19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.gep19, align 4
  %adj.gep37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.gep37, align 4
  %adj.gep33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.gep33, align 4
  %adj.gep39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.gep39, align 4
  %adj.gep41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.gep41, align 4
  %adj.gep47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.gep47, align 4
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 %n.val, i64 %src.val, i32* %dist.ptr, i64* %order_len, i64* %order.ptr)
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @Format, i64 0, i64 0
  %src.val2 = load i64, i64* %src, align 8
  %callprintf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %src.val2)
  store i64 0, i64* %i, align 8
  br label %loop_order_cond

loop_order_cond:                                  ; preds = %loop_order_body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %loop_order_body, label %after_order_loop

loop_order_body:                                  ; preds = %loop_order_cond
  %i.plus1 = add i64 %i.cur, 1
  %has_next = icmp ult i64 %i.plus1, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i64 0, i64 0
  %sep = select i1 %has_next, i8* %space.ptr, i8* %empty.ptr
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %callprintf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %ord.elem, i8* %sep)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop_order_cond

after_order_loop:                                 ; preds = %loop_order_cond
  %ch = call i32 @putchar(i32 10)
  store i64 0, i64* %j, align 8
  br label %loop_dist_cond

loop_dist_cond:                                   ; preds = %loop_dist_body, %after_order_loop
  %j.cur = load i64, i64* %j, align 8
  %n.val3 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j.cur, %n.val3
  br i1 %cmp2, label %loop_dist_body, label %after_dist_loop

loop_dist_body:                                   ; preds = %loop_dist_cond
  %dist.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.cur
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %src.val3 = load i64, i64* %src, align 8
  %callprintf3 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 %src.val3, i64 %j.cur, i32 %dist.elem)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop_dist_cond

after_dist_loop:                                  ; preds = %loop_dist_cond
  ret i32 0
}