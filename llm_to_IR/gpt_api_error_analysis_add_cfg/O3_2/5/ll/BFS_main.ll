; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@qword_2038 = external global i64

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.pzu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr
declare void @__stack_chk_fail() local_unnamed_addr noreturn
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main() local_unnamed_addr {
entry_0x10c0:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %queue.ptr = alloca i64*, align 8
  %len_rbx = alloca i64, align 8
  %head_rsi = alloca i64, align 8
  %curr_node = alloca i64, align 8
  %adj0_eax = alloca i32, align 4
  %saved_canary = alloca i64, align 8

  %canary = call i64 asm "movq %fs:0x28, $0", "=r"()
  store i64 %canary, i64* %saved_canary, align 8

  %adj.base.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.base.i8, i8 0, i64 196, i1 false)

  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %adj.idx1.i32 = getelementptr inbounds i32, i32* %adj.base, i64 1
  %adj.idx1.i64 = bitcast i32* %adj.idx1.i32 to i64*
  %q2038 = load i64, i64* @qword_2038, align 8
  store i64 %q2038, i64* %adj.idx1.i64, align 4

  %a7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %a7, align 4
  %a14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %a14, align 4
  %a22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %a22, align 4
  %a29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %a29, align 4
  %a19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %a19, align 4
  %a37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %a37, align 4
  %a33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %a33, align 4
  %a39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %a39, align 4
  %a41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %a41, align 4
  %a47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %a47, align 4

  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 -1, i32* %dist.base, align 4
  %d1 = getelementptr inbounds i32, i32* %dist.base, i64 1
  store i32 -1, i32* %d1, align 4
  %d2 = getelementptr inbounds i32, i32* %dist.base, i64 2
  store i32 -1, i32* %d2, align 4
  %d3 = getelementptr inbounds i32, i32* %dist.base, i64 3
  store i32 -1, i32* %d3, align 4
  %d4 = getelementptr inbounds i32, i32* %dist.base, i64 4
  store i32 -1, i32* %d4, align 4
  %d5 = getelementptr inbounds i32, i32* %dist.base, i64 5
  store i32 -1, i32* %d5, align 4
  %d6 = getelementptr inbounds i32, i32* %dist.base, i64 6
  store i32 -1, i32* %d6, align 4
  store i32 0, i32* %dist.base, align 4

  ; Precompute common format/suffix pointers to dominate all uses
  %fmt_pzu = getelementptr inbounds [6 x i8], [6 x i8]* @.str.pzu_s, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0

  %m = call i8* @malloc(i64 56)
  %m.null = icmp eq i8* %m, null
  br i1 %m.null, label %blk_0x1414, label %cont_after_malloc_0x1190

cont_after_malloc_0x1190:
  %m64 = bitcast i8* %m to i64*
  store i64* %m64, i64** %queue.ptr, align 8
  store i64 0, i64* %m64, align 8
  store i64 1, i64* %head_rsi, align 8
  store i64 0, i64* %len_rbx, align 8
  store i32 0, i32* %adj0_eax, align 4
  br label %blk_0x11D3

blk_0x11C0:
  %qptr.11C0 = load i64*, i64** %queue.ptr, align 8
  %rbx.11C0 = load i64, i64* %len_rbx, align 8
  %qelem.ptr.11C0 = getelementptr inbounds i64, i64* %qptr.11C0, i64 %rbx.11C0
  %curr.11C0 = load i64, i64* %qelem.ptr.11C0, align 8
  store i64 %curr.11C0, i64* %curr_node, align 8
  %curr7.11C0 = mul i64 %curr.11C0, 7
  %adj.idx0.11C0 = getelementptr inbounds i32, i32* %adj.base, i64 %curr7.11C0
  %adj0.val.11C0 = load i32, i32* %adj.idx0.11C0, align 4
  store i32 %adj0.val.11C0, i32* %adj0_eax, align 4
  br label %blk_0x11D3

blk_0x11D3:
  %rbx.prev = load i64, i64* %len_rbx, align 8
  %rbx.inc = add i64 %rbx.prev, 1
  store i64 %rbx.inc, i64* %len_rbx, align 8
  %qptr.11D3 = load i64*, i64** %queue.ptr, align 8
  %rbx.idx.m1 = add i64 %rbx.inc, -1
  %qelem.ptr.11D3 = getelementptr inbounds i64, i64* %qptr.11D3, i64 %rbx.idx.m1
  %curr.11D3 = load i64, i64* %qelem.ptr.11D3, align 8
  store i64 %curr.11D3, i64* %curr_node, align 8
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %order.slot = getelementptr inbounds i64, i64* %order.base, i64 %rbx.idx.m1
  store i64 %curr.11D3, i64* %order.slot, align 8
  %adj0.curr = load i32, i32* %adj0_eax, align 4
  %adj0.zero = icmp eq i32 %adj0.curr, 0
  br i1 %adj0.zero, label %blk_0x1200, label %chk0_has_edge_0x11e5

