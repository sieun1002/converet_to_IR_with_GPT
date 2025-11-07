; ModuleID = 'reconstructed_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = internal constant <4 x i32> <i32 10, i32 9, i32 8, i32 7>, align 16
@xmmword_2020 = internal constant <4 x i32> <i32 6, i32 5, i32 4, i32 3>, align 16
@unk_2004 = internal constant [4 x i8] c"%d \00", align 1
@unk_2008 = internal constant [2 x i8] c"\0A\00", align 1

@__stack_chk_guard = external global i64

declare void @__stack_chk_fail() noreturn
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
L1080:
  %stack = alloca [48 x i8], align 16
  %rbp.slot = alloca i8*, align 8
  %rbx.slot = alloca i8*, align 8
  %rsi.slot = alloca i8*, align 8
  %rdi.slot = alloca i8*, align 8
  %rax.slot = alloca i8*, align 8
  %rcx.slot = alloca i64, align 8
  %edx.slot = alloca i32, align 4
  %r8d.slot = alloca i32, align 4
  %r12.slot = alloca i8*, align 8
  %canary.slot = alloca i64, align 8
  store i64 0, i64* %rcx.slot, align 8
  %guard.ptr = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.ptr, i64* %canary.slot, align 8
  %arr.base.gep = getelementptr inbounds [48 x i8], [48 x i8]* %stack, i64 0, i64 0
  store i8* %arr.base.gep, i8** %rbp.slot, align 8
  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %arr0.ptr = bitcast i8* %arr.base.gep to <4 x i32>*
  store <4 x i32> %vec1, <4 x i32>* %arr0.ptr, align 16
  %vec2 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %arr16.gep = getelementptr inbounds i8, i8* %arr.base.gep, i64 16
  %arr16.ptr = bitcast i8* %arr16.gep to <4 x i32>*
  store <4 x i32> %vec2, <4 x i32>* %arr16.ptr, align 16
  %arr32.gep = getelementptr inbounds i8, i8* %arr.base.gep, i64 32
  %arr32.ptr = bitcast i8* %arr32.gep to i32*
  store i32 4, i32* %arr32.ptr, align 4
  store i8* %arr.base.gep, i8** %rbx.slot, align 8
  store i8* %arr.base.gep, i8** %rsi.slot, align 8
  br label %L10D0

L10D0:
  %rsi.ld.10d0 = load i8*, i8** %rsi.slot, align 8
  %rsi.plus4.10d0 = getelementptr inbounds i8, i8* %rsi.ld.10d0, i64 4
  %rsi.plus4.i32ptr.10d0 = bitcast i8* %rsi.plus4.10d0 to i32*
  %edx.ld.10d0 = load i32, i32* %rsi.plus4.i32ptr.10d0, align 4
  store i32 %edx.ld.10d0, i32* %edx.slot, align 4
  %rsi.i32ptr.10d0 = bitcast i8* %rsi.ld.10d0 to i32*
  %r8d.ld.10d0 = load i32, i32* %rsi.i32ptr.10d0, align 4
  store i32 %r8d.ld.10d0, i32* %r8d.slot, align 4
  store i8* %rsi.plus4.10d0, i8** %rdi.slot, align 8
  store i8* %rsi.ld.10d0, i8** %rax.slot, align 8
  %r8d.cmp.src = load i32, i32* %r8d.slot, align 4
  %edx.cmp.src = load i32, i32* %edx.slot, align 4
  %cmp.le.10d0 = icmp sle i32 %r8d.cmp.src, %edx.cmp.src
  br i1 %cmp.le.10d0, label %loc_12C3, label %L10E6

L10E6:
  %rsi.ld.10e6 = load i8*, i8** %rsi.slot, align 8
  %rsi.plus4.10e6 = getelementptr inbounds i8, i8* %rsi.ld.10e6, i64 4
  %rsi.plus4.i32ptr.10e6 = bitcast i8* %rsi.plus4.10e6 to i32*
  %r8d.store.10e6 = load i32, i32* %r8d.slot, align 4
  store i32 %r8d.store.10e6, i32* %rsi.plus4.i32ptr.10e6, align 4
  %rcx.ld.10ea = load i64, i64* %rcx.slot, align 8
  %rcx.iszero.10ea = icmp eq i64 %rcx.ld.10ea, 0
  br i1 %rcx.iszero.10ea, label %loc_1234, label %loc_10F3

