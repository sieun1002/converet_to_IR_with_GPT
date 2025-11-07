; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@__stack_chk_guard = external global i64

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8
  %adj = alloca [7 x [7 x i32]], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %queue.ptr = alloca i8*, align 8
  %adj.i8 = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %adj_10_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 0
  store i32 1, i32* %adj_10_ptr, align 4
  %adj_20_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 0
  store i32 1, i32* %adj_20_ptr, align 4
  %adj_31_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 1
  store i32 1, i32* %adj_31_ptr, align 4
  %adj_41_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 1
  store i32 1, i32* %adj_41_ptr, align 4
  %adj_25_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 5
  store i32 1, i32* %adj_25_ptr, align 4
  %adj_52_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 2
  store i32 1, i32* %adj_52_ptr, align 4
  %adj_45_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 5
  store i32 1, i32* %adj_45_ptr, align 4
  %adj_54_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 4
  store i32 1, i32* %adj_54_ptr, align 4
  %adj_56_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 6
  store i32 1, i32* %adj_56_ptr, align 4
  %adj_65_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 5
  store i32 1, i32* %adj_65_ptr, align 4
  %dist_i8 = bitcast [7 x i32]* %dist to i8*
  call void @llvm.memset.p0i8.i64(i8* %dist_i8, i8 -1, i64 28, i1 false)
  %qraw = call i8* @malloc(i64 56)
  store i8* %qraw, i8** %queue.ptr, align 8
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %loc_1414, label %after_malloc

after_malloc:
  %q64 = bitcast i8* %qraw to i64*
  %q0 = getelementptr inbounds i64, i64* %q64, i64 0
  store i64 0, i64* %q0, align 8
  %dist0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0ptr, align 4
  br label %loc_11D3

loc_11C0:
  %rbx.cur_for_11c0 = phi i64 [ %rbx.next.out, %loc_1320 ]
  %rsi.cur_for_11c0 = phi i64 [ %rsi.out, %loc_1320 ]
  %qbase.11c0 = load i8*, i8** %queue.ptr, align 8
  %q64.11c0 = bitcast i8* %qbase.11c0 to i64*
  %qdyn.ptr = getelementptr inbounds i64, i64* %q64.11c0, i64 %rbx.cur_for_11c0
  %node.for.next = load i64, i64* %qdyn.ptr, align 8
  %mul7.next = mul i64 %node.for.next, 7
  %adj_row0.base = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %node.for.next, i64 0
  %eax.next = load i32, i32* %adj_row0.base, align 4
  br label %loc_11D3

loc_11D3:
  %rbx.in = phi i64 [ 0, %after_malloc ], [ %rbx.cur_for_11c0, %loc_11C0 ]
  %rsi.in = phi i64 [ 1, %after_malloc ], [ %rsi.cur_for_11c0, %loc_11C0 ]
  %eax.prev = phi i32 [ 0, %after_malloc ], [ %eax.next, %loc_11C0 ]
  %rbx.next = add i64 %rbx.in, 1
  %qbase.11d3 = load i8*, i8** %queue.ptr, align 8
  %q64.11d3 = bitcast i8* %qbase.11d3 to i64*
  %idx.prev = add i64 %rbx.next, -1
  %qelem.ptr = getelementptr inbounds i64, i64* %q64.11d3, i64 %idx.prev
  %cur.node = load i64, i64* %qelem.ptr, align 8
  %order.store.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %idx.prev
  store i64 %cur.node, i64* %order.store.ptr, align 8
  %dist.cur.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %cur.node
  %tst_eax_zero = icmp eq i32 %eax.prev, 0
  br i1 %tst_eax_zero, label %loc_1200, label %bb_11d3_chk1

bb_11d3_chk1:
  %dist0.load = load i32, i32* %dist0ptr, align 4
  %dist0_ne_m1 = icmp ne i32 %dist0.load, -1
  br i1 %dist0_ne_m1, label %loc_1200, label %bb_11d3_then1

bb_11d3_then1:
  %dist.cur = load i32, i32* %dist.cur.ptr, align 4
  %rsi.enq0.next = add i64 %rsi.in, 1
  %qenq.ptr0 = getelementptr inbounds i64, i64* %q64.11d3, i64 %rsi.in
  store i64 0, i64* %qenq.ptr0, align 8
  %dist0.new = add i32 %dist.cur, 1
  store i32 %dist0.new, i32* %dist0ptr, align 4
  br label %loc_1200

loc_1200:
  %rsi.1200 = phi i64 [ %rsi.in, %loc_11D3 ], [ %rsi.in, %bb_11d3_chk1 ], [ %rsi.enq0.next, %bb_11d3_then1 ]
  %mul7.cur = mul i64 %cur.node, 7
  %adj_row1.base = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur.node, i64 1
  %r11d = load i32, i32* %adj_row1.base, align 4
  %r11_zero = icmp eq i32 %r11d, 0
  br i1 %r11_zero, label %loc_1240, label %bb_1200_chk2

bb_1200_chk2:
  %dist1ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 1
  %dist1 = load i32, i32* %dist1ptr, align 4
  %dist1_ne_m1 = icmp ne i32 %dist1, -1
  br i1 %dist1_ne_m1, label %loc_1240, label %bb_1200_then