chk0_has_edge_0x11e5:
  %d0 = load i32, i32* %dist.base, align 4
  %d0.is.neg1 = icmp eq i32 %d0, -1
  br i1 %d0.is.neg1, label %do_neighbor0_0x11eb, label %blk_0x1200

do_neighbor0_0x11eb:
  %curr.node0 = load i64, i64* %curr_node, align 8
  %dist.curr.ptr0 = getelementptr inbounds i32, i32* %dist.base, i64 %curr.node0
  %dist.curr0 = load i32, i32* %dist.curr.ptr0, align 4
  %newdist0 = add i32 %dist.curr0, 1
  %qptr.n0 = load i64*, i64** %queue.ptr, align 8
  %rsi.n0 = load i64, i64* %head_rsi, align 8
  %qslot.n0 = getelementptr inbounds i64, i64* %qptr.n0, i64 %rsi.n0
  store i64 0, i64* %qslot.n0, align 8
  %rsi.inc.n0 = add i64 %rsi.n0, 1
  store i64 %rsi.inc.n0, i64* %head_rsi, align 8
  store i32 %newdist0, i32* %dist.base, align 4
  br label %blk_0x1200

blk_0x1200:
  %curr.b1200 = load i64, i64* %curr_node, align 8
  %baseIdx = mul i64 %curr.b1200, 7

  %idx1 = add i64 %baseIdx, 1
  %adj1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx1
  %adj1.val = load i32, i32* %adj1.ptr, align 4
  %adj1.zero = icmp eq i32 %adj1.val, 0
  br i1 %adj1.zero, label %blk_0x1240, label %chk1_has_edge_0x121d

chk1_has_edge_0x121d:
  %d1v = load i32, i32* %d1, align 4
  %d1.unseen = icmp eq i32 %d1v, -1
  br i1 %d1.unseen, label %do_neighbor1_0x1224, label %blk_0x1240

do_neighbor1_0x1224:
  %dist.curr.ptr1 = getelementptr inbounds i32, i32* %dist.base, i64 %curr.b1200
  %dist.curr1 = load i32, i32* %dist.curr.ptr1, align 4
  %newdist1 = add i32 %dist.curr1, 1
  %qptr.n1 = load i64*, i64** %queue.ptr, align 8
  %rsi.n1 = load i64, i64* %head_rsi, align 8
  %qslot.n1 = getelementptr inbounds i64, i64* %qptr.n1, i64 %rsi.n1
  store i64 1, i64* %qslot.n1, align 8
  %rsi.inc.n1 = add i64 %rsi.n1, 1
  store i64 %rsi.inc.n1, i64* %head_rsi, align 8
  store i32 %newdist1, i32* %d1, align 4
  br label %blk_0x1240

blk_0x1240:
  %idx2 = add i64 %baseIdx, 2
  %adj2.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx2
  %adj2.val = load i32, i32* %adj2.ptr, align 4
  %adj2.zero = icmp eq i32 %adj2.val, 0
  br i1 %adj2.zero, label %blk_0x1270, label %chk2_has_edge_0x124a

chk2_has_edge_0x124a:
  %d2v2 = load i32, i32* %d2, align 4
  %d2.unseen = icmp eq i32 %d2v2, -1
  br i1 %d2.unseen, label %do_neighbor2_0x1251, label %blk_0x1270

do_neighbor2_0x1251:
  %dist.curr.ptr2 = getelementptr inbounds i32, i32* %dist.base, i64 %curr.b1200
  %dist.curr2 = load i32, i32* %dist.curr.ptr2, align 4
  %newdist2 = add i32 %dist.curr2, 1
  %qptr.n2 = load i64*, i64** %queue.ptr, align 8
  %rsi.n2 = load i64, i64* %head_rsi, align 8
  %qslot.n2 = getelementptr inbounds i64, i64* %qptr.n2, i64 %rsi.n2
  store i64 2, i64* %qslot.n2, align 8
  %rsi.inc.n2 = add i64 %rsi.n2, 1
  store i64 %rsi.inc.n2, i64* %head_rsi, align 8
  store i32 %newdist2, i32* %d2, align 4
  br label %blk_0x1270

blk_0x1270:
  %idx3 = add i64 %baseIdx, 3
  %adj3.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx3
  %adj3.val = load i32, i32* %adj3.ptr, align 4
  %adj3.zero = icmp eq i32 %adj3.val, 0
  br i1 %adj3.zero, label %blk_0x12A0, label %chk3_has_edge_0x127a

