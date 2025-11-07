; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@qword_2038 = external global i64

@.str_hdr = private constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_item = private constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private constant [2 x i8] c" \00", align 1
@.str_empty = private constant [1 x i8] c"\00", align 1
@.str_nl = private constant [2 x i8] c"\0A\00", align 1
@.str_dist = private constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr
declare void @__stack_chk_fail() local_unnamed_addr

define i32 @main() local_unnamed_addr {
addr_10c0:
  %saved_canary = alloca i64, align 8
  %dist = alloca [7 x i32], align 16
  %adj0 = alloca [49 x i32], align 16
  %adj1 = alloca [49 x i32], align 16
  %adj2 = alloca [49 x i32], align 16
  %adj3 = alloca [49 x i32], align 16
  %adj4 = alloca [49 x i32], align 16
  %adj5 = alloca [49 x i32], align 16
  %adj6 = alloca [49 x i32], align 16
  %processed = alloca [7 x i64], align 16
  %queue_raw = alloca i8*, align 8
  %gq = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %saved_canary, align 8
  %gqv = load i64, i64* @qword_2038, align 8
  store i64 %gqv, i64* %gq, align 8
  ; initialize distances to -1
  %d0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 -1, i32* %d0ptr, align 4
  %d1ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 1
  store i32 -1, i32* %d1ptr, align 4
  %d2ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 2
  store i32 -1, i32* %d2ptr, align 4
  %d3ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 3
  store i32 -1, i32* %d3ptr, align 4
  %d4ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 4
  store i32 -1, i32* %d4ptr, align 4
  %d5ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 5
  store i32 -1, i32* %d5ptr, align 4
  %d6ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 6
  store i32 -1, i32* %d6ptr, align 4
  ; zero adjacency tables (49 entries each)
  br label %init_adj0

init_adj0:
  %i0 = phi i64 [ 0, %addr_10c0 ], [ %i0.next, %init_adj0 ]
  %adj0.gep = getelementptr inbounds [49 x i32], [49 x i32]* %adj0, i64 0, i64 %i0
  store i32 0, i32* %adj0.gep, align 4
  %adj1.gep = getelementptr inbounds [49 x i32], [49 x i32]* %adj1, i64 0, i64 %i0
  store i32 0, i32* %adj1.gep, align 4
  %adj2.gep = getelementptr inbounds [49 x i32], [49 x i32]* %adj2, i64 0, i64 %i0
  store i32 0, i32* %adj2.gep, align 4
  %adj3.gep = getelementptr inbounds [49 x i32], [49 x i32]* %adj3, i64 0, i64 %i0
  store i32 0, i32* %adj3.gep, align 4
  %adj4.gep = getelementptr inbounds [49 x i32], [49 x i32]* %adj4, i64 0, i64 %i0
  store i32 0, i32* %adj4.gep, align 4
  %adj5.gep = getelementptr inbounds [49 x i32], [49 x i32]* %adj5, i64 0, i64 %i0
  store i32 0, i32* %adj5.gep, align 4
  %adj6.gep = getelementptr inbounds [49 x i32], [49 x i32]* %adj6, i64 0, i64 %i0
  store i32 0, i32* %adj6.gep, align 4
  %i0.next = add nuw nsw i64 %i0, 1
  %init.done = icmp eq i64 %i0.next, 49
  br i1 %init.done, label %addr_1188_prep, label %init_adj0

addr_1188_prep:
  ; malloc(0x38)
  %malloc.ptr = call i8* @malloc(i64 56)
  %isnull = icmp eq i8* %malloc.ptr, null
  br i1 %isnull, label %loc_1414, label %addr_1196

addr_1196:
  store i8* %malloc.ptr, i8** %queue_raw, align 8
  %queue.i64 = bitcast i8* %malloc.ptr to i64*
  %rsi.init = add i64 0, 1
  %rbx.init = add i64 0, 0
  %q0ptr = getelementptr inbounds i64, i64* %queue.i64, i64 0
  store i64 0, i64* %q0ptr, align 8
  store i32 0, i32* %d0ptr, align 4
  br label %loc_11D3

loc_11C0:
  ; predecessor: loc_1320
  %rbx.c0 = phi i64 [ %rbx.cur.l, %loc_1320 ]
  %rsi.c0 = phi i64 [ %rsi.cur.l, %loc_1320 ]
  %queue.ptr.c0.raw = load i8*, i8** %queue_raw, align 8
  %queue.ptr.c0 = bitcast i8* %queue.ptr.c0.raw to i64*
  %q.load.ptr = getelementptr inbounds i64, i64* %queue.ptr.c0, i64 %rbx.c0
  %rdx.c0 = load i64, i64* %q.load.ptr, align 8
  %rdx.mul8 = shl i64 %rdx.c0, 3
  %rcx7.c0 = sub i64 %rdx.mul8, %rdx.c0
  %adj0.idx.c0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj0, i64 0, i64 %rcx7.c0
  %eax0.c0 = load i32, i32* %adj0.idx.c0, align 4
  br label %loc_11D3

loc_11D3:
  ; predecessors: addr_1196, loc_11C0
  %rbx.phi = phi i64 [ %rbx.init, %addr_1196 ], [ %rbx.c0, %loc_11C0 ]
  %rsi.phi = phi i64 [ %rsi.init, %addr_1196 ], [ %rsi.c0, %loc_11C0 ]
  %eax.phi = phi i32 [ 0, %addr_1196 ], [ %eax0.c0, %loc_11C0 ]
  %rbx.cur = add i64 %rbx.phi, 1
  %q.idx.prev = sub i64 %rbx.cur, 1
  %queue.ptr.d3.raw = load i8*, i8** %queue_raw, align 8
  %queue.ptr.d3 = bitcast i8* %queue.ptr.d3.raw to i64*
  %q.elem.ptr = getelementptr inbounds i64, i64* %queue.ptr.d3, i64 %q.idx.prev
  %rdx.cur = load i64, i64* %q.elem.ptr, align 8
  %proc.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %processed, i64 0, i64 %q.idx.prev
  store i64 %rdx.cur, i64* %proc.ptr, align 8
  %tst.n0 = icmp ne i32 %eax.phi, 0
  br i1 %tst.n0, label %bb_11e5, label %loc_1200

bb_11e5:
  %dist0.load = load i32, i32* %d0ptr, align 4
  %dist0.isneg = icmp eq i32 %dist0.load, -1
  br i1 %dist0.isneg, label %bb_11eb, label %loc_1200

bb_11eb:
  %dist.cur.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur
  %dist.cur.val = load i32, i32* %dist.cur.ptr, align 4
  %q.next.ptr = getelementptr inbounds i64, i64* %queue.ptr.d3, i64 %rsi.phi
  store i64 0, i64* %q.next.ptr, align 8
  %rsi.inc.n0 = add i64 %rsi.phi, 1
  %dist0.new = add i32 %dist.cur.val, 1
  store i32 %dist0.new, i32* %d0ptr, align 4
  br label %loc_1200

loc_1200:
  ; predecessors: loc_11D3, bb_11eb, bb_11e5
  %rsi.phi.1200 = phi i64 [ %rsi.phi, %loc_11D3 ], [ %rsi.inc.n0, %bb_11eb ], [ %rsi.phi, %bb_11e5 ]
  %rdx.mul8.1200 = shl i64 %rdx.cur, 3
  %rcx7.1200 = sub i64 %rdx.mul8.1200, %rdx.cur
  %adj1.idx = getelementptr inbounds [49 x i32], [49 x i32]* %adj1, i64 0, i64 %rcx7.1200
  %r11d = load i32, i32* %adj1.idx, align 4
  %tst.r11 = icmp ne i32 %r11d, 0
  br i1 %tst.r11, label %bb_121d, label %loc_1240

bb_121d:
  %d1val = load i32, i32* %d1ptr, align 4
  %d1.neg = icmp eq i32 %d1val, -1
  br i1 %d1.neg, label %bb_1224, label %loc_1240

bb_1224:
  %dist.cur.ptr.1 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur
  %dist.cur.val.1 = load i32, i32* %dist.cur.ptr.1, align 4
  %q.put.1 = getelementptr inbounds i64, i64* %queue.ptr.d3, i64 %rsi.phi.1200
  store i64 1, i64* %q.put.1, align 8
  %rsi.inc.n1 = add i64 %rsi.phi.1200, 1
  %d1.new = add i32 %dist.cur.val.1, 1
  store i32 %d1.new, i32* %d1ptr, align 4
  br label %loc_1240

loc_1240:
  ; predecessors: loc_1200, bb_1224, bb_121d
  %rsi.phi.1240 = phi i64 [ %rsi.phi.1200, %loc_1200 ], [ %rsi.inc.n1, %bb_1224 ], [ %rsi.phi.1200, %bb_121d ]
  %adj2.idx = getelementptr inbounds [49 x i32], [49 x i32]* %adj2, i64 0, i64 %rcx7.1200
  %r10d = load i32, i32* %adj2.idx, align 4
  %tst.r10 = icmp ne i32 %r10d, 0
  br i1 %tst.r10, label %bb_1251, label %loc_1270

bb_1251:
  %d2val = load i32, i32* %d2ptr, align 4
  %d2.neg = icmp eq i32 %d2val, -1
  br i1 %d2.neg, label %bb_1251_do, label %loc_1270

bb_1251_do:
  %dist.cur.ptr.2 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur
  %dist.cur.val.2 = load i32, i32* %dist.cur.ptr.2, align 4
  %q.put.2 = getelementptr inbounds i64, i64* %queue.ptr.d3, i64 %rsi.phi.1240
  store i64 2, i64* %q.put.2, align 8
  %rsi.inc.n2 = add i64 %rsi.phi.1240, 1
  %d2.new = add i32 %dist.cur.val.2, 1
  store i32 %d2.new, i32* %d2ptr, align 4
  br label %loc_1270

loc_1270:
  ; predecessors: loc_1240, bb_1251_do, bb_1251
  %rsi.phi.1270 = phi i64 [ %rsi.phi.1240, %loc_1240 ], [ %rsi.inc.n2, %bb_1251_do ], [ %rsi.phi.1240, %bb_1251 ]
  %adj3.idx = getelementptr inbounds [49 x i32], [49 x i32]* %adj3, i64 0, i64 %rcx7.1200
  %r9d = load i32, i32* %adj3.idx, align 4
  %tst.r9 = icmp ne i32 %r9d, 0
  br i1 %tst.r9, label %bb_1281, label %loc_12A0

bb_1281:
  %d3val = load i32, i32* %d3ptr, align 4
  %d3.neg = icmp eq i32 %d3val, -1
  br i1 %d3.neg, label %bb_1281_do, label %loc_12A0

bb_1281_do:
  %dist.cur.ptr.3 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur
  %dist.cur.val.3 = load i32, i32* %dist.cur.ptr.3, align 4
  %q.put.3 = getelementptr inbounds i64, i64* %queue.ptr.d3, i64 %rsi.phi.1270
  store i64 3, i64* %q.put.3, align 8
  %rsi.inc.n3 = add i64 %rsi.phi.1270, 1
  %d3.new = add i32 %dist.cur.val.3, 1
  store i32 %d3.new, i32* %d3ptr, align 4
  br label %loc_12A0

loc_12A0:
  ; predecessors: loc_1270, bb_1281_do, bb_1281
  %rsi.phi.12A0 = phi i64 [ %rsi.phi.1270, %loc_1270 ], [ %rsi.inc.n3, %bb_1281_do ], [ %rsi.phi.1270, %bb_1281 ]
  %adj4.idx = getelementptr inbounds [49 x i32], [49 x i32]* %adj4, i64 0, i64 %rcx7.1200
  %r8d = load i32, i32* %adj4.idx, align 4
  %tst.r8 = icmp ne i32 %r8d, 0
  br i1 %tst.r8, label %bb_12b1, label %loc_12D0

bb_12b1:
  %d4val = load i32, i32* %d4ptr, align 4
  %d4.neg = icmp eq i32 %d4val, -1
  br i1 %d4.neg, label %bb_12b1_do, label %loc_12D0

bb_12b1_do:
  %dist.cur.ptr.4 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur
  %dist.cur.val.4 = load i32, i32* %dist.cur.ptr.4, align 4
  %q.put.4 = getelementptr inbounds i64, i64* %queue.ptr.d3, i64 %rsi.phi.12A0
  store i64 4, i64* %q.put.4, align 8
  %rsi.inc.n4 = add i64 %rsi.phi.12A0, 1
  %d4.new = add i32 %dist.cur.val.4, 1
  store i32 %d4.new, i32* %d4ptr, align 4
  br label %loc_12D0

loc_12D0:
  ; predecessors: loc_12A0, bb_12b1_do, bb_12b1
  %rsi.phi.12D0 = phi i64 [ %rsi.phi.12A0, %loc_12A0 ], [ %rsi.inc.n4, %bb_12b1_do ], [ %rsi.phi.12A0, %bb_12b1 ]
  %adj5.idx = getelementptr inbounds [49 x i32], [49 x i32]* %adj5, i64 0, i64 %rcx7.1200
  %ecx5 = load i32, i32* %adj5.idx, align 4
  %tst.ecx5 = icmp ne i32 %ecx5, 0
  br i1 %tst.ecx5, label %bb_12df, label %loc_12F8

bb_12df:
  %d5val = load i32, i32* %d5ptr, align 4
  %d5.neg = icmp eq i32 %d5val, -1
  br i1 %d5.neg, label %bb_12df_do, label %loc_12F8

bb_12df_do:
  %dist.cur.ptr.5 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur
  %dist.cur.val.5 = load i32, i32* %dist.cur.ptr.5, align 4
  %q.put.5 = getelementptr inbounds i64, i64* %queue.ptr.d3, i64 %rsi.phi.12D0
  store i64 5, i64* %q.put.5, align 8
  %rsi.inc.n5 = add i64 %rsi.phi.12D0, 1
  %d5.new = add i32 %dist.cur.val.5, 1
  store i32 %d5.new, i32* %d5ptr, align 4
  br label %loc_12F8

loc_12F8:
  ; predecessors: loc_12D0, bb_12df_do, bb_12df
  %rsi.phi.12F8 = phi i64 [ %rsi.phi.12D0, %loc_12D0 ], [ %rsi.inc.n5, %bb_12df_do ], [ %rsi.phi.12D0, %bb_12df ]
  %adj6.idx = getelementptr inbounds [49 x i32], [49 x i32]* %adj6, i64 0, i64 %rcx7.1200
  %eax6 = load i32, i32* %adj6.idx, align 4
  %tst.eax6 = icmp ne i32 %eax6, 0
  br i1 %tst.eax6, label %bb_1307, label %loc_1320

bb_1307:
  %d6val = load i32, i32* %d6ptr, align 4
  %d6.neg = icmp eq i32 %d6val, -1
  br i1 %d6.neg, label %bb_1307_do, label %loc_1320

bb_1307_do:
  %dist.cur.ptr.6 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %rdx.cur
  %dist.cur.val.6 = load i32, i32* %dist.cur.ptr.6, align 4
  %q.put.6 = getelementptr inbounds i64, i64* %queue.ptr.d3, i64 %rsi.phi.12F8
  store i64 6, i64* %q.put.6, align 8
  %rsi.inc.n6 = add i64 %rsi.phi.12F8, 1
  %d6.new = add i32 %dist.cur.val.6, 1
  store i32 %d6.new, i32* %d6ptr, align 4
  br label %loc_1320

loc_1320:
  ; predecessors: loc_12F8, bb_1307_do, bb_1307
  %rsi.cur.l = phi i64 [ %rsi.phi.12F8, %loc_12F8 ], [ %rsi.inc.n6, %bb_1307_do ], [ %rsi.phi.12F8, %bb_1307 ]
  %rbx.cur.l = phi i64 [ %rbx.cur, %loc_12F8 ], [ %rbx.cur, %bb_1307_do ], [ %rbx.cur, %bb_1307 ]
  %cont = icmp ult i64 %rbx.cur.l, %rsi.cur.l
  br i1 %cont, label %loc_11C0, label %after_bfs

after_bfs:
  %queue.raw.end = load i8*, i8** %queue_raw, align 8
  call void @free(i8* %queue.raw.end)
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %hdr.print = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr.ptr, i64 0)
  %first.proc.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %processed, i64 0, i64 0
  %first.proc = load i64, i64* %first.proc.ptr, align 8
  %rbx.eq1 = icmp ne i64 %rbx.cur.l, 1
  br i1 %rbx.eq1, label %loc_13DD, label %loc_1360

