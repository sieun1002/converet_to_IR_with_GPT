; ModuleID = 'bfs_ir'
target triple = "x86_64-pc-linux-gnu"

@qword_2038 = external global i64
@__stack_chk_guard = external global i64

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind
declare i32 @__printf_chk(i32, i8*, ...) nounwind
declare void @__stack_chk_fail() noreturn nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) nounwind

define i32 @main() local_unnamed_addr {
bb_10c0:
  %canary = alloca i64, align 8
  %queue.ptr = alloca i8*, align 8
  %rsi_idx = alloca i64, align 8
  %rbx_idx = alloca i64, align 8
  %order.base = alloca i64*, align 8
  %first.elem = alloca i64, align 8
  %rdx.cur = alloca i64, align 8
  %eax.var = alloca i32, align 4
  %dist = alloca [7 x i32], align 16
  %adj = alloca [7 x [7 x i32]], align 16
  %order = alloca [7 x i64], align 16
  %g = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g, i64* %canary, align 8
  %adj.i8 = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %order.i8 = bitcast [7 x i64]* %order to i8*
  call void @llvm.memset.p0i8.i64(i8* %order.i8, i8 0, i64 56, i1 false)
  %dist.i8 = bitcast [7 x i32]* %dist to i8*
  call void @llvm.memset.p0i8.i64(i8* %dist.i8, i8 -1, i64 28, i1 false)
  %dist0.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0.ptr, align 4
  ; set some adjacency entries to 1 (example)
  %adj.row0 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0
  %adj00 = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row0, i64 0, i64 1
  store i32 1, i32* %adj00, align 4
  %adj01 = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row0, i64 0, i64 2
  store i32 1, i32* %adj01, align 4
  %adj02 = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row0, i64 0, i64 3
  store i32 1, i32* %adj02, align 4
  %m = call i8* @malloc(i64 56)
  %isnull = icmp eq i8* %m, null
  br i1 %isnull, label %bb_1414, label %bb_after_malloc

bb_after_malloc:                                        ; preds = %bb_10c0
  store i8* %m, i8** %queue.ptr, align 8
  store i64 1, i64* %rsi_idx, align 8
  store i64 0, i64* %rbx_idx, align 8
  %order.base.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  store i64* %order.base.ptr, i64** %order.base, align 8
  %q64 = bitcast i8* %m to i64*
  store i64 0, i64* %q64, align 8
  store i32 0, i32* %eax.var, align 4
  store i32 0, i32* %dist0.ptr, align 4
  br label %bb_11d3

bb_11c0:                                                ; preds = %bb_1320
  %rbx.val = load i64, i64* %rbx_idx, align 8
  %q.p = load i8*, i8** %queue.ptr, align 8
  %q64.2 = bitcast i8* %q.p to i64*
  %q.elem.ptr = getelementptr inbounds i64, i64* %q64.2, i64 %rbx.val
  %rdx.val = load i64, i64* %q.elem.ptr, align 8
  store i64 %rdx.val, i64* %rdx.cur, align 8
  store i32 1, i32* %eax.var, align 4
  br label %bb_11d3

bb_11d3:                                                ; preds = %bb_after_malloc, %bb_11c0
  %rbx.load = load i64, i64* %rbx_idx, align 8
  %rbx.inc = add i64 %rbx.load, 1
  store i64 %rbx.inc, i64* %rbx_idx, align 8
  %q.p2 = load i8*, i8** %queue.ptr, align 8
  %q64.3 = bitcast i8* %q.p2 to i64*
  %idx.prev = add i64 %rbx.inc, -1
  %q.prev.ptr = getelementptr inbounds i64, i64* %q64.3, i64 %idx.prev
  %rdx.at = load i64, i64* %q.prev.ptr, align 8
  store i64 %rdx.at, i64* %rdx.cur, align 8
  %order.base.ld = load i64*, i64** %order.base, align 8
  %order.store.ptr = getelementptr inbounds i64, i64* %order.base.ld, i64 %idx.prev
  store i64 %rdx.at, i64* %order.store.ptr, align 8
  %eax.load = load i32, i32* %eax.var, align 4
  %tst = icmp eq i32 %eax.load, 0
  br i1 %tst, label %bb_1200, label %bb_11e5

bb_11e5:                                                ; preds = %bb_11d3
  %dist0v = load i32, i32* %dist0.ptr, align 4
  %isne = icmp ne i32 %dist0v, -1
  br i1 %isne, label %bb_1200, label %bb_11eb

bb_11eb:                                                ; preds = %bb_11e5
  %rdx.cur.ld0 = load i64, i64* %rdx.cur, align 8
  %dist.row.ptr0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur.ld0
  %dist.cur0 = load i32, i32* %dist.row.ptr0, align 4
  %q.p3 = load i8*, i8** %queue.ptr, align 8
  %q64.4 = bitcast i8* %q.p3 to i64*
  %rsi.ld0 = load i64, i64* %rsi_idx, align 8
  %q.enq.ptr0 = getelementptr inbounds i64, i64* %q64.4, i64 %rsi.ld0
  store i64 0, i64* %q.enq.ptr0, align 8
  %rsi.inc0 = add i64 %rsi.ld0, 1
  store i64 %rsi.inc0, i64* %rsi_idx, align 8
  %dist0.new = add i32 %dist.cur0, 1
  store i32 %dist0.new, i32* %dist0.ptr, align 4
  br label %bb_1200

bb_1200:                                                ; preds = %bb_11d3, %bb_11e5, %bb_11eb
  ; Neighbor 1
  %rdx.cur.ld1 = load i64, i64* %rdx.cur, align 8
  %adj.row.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %rdx.cur.ld1
  %adj.n1.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row.ptr, i64 0, i64 0
  %adj.n1 = load i32, i32* %adj.n1.ptr, align 4
  %cond.n1.zero = icmp eq i32 %adj.n1, 0
  br i1 %cond.n1.zero, label %bb_1240, label %bb_1200_cont

bb_1200_cont:                                           ; preds = %bb_1200
  %dist1.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 1
  %dist1.val = load i32, i32* %dist1.ptr, align 4
  %dist1.ne = icmp ne i32 %dist1.val, -1
  br i1 %dist1.ne, label %bb_1240, label %bb_1200_enq

bb_1200_enq:                                            ; preds = %bb_1200_cont
  %rdx.cur.ld1b = load i64, i64* %rdx.cur, align 8
  %dist.row.ptr1b = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur.ld1b
  %dist.cur1b = load i32, i32* %dist.row.ptr1b, align 4
  %q.p4 = load i8*, i8** %queue.ptr, align 8
  %q64.5 = bitcast i8* %q.p4 to i64*
  %rsi.ld1 = load i64, i64* %rsi_idx, align 8
  %q.enq.ptr1 = getelementptr inbounds i64, i64* %q64.5, i64 %rsi.ld1
  store i64 1, i64* %q.enq.ptr1, align 8
  %rsi.inc1 = add i64 %rsi.ld1, 1
  store i64 %rsi.inc1, i64* %rsi_idx, align 8
  %dist1.new = add i32 %dist.cur1b, 1
  store i32 %dist1.new, i32* %dist1.ptr, align 4
  br label %bb_1240

bb_1240:                                                ; preds = %bb_1200, %bb_1200_cont, %bb_1200_enq
  ; Neighbor 2
  %adj.n2.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row.ptr, i64 0, i64 1
  %adj.n2 = load i32, i32* %adj.n2.ptr, align 4
  %cond.n2.zero = icmp eq i32 %adj.n2, 0
  br i1 %cond.n2.zero, label %bb_1270, label %bb_1240_cont

bb_1240_cont:                                           ; preds = %bb_1240
  %dist2.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 2
  %dist2.val = load i32, i32* %dist2.ptr, align 4
  %dist2.ne = icmp ne i32 %dist2.val, -1
  br i1 %dist2.ne, label %bb_1270, label %bb_1240_enq

bb_1240_enq:                                            ; preds = %bb_1240_cont
  %rdx.cur.ld2b = load i64, i64* %rdx.cur, align 8
  %dist.row.ptr2b = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur.ld2b
  %dist.cur2b = load i32, i32* %dist.row.ptr2b, align 4
  %q.p5 = load i8*, i8** %queue.ptr, align 8
  %q64.6 = bitcast i8* %q.p5 to i64*
  %rsi.ld2 = load i64, i64* %rsi_idx, align 8
  %q.enq.ptr2 = getelementptr inbounds i64, i64* %q64.6, i64 %rsi.ld2
  store i64 2, i64* %q.enq.ptr2, align 8
  %rsi.inc2 = add i64 %rsi.ld2, 1
  store i64 %rsi.inc2, i64* %rsi_idx, align 8
  %dist2.new = add i32 %dist.cur2b, 1
  store i32 %dist2.new, i32* %dist2.ptr, align 4
  br label %bb_1270

bb_1270:                                                ; preds = %bb_1240, %bb_1240_cont, %bb_1240_enq
  ; Neighbor 3
  %adj.n3.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row.ptr, i64 0, i64 2
  %adj.n3 = load i32, i32* %adj.n3.ptr, align 4
  %cond.n3.zero = icmp eq i32 %adj.n3, 0
  br i1 %cond.n3.zero, label %bb_12A0, label %bb_1270_cont

bb_1270_cont:                                           ; preds = %bb_1270
  %dist3.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 3
  %dist3.val = load i32, i32* %dist3.ptr, align 4
  %dist3.ne = icmp ne i32 %dist3.val, -1
  br i1 %dist3.ne, label %bb_12A0, label %bb_1270_enq

bb_1270_enq:                                            ; preds = %bb_1270_cont
  %rdx.cur.ld3b = load i64, i64* %rdx.cur, align 8
  %dist.row.ptr3b = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur.ld3b
  %dist.cur3b = load i32, i32* %dist.row.ptr3b, align 4
  %q.p6 = load i8*, i8** %queue.ptr, align 8
  %q64.7 = bitcast i8* %q.p6 to i64*
  %rsi.ld3 = load i64, i64* %rsi_idx, align 8
  %q.enq.ptr3 = getelementptr inbounds i64, i64* %q64.7, i64 %rsi.ld3
  store i64 3, i64* %q.enq.ptr3, align 8
  %rsi.inc3 = add i64 %rsi.ld3, 1
  store i64 %rsi.inc3, i64* %rsi_idx, align 8
  %dist3.new = add i32 %dist.cur3b, 1
  store i32 %dist3.new, i32* %dist3.ptr, align 4
  br label %bb_12A0

bb_12A0:                                                ; preds = %bb_1270, %bb_1270_cont, %bb_1270_enq
  ; Neighbor 4
  %adj.n4.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row.ptr, i64 0, i64 3
  %adj.n4 = load i32, i32* %adj.n4.ptr, align 4
  %cond.n4.zero = icmp eq i32 %adj.n4, 0
  br i1 %cond.n4.zero, label %bb_12D0, label %bb_12A0_cont

bb_12A0_cont:                                           ; preds = %bb_12A0
  %dist4.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 4
  %dist4.val = load i32, i32* %dist4.ptr, align 4
  %dist4.ne = icmp ne i32 %dist4.val, -1
  br i1 %dist4.ne, label %bb_12D0, label %bb_12A0_enq

bb_12A0_enq:                                            ; preds = %bb_12A0_cont
  %rdx.cur.ld4b = load i64, i64* %rdx.cur, align 8
  %dist.row.ptr4b = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur.ld4b
  %dist.cur4b = load i32, i32* %dist.row.ptr4b, align 4
  %q.p7 = load i8*, i8** %queue.ptr, align 8
  %q64.8 = bitcast i8* %q.p7 to i64*
  %rsi.ld4 = load i64, i64* %rsi_idx, align 8
  %q.enq.ptr4 = getelementptr inbounds i64, i64* %q64.8, i64 %rsi.ld4
  store i64 4, i64* %q.enq.ptr4, align 8
  %rsi.inc4 = add i64 %rsi.ld4, 1
  store i64 %rsi.inc4, i64* %rsi_idx, align 8
  %dist4.new = add i32 %dist.cur4b, 1
  store i32 %dist4.new, i32* %dist4.ptr, align 4
  br label %bb_12D0

bb_12D0:                                                ; preds = %bb_12A0, %bb_12A0_cont, %bb_12A0_enq
  ; Neighbor 5
  %adj.n5.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row.ptr, i64 0, i64 4
  %adj.n5 = load i32, i32* %adj.n5.ptr, align 4
  %cond.n5.zero = icmp eq i32 %adj.n5, 0
  br i1 %cond.n5.zero, label %bb_12F8, label %bb_12D0_cont

bb_12D0_cont:                                           ; preds = %bb_12D0
  %dist5.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 5
  %dist5.val = load i32, i32* %dist5.ptr, align 4
  %dist5.ne = icmp ne i32 %dist5.val, -1
  br i1 %dist5.ne, label %bb_12F8, label %bb_12D0_enq

bb_12D0_enq:                                            ; preds = %bb_12D0_cont
  %rdx.cur.ld5b = load i64, i64* %rdx.cur, align 8
  %dist.row.ptr5b = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur.ld5b
  %dist.cur5b = load i32, i32* %dist.row.ptr5b, align 4
  %q.p8 = load i8*, i8** %queue.ptr, align 8
  %q64.9 = bitcast i8* %q.p8 to i64*
  %rsi.ld5 = load i64, i64* %rsi_idx, align 8
  %q.enq.ptr5 = getelementptr inbounds i64, i64* %q64.9, i64 %rsi.ld5
  store i64 5, i64* %q.enq.ptr5, align 8
  %rsi.inc5 = add i64 %rsi.ld5, 1
  store i64 %rsi.inc5, i64* %rsi_idx, align 8
  %dist5.new = add i32 %dist.cur5b, 1
  store i32 %dist5.new, i32* %dist5.ptr, align 4
  br label %bb_12F8

bb_12F8:                                                ; preds = %bb_12D0, %bb_12D0_cont, %bb_12D0_enq
  ; Neighbor 6
  %adj.n6.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %adj.row.ptr, i64 0, i64 5
  %adj.n6 = load i32, i32* %adj.n6.ptr, align 4
  %cond.n6.zero = icmp eq i32 %adj.n6, 0
  br i1 %cond.n6.zero, label %bb_1320, label %bb_12F8_cont

bb_12F8_cont:                                           ; preds = %bb_12F8
  %dist6.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 6
  %dist6.val = load i32, i32* %dist6.ptr, align 4
  %dist6.ne = icmp ne i32 %dist6.val, -1
  br i1 %dist6.ne, label %bb_1320, label %bb_12F8_enq

bb_12F8_enq:                                            ; preds = %bb_12F8_cont
  %rdx.cur.ld6b = load i64, i64* %rdx.cur, align 8
  %dist.row.ptr6b = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur.ld6b
  %dist.cur6b = load i32, i32* %dist.row.ptr6b, align 4
  %q.p9 = load i8*, i8** %queue.ptr, align 8
  %q64.10 = bitcast i8* %q.p9 to i64*
  %rsi.ld6 = load i64, i64* %rsi_idx, align 8
  %q.enq.ptr6 = getelementptr inbounds i64, i64* %q64.10, i64 %rsi.ld6
  store i64 6, i64* %q.enq.ptr6, align 8
  %rsi.inc6 = add i64 %rsi.ld6, 1
  store i64 %rsi.inc6, i64* %rsi_idx, align 8
  %dist6.new = add i32 %dist.cur6b, 1
  store i32 %dist6.new, i32* %dist6.ptr, align 4
  br label %bb_1320

bb_1320:                                                ; preds = %bb_12F8, %bb_12F8_cont, %bb_12F8_enq
  %rbx.chk = load i64, i64* %rbx_idx, align 8
  %rsi.chk = load i64, i64* %rsi_idx, align 8
  %cond.loop = icmp ult i64 %rbx.chk, %rsi.chk
  br i1 %cond.loop, label %bb_11c0, label %bb_1329

bb_1329:                                                ; preds = %bb_1320
  %q.free = load i8*, i8** %queue.ptr, align 8
  call void @free(i8* %q.free)
  %fmt.bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %print1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.bfs.ptr, i64 0)
  %order.base.ld2 = load i64*, i64** %order.base, align 8
  %first.val = load i64, i64* %order.base.ld2, align 8
  store i64 %first.val, i64* %first.elem, align 8
  %rbx.cnt = load i64, i64* %rbx_idx, align 8
  %cmp.rbx1 = icmp ne i64 %rbx.cnt, 1
  br i1 %cmp.rbx1, label %bb_13dd, label %bb_1360

