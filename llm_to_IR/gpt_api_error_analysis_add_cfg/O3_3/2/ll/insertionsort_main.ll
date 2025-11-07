; ModuleID = 'reconstructed_main_from_asm'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@xmmword_2010 = private unnamed_addr constant <4 x i32> <i32 9, i32 1, i32 8, i32 3>, align 16
@xmmword_2020 = private unnamed_addr constant <4 x i32> <i32 7, i32 2, i32 6, i32 5>, align 16
@unk_2004 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_2008 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
addr_1080:
  %canary.save = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %var_rbp = alloca i8*, align 8
  %var_rbx = alloca i8*, align 8
  %var_rsi = alloca i8*, align 8
  %var_rdi = alloca i8*, align 8
  %var_rax = alloca i8*, align 8
  %var_r12 = alloca i8*, align 8
  %var_rcx = alloca i64, align 8
  %var_edx = alloca i32, align 4
  %var_r8d = alloca i32, align 4

  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.save, align 8

  store i64 0, i64* %var_rcx, align 8

  %arr.base.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr.base.i8 = bitcast i32* %arr.base.i32 to i8*
  store i8* %arr.base.i8, i8** %var_rbp, align 8
  store i8* %arr.base.i8, i8** %var_rbx, align 8
  store i8* %arr.base.i8, i8** %var_rsi, align 8

  %p.v0 = bitcast i32* %arr.base.i32 to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %v0, <4 x i32>* %p.v0, align 16

  %p4.i32 = getelementptr inbounds i32, i32* %arr.base.i32, i64 4
  %p.v1 = bitcast i32* %p4.i32 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %p.v1, align 16

  %p8.i32 = getelementptr inbounds i32, i32* %arr.base.i32, i64 8
  store i32 4, i32* %p8.i32, align 4

  %p9.i32 = getelementptr inbounds i32, i32* %arr.base.i32, i64 9
  store i32 0, i32* %p9.i32, align 4

  br label %loc_10D0

loc_10D0:
  %rsi.10D0 = load i8*, i8** %var_rsi, align 8
  %addr.s4.10D0 = getelementptr inbounds i8, i8* %rsi.10D0, i64 4
  %addr.s4.i32.10D0 = bitcast i8* %addr.s4.10D0 to i32*
  %addr.s0.i32.10D0 = bitcast i8* %rsi.10D0 to i32*
  %edx.10D0 = load i32, i32* %addr.s4.i32.10D0, align 4
  %r8d.10D0 = load i32, i32* %addr.s0.i32.10D0, align 4
  store i32 %edx.10D0, i32* %var_edx, align 4
  store i32 %r8d.10D0, i32* %var_r8d, align 4
  store i8* %addr.s4.10D0, i8** %var_rdi, align 8
  store i8* %rsi.10D0, i8** %var_rax, align 8
  %cmp.le.10D0 = icmp sle i32 %r8d.10D0, %edx.10D0
  br i1 %cmp.le.10D0, label %loc_12C3, label %addr_10E6

addr_10E6:
  %rsi.10E6 = load i8*, i8** %var_rsi, align 8
  %addr.s4.10E6 = getelementptr inbounds i8, i8* %rsi.10E6, i64 4
  %addr.s4.i32.10E6 = bitcast i8* %addr.s4.10E6 to i32*
  %r8d.store.10E6 = load i32, i32* %var_r8d, align 4
  store i32 %r8d.store.10E6, i32* %addr.s4.i32.10E6, align 4
  %rcx.10E6 = load i64, i64* %var_rcx, align 8
  %isZero.10E6 = icmp eq i64 %rcx.10E6, 0
  br i1 %isZero.10E6, label %loc_1234, label %loc_10F3