loc_10F3:
  %rax.ld.10f3 = load i8*, i8** %rax.slot, align 8
  %rax.minus4.10f3 = getelementptr inbounds i8, i8* %rax.ld.10f3, i64 -4
  %rax.minus4.i32ptr.10f3 = bitcast i8* %rax.minus4.10f3 to i32*
  %r8d.ld.10f3 = load i32, i32* %rax.minus4.i32ptr.10f3, align 4
  store i32 %r8d.ld.10f3, i32* %r8d.slot, align 4
  %edx.ld.10f3 = load i32, i32* %edx.slot, align 4
  %cmp.le.10f7 = icmp sle i32 %r8d.ld.10f3, %edx.ld.10f3
  br i1 %cmp.le.10f7, label %loc_125B, label %L1100

L1100:
  %rax.ld.1100 = load i8*, i8** %rax.slot, align 8
  %rax.i32ptr.1100 = bitcast i8* %rax.ld.1100 to i32*
  %r8d.to.store.1100 = load i32, i32* %r8d.slot, align 4
  store i32 %r8d.to.store.1100, i32* %rax.i32ptr.1100, align 4
  %rcx.ld.1103 = load i64, i64* %rcx.slot, align 8
  %cmp.eq.rcx.1 = icmp eq i64 %rcx.ld.1103, 1
  br i1 %cmp.eq.rcx.1, label %loc_1263, label %L110D

L110D:
  %rax.ld.110d = load i8*, i8** %rax.slot, align 8
  %rax.minus8.110d = getelementptr inbounds i8, i8* %rax.ld.110d, i64 -8
  %rax.minus8.i32ptr.110d = bitcast i8* %rax.minus8.110d to i32*
  %r8d.ld.110d = load i32, i32* %rax.minus8.i32ptr.110d, align 4
  store i32 %r8d.ld.110d, i32* %r8d.slot, align 4
  %edx.ld.1111 = load i32, i32* %edx.slot, align 4
  %cmp.le.1111 = icmp sle i32 %r8d.ld.110d, %edx.ld.1111
  br i1 %cmp.le.1111, label %loc_1296, label %L111A

L111A:
  %rax.ld.111a = load i8*, i8** %rax.slot, align 8
  %rax.minus4.111a = getelementptr inbounds i8, i8* %rax.ld.111a, i64 -4
  %rax.minus4.i32ptr.111a = bitcast i8* %rax.minus4.111a to i32*
  %r8d.store.111a = load i32, i32* %r8d.slot, align 4
  store i32 %r8d.store.111a, i32* %rax.minus4.i32ptr.111a, align 4
  %rcx.ld.111e = load i64, i64* %rcx.slot, align 8
  %cmp.eq.rcx.2 = icmp eq i64 %rcx.ld.111e, 2
  br i1 %cmp.eq.rcx.2, label %loc_12A2, label %L1128

L1128:
  %rax.ld.1128 = load i8*, i8** %rax.slot, align 8
  %rax.minus12.1128 = getelementptr inbounds i8, i8* %rax.ld.1128, i64 -12
  %rax.minus12.i32ptr.1128 = bitcast i8* %rax.minus12.1128 to i32*
  %r8d.ld.1128 = load i32, i32* %rax.minus12.i32ptr.1128, align 4
  store i32 %r8d.ld.1128, i32* %r8d.slot, align 4
  %edx.ld.112c = load i32, i32* %edx.slot, align 4
  %cmp.le.112c = icmp sle i32 %r8d.ld.1128, %edx.ld.112c
  br i1 %cmp.le.112c, label %loc_12CE, label %L1135

L1135:
  %rax.ld.1135 = load i8*, i8** %rax.slot, align 8
  %rax.minus8.1135 = getelementptr inbounds i8, i8* %rax.ld.1135, i64 -8
  %rax.minus8.i32ptr.1135 = bitcast i8* %rax.minus8.1135 to i32*
  %r8d.store.1135 = load i32, i32* %r8d.slot, align 4
  store i32 %r8d.store.1135, i32* %rax.minus8.i32ptr.1135, align 4
  %rcx.ld.1139 = load i64, i64* %rcx.slot, align 8
  %cmp.eq.rcx.3 = icmp eq i64 %rcx.ld.1139, 3
  br i1 %cmp.eq.rcx.3, label %loc_12DA, label %L1143

L1143:
  %rax.ld.1143 = load i8*, i8** %rax.slot, align 8
  %rax.minus16.1143 = getelementptr inbounds i8, i8* %rax.ld.1143, i64 -16
  %rax.minus16.i32ptr.1143 = bitcast i8* %rax.minus16.1143 to i32*
  %r8d.ld.1143 = load i32, i32* %rax.minus16.i32ptr.1143, align 4
  store i32 %r8d.ld.1143, i32* %r8d.slot, align 4
  %edx.ld.1147 = load i32, i32* %edx.slot, align 4
  %cmp.le.1147 = icmp sle i32 %r8d.ld.1143, %edx.ld.1147
  br i1 %cmp.le.1147, label %loc_12FB, label %L1150

