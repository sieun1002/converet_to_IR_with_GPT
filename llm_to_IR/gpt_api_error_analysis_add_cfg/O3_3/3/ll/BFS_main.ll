; ModuleID = 'recovered_main'
source_filename = "recovered_main.ll"
target triple = "x86_64-pc-linux-gnu"

@qword_2038 = external global i32*

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare noalias i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind
declare i32 @__printf_chk(i32, i8*, ...) nounwind
declare void @__stack_chk_fail() noreturn nounwind

define i32 @main() {
L0x10c0:
  %guard = alloca i64, align 8
  %out_arr = alloca [7 x i64], align 16
  %dist = alloca [7 x i32], align 16
  %varF8 = alloca [49 x i32], align 16
  %adj_base.slot = alloca i32*, align 8
  %P.slot = alloca i64*, align 8
  store i64 0, i64* %guard, align 8
  br label %init_f8.loop

init_f8.loop:
  %f8.idx = phi i32 [ 0, %L0x10c0 ], [ %f8.idx.next.body, %f8.body ]
  %f8.end = icmp eq i32 %f8.idx, 49
  br i1 %f8.end, label %init_dist, label %f8.body

f8.body:
  %f8.gep = getelementptr inbounds [49 x i32], [49 x i32]* %varF8, i64 0, i64 0
  %f8.idx64 = sext i32 %f8.idx to i64
  %f8.gep.idx = getelementptr inbounds i32, i32* %f8.gep, i64 %f8.idx64
  store i32 0, i32* %f8.gep.idx, align 4
  %f8.idx.next.body = add i32 %f8.idx, 1
  br label %init_f8.loop

init_dist:
  br label %init_dist.loop

init_dist.loop:
  %d.idx = phi i32 [ 0, %init_dist ], [ %d.idx.next, %init_dist.loop ]
  %d.gep0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %d.elem = getelementptr inbounds i32, i32* %d.gep0, i32 %d.idx
  store i32 -1, i32* %d.elem, align 4
  %d.idx.next = add i32 %d.idx, 1
  %d.done = icmp eq i32 %d.idx.next, 7
  br i1 %d.done, label %after_init, label %init_dist.loop

after_init:
  %d0.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0.ptr, align 4
  %adj.base = load i32*, i32** @qword_2038, align 8
  store i32* %adj.base, i32** %adj_base.slot, align 8
  %malloc.sz = zext i32 56 to i64
  %p.raw = call noalias i8* @malloc(i64 %malloc.sz)
  %p.null = icmp eq i8* %p.raw, null
  br i1 %p.null, label %L0x1414, label %L0x1196

L0x1196:
  %p64 = bitcast i8* %p.raw to i64*
  store i64* %p64, i64** %P.slot, align 8
  %p0.gep = getelementptr inbounds i64, i64* %p64, i64 0
  store i64 0, i64* %p0.gep, align 8
  br label %L0x11B5

L0x11B5:
  br label %L0x11D3

L0x11C0:
  %rbx.carry = phi i64 [ %rbx.next.1320, %L0x1320 ]
  %rsi.carry = phi i64 [ %rsi.next.1320, %L0x1320 ]
  %P.reload.11C0 = load i64*, i64** %P.slot, align 8
  %p.idx.ptr.11C0 = getelementptr inbounds i64, i64* %P.reload.11C0, i64 %rbx.carry
  %rdx.node.11C0 = load i64, i64* %p.idx.ptr.11C0, align 8
  %rdx.mul7.11C0 = mul i64 %rdx.node.11C0, 7
  %f8.base.11C0 = getelementptr inbounds [49 x i32], [49 x i32]* %varF8, i64 0, i64 0
  %f8.elem.ptr.11C0 = getelementptr inbounds i32, i32* %f8.base.11C0, i64 %rdx.mul7.11C0
  %eax.from.11C0 = load i32, i32* %f8.elem.ptr.11C0, align 4
  br label %L0x11D3

L0x11D3:
  %rbx.curr = phi i64 [ 0, %L0x11B5 ], [ %rbx.carry, %L0x11C0 ]
  %rsi.curr = phi i64 [ 1, %L0x11B5 ], [ %rsi.carry, %L0x11C0 ]
  %eax.in = phi i32 [ 0, %L0x11B5 ], [ %eax.from.11C0, %L0x11C0 ]
  %rbx.next = add i64 %rbx.curr, 1
  %P.reload.11D3 = load i64*, i64** %P.slot, align 8
  %p.idx.ptr.11D3 = getelementptr inbounds i64, i64* %P.reload.11D3, i64 %rbx.curr
  %rdx.node = load i64, i64* %p.idx.ptr.11D3, align 8
  %out.base = getelementptr inbounds [7 x i64], [7 x i64]* %out_arr, i64 0, i64 0
  %out.store.ptr = getelementptr inbounds i64, i64* %out.base, i64 %rbx.curr
  store i64 %rdx.node, i64* %out.store.ptr, align 8
  %eax.iszero = icmp eq i32 %eax.in, 0
  br i1 %eax.iszero, label %L0x1200, label %L0x11E5

L0x11E5:
  %d0.load = load i32, i32* %d0.ptr, align 4
  %d0.is.neg1 = icmp eq i32 %d0.load, -1
  br i1 %d0.is.neg1, label %neighbor0.do, label %neighbor0.join

neighbor0.do:
  %dist.base.n0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.src.ptr.n0 = getelementptr inbounds i32, i32* %dist.base.n0, i64 %rdx.node
  %src.val.n0 = load i32, i32* %dist.src.ptr.n0, align 4
  %P.reload.n0 = load i64*, i64** %P.slot, align 8
  %p.enqueue.ptr.n0 = getelementptr inbounds i64, i64* %P.reload.n0, i64 %rsi.curr
  store i64 0, i64* %p.enqueue.ptr.n0, align 8
  %rsi.inc.n0 = add i64 %rsi.curr, 1
  %src.inc.n0 = add i32 %src.val.n0, 1
  store i32 %src.inc.n0, i32* %d0.ptr, align 4
  br label %neighbor0.join

neighbor0.join:
  %rsi.after.n0 = phi i64 [ %rsi.curr, %L0x11E5 ], [ %rsi.inc.n0, %neighbor0.do ]
  br label %L0x1200

L0x1200:
  %rsi.base.1200 = phi i64 [ %rsi.curr, %L0x11D3 ], [ %rsi.after.n0, %neighbor0.join ]
  %idx.mul7 = mul i64 %rdx.node, 7
  %idx.mul4 = mul i64 %idx.mul7, 4
  %adj.base.1200 = load i32*, i32** %adj_base.slot, align 8
  %adj.ptr.0 = getelementptr inbounds i32, i32* %adj.base.1200, i64 %idx.mul7
  %r11d = load i32, i32* %adj.ptr.0, align 4
  %r11.zero = icmp eq i32 %r11d, 0
  br i1 %r11.zero, label %L0x1240, label %neighbor1.check

neighbor1.check:
  %d1.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 1
  %d1.load = load i32, i32* %d1.ptr, align 4
  %d1.neg1 = icmp eq i32 %d1.load, -1
  br i1 %d1.neg1, label %neighbor1.do, label %L0x1240

neighbor1.do:
  %dist.base.n1 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.src.ptr.n1 = getelementptr inbounds i32, i32* %dist.base.n1, i64 %rdx.node
  %src.val.n1 = load i32, i32* %dist.src.ptr.n1, align 4
  %P.reload.n1 = load i64*, i64** %P.slot, align 8
  %p.enqueue.ptr.n1 = getelementptr inbounds i64, i64* %P.reload.n1, i64 %rsi.base.1200
  store i64 1, i64* %p.enqueue.ptr.n1, align 8
  %rsi.inc.n1 = add i64 %rsi.base.1200, 1
  %src.inc.n1 = add i32 %src.val.n1, 1
  store i32 %src.inc.n1, i32* %d1.ptr, align 4
  br label %L0x1240

L0x1240:
  %rsi.in.1240 = phi i64 [ %rsi.base.1200, %L0x1200 ], [ %rsi.base.1200, %neighbor1.check ], [ %rsi.inc.n1, %neighbor1.do ]
  %idx.plus1 = add i64 %idx.mul7, 1
  %adj.ptr.1 = getelementptr inbounds i32, i32* %adj.base.1200, i64 %idx.plus1
  %r10d = load i32, i32* %adj.ptr.1, align 4
  %r10.zero = icmp eq i32 %r10d, 0
  br i1 %r10.zero, label %L0x1270, label %neighbor2.check

neighbor2.check:
  %d2.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 2
  %d2.load = load i32, i32* %d2.ptr, align 4
  %d2.neg1 = icmp eq i32 %d2.load, -1
  br i1 %d2.neg1, label %neighbor2.do, label %L0x1270

neighbor2.do:
  %dist.base.n2 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.src.ptr.n2 = getelementptr inbounds i32, i32* %dist.base.n2, i64 %rdx.node
  %src.val.n2 = load i32, i32* %dist.src.ptr.n2, align 4
  %P.reload.n2 = load i64*, i64** %P.slot, align 8
  %p.enqueue.ptr.n2 = getelementptr inbounds i64, i64* %P.reload.n2, i64 %rsi.in.1240
  store i64 2, i64* %p.enqueue.ptr.n2, align 8
  %rsi.inc.n2 = add i64 %rsi.in.1240, 1
  %src.inc.n2 = add i32 %src.val.n2, 1
  store i32 %src.inc.n2, i32* %d2.ptr, align 4
  br label %L0x1270

L0x1270:
  %rsi.in.1270 = phi i64 [ %rsi.in.1240, %L0x1240 ], [ %rsi.inc.n2, %neighbor2.do ], [ %rsi.in.1240, %neighbor2.check ]
  %idx.plus2 = add i64 %idx.mul7, 2
  %adj.ptr.2 = getelementptr inbounds i32, i32* %adj.base.1200, i64 %idx.plus2
  %r9d = load i32, i32* %adj.ptr.2, align 4
  %r9.zero = icmp eq i32 %r9d, 0
  br i1 %r9.zero, label %L0x12A0, label %neighbor3.check

neighbor3.check:
  %d3.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 3
  %d3.load = load i32, i32* %d3.ptr, align 4
  %d3.neg1 = icmp eq i32 %d3.load, -1
  br i1 %d3.neg1, label %neighbor3.do, label %L0x12A0

neighbor3.do:
  %dist.base.n3 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.src.ptr.n3 = getelementptr inbounds i32, i32* %dist.base.n3, i64 %rdx.node
  %src.val.n3 = load i32, i32* %dist.src.ptr.n3, align 4
  %P.reload.n3 = load i64*, i64** %P.slot, align 8
  %p.enqueue.ptr.n3 = getelementptr inbounds i64, i64* %P.reload.n3, i64 %rsi.in.1270
  store i64 3, i64* %p.enqueue.ptr.n3, align 8
  %rsi.inc.n3 = add i64 %rsi.in.1270, 1
  %src.inc.n3 = add i32 %src.val.n3, 1
  store i32 %src.inc.n3, i32* %d3.ptr, align 4
  br label %L0x12A0

L0x12A0:
  %rsi.in.12A0 = phi i64 [ %rsi.in.1270, %L0x1270 ], [ %rsi.inc.n3, %neighbor3.do ], [ %rsi.in.1270, %neighbor3.check ]
  %idx.plus3 = add i64 %idx.mul7, 3
  %adj.ptr.3 = getelementptr inbounds i32, i32* %adj.base.1200, i64 %idx.plus3
  %r8d = load i32, i32* %adj.ptr.3, align 4
  %r8.zero = icmp eq i32 %r8d, 0
  br i1 %r8.zero, label %L0x12D0, label %neighbor4.check

neighbor4.check:
  %d4.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 4
  %d4.load = load i32, i32* %d4.ptr, align 4
  %d4.neg1 = icmp eq i32 %d4.load, -1
  br i1 %d4.neg1, label %neighbor4.do, label %L0x12D0

neighbor4.do:
  %dist.base.n4 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.src.ptr.n4 = getelementptr inbounds i32, i32* %dist.base.n4, i64 %rdx.node
  %src.val.n4 = load i32, i32* %dist.src.ptr.n4, align 4
  %P.reload.n4 = load i64*, i64** %P.slot, align 8
  %p.enqueue.ptr.n4 = getelementptr inbounds i64, i64* %P.reload.n4, i64 %rsi.in.12A0
  store i64 4, i64* %p.enqueue.ptr.n4, align 8
  %rsi.inc.n4 = add i64 %rsi.in.12A0, 1
  %src.inc.n4 = add i32 %src.val.n4, 1
  store i32 %src.inc.n4, i32* %d4.ptr, align 4
  br label %L0x12D0

L0x12D0:
  %rsi.in.12D0 = phi i64 [ %rsi.in.12A0, %L0x12A0 ], [ %rsi.inc.n4, %neighbor4.do ], [ %rsi.in.12A0, %neighbor4.check ]
  %idx.plus4 = add i64 %idx.mul7, 4
  %adj.ptr.4 = getelementptr inbounds i32, i32* %adj.base.1200, i64 %idx.plus4
  %ecx.adj = load i32, i32* %adj.ptr.4, align 4
  %ecx.zero = icmp eq i32 %ecx.adj, 0
  br i1 %ecx.zero, label %L0x12F8, label %neighbor5.check

neighbor5.check:
  %d5.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 5
  %d5.load = load i32, i32* %d5.ptr, align 4
  %d5.neg1 = icmp eq i32 %d5.load, -1
  br i1 %d5.neg1, label %neighbor5.do, label %L0x12F8

neighbor5.do:
  %dist.base.n5 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.src.ptr.n5 = getelementptr inbounds i32, i32* %dist.base.n5, i64 %rdx.node
  %src.val.n5 = load i32, i32* %dist.src.ptr.n5, align 4
  %P.reload.n5 = load i64*, i64** %P.slot, align 8
  %p.enqueue.ptr.n5 = getelementptr inbounds i64, i64* %P.reload.n5, i64 %rsi.in.12D0
  store i64 5, i64* %p.enqueue.ptr.n5, align 8
  %rsi.inc.n5 = add i64 %rsi.in.12D0, 1
  %src.inc.n5 = add i32 %src.val.n5, 1
  store i32 %src.inc.n5, i32* %d5.ptr, align 4
  br label %L0x12F8

L0x12F8:
  %rsi.in.12F8 = phi i64 [ %rsi.in.12D0, %L0x12D0 ], [ %rsi.inc.n5, %neighbor5.do ], [ %rsi.in.12D0, %neighbor5.check ]
  %idx.plus5 = add i64 %idx.mul7, 5
  %adj.ptr.5 = getelementptr inbounds i32, i32* %adj.base.1200, i64 %idx.plus5
  %eax.adj = load i32, i32* %adj.ptr.5, align 4
  %eax.zero2 = icmp eq i32 %eax.adj, 0
  br i1 %eax.zero2, label %L0x1320, label %neighbor6.check

neighbor6.check:
  %d6.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 6
  %d6.load = load i32, i32* %d6.ptr, align 4
  %d6.neg1 = icmp eq i32 %d6.load, -1
  br i1 %d6.neg1, label %neighbor6.do, label %L0x1320

neighbor6.do:
  %dist.base.n6 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.src.ptr.n6 = getelementptr inbounds i32, i32* %dist.base.n6, i64 %rdx.node
  %src.val.n6 = load i32, i32* %dist.src.ptr.n6, align 4
  %P.reload.n6 = load i64*, i64** %P.slot, align 8
  %p.enqueue.ptr.n6 = getelementptr inbounds i64, i64* %P.reload.n6, i64 %rsi.in.12F8
  store i64 6, i64* %p.enqueue.ptr.n6, align 8
  %rsi.inc.n6 = add i64 %rsi.in.12F8, 1
  %src.inc.n6 = add i32 %src.val.n6, 1
  store i32 %src.inc.n6, i32* %d6.ptr, align 4
  br label %L0x1320

L0x1320:
  %rsi.next.1320 = phi i64 [ %rsi.in.12F8, %L0x12F8 ], [ %rsi.inc.n6, %neighbor6.do ], [ %rsi.in.12F8, %neighbor6.check ]
  %rbx.next.1320 = phi i64 [ %rbx.next, %L0x12F8 ], [ %rbx.next, %neighbor6.do ], [ %rbx.next, %neighbor6.check ]
  %cmp.jb = icmp ult i64 %rbx.next.1320, %rsi.next.1320
  br i1 %cmp.jb, label %L0x11C0, label %L0x1329

L0x1329:
  %P.tofree = load i64*, i64** %P.slot, align 8
  %P.tofree.i8 = bitcast i64* %P.tofree to i8*
  call void @free(i8* %P.tofree.i8)
  %fmt.bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call.printf.hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.bfs.ptr, i64 0)
  br label %L0x134a