bb_1200_then:
  %qenq.ptr1 = getelementptr inbounds i64, i64* %q64.11d3, i64 %rsi.1200
  store i64 1, i64* %qenq.ptr1, align 8
  %rsi.1200.enq = add i64 %rsi.1200, 1
  %dist.cur2 = load i32, i32* %dist.cur.ptr, align 4
  %dist1.new = add i32 %dist.cur2, 1
  store i32 %dist1.new, i32* %dist1ptr, align 4
  br label %loc_1240

loc_1240:
  %rsi.1240 = phi i64 [ %rsi.1200, %loc_1200 ], [ %rsi.1200, %bb_1200_chk2 ], [ %rsi.1200.enq, %bb_1200_then ]
  %adj_row2.base = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur.node, i64 2
  %r10d = load i32, i32* %adj_row2.base, align 4
  %r10_zero = icmp eq i32 %r10d, 0
  br i1 %r10_zero, label %loc_1270, label %bb_1240_chk2

bb_1240_chk2:
  %dist2ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 2
  %dist2 = load i32, i32* %dist2ptr, align 4
  %dist2_ne_m1 = icmp ne i32 %dist2, -1
  br i1 %dist2_ne_m1, label %loc_1270, label %bb_1240_then

bb_1240_then:
  %qenq.ptr2 = getelementptr inbounds i64, i64* %q64.11d3, i64 %rsi.1240
  store i64 2, i64* %qenq.ptr2, align 8
  %rsi.1240.enq = add i64 %rsi.1240, 1
  %dist.cur3 = load i32, i32* %dist.cur.ptr, align 4
  %dist2.new = add i32 %dist.cur3, 1
  store i32 %dist2.new, i32* %dist2ptr, align 4
  br label %loc_1270

loc_1270:
  %rsi.1270 = phi i64 [ %rsi.1240, %loc_1240 ], [ %rsi.1240, %bb_1240_chk2 ], [ %rsi.1240.enq, %bb_1240_then ]
  %adj_row3.base = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur.node, i64 3
  %r9d = load i32, i32* %adj_row3.base, align 4
  %r9_zero = icmp eq i32 %r9d, 0
  br i1 %r9_zero, label %loc_12A0, label %bb_1270_chk2

bb_1270_chk2:
  %dist3ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 3
  %dist3 = load i32, i32* %dist3ptr, align 4
  %dist3_ne_m1 = icmp ne i32 %dist3, -1
  br i1 %dist3_ne_m1, label %loc_12A0, label %bb_1270_then

bb_1270_then:
  %qenq.ptr3 = getelementptr inbounds i64, i64* %q64.11d3, i64 %rsi.1270
  store i64 3, i64* %qenq.ptr3, align 8
  %rsi.1270.enq = add i64 %rsi.1270, 1
  %dist.cur4 = load i32, i32* %dist.cur.ptr, align 4
  %dist3.new = add i32 %dist.cur4, 1
  store i32 %dist3.new, i32* %dist3ptr, align 4
  br label %loc_12A0

loc_12A0:
  %rsi.12A0 = phi i64 [ %rsi.1270, %loc_1270 ], [ %rsi.1270, %bb_1270_chk2 ], [ %rsi.1270.enq, %bb_1270_then ]
  %adj_row4.base = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur.node, i64 4
  %r8d = load i32, i32* %adj_row4.base, align 4
  %r8_zero = icmp eq i32 %r8d, 0
  br i1 %r8_zero, label %loc_12D0, label %bb_12a0_chk2

bb_12a0_chk2:
  %dist4ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 4
  %dist4 = load i32, i32* %dist4ptr, align 4
  %dist4_ne_m1 = icmp ne i32 %dist4, -1
  br i1 %dist4_ne_m1, label %loc_12D0, label %bb_12a0_then

bb_12a0_then:
  %qenq.ptr4 = getelementptr inbounds i64, i64* %q64.11d3, i64 %rsi.12A0
  store i64 4, i64* %qenq.ptr4, align 8
  %rsi.12a0.enq = add i64 %rsi.12A0, 1
  %dist.cur5 = load i32, i32* %dist.cur.ptr, align 4
  %dist4.new = add i32 %dist.cur5, 1
  store i32 %dist4.new, i32* %dist4ptr, align 4
  br label %loc_12D0

loc_12D0:
  %rsi.12D0 = phi i64 [ %rsi.12A0, %loc_12A0 ], [ %rsi.12A0, %bb_12a0_chk2 ], [ %rsi.12a0.enq, %bb_12a0_then ]
  %adj_row5.base = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur.node, i64 5
  %rcx5 = load i32, i32* %adj_row5.base, align 4
  %rcx5_zero = icmp eq i32 %rcx5, 0
  br i1 %rcx5_zero, label %loc_12F8, label %bb_12d0_chk2

bb_12d0_chk2:
  %dist5ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 5
  %dist5 = load i32, i32* %dist5ptr, align 4
  %dist5_ne_m1 = icmp ne i32 %dist5, -1
  br i1 %dist5_ne_m1, label %loc_12F8, label %bb_12d0_then