L1150:
  %rax.ld.1150 = load i8*, i8** %rax.slot, align 8
  %rax.minus12.1150 = getelementptr inbounds i8, i8* %rax.ld.1150, i64 -12
  %rax.minus12.i32ptr.1150 = bitcast i8* %rax.minus12.1150 to i32*
  %r8d.store.1150 = load i32, i32* %r8d.slot, align 4
  store i32 %r8d.store.1150, i32* %rax.minus12.i32ptr.1150, align 4
  %rcx.ld.1154 = load i64, i64* %rcx.slot, align 8
  %cmp.eq.rcx.4 = icmp eq i64 %rcx.ld.1154, 4
  br i1 %cmp.eq.rcx.4, label %loc_1307, label %L115E

L115E:
  %rax.ld.115e = load i8*, i8** %rax.slot, align 8
  %rax.minus20.115e = getelementptr inbounds i8, i8* %rax.ld.115e, i64 -20
  %rax.minus20.i32ptr.115e = bitcast i8* %rax.minus20.115e to i32*
  %r8d.ld.115e = load i32, i32* %rax.minus20.i32ptr.115e, align 4
  store i32 %r8d.ld.115e, i32* %r8d.slot, align 4
  %edx.ld.1162 = load i32, i32* %edx.slot, align 4
  %cmp.le.1162 = icmp sle i32 %r8d.ld.115e, %edx.ld.1162
  br i1 %cmp.le.1162, label %loc_132B, label %L116B

L116B:
  %rax.ld.116b = load i8*, i8** %rax.slot, align 8
  %rax.minus16.116b = getelementptr inbounds i8, i8* %rax.ld.116b, i64 -16
  %rax.minus16.i32ptr.116b = bitcast i8* %rax.minus16.116b to i32*
  %r8d.store.116b = load i32, i32* %r8d.slot, align 4
  store i32 %r8d.store.116b, i32* %rax.minus16.i32ptr.116b, align 4
  %rcx.ld.116f = load i64, i64* %rcx.slot, align 8
  %cmp.eq.rcx.5 = icmp eq i64 %rcx.ld.116f, 5
  br i1 %cmp.eq.rcx.5, label %loc_1337, label %L1179

L1179:
  %rax.ld.1179 = load i8*, i8** %rax.slot, align 8
  %rax.minus24.1179 = getelementptr inbounds i8, i8* %rax.ld.1179, i64 -24
  %rax.minus24.i32ptr.1179 = bitcast i8* %rax.minus24.1179 to i32*
  %r8d.ld.1179 = load i32, i32* %rax.minus24.i32ptr.1179, align 4
  store i32 %r8d.ld.1179, i32* %r8d.slot, align 4
  %edx.ld.117d = load i32, i32* %edx.slot, align 4
  %cmp.le.117d = icmp sle i32 %r8d.ld.1179, %edx.ld.117d
  br i1 %cmp.le.117d, label %loc_135B, label %L1186

L1186:
  %rax.ld.1186 = load i8*, i8** %rax.slot, align 8
  %rax.minus20.1186 = getelementptr inbounds i8, i8* %rax.ld.1186, i64 -20
  %rax.minus20.i32ptr.1186 = bitcast i8* %rax.minus20.1186 to i32*
  %r8d.store.1186 = load i32, i32* %r8d.slot, align 4
  store i32 %r8d.store.1186, i32* %rax.minus20.i32ptr.1186, align 4
  %rcx.ld.118a = load i64, i64* %rcx.slot, align 8
  %cmp.eq.rcx.6 = icmp eq i64 %rcx.ld.118a, 6
  br i1 %cmp.eq.rcx.6, label %loc_1367, label %L1194

L1194:
  %rax.ld.1194 = load i8*, i8** %rax.slot, align 8
  %rax.minus28.1194 = getelementptr inbounds i8, i8* %rax.ld.1194, i64 -28
  %rax.minus28.i32ptr.1194 = bitcast i8* %rax.minus28.1194 to i32*
  %r8d.ld.1194 = load i32, i32* %rax.minus28.i32ptr.1194, align 4
  store i32 %r8d.ld.1194, i32* %r8d.slot, align 4
  %edx.ld.1198 = load i32, i32* %edx.slot, align 4
  %cmp.le.1198 = icmp sle i32 %r8d.ld.1194, %edx.ld.1198
  br i1 %cmp.le.1198, label %loc_1387, label %L11A1