loc_1234:
  %edx.1234 = load i32, i32* %var_edx, align 4
  %rbp.1234 = load i8*, i8** %var_rbp, align 8
  %rbp.i32.1234 = bitcast i8* %rbp.1234 to i32*
  store i32 %edx.1234, i32* %rbp.i32.1234, align 4

  %rdi.1234 = load i8*, i8** %var_rdi, align 8
  %rdi.plus4.1234 = getelementptr inbounds i8, i8* %rdi.1234, i64 4
  %rdi.plus8.1234 = getelementptr inbounds i8, i8* %rdi.1234, i64 8
  %rdi.plus8.i32.1234 = bitcast i8* %rdi.plus8.1234 to i32*
  %edx.next.1234 = load i32, i32* %rdi.plus8.i32.1234, align 4
  store i32 %edx.next.1234, i32* %var_edx, align 4

  %rsi.1234.new = getelementptr inbounds i8, i8* %rdi.1234, i64 8
  store i8* %rsi.1234.new, i8** %var_rsi, align 8

  store i8* %rdi.1234, i8** %var_rax, align 8

  %rdi.i32.1234 = bitcast i8* %rdi.1234 to i32*
  %ecx.val.1234 = load i32, i32* %rdi.i32.1234, align 4
  %edx.now.1234 = load i32, i32* %var_edx, align 4
  %cmp.le.1234 = icmp sle i32 %ecx.val.1234, %edx.now.1234
  br i1 %cmp.le.1234, label %loc_13CC, label %addr_124b

addr_124b:
  %rdi.i32p4.124b = bitcast i8* %rdi.plus4.1234 to i32*
  store i32 %ecx.val.1234, i32* %rdi.i32p4.124b, align 4
  %rsi.tmp.124b = load i8*, i8** %var_rsi, align 8
  store i8* %rdi.1234, i8** %var_rsi, align 8
  store i8* %rsi.tmp.124b, i8** %var_rdi, align 8
  br label %loc_10F3

loc_13CC:
  %rsi.13CC = load i8*, i8** %var_rsi, align 8
  store i8* %rsi.13CC, i8** %var_rax, align 8
  store i64 1, i64* %var_rcx, align 8
  br label %loc_11C6

loc_10F3:
  %rax.10F3 = load i8*, i8** %var_rax, align 8
  %addr.m4.10F3 = getelementptr inbounds i8, i8* %rax.10F3, i64 -4
  %addr.m4.i32.10F3 = bitcast i8* %addr.m4.10F3 to i32*
  %r8d.10F3 = load i32, i32* %addr.m4.i32.10F3, align 4
  %edx.10F3 = load i32, i32* %var_edx, align 4
  %cmp.le.10F3 = icmp sle i32 %r8d.10F3, %edx.10F3
  br i1 %cmp.le.10F3, label %loc_125B, label %addr_1100

addr_1100:
  %rax.store.1100 = load i8*, i8** %var_rax, align 8
  %rax.store.i32.1100 = bitcast i8* %rax.store.1100 to i32*
  store i32 %r8d.10F3, i32* %rax.store.i32.1100, align 4
  %rcx.1103 = load i64, i64* %var_rcx, align 8
  %isOne.1103 = icmp eq i64 %rcx.1103, 1
  br i1 %isOne.1103, label %loc_1263, label %addr_110d

loc_125B:
  %rdi.125B = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.125B, i8** %var_rsi, align 8
  br label %loc_11C6

addr_110d:
  %rax.110d = load i8*, i8** %var_rax, align 8
  %addr.m8.110d = getelementptr inbounds i8, i8* %rax.110d, i64 -8
  %addr.m8.i32.110d = bitcast i8* %addr.m8.110d to i32*
  %r8d.110d = load i32, i32* %addr.m8.i32.110d, align 4
  %edx.110d = load i32, i32* %var_edx, align 4
  %cmp.le.110d = icmp sle i32 %r8d.110d, %edx.110d
  br i1 %cmp.le.110d, label %loc_1296, label %addr_111a

loc_1263:
  %edx.1263 = load i32, i32* %var_edx, align 4
  %rbp.1263 = load i8*, i8** %var_rbp, align 8
  %rbp.i32.1263 = bitcast i8* %rbp.1263 to i32*
  store i32 %edx.1263, i32* %rbp.i32.1263, align 4

  %rdi.1263 = load i8*, i8** %var_rdi, align 8
  %rdi.p4.1263 = getelementptr inbounds i8, i8* %rdi.1263, i64 4
  %rdi.p8.1263 = getelementptr inbounds i8, i8* %rdi.1263, i64 8
  %rdi.p8.i32.1263 = bitcast i8* %rdi.p8.1263 to i32*
  %edx.next.1263 = load i32, i32* %rdi.p8.i32.1263, align 4
  store i32 %edx.next.1263, i32* %var_edx, align 4

  store i8* %rdi.p4.1263, i8** %var_rsi, align 8
  store i8* %rdi.1263, i8** %var_rax, align 8

  %rdi.i32.1263 = bitcast i8* %rdi.1263 to i32*
  %ecx.val.1263 = load i32, i32* %rdi.i32.1263, align 4
  %cmp.ge.1263 = icmp sge i32 %edx.next.1263, %ecx.val.1263
  br i1 %cmp.ge.1263, label %loc_13BF, label %addr_127a

