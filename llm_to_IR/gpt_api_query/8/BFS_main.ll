; ModuleID = 'recovered_main'
source_filename = "recovered_main.ll"
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()
declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  ; stack protector setup
  %canary.slot = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8

  ; zero adjacency matrix of 49 ints (196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %adj.i8, i8 0, i64 196, i1 false)

  ; set edges (column-major indexing: idx = u + v*n, n=7)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
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

  ; init order_len to 0 before bfs
  store i64 0, i64* %order_len, align 8

  ; call bfs(adj, n, start, dist, order, &order_len)
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adj.base, i64 %n.val, i64 %start.val, i32* nonnull %dist.base, i64* nonnull %order.base, i64* nonnull %order_len)

  ; printf("BFS order from %zu: ", start)
  %fmt0 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* nonnull %fmt0, i64 %start.val)

  ; for (i = 0; i < order_len; ++i) print "%zu%s" with space except after last
  store i64 0, i64* %i, align 8
  br label %order.loop

order.loop:                                           ; preds = %order.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %olen = load i64, i64* %order_len, align 8
  %cmp.ol = icmp ult i64 %i.cur, %olen
  br i1 %cmp.ol, label %order.body, label %order.done

order.body:                                           ; preds = %order.loop
  %next = add i64 %i.cur, 1
  %sep.use.space = icmp ult i64 %next, %olen
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.sep, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %sep.use.space, i8* %sep.space.ptr, i8* %sep.empty.ptr
  %ord.elem.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.cur
  %ord.val = load i64, i64* %ord.elem.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* nonnull %fmt1, i64 %ord.val, i8* %sep.ptr)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %order.loop

order.done:                                           ; preds = %order.loop
  %nl = call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", start, j, dist[j])
  store i64 0, i64* %j, align 8
  br label %dist.loop

dist.loop:                                            ; preds = %dist.body, %order.done
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp.j = icmp ult i64 %j.cur, %n.cur
  br i1 %cmp.j, label %dist.body, label %ret.check

dist.body:                                            ; preds = %dist.loop
  %dptr = getelementptr inbounds i32, i32* %dist.base, i64 %j.cur
  %dval = load i32, i32* %dptr, align 4
  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* nonnull %fmt2, i64 %start.val, i64 %j.cur, i32 %dval)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %dist.loop

ret.check:                                            ; preds = %dist.loop
  ; stack protector check
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.init = load i64, i64* %canary.slot, align 8
  %cmp.guard = icmp ne i64 %guard.end, %guard.init
  br i1 %cmp.guard, label %fail, label %ret.ok

fail:                                                 ; preds = %ret.check
  call void @__stack_chk_fail()
  unreachable

ret.ok:                                               ; preds = %ret.check
  ret i32 0
}