L11A1:
  %rax.ld.11a1 = load i8*, i8** %rax.slot, align 8
  %rax.minus24.11a1 = getelementptr inbounds i8, i8* %rax.ld.11a1, i64 -24
  %rax.minus24.i32ptr.11a1 = bitcast i8* %rax.minus24.11a1 to i32*
  %r8d.store.11a1 = load i32, i32* %r8d.slot, align 4
  store i32 %r8d.store.11a1, i32* %rax.minus24.i32ptr.11a1, align 4
  %rcx.ld.11a5 = load i64, i64* %rcx.slot, align 8
  %cmp.eq.rcx.7 = icmp eq i64 %rcx.ld.11a5, 7
  br i1 %cmp.eq.rcx.7, label %loc_1393, label %L11AF

L11AF:
  %rax.ld.11af = load i8*, i8** %rax.slot, align 8
  %rax.minus32.11af = getelementptr inbounds i8, i8* %rax.ld.11af, i64 -32
  %rax.minus32.i32ptr.11af = bitcast i8* %rax.minus32.11af to i32*
  %r8d.ld.11af = load i32, i32* %rax.minus32.i32ptr.11af, align 4
  store i32 %r8d.ld.11af, i32* %r8d.slot, align 4
  %edx.ld.11b3 = load i32, i32* %edx.slot, align 4
  %cmp.le.11b3 = icmp sle i32 %r8d.ld.11af, %edx.ld.11b3
  br i1 %cmp.le.11b3, label %loc_13B3, label %L11BC

L11BC:
  %rdi.ld.11bc = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.11bc, i8** %rsi.slot, align 8
  %rbp.ld.11c3 = load i8*, i8** %rbp.slot, align 8
  store i8* %rbp.ld.11c3, i8** %rax.slot, align 8
  br label %loc_11C6

loc_1234:
  %arr.base.ld.1234 = load i8*, i8** %rbp.slot, align 8
  %arr0.i32ptr.1234 = bitcast i8* %arr.base.ld.1234 to i32*
  %edx.save.1234 = load i32, i32* %edx.slot, align 4
  store i32 %edx.save.1234, i32* %arr0.i32ptr.1234, align 4
  %rdi.ld.1234 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1234 = getelementptr inbounds i8, i8* %rdi.ld.1234, i64 4
  %rdi.plus4.i32ptr.1234 = bitcast i8* %rdi.plus4.1234 to i32*
  %edx.load.next.1234 = load i32, i32* %rdi.plus4.i32ptr.1234, align 4
  store i32 %edx.load.next.1234, i32* %edx.slot, align 4
  %rsi.ld.1234 = load i8*, i8** %rsi.slot, align 8
  %rsi.plus8.1234 = getelementptr inbounds i8, i8* %rsi.ld.1234, i64 8
  store i8* %rsi.plus8.1234, i8** %rsi.slot, align 8
  store i8* %rdi.ld.1234, i8** %rax.slot, align 8
  %rdi.i32ptr.1241 = bitcast i8* %rdi.ld.1234 to i32*
  %ecx.from.mem.1241 = load i32, i32* %rdi.i32ptr.1241, align 4
  %edx.cur.1243 = load i32, i32* %edx.slot, align 4
  %cmp.le.1243 = icmp sle i32 %ecx.from.mem.1241, %edx.cur.1243
  br i1 %cmp.le.1243, label %loc_13CC, label %L124B

L124B:
  %rdi.ld.124b = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.124b = getelementptr inbounds i8, i8* %rdi.ld.124b, i64 4
  %rdi.plus4.i32ptr.124b = bitcast i8* %rdi.plus4.124b to i32*
  %ecx.to.store.124b = load i32, i32* %rdi.i32ptr.1241, align 4
  store i32 %ecx.to.store.124b, i32* %rdi.plus4.i32ptr.124b, align 4
  %rsi.swap.tmp.124e = load i8*, i8** %rsi.slot, align 8
  %rdi.swap.tmp.124e = load i8*, i8** %rdi.slot, align 8
  store i8* %rsi.swap.tmp.124e, i8** %rdi.slot, align 8
  store i8* %rdi.swap.tmp.124e, i8** %rsi.slot, align 8
  store i64 1, i64* %rcx.slot, align 8
  br label %loc_10F3