addr_127a:
  %rdi.p4.i32.127a = bitcast i8* %rdi.p4.1263 to i32*
  store i32 %ecx.val.1263, i32* %rdi.p4.i32.127a, align 4
  store i64 2, i64* %var_rcx, align 8
  %rsi.swap.src.127a = load i8*, i8** %var_rsi, align 8
  %rdi.swap.src.127a = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.swap.src.127a, i8** %var_rsi, align 8
  store i8* %rsi.swap.src.127a, i8** %var_rdi, align 8
  br label %loc_10F3

loc_1296:
  %rsi.1296 = load i8*, i8** %var_rsi, align 8
  %rax.new.1296 = getelementptr inbounds i8, i8* %rsi.1296, i64 -4
  store i8* %rax.new.1296, i8** %var_rax, align 8
  %rdi.1296 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.1296, i8** %var_rsi, align 8
  br label %loc_11C6

addr_111a:
  %rax.m4.store.addr.111a = getelementptr inbounds i8, i8* %rax.110d, i64 -4
  %rax.m4.store.i32.111a = bitcast i8* %rax.m4.store.addr.111a to i32*
  store i32 %r8d.110d, i32* %rax.m4.store.i32.111a, align 4
  %rcx.111e = load i64, i64* %var_rcx, align 8
  %isTwo.111e = icmp eq i64 %rcx.111e, 2
  br i1 %isTwo.111e, label %loc_12A2, label %addr_1128

loc_12A2:
  %edx.12A2 = load i32, i32* %var_edx, align 4
  %rbp.12A2 = load i8*, i8** %var_rbp, align 8
  %rbp.i32.12A2 = bitcast i8* %rbp.12A2 to i32*
  store i32 %edx.12A2, i32* %rbp.i32.12A2, align 4

  %rdi.12A2 = load i8*, i8** %var_rdi, align 8
  %rdi.p4.12A2 = getelementptr inbounds i8, i8* %rdi.12A2, i64 4
  %rdi.p8.12A2 = getelementptr inbounds i8, i8* %rdi.12A2, i64 8
  %rdi.p8.i32.12A2 = bitcast i8* %rdi.p8.12A2 to i32*
  %edx.next.12A2 = load i32, i32* %rdi.p8.i32.12A2, align 4
  store i32 %edx.next.12A2, i32* %var_edx, align 4

  store i8* %rdi.p4.12A2, i8** %var_rsi, align 8
  store i8* %rdi.12A2, i8** %var_rax, align 8

  %rdi.i32.12A2 = bitcast i8* %rdi.12A2 to i32*
  %ecx.val.12A2 = load i32, i32* %rdi.i32.12A2, align 4
  %cmp.le.12A2 = icmp sle i32 %ecx.val.12A2, %edx.next.12A2
  br i1 %cmp.le.12A2, label %loc_1400, label %addr_12b9

addr_12b9:
  %rdi.p4.i32.12b9 = bitcast i8* %rdi.p4.12A2 to i32*
  store i32 %ecx.val.12A2, i32* %rdi.p4.i32.12b9, align 4
  store i64 3, i64* %var_rcx, align 8
  %rsi.swap.src.12b9 = load i8*, i8** %var_rsi, align 8
  %rdi.swap.src.12b9 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.swap.src.12b9, i8** %var_rsi, align 8
  store i8* %rsi.swap.src.12b9, i8** %var_rdi, align 8
  br label %loc_10F3

loc_1400:
  %rsi.1400 = load i8*, i8** %var_rsi, align 8
  store i8* %rsi.1400, i8** %var_rax, align 8
  store i64 3, i64* %var_rcx, align 8
  br label %loc_11C6

addr_1128:
  %rax.1128 = load i8*, i8** %var_rax, align 8
  %addr.m12.1128 = getelementptr inbounds i8, i8* %rax.1128, i64 -12
  %addr.m12.i32.1128 = bitcast i8* %addr.m12.1128 to i32*
  %r8d.1128 = load i32, i32* %addr.m12.i32.1128, align 4
  %edx.1128 = load i32, i32* %var_edx, align 4
  %cmp.le.1128 = icmp sle i32 %r8d.1128, %edx.1128
  br i1 %cmp.le.1128, label %loc_12CE, label %addr_1135

