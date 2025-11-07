; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@xmmword_2010 = internal constant <4 x i32> <i32 1, i32 3, i32 5, i32 7>, align 16
@xmmword_2020 = internal constant <4 x i32> <i32 2, i32 4, i32 6, i32 8>, align 16
@unk_2004 = internal constant [4 x i8] c"%d \00", align 1
@unk_2008 = internal constant [2 x i8] c"\0A\00", align 1

@__stack_chk_guard = external global i64

declare noalias i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind
declare i32 @__printf_chk(i32, i8*, ...) nounwind
declare void @__stack_chk_fail() noreturn nounwind

define i32 @main() local_unnamed_addr {
; 0x10c0:
L10c0:
  %saved_canary = alloca i64, align 8
  %arrA = alloca [10 x i32], align 16
  %arrB = alloca [10 x i32], align 16
  %ptr_malloc = alloca i32*, align 8
  %ptr_dst = alloca i32*, align 8
  %ptr_src = alloca i32*, align 8
  %var_70 = alloca i32*, align 8
  %var_7C = alloca i32, align 4
  %var_88 = alloca i64, align 8
  %r11 = alloca i64, align 8
  %r8 = alloca i64, align 8
  %rax = alloca i64, align 8
  %rbx = alloca i64, align 8
  %rcx = alloca i64, align 8
  %rdx = alloca i64, align 8
  %rsi = alloca i64, align 8
  %rdi = alloca i64, align 8
  %r9 = alloca i64, align 8
  %r10 = alloca i64, align 8
  %r12 = alloca i64, align 8
  %r13 = alloca i64, align 8
  %r14 = alloca i64, align 8
  %r15 = alloca i64, align 8
  %rbp = alloca i64, align 8
  %can0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %can0, i64* %saved_canary, align 8
  %arrA.v.ptr = bitcast [10 x i32]* %arrA to <4 x i32>*
  %vA = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %vA, <4 x i32>* %arrA.v.ptr, align 16
  %arrB.v.ptr = bitcast [10 x i32]* %arrB to <4 x i32>*
  %vB = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vB, <4 x i32>* %arrB.v.ptr, align 16
  %size = zext i32 40 to i64
  %m = call noalias i8* @malloc(i64 %size)
  %m.int = ptrtoint i8* %m to i64
  %m.isnull = icmp eq i8* %m, null
  br i1 %m.isnull, label %L142E, label %L1118

; 0x1118 falls in after malloc success
L1118:
  %arrA.i8 = bitcast [10 x i32]* %arrA to i8*
  %arrB.i8 = bitcast [10 x i32]* %arrB to i8*
  %arrA.i32p = bitcast i8* %arrA.i8 to i32*
  %m.i32p = bitcast i8* %m to i32*
  store i32 4, i32* %var_7C, align 4
  store i32* %m.i32p, i32** %ptr_malloc, align 8
  store i32* %m.i32p, i32** %ptr_dst, align 8
  store i32* %arrA.i32p, i32** %var_70, align 8
  store i64 %m.int, i64* %rsi, align 8
  %arrA.int = ptrtoint i8* %arrA.i8 to i64
  store i64 %arrA.int, i64* %rbx, align 8
  store i64 %arrA.int, i64* %rcx, align 8
  store i64 1, i64* %rdi, align 8
  store i64 0, i64* %rax, align 8
  store i64 1, i64* %r11, align 8
  %rdi2 = add i64 1, 1
  store i64 %rdi2, i64* %rdi, align 8
  store i64 0, i64* %r8, align 8
  store i64 %rdi2, i64* %var_88, align 8
  br label %L1140

; 0x1140:
L1140:
  %r11.v = load i64, i64* %r11, align 8
  %rdi.v = load i64, i64* %rdi, align 8
  %r8.v = load i64, i64* %r8, align 8
  %rdi.add = add i64 %rdi.v, %rdi.v
  store i64 %rdi.add, i64* %rdi, align 8
  store i64 %rdi.add, i64* %var_88, align 8
  br label %L128A

; 0x1158:
L1158:
  %rcx.p = load i64, i64* %rcx, align 8
  %r12.p = load i64, i64* %r12, align 8
  %r12.idx = lshr i64 %r12.p, 0
  %src.p.i32 = inttoptr i64 %rcx.p to i32*
  %gep.src.r12 = getelementptr inbounds i32, i32* %src.p.i32, i64 %r12.idx
  %r9.val = load i32, i32* %gep.src.r12, align 4
  %rax.v = load i64, i64* %rax, align 8
  %rdi.next = add i64 %rax.v, 1
  %rsi.p = load i64, i64* %rsi, align 8
  %dst.p.i32 = inttoptr i64 %rsi.p to i32*
  %gep.dst.rax = getelementptr inbounds i32, i32* %dst.p.i32, i64 %rax.v
  store i32 %r9.val, i32* %gep.dst.rax, align 4
  %rdx.v = load i64, i64* %rdx, align 8
  %cmp_rdx_rdi = icmp eq i64 %rdx.v, %rdi.next
  br i1 %cmp_rdx_rdi, label %L1280, label %L116D

; 0x116D:
L116D:
  %r12.inc = add i64 %r12.p, 1
  store i64 %r12.inc, i64* %r9, align 8
  %r10.v = load i64, i64* %r10, align 8
  %rbx.v = load i64, i64* %rbx, align 8
  %cmp_r10_rbx = icmp ult i64 %r10.v, %rbx.v
  br i1 %cmp_r10_rbx, label %L143A, label %L117B

; 0x117B:
L117B:
  store i64 %rdx.v, i64* %rbx, align 8
  %rax.v.2 = load i64, i64* %rax, align 8
  %r13.tmp = add i64 %rax.v.2, 2
  store i64 %r13.tmp, i64* %r13, align 8
  %rbx.diff = sub i64 %rdx.v, %rdi.next
  %r10.tmp = add i64 %rbx.diff, -1
  store i64 %r10.tmp, i64* %r10, align 8
  %cmp_r10_2 = icmp ule i64 %r10.tmp, 2
  br i1 %cmp_r10_2, label %L13A0, label %L1193

; 0x1193:
L1193:
  %rdx.cur = load i64, i64* %rdx, align 8
  %r13.cur = load i64, i64* %r13, align 8
  %cmp_rdx_r13_jb = icmp ult i64 %rdx.cur, %r13.cur
  br i1 %cmp_rdx_r13_jb, label %L13A0, label %L119C

; 0x119C:
L119C:
  %rdi.cur = load i64, i64* %rdi, align 8
  %r10.scale = mul i64 %rdi.cur, 4
  %r12.cur = load i64, i64* %r12, align 8
  %r12.mul = mul i64 %r12.cur, 4
  %r12.scale = add i64 %r12.mul, 8
  %rsi.cur = load i64, i64* %rsi, align 8
  %rbp.ptr = add i64 %rsi.cur, %r10.scale
  %rcx.cur = load i64, i64* %rcx, align 8
  %r15.ptr = add i64 %rcx.cur, %r12.scale
  %r14.tmp = sub i64 %rbp.ptr, %r15.ptr
  %cmp_r14_8 = icmp ugt i64 %r14.tmp, 8
  br i1 %cmp_r14_8, label %L12F0, label %L11C4

; 0x11C4:
L11C4:
  %r9.cur = load i64, i64* %r9, align 8
  %rdi.cur.b = load i64, i64* %rdi, align 8
  %r10.scale.b = mul i64 %rdi.cur.b, 4
  %rcx.cur.b = load i64, i64* %rcx, align 8
  %src.i32.b = inttoptr i64 %rcx.cur.b to i32*
  %idxA = mul i64 %r9.cur, 4
  %idxA.el = lshr i64 %idxA, 2
  %v1.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idxA.el
  %v1.val = load i32, i32* %v1.ptr, align 4
  %rsi.cur.b = load i64, i64* %rsi, align 8
  %dst.i32.b = inttoptr i64 %rsi.cur.b to i32*
  %dst.i8.b = bitcast i32* %dst.i32.b to i8*
  %dst.off.ptr = getelementptr inbounds i8, i8* %dst.i8.b, i64 %r10.scale.b
  %dst.off.i32 = bitcast i8* %dst.off.ptr to i32*
  store i32 %v1.val, i32* %dst.off.i32, align 4
  %r13.now = load i64, i64* %r13, align 8
  %rdx.now = load i64, i64* %rdx, align 8
  %cmp_r13_rdx = icmp uge i64 %r13.now, %rdx.now
  br i1 %cmp_r13_rdx, label %L1280, label %L11DD

; 0x11DD:
L11DD:
  %idx.next1 = add i64 %idxA.el, 1
  %v2.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idx.next1
  %v2.val = load i32, i32* %v2.ptr, align 4
  %dst.off1 = getelementptr inbounds i32, i32* %dst.off.i32, i64 1
  store i32 %v2.val, i32* %dst.off1, align 4
  %rax.cur = load i64, i64* %rax, align 8
  %r9.ax3 = add i64 %rax.cur, 3
  %cmp_r9_rdx1 = icmp uge i64 %r9.ax3, %rdx.now
  br i1 %cmp_r9_rdx1, label %L1280, label %L11F4

; 0x11F4:
L11F4:
  %idx.next2 = add i64 %idxA.el, 2
  %v3.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idx.next2
  %v3.val = load i32, i32* %v3.ptr, align 4
  %dst.off2 = getelementptr inbounds i32, i32* %dst.off.i32, i64 2
  store i32 %v3.val, i32* %dst.off2, align 4
  %rax.cur2 = load i64, i64* %rax, align 8
  %ax4 = add i64 %rax.cur2, 4
  %cmp4 = icmp uge i64 %ax4, %rdx.now
  br i1 %cmp4, label %L1280, label %L1207

; 0x1207:
L1207:
  %idx.next3 = add i64 %idxA.el, 3
  %v4.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idx.next3
  %v4.val = load i32, i32* %v4.ptr, align 4
  %dst.off3 = getelementptr inbounds i32, i32* %dst.off.i32, i64 3
  store i32 %v4.val, i32* %dst.off3, align 4
  %rax.cur3 = load i64, i64* %rax, align 8
  %ax5 = add i64 %rax.cur3, 5
  %cmp5 = icmp uge i64 %ax5, %rdx.now
  br i1 %cmp5, label %L1280, label %L121A

; 0x121A:
L121A:
  %idx.next4 = add i64 %idxA.el, 4
  %v5.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idx.next4
  %v5.val = load i32, i32* %v5.ptr, align 4
  %dst.off4 = getelementptr inbounds i32, i32* %dst.off.i32, i64 4
  store i32 %v5.val, i32* %dst.off4, align 4
  %rax.cur4 = load i64, i64* %rax, align 8
  %ax6 = add i64 %rax.cur4, 6
  %cmp6 = icmp uge i64 %ax6, %rdx.now
  br i1 %cmp6, label %L1280, label %L122D

; 0x122D:
L122D:
  %idx.next5 = add i64 %idxA.el, 5
  %v6.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idx.next5
  %v6.val = load i32, i32* %v6.ptr, align 4
  %dst.off5 = getelementptr inbounds i32, i32* %dst.off.i32, i64 5
  store i32 %v6.val, i32* %dst.off5, align 4
  %rax.cur5 = load i64, i64* %rax, align 8
  %ax7 = add i64 %rax.cur5, 7
  %cmp7 = icmp uge i64 %ax7, %rdx.now
  br i1 %cmp7, label %L1280, label %L1240

; 0x1240:
L1240:
  %idx.next6 = add i64 %idxA.el, 6
  %v7.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idx.next6
  %v7.val = load i32, i32* %v7.ptr, align 4
  %dst.off6 = getelementptr inbounds i32, i32* %dst.off.i32, i64 6
  store i32 %v7.val, i32* %dst.off6, align 4
  %rax.add8 = add i64 %rax.cur5, 8
  store i64 %rax.add8, i64* %rax, align 8
  %cmp8 = icmp uge i64 %rax.add8, %rdx.now
  br i1 %cmp8, label %L1280, label %L1253

; 0x1253:
L1253:
  %idx.next7 = add i64 %idxA.el, 7
  %v8.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idx.next7
  %v8.val = load i32, i32* %v8.ptr, align 4
  %dst.off7 = getelementptr inbounds i32, i32* %dst.off.i32, i64 7
  store i32 %v8.val, i32* %dst.off7, align 4
  %rdi.cur.c = load i64, i64* %rdi, align 8
  %al.z = icmp eq i64 %rdi.cur.c, 1
  %al.n = zext i1 %al.z to i64
  %neg.al = sub i64 0, %al.n
  %tmp.add10 = add i64 %neg.al, 10
  %cmp10 = icmp uge i64 %tmp.add10, %rdx.now
  br i1 %cmp10, label %L1280, label %L1271

; 0x1271:
L1271:
  %idx.next8 = add i64 %idxA.el, 8
  %v9.ptr = getelementptr inbounds i32, i32* %src.i32.b, i64 %idx.next8
  %v9.val = load i32, i32* %v9.ptr, align 4
  %dst.off8 = getelementptr inbounds i32, i32* %dst.off.i32, i64 9
  store i32 %v9.val, i32* %dst.off8, align 4
  br label %L1280

; 0x1280:
L1280:
  %r8.loop = load i64, i64* %r8, align 8
  %cond_end = icmp ugt i64 %r8.loop, 9
  br i1 %cond_end, label %L1380, label %L128A

; 0x128A:
L128A:
  %r11.loop = load i64, i64* %r11, align 8
  %r8.loop2 = load i64, i64* %r8, align 8
  %rdx.calc = add i64 %r11.loop, %r8.loop2
  %rbx.init = zext i32 10 to i64
  %rax.init = load i64, i64* %r8, align 8
  %cmp_be1 = icmp ule i64 %rdx.calc, %rbx.init
  %r8.new = add i64 %rdx.calc, %r11.loop
  %r10.set = add i64 %rax.init, 0
  %rbx.sel = select i1 %cmp_be1, i64 %rdx.calc, i64 %rbx.init
  %rdx.base = zext i32 10 to i64
  %cmp_be2 = icmp ule i64 %r8.new, %rdx.base
  %rdx.sel = select i1 %cmp_be2, i64 %r8.new, i64 %rdx.base
  store i64 %rbx.sel, i64* %r12, align 8
  store i64 %rdx.sel, i64* %rdx, align 8
  %cmp_rax_rdx = icmp uge i64 %rax.init, %rdx.sel
  br i1 %cmp_rax_rdx, label %L1280, label %L12B8

; 0x12B8:
L12B8:
  %r10.cur = load i64, i64* %r10, align 8
  %rbx.bound = load i64, i64* %r12, align 8
  %cmp_r10_rbx2 = icmp uge i64 %r10.cur, %rbx.bound
  br i1 %cmp_r10_rbx2, label %L1158, label %L12C1

; 0x12C1:
L12C1:
  %rcx.s = load i64, i64* %rcx, align 8
  %r10.s = load i64, i64* %r10, align 8
  %srcp = inttoptr i64 %rcx.s to i32*
  %v.s.ptr = getelementptr inbounds i32, i32* %srcp, i64 %r10.s
  %edi.val = load i32, i32* %v.s.ptr, align 4
  %r12.s = load i64, i64* %r12, align 8
  %rdx.s = load i64, i64* %rdx, align 8
  %cmp_r12_rdx = icmp uge i64 %r12.s, %rdx.s
  br i1 %cmp_r12_rdx, label %L12D7, label %L12CA

; 0x12CA:
L12CA:
  %r12.s2 = load i64, i64* %r12, align 8
  %val.ptr2 = getelementptr inbounds i32, i32* %srcp, i64 %r12.s2
  %r9d.val2 = load i32, i32* %val.ptr2, align 4
  %cmpjl = icmp slt i32 %r9d.val2, %edi.val
  br i1 %cmpjl, label %L1158, label %L12D7

; 0x12D7:
L12D7:
  %rsi.s = load i64, i64* %rsi, align 8
  %rax.s = load i64, i64* %rax, align 8
  %dstp = inttoptr i64 %rsi.s to i32*
  %dst.elt = getelementptr inbounds i32, i32* %dstp, i64 %rax.s
  store i32 %edi.val, i32* %dst.elt, align 4
  %rax.inc = add i64 %rax.s, 1
  store i64 %rax.inc, i64* %rax, align 8
  %rdx.s2 = load i64, i64* %rdx, align 8
  %cmp_end = icmp eq i64 %rdx.s2, %rax.inc
  br i1 %cmp_end, label %L1280, label %L12E3

; 0x12E3:
L12E3:
  %r10.inc = add i64 %r10.s, 1
  store i64 %r10.inc, i64* %r10, align 8
  br label %L12B8

; 0x12F0:
L12F0:
  %rcx.v = load i64, i64* %rcx, align 8
  %r12.v = load i64, i64* %r12, align 8
  %r12.mul.v = mul i64 %r12.v, 4
  %r12.addm.v = add i64 %r12.mul.v, -4
  %base.src = add i64 %rcx.v, %r12.addm.v
  %rbx.len = load i64, i64* %rbx, align 8
  %rbp.v = load i64, i64* %rsi, align 8
  %rdi.v2 = load i64, i64* %rdi, align 8
  %dst.off.v = mul i64 %rdi.v2, 4
  %dst.ptr.v = add i64 %rbp.v, %dst.off.v
  %src.vec.ptr = inttoptr i64 %base.src to <4 x i32>*
  %dst.vec.ptr = inttoptr i64 %dst.ptr.v to <4 x i32>*
  %vec1 = load <4 x i32>, <4 x i32>* %src.vec.ptr, align 1
  store <4 x i32> %vec1, <4 x i32>* %dst.vec.ptr, align 1
  %rax.v3 = load i64, i64* %rax, align 8
  %rbx.masked = and i64 %rbx.len, -4
  %r9.cur.v = load i64, i64* %r9, align 8
  %r9.add = add i64 %r9.cur.v, %rbx.masked
  %rax.add = add i64 %rbx.masked, %rdi.v2
  store i64 %r9.add, i64* %r9, align 8
  store i64 %rax.add, i64* %rax, align 8
  %rem = and i64 %rbx.len, 3
  %rem.zero = icmp eq i64 %rem, 0
  br i1 %rem.zero, label %L1280, label %L1329

; 0x1313:
L1313:
  br label %L1329

; 0x1329:
L1329:
  %rcx.t = load i64, i64* %rcx, align 8
  %r9.t = load i64, i64* %r9, align 8
  %srcp.t = inttoptr i64 %rcx.t to i32*
  %src.idx.t = getelementptr inbounds i32, i32* %srcp.t, i64 %r9.t
  %v.t = load i32, i32* %src.idx.t, align 4
  %rsi.t = load i64, i64* %rsi, align 8
  %rax.t = load i64, i64* %rax, align 8
  %dstp.t = inttoptr i64 %rsi.t to i32*
  %dst.idx.t = getelementptr inbounds i32, i32* %dstp.t, i64 %rax.t
  store i32 %v.t, i32* %dst.idx.t, align 4
  %rax.t1 = add i64 %rax.t, 1
  %rdx.t = load i64, i64* %rdx, align 8
  %c1 = icmp uge i64 %rax.t1, %rdx.t
  br i1 %c1, label %L1280, label %L134E

; 0x134E:
L134E:
  %v.t2p = getelementptr inbounds i32, i32* %src.idx.t, i64 1
  %v.t2 = load i32, i32* %v.t2p, align 4
  %dst.off.t2 = getelementptr inbounds i32, i32* %dst.idx.t, i64 1
  store i32 %v.t2, i32* %dst.off.t2, align 4
  %rax.t2 = add i64 %rax.t, 2
  %c2 = icmp uge i64 %rax.t2, %rdx.t
  br i1 %c2, label %L1280, label %L1365

; 0x1365:
L1365:
  %v.t3p = getelementptr inbounds i32, i32* %src.idx.t, i64 2
  %v.t3 = load i32, i32* %v.t3p, align 4
  %dst.off.t3 = getelementptr inbounds i32, i32* %dst.idx.t, i64 2
  store i32 %v.t3, i32* %dst.off.t3, align 4
  %r8.chk = load i64, i64* %r8, align 8
  %c3 = icmp ule i64 %r8.chk, 9
  br i1 %c3, label %L128A, label %L1378

; 0x1378:
L1378:
  br label %L1380

; 0x1380:
L1380:
  %var7C.v = load i32, i32* %var_7C, align 4
  %dec = add i32 %var7C.v, -1
  store i32 %dec, i32* %var_7C, align 4
  %rdi.load = load i64, i64* %var_88, align 8
  store i64 %rdi.load, i64* %rdi, align 8
  %is_zero = icmp eq i32 %dec, 0
  br i1 %is_zero, label %L13AD, label %L138B

; 0x138B:
L138B:
  %rdx.swap = load i64, i64* %rcx, align 8
  %rcx.new = load i64, i64* %rsi, align 8
  store i64 %rcx.new, i64* %rcx, align 8
  store i64 %rdx.swap, i64* %rsi, align 8
  br label %L1140

; 0x13A0:
L13A0:
  %rdi.cur2 = load i64, i64* %rdi, align 8
  %r10.scale2 = mul i64 %rdi.cur2, 4
  store i64 %r10.scale2, i64* %r10, align 8
  br label %L11C4

; 0x13AD:
L13AD:
  %arrA.base = load i32*, i32** %var_70, align 8
  %heap.ptr = load i32*, i32** %ptr_malloc, align 8
  %rsi.curp = load i64, i64* %rsi, align 8
  %rsi.asptr = inttoptr i64 %rsi.curp to i32*
  %rbx.is = ptrtoint i32* %arrA.base to i64
  %rsi.is = ptrtoint i32* %rsi.asptr to i64
  %cmp.eq.buf = icmp eq i64 %rsi.is, %rbx.is
  br i1 %cmp.eq.buf, label %L13C6, label %L13BC

; 0x13BC:
L13BC:
  %cnt = zext i32 10 to i64
  %d.dst = bitcast i32* %arrA.base to i8*
  %d.src = bitcast i32* %rsi.asptr to i8*
  %bytes = mul i64 %cnt, 4
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %d.dst, i8* %d.src, i64 %bytes, i1 false)
  br label %L13C6