loc_125B:
  %rdi.ld.125b = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.125b, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1263:
  %arr.base.ld.1263 = load i8*, i8** %rbp.slot, align 8
  %arr0.i32ptr.1263 = bitcast i8* %arr.base.ld.1263 to i32*
  %edx.save.1263 = load i32, i32* %edx.slot, align 4
  store i32 %edx.save.1263, i32* %arr0.i32ptr.1263, align 4
  %rdi.ld.1263 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1266 = getelementptr inbounds i8, i8* %rdi.ld.1263, i64 4
  %rdi.plus4.i32ptr.1266 = bitcast i8* %rdi.plus4.1266 to i32*
  %edx.next.1266 = load i32, i32* %rdi.plus4.i32ptr.1266, align 4
  store i32 %edx.next.1266, i32* %edx.slot, align 4
  store i8* %rdi.plus4.1266, i8** %rsi.slot, align 8
  store i8* %rdi.ld.1263, i8** %rax.slot, align 8
  %rdi.i32ptr.1270 = bitcast i8* %rdi.ld.1263 to i32*
  %ecx.mem.1270 = load i32, i32* %rdi.i32ptr.1270, align 4
  %edx.cur.1272 = load i32, i32* %edx.slot, align 4
  %cmp.sge.1272 = icmp sge i32 %edx.cur.1272, %ecx.mem.1270
  br i1 %cmp.sge.1272, label %loc_13BF, label %L127A

L127A:
  %rdi.plus4.i32ptr.127a = bitcast i8* %rdi.plus4.1266 to i32*
  store i32 %ecx.mem.1270, i32* %rdi.plus4.i32ptr.127a, align 4
  store i64 2, i64* %rcx.slot, align 8
  br label %loc_1288

loc_1288:
  %rsi.ld.1288 = load i8*, i8** %rsi.slot, align 8
  %rdi.ld.1288 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.1288, i8** %rsi.slot, align 8
  store i8* %rsi.ld.1288, i8** %rdi.slot, align 8
  br label %loc_10F3

loc_1296:
  %rsi.ld.1296 = load i8*, i8** %rsi.slot, align 8
  %rax.new.1296 = getelementptr inbounds i8, i8* %rsi.ld.1296, i64 -4
  store i8* %rax.new.1296, i8** %rax.slot, align 8
  %rdi.ld.129a = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.129a, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_12A2:
  %arr.base.ld.12a2 = load i8*, i8** %rbp.slot, align 8
  %arr0.i32ptr.12a2 = bitcast i8* %arr.base.ld.12a2 to i32*
  %edx.save.12a2 = load i32, i32* %edx.slot, align 4
  store i32 %edx.save.12a2, i32* %arr0.i32ptr.12a2, align 4
  %rdi.ld.12a2 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.12a5 = getelementptr inbounds i8, i8* %rdi.ld.12a2, i64 4
  %rdi.plus4.i32ptr.12a5 = bitcast i8* %rdi.plus4.12a5 to i32*
  %edx.next.12a5 = load i32, i32* %rdi.plus4.i32ptr.12a5, align 4
  store i32 %edx.next.12a5, i32* %edx.slot, align 4
  store i8* %rdi.plus4.12a5, i8** %rsi.slot, align 8
  store i8* %rdi.ld.12a2, i8** %rax.slot, align 8
  %rdi.i32ptr.12af = bitcast i8* %rdi.ld.12a2 to i32*
  %ecx.mem.12af = load i32, i32* %rdi.i32ptr.12af, align 4
  %edx.cur.12b1 = load i32, i32* %edx.slot, align 4
  %cmp.le.12b1 = icmp sle i32 %ecx.mem.12af, %edx.cur.12b1
  br i1 %cmp.le.12b1, label %loc_1400, label %L12B9

L12B9:
  %rdi.plus4.i32ptr.12b9 = bitcast i8* %rdi.plus4.12a5 to i32*
  store i32 %ecx.mem.12af, i32* %rdi.plus4.i32ptr.12b9, align 4
  store i64 3, i64* %rcx.slot, align 8
  br label %loc_1288

loc_12C3:
  %rdi.ld.12c3 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.12c3, i8** %rsi.slot, align 8
  store i8* %rdi.ld.12c3, i8** %rax.slot, align 8
  br label %loc_11C6