loc_12CE:
  %rsi.12CE = load i8*, i8** %var_rsi, align 8
  %rax.new.12CE = getelementptr inbounds i8, i8* %rsi.12CE, i64 -8
  store i8* %rax.new.12CE, i8** %var_rax, align 8
  %rdi.12CE = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.12CE, i8** %var_rsi, align 8
  br label %loc_11C6

addr_1135:
  %rax.m8.store.addr.1135 = getelementptr inbounds i8, i8* %rax.1128, i64 -8
  %rax.m8.store.i32.1135 = bitcast i8* %rax.m8.store.addr.1135 to i32*
  store i32 %r8d.1128, i32* %rax.m8.store.i32.1135, align 4
  %rcx.1139 = load i64, i64* %var_rcx, align 8
  %isThree.1139 = icmp eq i64 %rcx.1139, 3
  br i1 %isThree.1139, label %loc_12DA, label %addr_1143

loc_12DA:
  %edx.12DA = load i32, i32* %var_edx, align 4
  %rbp.12DA = load i8*, i8** %var_rbp, align 8
  %rbp.i32.12DA = bitcast i8* %rbp.12DA to i32*
  store i32 %edx.12DA, i32* %rbp.i32.12DA, align 4

  %rdi.12DA = load i8*, i8** %var_rdi, align 8
  %rdi.p4.12DA = getelementptr inbounds i8, i8* %rdi.12DA, i64 4
  %rdi.p8.12DA = getelementptr inbounds i8, i8* %rdi.12DA, i64 8
  %rdi.p8.i32.12DA = bitcast i8* %rdi.p8.12DA to i32*
  %edx.next.12DA = load i32, i32* %rdi.p8.i32.12DA, align 4
  store i32 %edx.next.12DA, i32* %var_edx, align 4

  store i8* %rdi.p4.12DA, i8** %var_rsi, align 8
  store i8* %rdi.12DA, i8** %var_rax, align 8

  %rdi.i32.12DA = bitcast i8* %rdi.12DA to i32*
  %ecx.val.12DA = load i32, i32* %rdi.i32.12DA, align 4
  %cmp.ge.12DA = icmp sge i32 %edx.next.12DA, %ecx.val.12DA
  br i1 %cmp.ge.12DA, label %loc_140D, label %addr_12f1

addr_12f1:
  %rdi.p4.i32.12f1 = bitcast i8* %rdi.p4.12DA to i32*
  store i32 %ecx.val.12DA, i32* %rdi.p4.i32.12f1, align 4
  store i64 4, i64* %var_rcx, align 8
  %rsi.swap.src.12f1 = load i8*, i8** %var_rsi, align 8
  %rdi.swap.src.12f1 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.swap.src.12f1, i8** %var_rsi, align 8
  store i8* %rsi.swap.src.12f1, i8** %var_rdi, align 8
  br label %loc_10F3

loc_140D:
  %rsi.140D = load i8*, i8** %var_rsi, align 8
  store i8* %rsi.140D, i8** %var_rax, align 8
  store i64 4, i64* %var_rcx, align 8
  br label %loc_11C6

addr_1143:
  %rax.1143 = load i8*, i8** %var_rax, align 8
  %addr.m16.1143 = getelementptr inbounds i8, i8* %rax.1143, i64 -16
  %addr.m16.i32.1143 = bitcast i8* %addr.m16.1143 to i32*
  %r8d.1143 = load i32, i32* %addr.m16.i32.1143, align 4
  %edx.1143 = load i32, i32* %var_edx, align 4
  %cmp.le.1143 = icmp sle i32 %r8d.1143, %edx.1143
  br i1 %cmp.le.1143, label %loc_12FB, label %addr_1150

loc_12FB:
  %rsi.12FB = load i8*, i8** %var_rsi, align 8
  %rax.new.12FB = getelementptr inbounds i8, i8* %rsi.12FB, i64 -12
  store i8* %rax.new.12FB, i8** %var_rax, align 8
  %rdi.12FB = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.12FB, i8** %var_rsi, align 8
  br label %loc_11C6