bb_12d0_then:
  %qenq.ptr5 = getelementptr inbounds i64, i64* %q64.11d3, i64 %rsi.12D0
  store i64 5, i64* %qenq.ptr5, align 8
  %rsi.12d0.enq = add i64 %rsi.12D0, 1
  %dist.cur6 = load i32, i32* %dist.cur.ptr, align 4
  %dist5.new = add i32 %dist.cur6, 1
  store i32 %dist5.new, i32* %dist5ptr, align 4
  br label %loc_12F8

loc_12F8:
  %rsi.12F8 = phi i64 [ %rsi.12D0, %loc_12D0 ], [ %rsi.12D0, %bb_12d0_chk2 ], [ %rsi.12d0.enq, %bb_12d0_then ]
  %adj_row6.base = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %cur.node, i64 6
  %eax6 = load i32, i32* %adj_row6.base, align 4
  %eax6_zero = icmp eq i32 %eax6, 0
  br i1 %eax6_zero, label %loc_1320, label %bb_12f8_chk2

bb_12f8_chk2:
  %dist6ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 6
  %dist6 = load i32, i32* %dist6ptr, align 4
  %dist6_ne_m1 = icmp ne i32 %dist6, -1
  br i1 %dist6_ne_m1, label %loc_1320, label %bb_12f8_then

bb_12f8_then:
  %qenq.ptr6 = getelementptr inbounds i64, i64* %q64.11d3, i64 %rsi.12F8
  store i64 6, i64* %qenq.ptr6, align 8
  %rsi.12f8.enq = add i64 %rsi.12F8, 1
  %dist.cur7 = load i32, i32* %dist.cur.ptr, align 4
  %dist6.new = add i32 %dist.cur7, 1
  store i32 %dist6.new, i32* %dist6ptr, align 4
  br label %loc_1320

loc_1320:
  %rsi.out = phi i64 [ %rsi.12F8, %loc_12F8 ], [ %rsi.12F8, %bb_12f8_chk2 ], [ %rsi.12f8.enq, %bb_12f8_then ]
  %rbx.next.out = phi i64 [ %rbx.next, %loc_12F8 ], [ %rbx.next, %bb_12f8_chk2 ], [ %rbx.next, %bb_12f8_then ]
  %cmp_rbx_rsi = icmp ult i64 %rbx.next.out, %rsi.out
  br i1 %cmp_rbx_rsi, label %loc_11C0, label %bb_1329

bb_1329:
  %count = phi i64 [ %rsi.out, %loc_1320 ]
  %qbase.free = load i8*, i8** %queue.ptr, align 8
  call void @free(i8* %qbase.free)
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %ret0 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr.ptr, i64 0)
  %first.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %first.elem = load i64, i64* %first.elem.ptr, align 8
  %cmp_one = icmp ne i64 %count, 1
  br i1 %cmp_one, label %loc_13DD, label %loc_1360

loc_13DD:
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %order.end = getelementptr inbounds i64, i64* %order.base, i64 %count
  %iter.ptr.init = getelementptr inbounds i64, i64* %order.base, i64 1
  br label %loc_13F0

loc_13F0:
  %iter.ptr = phi i64* [ %iter.ptr.init, %loc_13DD ], [ %iter.ptr.next, %bb_140a_back ]
  %last.val = phi i64 [ %first.elem, %loc_13DD ], [ %next.val, %bb_140a_back ]
  %fmt_zus = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %ret1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zus, i64 %last.val, i8* %space.ptr)
  %iter.ptr.next = getelementptr inbounds i64, i64* %iter.ptr, i64 1
  %next.val = load i64, i64* %iter.ptr, align 8
  %cmp_end = icmp ne i64* %iter.ptr.next, %order.end
  br i1 %cmp_end, label %bb_140a_back, label %loc_1360

bb_140a_back:
  br label %loc_13F0

loc_1360:
  %last.to.print = phi i64 [ %first.elem, %bb_1329 ], [ %next.val, %loc_13F0 ]
  %fmt_zus2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %ret2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zus2, i64 %last.to.print, i8* %empty.ptr)
  br label %loc_1376

loc_1414:
  %hdr.ptr.fail = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %retf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr.ptr.fail, i64 0)
  br label %loc_1376

loc_1376:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %ret3 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  br label %loc_1398

loc_1398:
  %i.idx = phi i64 [ 0, %loc_1376 ], [ %i.next, %loc_1398 ]
  %dist.i.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i.idx
  %dist.i32 = load i32, i32* %dist.i.ptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %ret4 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_dist, i64 0, i64 %i.idx, i32 %dist.i32)
  %i.next = add i64 %i.idx, 1
  %cmp7 = icmp ne i64 %i.next, 7
  br i1 %cmp7, label %loc_1398, label %epilogue

loc_142E:
  call void @__stack_chk_fail()
  unreachable

epilogue:
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.init = load i64, i64* %canary.slot, align 8
  %guard.ok = icmp eq i64 %guard.end, %guard.init
  br i1 %guard.ok, label %retblock, label %loc_142E

retblock:
  ret i32 0
}