loc_12CE:
  %rsi.ld.12ce = load i8*, i8** %rsi.slot, align 8
  %rax.new.12ce = getelementptr inbounds i8, i8* %rsi.ld.12ce, i64 -8
  store i8* %rax.new.12ce, i8** %rax.slot, align 8
  %rdi.ld.12d2 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.12d2, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_12DA:
  %arr.base.ld.12da = load i8*, i8** %rbp.slot, align 8
  %arr0.i32ptr.12da = bitcast i8* %arr.base.ld.12da to i32*
  %edx.save.12da = load i32, i32* %edx.slot, align 4
  store i32 %edx.save.12da, i32* %arr0.i32ptr.12da, align 4
  %rdi.ld.12da = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.12dd = getelementptr inbounds i8, i8* %rdi.ld.12da, i64 4
  %rdi.plus4.i32ptr.12dd = bitcast i8* %rdi.plus4.12dd to i32*
  %edx.next.12dd = load i32, i32* %rdi.plus4.i32ptr.12dd, align 4
  store i32 %edx.next.12dd, i32* %edx.slot, align 4
  store i8* %rdi.plus4.12dd, i8** %rsi.slot, align 8
  store i8* %rdi.ld.12da, i8** %rax.slot, align 8
  %rdi.i32ptr.12e7 = bitcast i8* %rdi.ld.12da to i32*
  %ecx.mem.12e7 = load i32, i32* %rdi.i32ptr.12e7, align 4
  %edx.cur.12e9 = load i32, i32* %edx.slot, align 4
  %cmp.sge.12e9 = icmp sge i32 %edx.cur.12e9, %ecx.mem.12e7
  br i1 %cmp.sge.12e9, label %loc_140D, label %L12F1

L12F1:
  %rdi.plus4.i32ptr.12f1 = bitcast i8* %rdi.plus4.12dd to i32*
  store i32 %ecx.mem.12e7, i32* %rdi.plus4.i32ptr.12f1, align 4
  store i64 4, i64* %rcx.slot, align 8
  br label %loc_1288

loc_12FB:
  %rsi.ld.12fb = load i8*, i8** %rsi.slot, align 8
  %rax.new.12fb = getelementptr inbounds i8, i8* %rsi.ld.12fb, i64 -12
  store i8* %rax.new.12fb, i8** %rax.slot, align 8
  %rdi.ld.12ff = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.12ff, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1307:
  %arr.base.ld.1307 = load i8*, i8** %rbp.slot, align 8
  %arr0.i32ptr.1307 = bitcast i8* %arr.base.ld.1307 to i32*
  %edx.save.1307 = load i32, i32* %edx.slot, align 4
  store i32 %edx.save.1307, i32* %arr0.i32ptr.1307, align 4
  %rdi.ld.1307 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.130a = getelementptr inbounds i8, i8* %rdi.ld.1307, i64 4
  %rdi.plus4.i32ptr.130a = bitcast i8* %rdi.plus4.130a to i32*
  %edx.next.130a = load i32, i32* %rdi.plus4.i32ptr.130a, align 4
  store i32 %edx.next.130a, i32* %edx.slot, align 4
  store i8* %rdi.plus4.130a, i8** %rsi.slot, align 8
  store i8* %rdi.ld.1307, i8** %rax.slot, align 8
  %rdi.i32ptr.1314 = bitcast i8* %rdi.ld.1307 to i32*
  %ecx.mem.1314 = load i32, i32* %rdi.i32ptr.1314, align 4
  %edx.cur.1316 = load i32, i32* %edx.slot, align 4
  %cmp.sge.1316 = icmp sge i32 %edx.cur.1316, %ecx.mem.1314
  br i1 %cmp.sge.1316, label %loc_13E6, label %L131E

L131E:
  %rdi.plus4.i32ptr.131e = bitcast i8* %rdi.plus4.130a to i32*
  store i32 %ecx.mem.1314, i32* %rdi.plus4.i32ptr.131e, align 4
  store i64 5, i64* %rcx.slot, align 8
  br label %loc_1288

loc_132B:
  %rsi.ld.132b = load i8*, i8** %rsi.slot, align 8
  %rax.new.132b = getelementptr inbounds i8, i8* %rsi.ld.132b, i64 -16
  store i8* %rax.new.132b, i8** %rax.slot, align 8
  %rdi.ld.132f = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.132f, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1337:
  %arr.base.ld.1337 = load i8*, i8** %rbp.slot, align 8
  %arr0.i32ptr.1337 = bitcast i8* %arr.base.ld.1337 to i32*
  %edx.save.1337 = load i32, i32* %edx.slot, align 4
  store i32 %edx.save.1337, i32* %arr0.i32ptr.1337, align 4
  %rdi.ld.1337 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.133a = getelementptr inbounds i8, i8* %rdi.ld.1337, i64 4
  %rdi.plus4.i32ptr.133a = bitcast i8* %rdi.plus4.133a to i32*
  %edx.next.133a = load i32, i32* %rdi.plus4.i32ptr.133a, align 4
  store i32 %edx.next.133a, i32* %edx.slot, align 4
  store i8* %rdi.plus4.133a, i8** %rsi.slot, align 8
  store i8* %rdi.ld.1337, i8** %rax.slot, align 8
  %rdi.i32ptr.1344 = bitcast i8* %rdi.ld.1337 to i32*
  %ecx.mem.1344 = load i32, i32* %rdi.i32ptr.1344, align 4
  %edx.cur.1346 = load i32, i32* %edx.slot, align 4
  %cmp.sge.1346 = icmp sge i32 %edx.cur.1346, %ecx.mem.1344
  br i1 %cmp.sge.1346, label %loc_13F3, label %L134E

