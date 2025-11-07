; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@asc_2022 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@aDfsPreorderFro = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@qword_2028 = external global i8*

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main() {
bb_10e0:
  %canary.save = alloca i64, align 8
  %adj = alloca [64 x i32], align 16
  %order = alloca [64 x i64], align 16
  %rbx_p = alloca i8*, align 8
  %r13_p = alloca i8*, align 8
  %r12_p = alloca i8*, align 8
  %rdi_cnt = alloca i64, align 8
  %rbp_cnt = alloca i64, align 8
  %dummy1 = alloca i8*, align 8
  %dummy2 = alloca i8*, align 8
  %can0 = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %can0, i64* %canary.save, align 8
  %adj.bc = bitcast [64 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.bc, i8 0, i64 256, i1 false)
  %q = load i8*, i8** @qword_2028
  store i8* %q, i8** %dummy1, align 8
  store i8* %q, i8** %dummy2, align 8
  %adj_i7 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj_i7, align 4
  %adj_i14 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj_i14, align 4
  %adj_i22 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj_i22, align 4
  %adj_i29 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj_i29, align 4
  %adj_i19 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj_i19, align 4
  %adj_i37 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj_i37, align 4
  %adj_i33 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj_i33, align 4
  %adj_i39 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj_i39, align 4
  %adj_i41 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj_i41, align 4
  %adj_i47 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj_i47, align 4
  %rbx0 = call i8* @calloc(i64 28, i64 1)
  store i8* %rbx0, i8** %rbx_p, align 8
  %r13_0 = call i8* @calloc(i64 56, i64 1)
  store i8* %r13_0, i8** %r13_p, align 8
  %r12_0 = call i8* @malloc(i64 56)
  store i8* %r12_0, i8** %r12_p, align 8
  %rbx.null = icmp eq i8* %rbx0, null
  %r13.null = icmp eq i8* %r13_0, null
  %r12.null = icmp eq i8* %r12_0, null
  %tmp.or0 = or i1 %rbx.null, %r13.null
  %anynull = or i1 %tmp.or0, %r12.null
  br i1 %anynull, label %bb_1455, label %bb_11e0

bb_11e0:
  %r12_i64p.init = bitcast i8* %r12_0 to i64*
  store i64 0, i64* %r12_i64p.init, align 8
  store i64 1, i64* %rbp_cnt, align 8
  store i64 1, i64* %rdi_cnt, align 8
  %rbx_i32p0 = bitcast i8* %rbx0 to i32*
  store i32 1, i32* %rbx_i32p0, align 4
  %ord0 = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 0
  store i64 0, i64* %ord0, align 8
  br label %bb_120d

bb_1208:
  %r12.1 = load i8*, i8** %r12_p, align 8
  %r12.1.i64 = bitcast i8* %r12.1 to i64*
  %rdi.cur = load i64, i64* %rdi_cnt, align 8
  %rdi.m1 = add i64 %rdi.cur, -1
  %stack.elem.ptr = getelementptr inbounds i64, i64* %r12.1.i64, i64 %rdi.m1
  %rdx.from.stack = load i64, i64* %stack.elem.ptr, align 8
  br label %bb_120d

bb_120d:
  %rdx.phi = phi i64 [ 0, %bb_11e0 ], [ %rdx.from.stack, %bb_1208 ]
  %r13.cur = load i8*, i8** %r13_p, align 8
  %rcx.mul8 = mul i64 %rdx.phi, 8
  %r8.ptr.i8 = getelementptr inbounds i8, i8* %r13.cur, i64 %rcx.mul8
  %r8.ptr = bitcast i8* %r8.ptr.i8 to i64*
  %a = load i64, i64* %r8.ptr, align 8
  %a.gt6 = icmp ugt i64 %a, 6
  br i1 %a.gt6, label %bb_1412, label %bb_a_le6

bb_a_le6:
  %rcx.sub = sub i64 %rcx.mul8, %rdx.phi
  %idx0 = add i64 %rcx.sub, %a
  %adj.idx0 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 %idx0
  %adj.val0 = load i32, i32* %adj.idx0, align 4
  %is0 = icmp eq i32 %adj.val0, 0
  br i1 %is0, label %bb_1248, label %bb_chk_vis0

bb_chk_vis0:
  %rbx.cur0 = load i8*, i8** %rbx_p, align 8
  %a.shl2 = shl i64 %a, 2
  %rsi0.i8 = getelementptr inbounds i8, i8* %rbx.cur0, i64 %a.shl2
  %rsi0 = bitcast i8* %rsi0.i8 to i32*
  %vis0 = load i32, i32* %rsi0, align 4
  %vis0.is0 = icmp eq i32 %vis0, 0
  br i1 %vis0.is0, label %bb_13ea, label %bb_1248

bb_13ea:
  br label %bb_13f0

bb_1248:
  %cand1 = add i64 %a, 1
  %a.eq6 = icmp eq i64 %a, 6
  br i1 %a.eq6, label %bb_133d, label %bb_c1_chk

bb_c1_chk:
  %idx1 = add i64 %rcx.sub, %cand1
  %adj.idx1 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 %idx1
  %adj.val1 = load i32, i32* %adj.idx1, align 4
  %is1 = icmp eq i32 %adj.val1, 0
  br i1 %is1, label %bb_1274, label %bb_visit1

bb_visit1:
  %rbx.cur1 = load i8*, i8** %rbx_p, align 8
  %cand1.shl2 = shl i64 %cand1, 2
  %rsi1.i8 = getelementptr inbounds i8, i8* %rbx.cur1, i64 %cand1.shl2
  %rsi1 = bitcast i8* %rsi1.i8 to i32*
  %vis1 = load i32, i32* %rsi1, align 4
  %vis1.is0 = icmp eq i32 %vis1, 0
  br i1 %vis1.is0, label %bb_13f0_from1, label %bb_1274

bb_1274:
  %cand2 = add i64 %a, 2
  %a.eq5 = icmp eq i64 %a, 5
  br i1 %a.eq5, label %bb_133d, label %bb_c2_chk

bb_c2_chk:
  %idx2 = add i64 %rcx.sub, %cand2
  %adj.idx2 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 %idx2
  %adj.val2 = load i32, i32* %adj.idx2, align 4
  %is2 = icmp eq i32 %adj.val2, 0
  br i1 %is2, label %bb_12a0, label %bb_visit2

bb_visit2:
  %rbx.cur2 = load i8*, i8** %rbx_p, align 8
  %cand2.shl2 = shl i64 %cand2, 2
  %rsi2.i8 = getelementptr inbounds i8, i8* %rbx.cur2, i64 %cand2.shl2
  %rsi2 = bitcast i8* %rsi2.i8 to i32*
  %vis2 = load i32, i32* %rsi2, align 4
  %vis2.is0 = icmp eq i32 %vis2, 0
  br i1 %vis2.is0, label %bb_13f0_from2, label %bb_12a0

bb_12a0:
  %cand3 = add i64 %a, 3
  %a.eq4 = icmp eq i64 %a, 4
  br i1 %a.eq4, label %bb_133d, label %bb_c3_chk

bb_c3_chk:
  %idx3 = add i64 %rcx.sub, %cand3
  %adj.idx3 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 %idx3
  %adj.val3 = load i32, i32* %adj.idx3, align 4
  %is3 = icmp eq i32 %adj.val3, 0
  br i1 %is3, label %bb_12cc, label %bb_visit3

bb_visit3:
  %rbx.cur3 = load i8*, i8** %rbx_p, align 8
  %cand3.shl2 = shl i64 %cand3, 2
  %rsi3.i8 = getelementptr inbounds i8, i8* %rbx.cur3, i64 %cand3.shl2
  %rsi3 = bitcast i8* %rsi3.i8 to i32*
  %vis3 = load i32, i32* %rsi3, align 4
  %vis3.is0 = icmp eq i32 %vis3, 0
  br i1 %vis3.is0, label %bb_13f0_from3, label %bb_12cc

bb_12cc:
  %cand4 = add i64 %a, 4
  %a.eq3 = icmp eq i64 %a, 3
  br i1 %a.eq3, label %bb_133d, label %bb_c4_chk

bb_c4_chk:
  %idx4 = add i64 %rcx.sub, %cand4
  %adj.idx4 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 %idx4
  %adj.val4 = load i32, i32* %adj.idx4, align 4
  %is4 = icmp eq i32 %adj.val4, 0
  br i1 %is4, label %bb_12f4, label %bb_visit4

bb_visit4:
  %rbx.cur4 = load i8*, i8** %rbx_p, align 8
  %cand4.shl2 = shl i64 %cand4, 2
  %rsi4.i8 = getelementptr inbounds i8, i8* %rbx.cur4, i64 %cand4.shl2
  %rsi4 = bitcast i8* %rsi4.i8 to i32*
  %vis4 = load i32, i32* %rsi4, align 4
  %vis4.is0 = icmp eq i32 %vis4, 0
  br i1 %vis4.is0, label %bb_13f0_from4, label %bb_12f4

bb_12f4:
  %cand5 = add i64 %a, 5
  %a.eq2 = icmp eq i64 %a, 2
  br i1 %a.eq2, label %bb_133d, label %bb_c5_chk

bb_c5_chk:
  %idx5 = add i64 %rcx.sub, %cand5
  %adj.idx5 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 %idx5
  %adj.val5 = load i32, i32* %adj.idx5, align 4
  %is5 = icmp eq i32 %adj.val5, 0
  br i1 %is5, label %bb_131c, label %bb_visit5

bb_visit5:
  %rbx.cur5 = load i8*, i8** %rbx_p, align 8
  %cand5.shl2 = shl i64 %cand5, 2
  %rsi5.i8 = getelementptr inbounds i8, i8* %rbx.cur5, i64 %cand5.shl2
  %rsi5 = bitcast i8* %rsi5.i8 to i32*
  %vis5 = load i32, i32* %rsi5, align 4
  %vis5.is0 = icmp eq i32 %vis5, 0
  br i1 %vis5.is0, label %bb_13f0_from5, label %bb_131c

bb_131c:
  %a.ne0 = icmp ne i64 %a, 0
  br i1 %a.ne0, label %bb_133d, label %bb_1321

bb_1321:
  %idx6 = add i64 %rcx.sub, 6
  %adj.idx6 = getelementptr inbounds [64 x i32], [64 x i32]* %adj, i64 0, i64 %idx6
  %adj.val6 = load i32, i32* %adj.idx6, align 4
  %is6 = icmp eq i32 %adj.val6, 0
  br i1 %is6, label %bb_133d, label %bb_1329

bb_1329:
  %rbx.cur6 = load i8*, i8** %rbx_p, align 8
  %rsi6.i8 = getelementptr inbounds i8, i8* %rbx.cur6, i64 24
  %rsi6 = bitcast i8* %rsi6.i8 to i32*
  %vis6 = load i32, i32* %rsi6, align 4
  %vis6.is0 = icmp eq i32 %vis6, 0
  br i1 %vis6.is0, label %bb_13f0_from6, label %bb_133d

bb_13f0_from1:
  br label %bb_13f0

bb_13f0_from2:
  br label %bb_13f0

bb_13f0_from3:
  br label %bb_13f0

bb_13f0_from4:
  br label %bb_13f0

bb_13f0_from5:
  br label %bb_13f0

bb_13f0_from6:
  br label %bb_13f0

bb_13f0:
  %chosen = phi i64 [ %a, %bb_13ea ], [ %cand1, %bb_13f0_from1 ], [ %cand2, %bb_13f0_from2 ], [ %cand3, %bb_13f0_from3 ], [ %cand4, %bb_13f0_from4 ], [ %cand5, %bb_13f0_from5 ], [ 6, %bb_13f0_from6 ]
  %rsi.chosen = phi i32* [ %rsi0, %bb_13ea ], [ %rsi1, %bb_13f0_from1 ], [ %rsi2, %bb_13f0_from2 ], [ %rsi3, %bb_13f0_from3 ], [ %rsi4, %bb_13f0_from4 ], [ %rsi5, %bb_13f0_from5 ], [ %rsi6, %bb_13f0_from6 ]
  %r8.keep = phi i64* [ %r8.ptr, %bb_13ea ], [ %r8.ptr, %bb_13f0_from1 ], [ %r8.ptr, %bb_13f0_from2 ], [ %r8.ptr, %bb_13f0_from3 ], [ %r8.ptr, %bb_13f0_from4 ], [ %r8.ptr, %bb_13f0_from5 ], [ %r8.ptr, %bb_13f0_from6 ]
  %next = add i64 %chosen, 1
  %rbp.cur = load i64, i64* %rbp_cnt, align 8
  %ord.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 %rbp.cur
  store i64 %chosen, i64* %ord.ptr, align 8
  %rbp.inc = add i64 %rbp.cur, 1
  store i64 %rbp.inc, i64* %rbp_cnt, align 8
  %r12.cur = load i8*, i8** %r12_p, align 8
  %r12.cur.i64 = bitcast i8* %r12.cur to i64*
  %rdi.cur2 = load i64, i64* %rdi_cnt, align 8
  %stack.store.ptr = getelementptr inbounds i64, i64* %r12.cur.i64, i64 %rdi.cur2
  store i64 %chosen, i64* %stack.store.ptr, align 8
  %rdi.inc = add i64 %rdi.cur2, 1
  store i64 %rdi.inc, i64* %rdi_cnt, align 8
  store i64 %next, i64* %r8.keep, align 8
  store i32 1, i32* %rsi.chosen, align 4
  br label %bb_1341

bb_133d:
  %rdi.cur3 = load i64, i64* %rdi_cnt, align 8
  %rdi.dec = add i64 %rdi.cur3, -1
  store i64 %rdi.dec, i64* %rdi_cnt, align 8
  %rdi.nz = icmp ne i64 %rdi.dec, 0
  br i1 %rdi.nz, label %bb_1208, label %bb_134a

bb_1341:
  %rdi.cur4 = load i64, i64* %rdi_cnt, align 8
  %rdi.nz2 = icmp ne i64 %rdi.cur4, 0
  br i1 %rdi.nz2, label %bb_1208, label %bb_134a

bb_134a:
  %rbx.free = load i8*, i8** %rbx_p, align 8
  call void @free(i8* %rbx.free)
  %r13.free = load i8*, i8** %r13_p, align 8
  call void @free(i8* %r13.free)
  %r12.free = load i8*, i8** %r12_p, align 8
  call void @free(i8* %r12.free)
  %fmt.hdr = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.hdr, i64 0)
  %rbp.final = load i64, i64* %rbp_cnt, align 8
  %rbp.is0 = icmp eq i64 %rbp.final, 0
  br i1 %rbp.is0, label %bb_13ae, label %bb_137c