bb_1360:                                                ; preds = %bb_1329, %bb_1402
  %fmt.zus.ptr0 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %first.to.print0 = load i64, i64* %first.elem, align 8
  %print.one = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.zus.ptr0, i64 %first.to.print0, i8* %empty.ptr)
  br label %bb_1376

bb_1376:                                                ; preds = %bb_1360, %bb_1414
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %print.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  store i64 0, i64* %rbx_idx, align 8
  br label %bb_1398

bb_1398:                                                ; preds = %bb_1376, %bb_13b8
  %idx = load i64, i64* %rbx_idx, align 8
  %dist.ptr.i = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %idx
  %dist.val.i = load i32, i32* %dist.ptr.i, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %print.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.dist.ptr, i64 0, i64 %idx, i32 %dist.val.i)
  %idx.next = add i64 %idx, 1
  store i64 %idx.next, i64* %rbx_idx, align 8
  %cmp.end = icmp ne i64 %idx.next, 7
  br i1 %cmp.end, label %bb_1398, label %bb_13ba

bb_13ba:                                                ; preds = %bb_1398
  %g.save = load i64, i64* %canary, align 8
  %g.cur = load i64, i64* @__stack_chk_guard, align 8
  %cmp.canary = icmp ne i64 %g.save, %g.cur
  br i1 %cmp.canary, label %bb_142e, label %bb_ret