L134E:
  %rdi.plus4.i32ptr.134e = bitcast i8* %rdi.plus4.133a to i32*
  store i32 %ecx.mem.1344, i32* %rdi.plus4.i32ptr.134e, align 4
  store i64 6, i64* %rcx.slot, align 8
  br label %loc_1288

loc_135B:
  %rsi.ld.135b = load i8*, i8** %rsi.slot, align 8
  %rax.new.135b = getelementptr inbounds i8, i8* %rsi.ld.135b, i64 -20
  store i8* %rax.new.135b, i8** %rax.slot, align 8
  %rdi.ld.135f = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.135f, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1367:
  %arr.base.ld.1367 = load i8*, i8** %rbp.slot, align 8
  %arr0.i32ptr.1367 = bitcast i8* %arr.base.ld.1367 to i32*
  %edx.save.1367 = load i32, i32* %edx.slot, align 4
  store i32 %edx.save.1367, i32* %arr0.i32ptr.1367, align 4
  %rdi.ld.1367 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.136a = getelementptr inbounds i8, i8* %rdi.ld.1367, i64 4
  %rdi.plus4.i32ptr.136a = bitcast i8* %rdi.plus4.136a to i32*
  %edx.next.136a = load i32, i32* %rdi.plus4.i32ptr.136a, align 4
  store i32 %edx.next.136a, i32* %edx.slot, align 4
  store i8* %rdi.plus4.136a, i8** %rsi.slot, align 8
  store i8* %rdi.ld.1367, i8** %rax.slot, align 8
  %rdi.i32ptr.1374 = bitcast i8* %rdi.ld.1367 to i32*
  %ecx.mem.1374 = load i32, i32* %rdi.i32ptr.1374, align 4
  %edx.cur.1376 = load i32, i32* %edx.slot, align 4
  %cmp.sge.1376 = icmp sge i32 %edx.cur.1376, %ecx.mem.1374
  br i1 %cmp.sge.1376, label %loc_13D9, label %L137A

L137A:
  %rdi.plus4.i32ptr.137a = bitcast i8* %rdi.plus4.136a to i32*
  store i32 %ecx.mem.1374, i32* %rdi.plus4.i32ptr.137a, align 4
  store i64 7, i64* %rcx.slot, align 8
  br label %loc_1288

loc_1387:
  %rsi.ld.1387 = load i8*, i8** %rsi.slot, align 8
  %rax.new.1387 = getelementptr inbounds i8, i8* %rsi.ld.1387, i64 -24
  store i8* %rax.new.1387, i8** %rax.slot, align 8
  %rdi.ld.138b = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.138b, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_1393:
  %arr.base.ld.1393 = load i8*, i8** %rbp.slot, align 8
  %arr0.i32ptr.1393 = bitcast i8* %arr.base.ld.1393 to i32*
  %edx.save.1393 = load i32, i32* %edx.slot, align 4
  store i32 %edx.save.1393, i32* %arr0.i32ptr.1393, align 4
  %rdi.ld.1393 = load i8*, i8** %rdi.slot, align 8
  %rdi.plus4.1396 = getelementptr inbounds i8, i8* %rdi.ld.1393, i64 4
  %rdi.plus4.i32ptr.1396 = bitcast i8* %rdi.plus4.1396 to i32*
  %edx.next.1396 = load i32, i32* %rdi.plus4.i32ptr.1396, align 4
  store i32 %edx.next.1396, i32* %edx.slot, align 4
  store i8* %rdi.plus4.1396, i8** %rsi.slot, align 8
  store i8* %rdi.ld.1393, i8** %rax.slot, align 8
  %rdi.i32ptr.13a0 = bitcast i8* %rdi.ld.1393 to i32*
  %ecx.mem.13a0 = load i32, i32* %rdi.i32ptr.13a0, align 4
  %edx.cur.13a2 = load i32, i32* %edx.slot, align 4
  %cmp.sge.13a2 = icmp sge i32 %edx.cur.13a2, %ecx.mem.13a0
  br i1 %cmp.sge.13a2, label %loc_141A, label %L13A6