loc_13DD:
  %end.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %processed, i64 0, i64 %rbx.cur.l
  %rp.init = getelementptr inbounds [7 x i64], [7 x i64]* %processed, i64 0, i64 1
  br label %loc_13F0

loc_13F0:
  %rp.cur = phi i64* [ %rp.init, %loc_13DD ], [ %rp.next, %loc_13F0 ]
  %elem.ptr = getelementptr inbounds i64, i64* %rp.cur, i64 -1
  %elem.val = load i64, i64* %elem.ptr, align 8
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %print.item = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.item.ptr, i64 %elem.val, i8* %space.ptr)
  %rp.next = getelementptr inbounds i64, i64* %rp.cur, i64 1
  %at.end = icmp eq i64* %rp.next, %end.ptr
  br i1 %at.end, label %loc_1360, label %loc_13F0

loc_1360:
  %fmt.item.ptr.1360 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %print.first = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.item.ptr.1360, i64 %first.proc, i8* %empty.ptr)
  br label %loc_1376

loc_1376:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %print.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  br label %loc_1398

loc_1398:
  %idx.print = phi i64 [ 0, %loc_1376 ], [ %idx.next, %loc_1398 ]
  %val.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %idx.print
  %val = load i32, i32* %val.ptr, align 4
  %print.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.dist.ptr, i64 0, i64 %idx.print, i32 %val)
  %idx.next = add nuw nsw i64 %idx.print, 1
  %done.print = icmp eq i64 %idx.next, 7
  br i1 %done.print, label %epilogue_check, label %loc_1398

epilogue_check:
  %guard1 = load i64, i64* %saved_canary, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %canary.ok = icmp eq i64 %guard1, %guard.now
  br i1 %canary.ok, label %ret_ok, label %loc_142E

ret_ok:
  ret i32 0

loc_1414:
  %hdr.ptr.1414 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %print.hdr.1414 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr.ptr.1414, i64 0)
  br label %loc_1376

loc_142E:
  call void @__stack_chk_fail()
  unreachable
}