addr_1150:
  %rax.m12.store.addr.1150 = getelementptr inbounds i8, i8* %rax.1143, i64 -12
  %rax.m12.store.i32.1150 = bitcast i8* %rax.m12.store.addr.1150 to i32*
  store i32 %r8d.1143, i32* %rax.m12.store.i32.1150, align 4
  %rcx.1154 = load i64, i64* %var_rcx, align 8
  %isFour.1154 = icmp eq i64 %rcx.1154, 4
  br i1 %isFour.1154, label %loc_1307, label %addr_115e

loc_1307:
  %edx.1307 = load i32, i32* %var_edx, align 4
  %rbp.1307 = load i8*, i8** %var_rbp, align 8
  %rbp.i32.1307 = bitcast i8* %rbp.1307 to i32*
  store i32 %edx.1307, i32* %rbp.i32.1307, align 4

  %rdi.1307 = load i8*, i8** %var_rdi, align 8
  %rdi.p4.1307 = getelementptr inbounds i8, i8* %rdi.1307, i64 4
  %rdi.p8.1307 = getelementptr inbounds i8, i8* %rdi.1307, i64 8
  %rdi.p8.i32.1307 = bitcast i8* %rdi.p8.1307 to i32*
  %edx.next.1307 = load i32, i32* %rdi.p8.i32.1307, align 4
  store i32 %edx.next.1307, i32* %var_edx, align 4

  store i8* %rdi.p4.1307, i8** %var_rsi, align 8
  store i8* %rdi.1307, i8** %var_rax, align 8

  %rdi.i32.1307 = bitcast i8* %rdi.1307 to i32*
  %ecx.val.1307 = load i32, i32* %rdi.i32.1307, align 4
  %cmp.ge.1307 = icmp sge i32 %edx.next.1307, %ecx.val.1307
  br i1 %cmp.ge.1307, label %loc_13E6, label %addr_131e

addr_131e:
  %rdi.p4.i32.131e = bitcast i8* %rdi.p4.1307 to i32*
  store i32 %ecx.val.1307, i32* %rdi.p4.i32.131e, align 4
  store i64 5, i64* %var_rcx, align 8
  %rsi.swap.src.131e = load i8*, i8** %var_rsi, align 8
  %rdi.swap.src.131e = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.swap.src.131e, i8** %var_rsi, align 8
  store i8* %rsi.swap.src.131e, i8** %var_rdi, align 8
  br label %loc_10F3

loc_13E6:
  %rsi.13E6 = load i8*, i8** %var_rsi, align 8
  store i8* %rsi.13E6, i8** %var_rax, align 8
  store i64 5, i64* %var_rcx, align 8
  br label %loc_11C6

addr_115e:
  %rax.115e = load i8*, i8** %var_rax, align 8
  %addr.m20.115e = getelementptr inbounds i8, i8* %rax.115e, i64 -20
  %addr.m20.i32.115e = bitcast i8* %addr.m20.115e to i32*
  %r8d.115e = load i32, i32* %addr.m20.i32.115e, align 4
  %edx.115e = load i32, i32* %var_edx, align 4
  %cmp.le.115e = icmp sle i32 %r8d.115e, %edx.115e
  br i1 %cmp.le.115e, label %loc_132B, label %addr_116b

loc_132B:
  %rsi.132B = load i8*, i8** %var_rsi, align 8
  %rax.new.132B = getelementptr inbounds i8, i8* %rsi.132B, i64 -16
  store i8* %rax.new.132B, i8** %var_rax, align 8
  %rdi.132B = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.132B, i8** %var_rsi, align 8
  br label %loc_11C6

addr_116b:
  %rax.m16.store.addr.116b = getelementptr inbounds i8, i8* %rax.115e, i64 -16
  %rax.m16.store.i32.116b = bitcast i8* %rax.m16.store.addr.116b to i32*
  store i32 %r8d.115e, i32* %rax.m16.store.i32.116b, align 4
  %rcx.116f = load i64, i64* %var_rcx, align 8
  %isFive.116f = icmp eq i64 %rcx.116f, 5
  br i1 %isFive.116f, label %loc_1337, label %addr_1179