L0x134a:
  %rbx.final = phi i64 [ %rbx.next.1320, %L0x1329 ]
  %out.base.134a = getelementptr inbounds [7 x i64], [7 x i64]* %out_arr, i64 0, i64 0
  %first.elem = load i64, i64* %out.base.134a, align 8
  %cmp.rbx1 = icmp ne i64 %rbx.final, 1
  br i1 %cmp.rbx1, label %L0x13DD, label %L0x1360

L0x1360:
  %last.elem = phi i64 [ %first.elem, %L0x134a ], [ %next.elem, %L0x13F0 ]
  %fmt.zu.s = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %empty.str.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %call.print.single = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.zu.s, i64 %last.elem, i8* %empty.str.ptr)
  br label %L0x1376

L0x1376:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  br label %L0x1398

L0x1398:
  %dist.idx = phi i64 [ 0, %L0x1376 ], [ %dist.idx.next, %L0x13B4 ]
  %dist.base.loop = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist.base.loop, i64 %dist.idx
  %dist.val.i32 = load i32, i32* %dist.ptr.i, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.dist.ptr, i64 0, i64 %dist.idx, i32 %dist.val.i32)
  %dist.idx.next = add i64 %dist.idx, 1
  br label %L0x13B4

L0x13B4:
  %cmp.end = icmp ne i64 %dist.idx.next, 7
  br i1 %cmp.end, label %L0x1398, label %L0x13BA