chk3_has_edge_0x127a:
  %d3v3 = load i32, i32* %d3, align 4
  %d3.unseen = icmp eq i32 %d3v3, -1
  br i1 %d3.unseen, label %do_neighbor3_0x1281, label %blk_0x12A0

do_neighbor3_0x1281:
  %dist.curr.ptr3 = getelementptr inbounds i32, i32* %dist.base, i64 %curr.b1200
  %dist.curr3 = load i32, i32* %dist.curr.ptr3, align 4
  %newdist3 = add i32 %dist.curr3, 1
  %qptr.n3 = load i64*, i64** %queue.ptr, align 8
  %rsi.n3 = load i64, i64* %head_rsi, align 8
  %qslot.n3 = getelementptr inbounds i64, i64* %qptr.n3, i64 %rsi.n3
  store i64 3, i64* %qslot.n3, align 8
  %rsi.inc.n3 = add i64 %rsi.n3, 1
  store i64 %rsi.inc.n3, i64* %head_rsi, align 8
  store i32 %newdist3, i32* %d3, align 4
  br label %blk_0x12A0

blk_0x12A0:
  %idx4 = add i64 %baseIdx, 4
  %adj4.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx4
  %adj4.val = load i32, i32* %adj4.ptr, align 4
  %adj4.zero = icmp eq i32 %adj4.val, 0
  br i1 %adj4.zero, label %blk_0x12D0, label %chk4_has_edge_0x12aa

chk4_has_edge_0x12aa:
  %d4v4 = load i32, i32* %d4, align 4
  %d4.unseen = icmp eq i32 %d4v4, -1
  br i1 %d4.unseen, label %do_neighbor4_0x12b1, label %blk_0x12D0

do_neighbor4_0x12b1:
  %dist.curr.ptr4 = getelementptr inbounds i32, i32* %dist.base, i64 %curr.b1200
  %dist.curr4 = load i32, i32* %dist.curr.ptr4, align 4
  %newdist4 = add i32 %dist.curr4, 1
  %qptr.n4 = load i64*, i64** %queue.ptr, align 8
  %rsi.n4 = load i64, i64* %head_rsi, align 8
  %qslot.n4 = getelementptr inbounds i64, i64* %qptr.n4, i64 %rsi.n4
  store i64 4, i64* %qslot.n4, align 8
  %rsi.inc.n4 = add i64 %rsi.n4, 1
  store i64 %rsi.inc.n4, i64* %head_rsi, align 8
  store i32 %newdist4, i32* %d4, align 4
  br label %blk_0x12D0

blk_0x12D0:
  %idx5 = add i64 %baseIdx, 5
  %adj5.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx5
  %adj5.val = load i32, i32* %adj5.ptr, align 4
  %adj5.zero = icmp eq i32 %adj5.val, 0
  br i1 %adj5.zero, label %blk_0x12F8, label %chk5_has_edge_0x12d8

chk5_has_edge_0x12d8:
  %d5v5 = load i32, i32* %d5, align 4
  %d5.unseen = icmp eq i32 %d5v5, -1
  br i1 %d5.unseen, label %do_neighbor5_0x12df, label %blk_0x12F8

do_neighbor5_0x12df:
  %dist.curr.ptr5 = getelementptr inbounds i32, i32* %dist.base, i64 %curr.b1200
  %dist.curr5 = load i32, i32* %dist.curr.ptr5, align 4
  %newdist5 = add i32 %dist.curr5, 1
  %qptr.n5 = load i64*, i64** %queue.ptr, align 8
  %rsi.n5 = load i64, i64* %head_rsi, align 8
  %qslot.n5 = getelementptr inbounds i64, i64* %qptr.n5, i64 %rsi.n5
  store i64 5, i64* %qslot.n5, align 8
  %rsi.inc.n5 = add i64 %rsi.n5, 1
  store i64 %rsi.inc.n5, i64* %head_rsi, align 8
  store i32 %newdist5, i32* %d5, align 4
  br label %blk_0x12F8

blk_0x12F8:
  %idx6 = add i64 %baseIdx, 6
  %adj6.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx6
  %adj6.val = load i32, i32* %adj6.ptr, align 4
  %adj6.zero = icmp eq i32 %adj6.val, 0
  br i1 %adj6.zero, label %blk_0x1320, label %chk6_has_edge_0x1300

chk6_has_edge_0x1300:
  %d6v6 = load i32, i32* %d6, align 4
  %d6.unseen = icmp eq i32 %d6v6, -1
  br i1 %d6.unseen, label %do_neighbor6_0x1307, label %blk_0x1320