bb_137c:
  %ord0.ld = load i64, i64* %ord0, align 8
  %fmt.num = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %rbp.eq1 = icmp eq i64 %rbp.final, 1
  br i1 %rbp.eq1, label %bb_1398, label %bb_1421

bb_1398:
  %empty = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 1
  %call.one = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.num, i64 %ord0.ld, i8* %empty)
  br label %bb_13ae

bb_13ae:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl)
  %can1 = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %can.saved = load i64, i64* %canary.save, align 8
  %can.diff = icmp ne i64 %can.saved, %can1
  br i1 %can.diff, label %bb_1487, label %bb_13d8

bb_13d8:
  ret i32 0

bb_1412:
  %a.ne7 = icmp ne i64 %a, 7
  br i1 %a.ne7, label %bb_1208, label %bb_133d

bb_1421:
  %space = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 22
  %order.base = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 0
  %call.first = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.num, i64 %ord0.ld, i8* %space)
  br label %bb_1430

bb_1430:
  %i.phi = phi i64 [ 1, %bb_1421 ], [ %i.next, %bb_1430 ]
  %elem.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.phi
  %rdx.loop = load i64, i64* %elem.ptr, align 8
  %call.loop = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.num, i64 %rdx.loop, i8* %space)
  %i.next = add i64 %i.phi, 1
  %cmp.end = icmp ne i64 %i.next, %rbp.final
  br i1 %cmp.end, label %bb_1430, label %bb_1450

bb_1450:
  br label %bb_1398

bb_1455:
  %rbx.f = load i8*, i8** %rbx_p, align 8
  call void @free(i8* %rbx.f)
  %r13.f = load i8*, i8** %r13_p, align 8
  call void @free(i8* %r13.f)
  %r12.f = load i8*, i8** %r12_p, align 8
  call void @free(i8* %r12.f)
  %fmt.h = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %call.h = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.h, i64 0)
  br label %bb_13ae

bb_1487:
  call void @__stack_chk_fail()
  unreachable
}