L0x13BA:
  %canary.saved = load i64, i64* %guard, align 8
  %canary.curr = load i64, i64* %guard, align 8
  %canary.diff = icmp ne i64 %canary.saved, %canary.curr
  br i1 %canary.diff, label %L0x142E, label %epilogue

epilogue:
  ret i32 0

L0x13DD:
  %out.base.13DD = getelementptr inbounds [7 x i64], [7 x i64]* %out_arr, i64 0, i64 0
  %out.end.ptr = getelementptr inbounds i64, i64* %out.base.13DD, i64 %rbx.final
  %out.iter.ptr = getelementptr inbounds i64, i64* %out.base.13DD, i64 1
  br label %L0x13F0

L0x13F0:
  %curr.elem = phi i64 [ %first.elem, %L0x13DD ], [ %carry.elem, %L0x13F0_latch ]
  %iter.ptr.cur = phi i64* [ %out.iter.ptr, %L0x13DD ], [ %carry.ptr, %L0x13F0_latch ]
  %fmt.zu.s.loop = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %call.loop.print = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.zu.s.loop, i64 %curr.elem, i8* %space.ptr)
  %next.elem.ptr = getelementptr inbounds i64, i64* %iter.ptr.cur, i64 0
  %next.elem = load i64, i64* %next.elem.ptr, align 8
  %done.loop = icmp eq i64* %iter.ptr.cur, %out.end.ptr
  %out.iter.ptr.next = getelementptr inbounds i64, i64* %iter.ptr.cur, i64 1
  br i1 %done.loop, label %L0x1360, label %L0x13F0_latch

L0x13F0_latch:
  %carry.elem = phi i64 [ %next.elem, %L0x13F0 ]
  %carry.ptr = phi i64* [ %out.iter.ptr.next, %L0x13F0 ]
  br label %L0x13F0

L0x1414:
  %fmt.bfs.ptr.fail = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call.printf.hdr.fail = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.bfs.ptr.fail, i64 0)
  br label %L0x1376

L0x142E:
  call void @__stack_chk_fail()
  unreachable
}