bb_ret:                                                 ; preds = %bb_13ba
  ret i32 0

bb_13dd:                                                ; preds = %bb_1329
  %order.base.ld3 = load i64*, i64** %order.base, align 8
  %rbx.count2 = load i64, i64* %rbx_idx, align 8
  %end.ptr = getelementptr inbounds i64, i64* %order.base.ld3, i64 %rbx.count2
  %rbp.cur = alloca i64*, align 8
  %rbp.start = getelementptr inbounds i64, i64* %order.base.ld3, i64 1
  store i64* %rbp.start, i64** %rbp.cur, align 8
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  br label %bb_13f0

bb_13f0:                                                ; preds = %bb_13dd, %bb_1402
  %fmt.zus.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %first.to.print = load i64, i64* %first.elem, align 8
  %print.elem = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.zus.ptr, i64 %first.to.print, i8* %space.ptr)
  br label %bb_1402

bb_1402:                                                ; preds = %bb_13f0
  %rbp.ld = load i64*, i64** %rbp.cur, align 8
  %rbp.next = getelementptr inbounds i64, i64* %rbp.ld, i64 1
  store i64* %rbp.next, i64** %rbp.cur, align 8
  %rbp.prev = getelementptr inbounds i64, i64* %rbp.next, i64 -1
  %val.next = load i64, i64* %rbp.prev, align 8
  store i64 %val.next, i64* %first.elem, align 8
  %r12.end.cmp = icmp ne i64* %rbp.next, %end.ptr
  br i1 %r12.end.cmp, label %bb_13f0, label %bb_1360

bb_1414:                                                ; preds = %bb_10c0
  %fmt.bfs2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %print1b = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.bfs2.ptr, i64 0)
  br label %bb_1376

bb_142e:                                                ; preds = %bb_13ba
  call void @__stack_chk_fail()
  unreachable
}