loc_1337:
  %edx.1337 = load i32, i32* %var_edx, align 4
  %rbp.1337 = load i8*, i8** %var_rbp, align 8
  %rbp.i32.1337 = bitcast i8* %rbp.1337 to i32*
  store i32 %edx.1337, i32* %rbp.i32.1337, align 4

  %rdi.1337 = load i8*, i8** %var_rdi, align 8
  %rdi.p4.1337 = getelementptr inbounds i8, i8* %rdi.1337, i64 4
  %rdi.p8.1337 = getelementptr inbounds i8, i8* %rdi.1337, i64 8
  %rdi.p8.i32.1337 = bitcast i8* %rdi.p8.1337 to i32*
  %edx.next.1337 = load i32, i32* %rdi.p8.i32.1337, align 4
  store i32 %edx.next.1337, i32* %var_edx, align 4

  store i8* %rdi.p4.1337, i8** %var_rsi, align 8
  store i8* %rdi.1337, i8** %var_rax, align 8

  %rdi.i32.1337 = bitcast i8* %rdi.1337 to i32*
  %ecx.val.1337 = load i32, i32* %rdi.i32.1337, align 4
  %cmp.ge.1337 = icmp sge i32 %edx.next.1337, %ecx.val.1337
  br i1 %cmp.ge.1337, label %loc_13F3, label %addr_134e

addr_134e:
  %rdi.p4.i32.134e = bitcast i8* %rdi.p4.1337 to i32*
  store i32 %ecx.val.1337, i32* %rdi.p4.i32.134e, align 4
  store i64 6, i64* %var_rcx, align 8
  %rsi.swap.src.134e = load i8*, i8** %var_rsi, align 8
  %rdi.swap.src.134e = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.swap.src.134e, i8** %var_rsi, align 8
  store i8* %rsi.swap.src.134e, i8** %var_rdi, align 8
  br label %loc_10F3

loc_13F3:
  %rsi.13F3 = load i8*, i8** %var_rsi, align 8
  store i8* %rsi.13F3, i8** %var_rax, align 8
  store i64 6, i64* %var_rcx, align 8
  br label %loc_11C6

addr_1179:
  %rax.1179 = load i8*, i8** %var_rax, align 8
  %addr.m24.1179 = getelementptr inbounds i8, i8* %rax.1179, i64 -24
  %addr.m24.i32.1179 = bitcast i8* %addr.m24.1179 to i32*
  %r8d.1179 = load i32, i32* %addr.m24.i32.1179, align 4
  %edx.1179 = load i32, i32* %var_edx, align 4
  %cmp.le.1179 = icmp sle i32 %r8d.1179, %edx.1179
  br i1 %cmp.le.1179, label %loc_135B, label %addr_1186

loc_135B:
  %rsi.135B = load i8*, i8** %var_rsi, align 8
  %rax.new.135B = getelementptr inbounds i8, i8* %rsi.135B, i64 -20
  store i8* %rax.new.135B, i8** %var_rax, align 8
  %rdi.135B = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.135B, i8** %var_rsi, align 8
  br label %loc_11C6

addr_1186:
  %rax.m20.store.addr.1186 = getelementptr inbounds i8, i8* %rax.1179, i64 -20
  %rax.m20.store.i32.1186 = bitcast i8* %rax.m20.store.addr.1186 to i32*
  store i32 %r8d.1179, i32* %rax.m20.store.i32.1186, align 4
  %rcx.118a = load i64, i64* %var_rcx, align 8
  %isSix.118a = icmp eq i64 %rcx.118a, 6
  br i1 %isSix.118a, label %loc_1367, label %addr_1194

loc_1367:
  %edx.1367 = load i32, i32* %var_edx, align 4
  %rbp.1367 = load i8*, i8** %var_rbp, align 8
  %rbp.i32.1367 = bitcast i8* %rbp.1367 to i32*
  store i32 %edx.1367, i32* %rbp.i32.1367, align 4

  %rdi.1367 = load i8*, i8** %var_rdi, align 8
  %rdi.p4.1367 = getelementptr inbounds i8, i8* %rdi.1367, i64 4
  %rdi.p8.1367 = getelementptr inbounds i8, i8* %rdi.1367, i64 8
  %rdi.p8.i32.1367 = bitcast i8* %rdi.p8.1367 to i32*
  %edx.next.1367 = load i32, i32* %rdi.p8.i32.1367, align 4
  store i32 %edx.next.1367, i32* %var_edx, align 4

  store i8* %rdi.p4.1367, i8** %var_rsi, align 8
  store i8* %rdi.1367, i8** %var_rax, align 8

  %rdi.i32.1367 = bitcast i8* %rdi.1367 to i32*
  %ecx.val.1367 = load i32, i32* %rdi.i32.1367, align 4
  %cmp.ge.1367 = icmp sge i32 %edx.next.1367, %ecx.val.1367
  br i1 %cmp.ge.1367, label %loc_13D9, label %addr_137a