do_neighbor6_0x1307:
  %dist.curr.ptr6 = getelementptr inbounds i32, i32* %dist.base, i64 %curr.b1200
  %dist.curr6 = load i32, i32* %dist.curr.ptr6, align 4
  %newdist6 = add i32 %dist.curr6, 1
  %qptr.n6 = load i64*, i64** %queue.ptr, align 8
  %rsi.n6 = load i64, i64* %head_rsi, align 8
  %qslot.n6 = getelementptr inbounds i64, i64* %qptr.n6, i64 %rsi.n6
  store i64 6, i64* %qslot.n6, align 8
  %rsi.inc.n6 = add i64 %rsi.n6, 1
  store i64 %rsi.inc.n6, i64* %head_rsi, align 8
  store i32 %newdist6, i32* %d6, align 4
  br label %blk_0x1320

blk_0x1320:
  %rbx.cur = load i64, i64* %len_rbx, align 8
  %rsi.cur = load i64, i64* %head_rsi, align 8
  %cmp.jb = icmp ult i64 %rbx.cur, %rsi.cur
  br i1 %cmp.jb, label %blk_0x11C0, label %after_bfs_0x1329

after_bfs_0x1329:
  %qptr.free = load i64*, i64** %queue.ptr, align 8
  %qptr.free.i8 = bitcast i64* %qptr.free to i8*
  call void @free(i8* %qptr.free.i8)

  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %r = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.bfs, i64 0)

  %ord.base2 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %ord0 = load i64, i64* %ord.base2, align 8
  %len.final = load i64, i64* %len_rbx, align 8
  %cmp.len.eq1 = icmp ne i64 %len.final, 1
  br i1 %cmp.len.eq1, label %blk_0x13DD, label %blk_0x1360

blk_0x1360:
  br label %call_print_single_0x1360

call_print_single_0x1360:
  %phi.elem = phi i64 [ %ord0, %blk_0x1360 ], [ %loop.last.elem, %blk_0x140F ], [ 0, %blk_0x1414 ]
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_pzu, i64 %phi.elem, i8* %empty_ptr)
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  br label %blk_0x1384_1376

blk_0x1384_1376:
  store i64 0, i64* %len_rbx, align 8
  br label %blk_0x1398

blk_0x1398:
  %idx.node = load i64, i64* %len_rbx, align 8
  %dist.ptr.it = getelementptr inbounds i32, i32* %dist.base, i64 %idx.node
  %dist.val.it = load i32, i32* %dist.ptr.it, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %_dist = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.dist, i64 0, i64 %idx.node, i32 %dist.val.it)
  %idx.next = add i64 %idx.node, 1
  store i64 %idx.next, i64* %len_rbx, align 8
  %cond.more = icmp ne i64 %idx.next, 7
  br i1 %cond.more, label %blk_0x1398, label %blk_0x13BA

blk_0x13BA:
  %canary.saved = load i64, i64* %saved_canary, align 8
  %canary.now = call i64 asm "movq %fs:0x28, $0", "=r"()
  %canary.eq = icmp eq i64 %canary.saved, %canary.now
  br i1 %canary.eq, label %epilogue_ok_0x13cd, label %blk_0x142E

epilogue_ok_0x13cd:
  ret i32 0

blk_0x13DD:
  %len.mul8 = mul i64 %len.final, 8
  %ord.base3.i8 = bitcast i64* %ord.base2 to i8*
  %end.ptr.i8 = getelementptr inbounds i8, i8* %ord.base3.i8, i64 %len.mul8
  %end.ptr = bitcast i8* %end.ptr.i8 to i64*
  %first1.ptr = getelementptr inbounds i64, i64* %ord.base2, i64 1
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %blk_0x13F0

blk_0x13F0:
  %seed.elem = phi i64 [ %ord0, %blk_0x13DD ], [ %next.elem, %blk_0x140D ]
  %rbp.cur = phi i64* [ %first1.ptr, %blk_0x13DD ], [ %rbp.next, %blk_0x140D ]
  %_loopprint = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_pzu, i64 %seed.elem, i8* %space.ptr)
  br label %blk_0x1402

blk_0x1402:
  %rbp.next = getelementptr inbounds i64, i64* %rbp.cur, i64 1
  %rbp.prev.elem.ptr = getelementptr inbounds i64, i64* %rbp.next, i64 -1
  %next.elem = load i64, i64* %rbp.prev.elem.ptr, align 8
  br label %blk_0x140D

blk_0x140D:
  %cmp.ne.end = icmp ne i64* %rbp.next, %end.ptr
  br i1 %cmp.ne.end, label %blk_0x13F0, label %blk_0x140F

blk_0x140F:
  %loop.last.elem = phi i64 [ %next.elem, %blk_0x140D ]
  br label %call_print_single_0x1360

blk_0x1414:
  %fmt.bfs2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %_hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.bfs2, i64 0)
  br label %call_print_single_0x1360

blk_0x142E:
  call void @__stack_chk_fail()
  unreachable
}