L13A6:
  %rdi.plus4.i32ptr.13a6 = bitcast i8* %rdi.plus4.1396 to i32*
  store i32 %ecx.mem.13a0, i32* %rdi.plus4.i32ptr.13a6, align 4
  store i64 8, i64* %rcx.slot, align 8
  br label %loc_1288

loc_13B3:
  %rsi.ld.13b3 = load i8*, i8** %rsi.slot, align 8
  %rax.new.13b3 = getelementptr inbounds i8, i8* %rsi.ld.13b3, i64 -28
  store i8* %rax.new.13b3, i8** %rax.slot, align 8
  %rdi.ld.13b7 = load i8*, i8** %rdi.slot, align 8
  store i8* %rdi.ld.13b7, i8** %rsi.slot, align 8
  br label %loc_11C6

loc_13BF:
  %rsi.ld.13bf = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.ld.13bf, i8** %rax.slot, align 8
  store i64 2, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_13CC:
  %rsi.ld.13cc = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.ld.13cc, i8** %rax.slot, align 8
  store i64 1, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_13D9:
  %rsi.ld.13d9 = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.ld.13d9, i8** %rax.slot, align 8
  store i64 7, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_13E6:
  %rsi.ld.13e6 = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.ld.13e6, i8** %rax.slot, align 8
  store i64 5, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_13F3:
  %rsi.ld.13f3 = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.ld.13f3, i8** %rax.slot, align 8
  store i64 6, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_1400:
  %rsi.ld.1400 = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.ld.1400, i8** %rax.slot, align 8
  store i64 3, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_140D:
  %rsi.ld.140d = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.ld.140d, i8** %rax.slot, align 8
  store i64 4, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_141A:
  %rsi.ld.141a = load i8*, i8** %rsi.slot, align 8
  store i8* %rsi.ld.141a, i8** %rax.slot, align 8
  store i64 8, i64* %rcx.slot, align 8
  br label %loc_11C6

loc_11C6:
  %rcx.ld.11c6 = load i64, i64* %rcx.slot, align 8
  %rcx.inc.11c6 = add i64 %rcx.ld.11c6, 1
  store i64 %rcx.inc.11c6, i64* %rcx.slot, align 8
  %rax.ld.11ca = load i8*, i8** %rax.slot, align 8
  %rax.i32ptr.11ca = bitcast i8* %rax.ld.11ca to i32*
  %edx.ld.11ca = load i32, i32* %edx.slot, align 4
  store i32 %edx.ld.11ca, i32* %rax.i32ptr.11ca, align 4
  %rcx.ld.11cc = load i64, i64* %rcx.slot, align 8
  %cmp.ne.11cc = icmp ne i64 %rcx.ld.11cc, 9
  br i1 %cmp.ne.11cc, label %L10D0, label %L11D6

L11D6:
  %rbp.ld.11d6 = load i8*, i8** %rbp.slot, align 8
  %rbp.plus40.11d6 = getelementptr inbounds i8, i8* %rbp.ld.11d6, i64 40
  store i8* %rbp.plus40.11d6, i8** %rbp.slot, align 8
  %fmt.ptr.11da = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  store i8* %fmt.ptr.11da, i8** %r12.slot, align 8
  br label %loc_11E8

loc_11E8:
  %rbx.ld.11e8 = load i8*, i8** %rbx.slot, align 8
  %rbx.i32ptr.11e8 = bitcast i8* %rbx.ld.11e8 to i32*
  %edx.prn.11e8 = load i32, i32* %rbx.i32ptr.11e8, align 4
  %fmt.load.11ea = load i8*, i8** %r12.slot, align 8
  %rbx.plus4.11f4 = getelementptr inbounds i8, i8* %rbx.ld.11e8, i64 4
  store i8* %rbx.plus4.11f4, i8** %rbx.slot, align 8
  %call.printf.loop = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.load.11ea, i32 %edx.prn.11e8)
  %rbp.ld.11fd = load i8*, i8** %rbp.slot, align 8
  %rbx.ld.11fd = load i8*, i8** %rbx.slot, align 8
  %cmp.ne.1200 = icmp ne i8* %rbp.ld.11fd, %rbx.ld.11fd
  br i1 %cmp.ne.1200, label %loc_11E8, label %L1202

L1202:
  %nl.ptr.1204 = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.printf.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr.1204)
  %canary.saved.1215 = load i64, i64* %canary.slot, align 8
  %canary.cur.121a = load i64, i64* @__stack_chk_guard, align 8
  %canary.eq.1223 = icmp eq i64 %canary.saved.1215, %canary.cur.121a
  br i1 %canary.eq.1223, label %L1229, label %loc_1427

L1229:
  ret i32 0

loc_1427:
  call void @__stack_chk_fail()
  unreachable
}