addr_137a:
  %rdi.p4.i32.137a = bitcast i8* %rdi.p4.1367 to i32*
  store i32 %ecx.val.1367, i32* %rdi.p4.i32.137a, align 4
  store i64 7, i64* %var_rcx, align 8
  %rsi.swap.src.137a = load i8*, i8** %var_rsi, align 8
  %rdi.swap.src.137a = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.swap.src.137a, i8** %var_rsi, align 8
  store i8* %rsi.swap.src.137a, i8** %var_rdi, align 8
  br label %loc_10F3

loc_13D9:
  %rsi.13D9 = load i8*, i8** %var_rsi, align 8
  store i8* %rsi.13D9, i8** %var_rax, align 8
  store i64 7, i64* %var_rcx, align 8
  br label %loc_11C6

addr_1194:
  %rax.1194 = load i8*, i8** %var_rax, align 8
  %addr.m28.1194 = getelementptr inbounds i8, i8* %rax.1194, i64 -28
  %addr.m28.i32.1194 = bitcast i8* %addr.m28.1194 to i32*
  %r8d.1194 = load i32, i32* %addr.m28.i32.1194, align 4
  %edx.1194 = load i32, i32* %var_edx, align 4
  %cmp.le.1194 = icmp sle i32 %r8d.1194, %edx.1194
  br i1 %cmp.le.1194, label %loc_1387, label %addr_11a1

loc_1387:
  %rsi.1387 = load i8*, i8** %var_rsi, align 8
  %rax.new.1387 = getelementptr inbounds i8, i8* %rsi.1387, i64 -24
  store i8* %rax.new.1387, i8** %var_rax, align 8
  %rdi.1387 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.1387, i8** %var_rsi, align 8
  br label %loc_11C6

addr_11a1:
  %rax.m24.store.addr.11a1 = getelementptr inbounds i8, i8* %rax.1194, i64 -24
  %rax.m24.store.i32.11a1 = bitcast i8* %rax.m24.store.addr.11a1 to i32*
  store i32 %r8d.1194, i32* %rax.m24.store.i32.11a1, align 4
  %rcx.11a5 = load i64, i64* %var_rcx, align 8
  %isSeven.11a5 = icmp eq i64 %rcx.11a5, 7
  br i1 %isSeven.11a5, label %loc_1393, label %addr_11af

loc_1393:
  %edx.1393 = load i32, i32* %var_edx, align 4
  %rbp.1393 = load i8*, i8** %var_rbp, align 8
  %rbp.i32.1393 = bitcast i8* %rbp.1393 to i32*
  store i32 %edx.1393, i32* %rbp.i32.1393, align 4

  %rdi.1393 = load i8*, i8** %var_rdi, align 8
  %rdi.p4.1393 = getelementptr inbounds i8, i8* %rdi.1393, i64 4
  %rdi.p8.1393 = getelementptr inbounds i8, i8* %rdi.1393, i64 8
  %rdi.p8.i32.1393 = bitcast i8* %rdi.p8.1393 to i32*
  %edx.next.1393 = load i32, i32* %rdi.p8.i32.1393, align 4
  store i32 %edx.next.1393, i32* %var_edx, align 4

  store i8* %rdi.p4.1393, i8** %var_rsi, align 8
  store i8* %rdi.1393, i8** %var_rax, align 8

  %rdi.i32.1393 = bitcast i8* %rdi.1393 to i32*
  %ecx.val.1393 = load i32, i32* %rdi.i32.1393, align 4
  %cmp.ge.1393 = icmp sge i32 %edx.next.1393, %ecx.val.1393
  br i1 %cmp.ge.1393, label %loc_141A, label %addr_13a6

addr_13a6:
  %rdi.p4.i32.13a6 = bitcast i8* %rdi.p4.1393 to i32*
  store i32 %ecx.val.1393, i32* %rdi.p4.i32.13a6, align 4
  store i64 8, i64* %var_rcx, align 8
  %rsi.swap.src.13a6 = load i8*, i8** %var_rsi, align 8
  %rdi.swap.src.13a6 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.swap.src.13a6, i8** %var_rsi, align 8
  store i8* %rsi.swap.src.13a6, i8** %var_rdi, align 8
  br label %loc_10F3