; 0x13C6:
L13C6:
  %heap.ptr.i8 = bitcast i32* %heap.ptr to i8*
  call void @free(i8* %heap.ptr.i8)
  br label %L13CE

; 0x13CE:
L13CE:
  %r12.loopb = getelementptr inbounds [10 x i32], [10 x i32]* %arrA, i64 0, i64 10
  %r12.end = bitcast i32* %r12.loopb to i8*
  %r12.base = bitcast [10 x i32]* %arrA to i8*
  %rbp.fmt = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %rbx.print = bitcast [10 x i32]* %arrA to i32*
  br label %L13E0

; 0x13E0:
L13E0:
  %cur.ptr = phi i32* [ %rbx.print, %L13CE ], [ %next.ptr, %L13E0 ]
  %val = load i32, i32* %cur.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %chk = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %next.ptr = getelementptr inbounds i32, i32* %cur.ptr, i64 1
  %cur.i8 = bitcast i32* %next.ptr to i8*
  %end.i8 = getelementptr inbounds [10 x i32], [10 x i32]* %arrA, i64 0, i64 10
  %end.i8cast = bitcast i32* %end.i8 to i8*
  %cmp.loop = icmp ne i8* %cur.i8, %end.i8cast
  br i1 %cmp.loop, label %L13E0, label %L13FA

; 0x13FA:
L13FA:
  %fmt2 = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %chk2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2)
  %can.end = load i64, i64* %saved_canary, align 8
  %can.now = load i64, i64* @__stack_chk_guard, align 8
  %can.diff = sub i64 %can.end, %can.now
  %can.bad = icmp ne i64 %can.diff, 0
  br i1 %can.bad, label %L1435, label %L141D

; 0x141D:
L141D:
  %ret0 = add i32 0, 0
  ret i32 %ret0

; 0x142E:
L142E:
  %arrA.ptr2 = bitcast [10 x i32]* %arrA to i32*
  br label %L13CE

; 0x1435:
L1435:
  call void @__stack_chk_fail()
  unreachable

; 0x143A:
L143A:
  %r9.swap = load i64, i64* %r9, align 8
  store i64 %r9.swap, i64* %r12, align 8
  store i64 %rdi.next, i64* %rax, align 8
  br label %L12B8
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1) nounwind