; ModuleID = 'recovered_from_asm_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1
@__stack_chk_guard = external global i64, align 8

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() {
loc_1080:
  %arr = alloca [10 x i32], align 16
  %rbp.slot = alloca i8*, align 8
  %rbx.slot = alloca i8*, align 8
  %rsi.slot = alloca i8*, align 8
  %rdi.slot = alloca i8*, align 8
  %rax.slot = alloca i8*, align 8
  %rcx.slot = alloca i64, align 8
  %r12.slot = alloca i8*, align 8
  %edx.slot = alloca i32, align 4
  %r8d.slot = alloca i32, align 4
  %canary.slot = alloca i64, align 8
  %base.i32p = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %base.i8p = bitcast i32* %base.i32p to i8*
  %g0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g0, i64* %canary.slot, align 8
  store i64 0, i64* %rcx.slot, align 8
  store i8* %base.i8p, i8** %rbp.slot, align 8
  store i8* %base.i8p, i8** %rbx.slot, align 8
  store i8* %base.i8p, i8** %rsi.slot, align 8
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %vec0 = bitcast i32* %base.i32p to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %vec0, align 16
  %p16 = getelementptr inbounds i8, i8* %base.i8p, i64 16
  %vec1 = bitcast i8* %p16 to <4 x i32>*
  %v2 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v2, <4 x i32>* %vec1, align 16
  %p8.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8.i32, align 4
  br label %loc_10D0

loc_10D0:
  %rsi.0 = load i8*, i8** %rsi.slot, align 8
  %rsi.plus4 = getelementptr inbounds i8, i8* %rsi.0, i64 4
  %rsi.plus4.i32p = bitcast i8* %rsi.plus4 to i32*
  %edx.1 = load i32, i32* %rsi.plus4.i32p, align 4
  store i32 %edx.1, i32* %edx.slot, align 4
  %rsi.i32p = bitcast i8* %rsi.0 to i32*
  %r8d.1 = load i32, i32* %rsi.i32p, align 4
  store i32 %r8d.1, i32* %r8d.slot, align 4
  store i8* %rsi.plus4, i8** %rdi.slot, align 8
  store i8* %rsi.0, i8** %rax.slot, align 8
  %cmp.10d0 = icmp sle i32 %r8d.1, %edx.1
  br i1 %cmp.10d0, label %loc_12C3, label %bb_10E6

bb_10E6:
  store i32 %r8d.1, i32* %rsi.plus4.i32p, align 4
  %rcx.cur.10e6 = load i64, i64* %rcx.slot, align 8
  %test.rcx.zero = icmp eq i64 %rcx.cur.10e6, 0
  br i1 %test.rcx.zero, label %loc_1234, label %loc_10F3

loc_12C3:
  %rdi.v.12c3 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.v.12c3, i8** %rsi.slot, align 8
  store i8* %rdi.v.12c3, i8** %rax.slot, align 8
  br label %loc_11C6

loc_1234:
  %edx.v.1234 = load i32, i32* %edx.slot, align 4
  store i32 %edx.v.1234, i32* %base.i32p, align 4
  %rdi.v.1234 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1234 = getelementptr inbounds i8, i8* %rdi.v.1234, i64 4
  %rdi.plus4.1234.i32p = bitcast i8* %rdi.plus4.1234 to i32*
  %edx.n.1234 = load i32, i32* %rdi.plus4.1234.i32p, align 4
  store i32 %edx.n.1234, i32* %edx.slot, align 4
  %rsi.v.1234 = load i8*, i8** %rsi.slot, align 8
  %rsi.plus8.1234 = getelementptr inbounds i8, i8* %rsi.v.1234, i64 8
  store i8* %rsi.plus8.1234, i8** %rsi.slot, align 8
  store i8* %rdi.v.1234, i8** %rax.slot, align 8
  %rdi.i32p.1234 = bitcast i8* %rdi.v.1234 to i32*
  %ecx.tmp.1234 = load i32, i32* %rdi.i32p.1234, align 4
  %cmp.1234 = icmp sle i32 %ecx.tmp.1234, %edx.n.1234
  br i1 %cmp.1234, label %loc_13CC, label %bb_124B

bb_124B:
  store i32 %ecx.tmp.1234, i32* %rdi.plus4.1234.i32p, align 4
  %rdi.swap = load i8*, i8** %rdi.slot, align 8
  %rsi.swap = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.swap, i8** %rdi.slot, align 8
  store i8* %rdi.swap, i8** %rsi.slot, align 8
  store i64 1, i64* %rcx.slot, align 8
  br label %loc_10F3

loc_13CC:
  %rsi.to.13cc = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.to.13cc, i8** %rax.slot, align 8
  store i64 1, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_10F3:
  %rax.v.10f3 = load i8*, i8** %rax.slot, align 8
  %rax.m4.10f3 = getelementptr inbounds i8, i8* %rax.v.10f3, i64 -4
  %rax.m4.10f3.i32p = bitcast i8* %rax.m4.10f3 to i32*
  %r8d.10f3 = load i32, i32* %rax.m4.10f3.i32p, align 4
  %edx.cur.10f3 = load i32, i32* %edx.slot, align 4
  %cmp.10f3 = icmp sle i32 %r8d.10f3, %edx.cur.10f3
  br i1 %cmp.10f3, label %loc_125B, label %bb_1100

bb_1100:
  %rax.i32p.1100 = bitcast i8* %rax.v.10f3 to i32*
  store i32 %r8d.10f3, i32* %rax.i32p.1100, align 4
  %rcx.cur.1100 = load i64, i64* %rcx.slot, align 8
  %cmp.rcx.eq1 = icmp eq i64 %rcx.cur.1100, 1
  br i1 %cmp.rcx.eq1, label %loc_1263, label %bb_110D

bb_110D:
  %rax.m8 = getelementptr inbounds i8, i8* %rax.v.10f3, i64 -8
  %rax.m8.i32p = bitcast i8* %rax.m8 to i32*
  %r8d.110d = load i32, i32* %rax.m8.i32p, align 4
  %edx.cur.110d = load i32, i32* %edx.slot, align 4
  %cmp.110d = icmp sle i32 %r8d.110d, %edx.cur.110d
  br i1 %cmp.110d, label %loc_1296, label %bb_111A

bb_111A:
  %rax.m4.i32p.111a = bitcast i8* %rax.m4.10f3 to i32*
  store i32 %r8d.110d, i32* %rax.m4.i32p.111a, align 4
  %rcx.cur.111a = load i64, i64* %rcx.slot, align 8
  %cmp.rcx.eq2 = icmp eq i64 %rcx.cur.111a, 2
  br i1 %cmp.rcx.eq2, label %loc_12A2, label %bb_1128

bb_1128:
  %rax.m12 = getelementptr inbounds i8, i8* %rax.v.10f3, i64 -12
  %rax.m12.i32p = bitcast i8* %rax.m12 to i32*
  %r8d.1128 = load i32, i32* %rax.m12.i32p, align 4
  %edx.cur.1128 = load i32, i32* %edx.slot, align 4
  %cmp.1128 = icmp sle i32 %r8d.1128, %edx.cur.1128
  br i1 %cmp.1128, label %loc_12CE, label %bb_1135

bb_1135:
  store i32 %r8d.1128, i32* %rax.m8.i32p, align 4
  %rcx.cur.1135 = load i64, i64* %rcx.slot, align 8
  %cmp.rcx.eq3 = icmp eq i64 %rcx.cur.1135, 3
  br i1 %cmp.rcx.eq3, label %loc_12DA, label %bb_1143

bb_1143:
  %rax.m16 = getelementptr inbounds i8, i8* %rax.v.10f3, i64 -16
  %rax.m16.i32p = bitcast i8* %rax.m16 to i32*
  %r8d.1143 = load i32, i32* %rax.m16.i32p, align 4
  %edx.cur.1143 = load i32, i32* %edx.slot, align 4
  %cmp.1143 = icmp sle i32 %r8d.1143, %edx.cur.1143
  br i1 %cmp.1143, label %loc_12FB, label %bb_1150

bb_1150:
  store i32 %r8d.1143, i32* %rax.m12.i32p, align 4
  %rcx.cur.1150 = load i64, i64* %rcx.slot, align 8
  %cmp.rcx.eq4 = icmp eq i64 %rcx.cur.1150, 4
  br i1 %cmp.rcx.eq4, label %loc_1307, label %bb_115E

bb_115E:
  %rax.m20 = getelementptr inbounds i8, i8* %rax.v.10f3, i64 -20
  %rax.m20.i32p = bitcast i8* %rax.m20 to i32*
  %r8d.115e = load i32, i32* %rax.m20.i32p, align 4
  %edx.cur.115e = load i32, i32* %edx.slot, align 4
  %cmp.115e = icmp sle i32 %r8d.115e, %edx.cur.115e
  br i1 %cmp.115e, label %loc_132B, label %bb_116B

bb_116B:
  store i32 %r8d.115e, i32* %rax.m16.i32p, align 4
  %rcx.cur.116b = load i64, i64* %rcx.slot, align 8
  %cmp.rcx.eq5 = icmp eq i64 %rcx.cur.116b, 5
  br i1 %cmp.rcx.eq5, label %loc_1337, label %bb_1179

bb_1179:
  %rax.m24 = getelementptr inbounds i8, i8* %rax.v.10f3, i64 -24
  %rax.m24.i32p = bitcast i8* %rax.m24 to i32*
  %r8d.1179 = load i32, i32* %rax.m24.i32p, align 4
  %edx.cur.1179 = load i32, i32* %edx.slot, align 4
  %cmp.1179 = icmp sle i32 %r8d.1179, %edx.cur.1179
  br i1 %cmp.1179, label %loc_135B, label %bb_1186

bb_1186:
  store i32 %r8d.1179, i32* %rax.m20.i32p, align 4
  %rcx.cur.1186 = load i64, i64* %rcx.slot, align 8
  %cmp.rcx.eq6 = icmp eq i64 %rcx.cur.1186, 6
  br i1 %cmp.rcx.eq6, label %loc_1367, label %bb_1194

bb_1194:
  %rax.m28 = getelementptr inbounds i8, i8* %rax.v.10f3, i64 -28
  %rax.m28.i32p = bitcast i8* %rax.m28 to i32*
  %r8d.1194 = load i32, i32* %rax.m28.i32p, align 4
  %edx.cur.1194 = load i32, i32* %edx.slot, align 4
  %cmp.1194 = icmp sle i32 %r8d.1194, %edx.cur.1194
  br i1 %cmp.1194, label %loc_1387, label %bb_11A1

bb_11A1:
  store i32 %r8d.1194, i32* %rax.m24.i32p, align 4
  %rcx.cur.11a1 = load i64, i64* %rcx.slot, align 8
  %cmp.rcx.eq7 = icmp eq i64 %rcx.cur.11a1, 7
  br i1 %cmp.rcx.eq7, label %loc_1393, label %bb_11AF

bb_11AF:
  %rax.m32 = getelementptr inbounds i8, i8* %rax.v.10f3, i64 -32
  %rax.m32.i32p = bitcast i8* %rax.m32 to i32*
  %r8d.11af = load i32, i32* %rax.m32.i32p, align 4
  %edx.cur.11af = load i32, i32* %edx.slot, align 4
  %cmp.11af = icmp sle i32 %r8d.11af, %edx.cur.11af
  br i1 %cmp.11af, label %loc_13B3, label %bb_11BC

bb_11BC:
  store i32 %r8d.11af, i32* %rax.m28.i32p, align 4
  %rdi.to.11c0 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.11c0, i8** %rsi.slot, align 8
  %rbp.val.11c3 = load i8*, i8** %rbp.slot, align 8
  store i8* %rbp.val.11c3, i8** %rax.slot, align 8
  br label %loc_11C6

loc_125B:
  %rdi.to.125b = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.125b, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1263:
  %edx.v.1263 = load i32, i32* %edx.slot, align 4
  store i32 %edx.v.1263, i32* %base.i32p, align 4
  %rdi.v.1263 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1263 = getelementptr inbounds i8, i8* %rdi.v.1263, i64 4
  %rdi.plus4.1263.i32p = bitcast i8* %rdi.plus4.1263 to i32*
  %edx.n.1263 = load i32, i32* %rdi.plus4.1263.i32p, align 4
  store i32 %edx.n.1263, i32* %edx.slot, align 4
  %rsi.new.1263 = getelementptr inbounds i8, i8* %rdi.v.1263, i64 4
  store i8* %rsi.new.1263, i8** %rsi.slot, align 8
  store i8* %rdi.v.1263, i8** %rax.slot, align 8
  %rdi.i32p.1263 = bitcast i8* %rdi.v.1263 to i32*
  %ecx.tmp.1263 = load i32, i32* %rdi.i32p.1263, align 4
  %cmp.1263 = icmp sge i32 %ecx.tmp.1263, %edx.n.1263
  br i1 %cmp.1263, label %loc_13BF, label %bb_127A

bb_127A:
  store i32 %ecx.tmp.1263, i32* %rdi.plus4.1263.i32p, align 4
  store i64 2, i64* %rcx.slot, align 8
  br label %loc_1288

loc_1288:
  %rsi.swap.1288 = load i8*, i8** %rsi.slot, align 8
  %rdi.swap.1288 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.swap.1288, i8** %rsi.slot, align 8
  store i8* %rsi.swap.1288, i8** %rdi.slot, align 8
  br label %loc_10F3

loc_1296:
  %rsi.v.1296 = load i8*, i8** %rsi.slot, align 8
  %rax.new.1296 = getelementptr inbounds i8, i8* %rsi.v.1296, i64 -4
  store i8* %rax.new.1296, i8** %rax.slot, align 8
  %rdi.to.1296 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.1296, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_12A2:
  %edx.v.12a2 = load i32, i32* %edx.slot, align 4
  store i32 %edx.v.12a2, i32* %base.i32p, align 4
  %rdi.v.12a2 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.12a2 = getelementptr inbounds i8, i8* %rdi.v.12a2, i64 4
  %rdi.plus4.12a2.i32p = bitcast i8* %rdi.plus4.12a2 to i32*
  %edx.n.12a2 = load i32, i32* %rdi.plus4.12a2.i32p, align 4
  store i32 %edx.n.12a2, i32* %edx.slot, align 4
  %rsi.new.12a2 = getelementptr inbounds i8, i8* %rdi.v.12a2, i64 4
  store i8* %rsi.new.12a2, i8** %rsi.slot, align 8
  store i8* %rdi.v.12a2, i8** %rax.slot, align 8
  %rdi.i32p.12a2 = bitcast i8* %rdi.v.12a2 to i32*
  %ecx.tmp.12a2 = load i32, i32* %rdi.i32p.12a2, align 4
  %cmp.12a2 = icmp sle i32 %ecx.tmp.12a2, %edx.n.12a2
  br i1 %cmp.12a2, label %loc_1400, label %bb_12B9

bb_12B9:
  store i32 %ecx.tmp.12a2, i32* %rdi.plus4.12a2.i32p, align 4
  store i64 3, i64* %rcx.slot, align 8
  br label %loc_1288

loc_12CE:
  %rsi.v.12ce = load i8*, i8** %rsi.slot, align 8
  %rax.new.12ce = getelementptr inbounds i8, i8* %rsi.v.12ce, i64 -8
  store i8* %rax.new.12ce, i8** %rax.slot, align 8
  %rdi.to.12ce = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.12ce, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_12DA:
  %edx.v.12da = load i32, i32* %edx.slot, align 4
  store i32 %edx.v.12da, i32* %base.i32p, align 4
  %rdi.v.12da = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.12da = getelementptr inbounds i8, i8* %rdi.v.12da, i64 4
  %rdi.plus4.12da.i32p = bitcast i8* %rdi.plus4.12da to i32*
  %edx.n.12da = load i32, i32* %rdi.plus4.12da.i32p, align 4
  store i32 %edx.n.12da, i32* %edx.slot, align 4
  %rsi.new.12da = getelementptr inbounds i8, i8* %rdi.v.12da, i64 4
  store i8* %rsi.new.12da, i8** %rsi.slot, align 8
  store i8* %rdi.v.12da, i8** %rax.slot, align 8
  %rdi.i32p.12da = bitcast i8* %rdi.v.12da to i32*
  %ecx.tmp.12da = load i32, i32* %rdi.i32p.12da, align 4
  %cmp.12da = icmp sge i32 %ecx.tmp.12da, %edx.n.12da
  br i1 %cmp.12da, label %loc_140D, label %bb_12F1

bb_12F1:
  store i32 %ecx.tmp.12da, i32* %rdi.plus4.12da.i32p, align 4
  store i64 4, i64* %rcx.slot, align 8
  br label %loc_1288

loc_12FB:
  %rsi.v.12fb = load i8*, i8** %rsi.slot, align 8
  %rax.new.12fb = getelementptr inbounds i8, i8* %rsi.v.12fb, i64 -12
  store i8* %rax.new.12fb, i8** %rax.slot, align 8
  %rdi.to.12fb = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.12fb, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1307:
  %edx.v.1307 = load i32, i32* %edx.slot, align 4
  store i32 %edx.v.1307, i32* %base.i32p, align 4
  %rdi.v.1307 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1307 = getelementptr inbounds i8, i8* %rdi.v.1307, i64 4
  %rdi.plus4.1307.i32p = bitcast i8* %rdi.plus4.1307 to i32*
  %edx.n.1307 = load i32, i32* %rdi.plus4.1307.i32p, align 4
  store i32 %edx.n.1307, i32* %edx.slot, align 4
  %rsi.new.1307 = getelementptr inbounds i8, i8* %rdi.v.1307, i64 4
  store i8* %rsi.new.1307, i8** %rsi.slot, align 8
  store i8* %rdi.v.1307, i8** %rax.slot, align 8
  %rdi.i32p.1307 = bitcast i8* %rdi.v.1307 to i32*
  %ecx.tmp.1307 = load i32, i32* %rdi.i32p.1307, align 4
  %cmp.1307 = icmp sge i32 %ecx.tmp.1307, %edx.n.1307
  br i1 %cmp.1307, label %loc_13E6, label %bb_131E

bb_131E:
  store i32 %ecx.tmp.1307, i32* %rdi.plus4.1307.i32p, align 4
  store i64 5, i64* %rcx.slot, align 8
  br label %loc_1288

loc_132B:
  %rsi.v.132b = load i8*, i8** %rsi.slot, align 8
  %rax.new.132b = getelementptr inbounds i8, i8* %rsi.v.132b, i64 -16
  store i8* %rax.new.132b, i8** %rax.slot, align 8
  %rdi.to.132b = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.132b, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1337:
  %edx.v.1337 = load i32, i32* %edx.slot, align 4
  store i32 %edx.v.1337, i32* %base.i32p, align 4
  %rdi.v.1337 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1337 = getelementptr inbounds i8, i8* %rdi.v.1337, i64 4
  %rdi.plus4.1337.i32p = bitcast i8* %rdi.plus4.1337 to i32*
  %edx.n.1337 = load i32, i32* %rdi.plus4.1337.i32p, align 4
  store i32 %edx.n.1337, i32* %edx.slot, align 4
  %rsi.new.1337 = getelementptr inbounds i8, i8* %rdi.v.1337, i64 4
  store i8* %rsi.new.1337, i8** %rsi.slot, align 8
  store i8* %rdi.v.1337, i8** %rax.slot, align 8
  %rdi.i32p.1337 = bitcast i8* %rdi.v.1337 to i32*
  %ecx.tmp.1337 = load i32, i32* %rdi.i32p.1337, align 4
  %cmp.1337 = icmp sge i32 %ecx.tmp.1337, %edx.n.1337
  br i1 %cmp.1337, label %loc_13F3, label %bb_134E

bb_134E:
  store i32 %ecx.tmp.1337, i32* %rdi.plus4.1337.i32p, align 4
  store i64 6, i64* %rcx.slot, align 8
  br label %loc_1288

loc_135B:
  %rsi.v.135b = load i8*, i8** %rsi.slot, align 8
  %rax.new.135b = getelementptr inbounds i8, i8* %rsi.v.135b, i64 -20
  store i8* %rax.new.135b, i8** %rax.slot, align 8
  %rdi.to.135b = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.135b, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1367:
  %edx.v.1367 = load i32, i32* %edx.slot, align 4
  store i32 %edx.v.1367, i32* %base.i32p, align 4
  %rdi.v.1367 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1367 = getelementptr inbounds i8, i8* %rdi.v.1367, i64 4
  %rdi.plus4.1367.i32p = bitcast i8* %rdi.plus4.1367 to i32*
  %edx.n.1367 = load i32, i32* %rdi.plus4.1367.i32p, align 4
  store i32 %edx.n.1367, i32* %edx.slot, align 4
  %rsi.new.1367 = getelementptr inbounds i8, i8* %rdi.v.1367, i64 4
  store i8* %rsi.new.1367, i8** %rsi.slot, align 8
  store i8* %rdi.v.1367, i8** %rax.slot, align 8
  %rdi.i32p.1367 = bitcast i8* %rdi.v.1367 to i32*
  %ecx.tmp.1367 = load i32, i32* %rdi.i32p.1367, align 4
  %cmp.1367 = icmp sge i32 %ecx.tmp.1367, %edx.n.1367
  br i1 %cmp.1367, label %loc_13D9, label %bb_137A

bb_137A:
  store i32 %ecx.tmp.1367, i32* %rdi.plus4.1367.i32p, align 4
  store i64 7, i64* %rcx.slot, align 8
  br label %loc_1288

loc_1387:
  %rsi.v.1387 = load i8*, i8** %rsi.slot, align 8
  %rax.new.1387 = getelementptr inbounds i8, i8* %rsi.v.1387, i64 -24
  store i8* %rax.new.1387, i8** %rax.slot, align 8
  %rdi.to.1387 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.1387, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1393:
  %edx.v.1393 = load i32, i32* %edx.slot, align 4
  store i32 %edx.v.1393, i32* %base.i32p, align 4
  %rdi.v.1393 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1393 = getelementptr inbounds i8, i8* %rdi.v.1393, i64 4
  %rdi.plus4.1393.i32p = bitcast i8* %rdi.plus4.1393 to i32*
  %edx.n.1393 = load i32, i32* %rdi.plus4.1393.i32p, align 4
  store i32 %edx.n.1393, i32* %edx.slot, align 4
  %rsi.new.1393 = getelementptr inbounds i8, i8* %rdi.v.1393, i64 4
  store i8* %rsi.new.1393, i8** %rsi.slot, align 8
  store i8* %rdi.v.1393, i8** %rax.slot, align 8
  %rdi.i32p.1393 = bitcast i8* %rdi.v.1393 to i32*
  %ecx.tmp.1393 = load i32, i32* %rdi.i32p.1393, align 4
  %cmp.1393 = icmp sge i32 %ecx.tmp.1393, %edx.n.1393
  br i1 %cmp.1393, label %loc_141A, label %bb_13A6

bb_13A6:
  store i32 %ecx.tmp.1393, i32* %rdi.plus4.1393.i32p, align 4
  store i64 8, i64* %rcx.slot, align 8
  br label %loc_1288

loc_13B3:
  %rsi.v.13b3 = load i8*, i8** %rsi.slot, align 8
  %rax.new.13b3 = getelementptr inbounds i8, i8* %rsi.v.13b3, i64 -28
  store i8* %rax.new.13b3, i8** %rax.slot, align 8
  %rdi.to.13b3 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.to.13b3, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_13BF:
  %rsi.to.13bf = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.to.13bf, i8** %rax.slot, align 8
  store i64 2, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_1400:
  %rsi.to.1400 = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.to.1400, i8** %rax.slot, align 8
  store i64 3, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_140D:
  %rsi.to.140d = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.to.140d, i8** %rax.slot, align 8
  store i64 4, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_13E6:
  %rsi.to.13e6 = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.to.13e6, i8** %rax.slot, align 8
  store i64 5, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_13F3:
  %rsi.to.13f3 = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.to.13f3, i8** %rax.slot, align 8
  store i64 6, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_13D9:
  %rsi.to.13d9 = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.to.13d9, i8** %rax.slot, align 8
  store i64 7, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_141A:
  %rsi.to.141a = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.to.141a, i8** %rax.slot, align 8
  store i64 8, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_11C6:
  %rsi.from.11c6 = load i8*, i8** %rsi.slot, align 8
  %rdi.from.11c6 = load i8*, i8** %rdi.slot, align 8
  %rsi.new.11c6 = select i1 true, i8* %rdi.from.11c6, i8* %rsi.from.11c6
  store i8* %rsi.new.11c6, i8** %rsi.slot, align 8
  %rbp.val.11c6 = load i8*, i8** %rbp.slot, align 8
  store i8* %rbp.val.11c6, i8** %rax.slot, align 8
  %rcx.cur.11c6 = load i64, i64* %rcx.slot, align 8
  %rcx.inc = add i64 %rcx.cur.11c6, 1
  store i64 %rcx.inc, i64* %rcx.slot, align 8
  %edx.to.store.11c6 = load i32, i32* %edx.slot, align 4
  %rax.cur.ptr.11c6 = load i8*, i8** %rax.slot, align 8
  %rax.cur.ptr.i32p.11c6 = bitcast i8* %rax.cur.ptr.11c6 to i32*
  store i32 %edx.to.store.11c6, i32* %rax.cur.ptr.i32p.11c6, align 4
  %cmp.rcx.9 = icmp ne i64 %rcx.inc, 9
  br i1 %cmp.rcx.9, label %loc_10D0, label %bb_11D6

bb_11D6:
  %rbp.cur.11d6 = load i8*, i8** %rbp.slot, align 8
  %rbp.plus40 = getelementptr inbounds i8, i8* %rbp.cur.11d6, i64 40
  store i8* %rbp.plus40, i8** %rbp.slot, align 8
  %fmt0 = getelementptr inbounds i8, i8* @unk_2004, i64 0
  store i8* %fmt0, i8** %r12.slot, align 8
  br label %loc_11E8

loc_11E8:
  %rbx.cur.11e8 = load i8*, i8** %rbx.slot, align 8
  %rbx.cur.i32p.11e8 = bitcast i8* %rbx.cur.11e8 to i32*
  %val.11e8 = load i32, i32* %rbx.cur.i32p.11e8, align 4
  %fmt.ptr.11e8 = load i8*, i8** %r12.slot, align 8
  %rbx.next.11e8 = getelementptr inbounds i8, i8* %rbx.cur.11e8, i64 4
  store i8* %rbx.next.11e8, i8** %rbx.slot, align 8
  %call.printf.11e8 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr.11e8, i32 %val.11e8)
  %rbp.end.11e8 = load i8*, i8** %rbp.slot, align 8
  %rbx.now.11e8 = load i8*, i8** %rbx.slot, align 8
  %cmp.loop.11e8 = icmp ne i8* %rbx.now.11e8, %rbp.end.11e8
  br i1 %cmp.loop.11e8, label %loc_11E8, label %bb_1202

bb_1202:
  %fmt1 = getelementptr inbounds i8, i8* @unk_2008, i64 0
  %call.printf.end = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1)
  %saved = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %cmp.canary = icmp ne i64 %saved, %guard.now
  br i1 %cmp.canary, label %loc_1427, label %bb_1229

bb_1229:
  ret i32 0

loc_1427:
  call void @___stack_chk_fail()
  unreachable
}