loc_141A:
  %rsi.141A = load i8*, i8** %var_rsi, align 8
  store i8* %rsi.141A, i8** %var_rax, align 8
  store i64 8, i64* %var_rcx, align 8
  br label %loc_11C6

addr_11af:
  %rax.11af = load i8*, i8** %var_rax, align 8
  %addr.m32.11af = getelementptr inbounds i8, i8* %rax.11af, i64 -32
  %addr.m32.i32.11af = bitcast i8* %addr.m32.11af to i32*
  %r8d.11af = load i32, i32* %addr.m32.i32.11af, align 4
  %edx.11af = load i32, i32* %var_edx, align 4
  %cmp.le.11af = icmp sle i32 %r8d.11af, %edx.11af
  br i1 %cmp.le.11af, label %loc_13B3, label %addr_11bc

loc_13B3:
  %rsi.13B3 = load i8*, i8** %var_rsi, align 8
  %rax.new.13B3 = getelementptr inbounds i8, i8* %rsi.13B3, i64 -28
  store i8* %rax.new.13B3, i8** %var_rax, align 8
  %rdi.13B3 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.13B3, i8** %var_rsi, align 8
  br label %loc_11C6

addr_11bc:
  %rax.m28.store.i8.11bc = getelementptr inbounds i8, i8* %rax.11af, i64 -28
  %rax.m28.store.i32.11bc = bitcast i8* %rax.m28.store.i8.11bc to i32*
  store i32 %r8d.11af, i32* %rax.m28.store.i32.11bc, align 4
  br label %loc_11C0

loc_11C0:
  %rdi.11C0 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.11C0, i8** %var_rsi, align 8
  %rbp.11C0 = load i8*, i8** %var_rbp, align 8
  store i8* %rbp.11C0, i8** %var_rax, align 8
  br label %loc_11C6

loc_12C3:
  %rdi.12C3 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi.12C3, i8** %var_rsi, align 8
  store i8* %rdi.12C3, i8** %var_rax, align 8
  br label %loc_11C6

loc_11C6:
  %rcx.in = load i64, i64* %var_rcx, align 8
  %rcx.next = add i64 %rcx.in, 1
  store i64 %rcx.next, i64* %var_rcx, align 8
  %rax.ins = load i8*, i8** %var_rax, align 8
  %rax.ins.i32 = bitcast i8* %rax.ins to i32*
  %edx.ins = load i32, i32* %var_edx, align 4
  store i32 %edx.ins, i32* %rax.ins.i32, align 4
  %cmp.rcx9 = icmp ne i64 %rcx.next, 9
  br i1 %cmp.rcx9, label %loc_10D0, label %addr_11D6

addr_11D6:
  %rbp.11D6 = load i8*, i8** %var_rbp, align 8
  %rbp.end = getelementptr inbounds i8, i8* %rbp.11D6, i64 40
  store i8* %rbp.end, i8** %var_rbp, align 8
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  store i8* %fmt.ptr, i8** %var_r12, align 8
  br label %loc_11E8

loc_11E8:
  %rbx.11E8 = load i8*, i8** %var_rbx, align 8
  %rbx.i32.11E8 = bitcast i8* %rbx.11E8 to i32*
  %val.11E8 = load i32, i32* %rbx.i32.11E8, align 4
  %fmt.use = load i8*, i8** %var_r12, align 8
  %rbx.next = getelementptr inbounds i8, i8* %rbx.11E8, i64 4
  store i8* %rbx.next, i8** %var_rbx, align 8
  %call0 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.use, i32 %val.11E8)
  br label %addr_11fd

addr_11fd:
  %rbp.end2 = load i8*, i8** %var_rbp, align 8
  %rbx.cur2 = load i8*, i8** %var_rbx, align 8
  %cmp.ne.print = icmp ne i8* %rbp.end2, %rbx.cur2
  br i1 %cmp.ne.print, label %loc_11E8, label %addr_1202

addr_1202:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %nl.ptr)
  %guard.saved = load i64, i64* %canary.save, align 8
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %guard.eq = icmp eq i64 %guard.saved, %guard.cur
  br i1 %guard.eq, label %addr_1229, label %loc_1427

addr_1229:
  ret i32 0

loc_13BF:
  %rsi.13BF = load i8*, i8** %var_rsi, align 8
  store i8* %rsi.13BF, i8** %var_rax, align 8
  store i64 2, i64* %var_rcx, align 8
  br label %loc_11C6

loc_1427:
  call void @___stack_chk_fail()
  unreachable
}