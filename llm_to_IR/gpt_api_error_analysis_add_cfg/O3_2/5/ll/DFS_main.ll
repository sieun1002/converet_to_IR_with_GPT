; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str.dfs = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@qword_2028 = external global i64

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() local_unnamed_addr {
entry_10e0:
  %canary.slot = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %rdx_var = alloca i64, align 8
  %rbp_var = alloca i64, align 8
  %rdi_var = alloca i64, align 8
  %result = alloca [8 x i64], align 16
  %r8_saved = alloca i64*, align 8
  %rsi_saved = alloca i32*, align 8
  %print_value = alloca i64, align 8
  %varF4 = alloca i64, align 8
  %varD0 = alloca i64, align 8
  %canary.init = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %canary.init, i64* %canary.slot, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4
  %qv = load i64, i64* @qword_2028, align 8
  store i64 %qv, i64* %varF4, align 8
  store i64 %qv, i64* %varD0, align 8
  %rbx.i8 = call i8* @calloc(i64 28, i64 1)
  %r13.i8 = call i8* @calloc(i64 56, i64 1)
  %r12.i8 = call i8* @malloc(i64 56)
  %rbx.null = icmp eq i8* %rbx.i8, null
  %r13.null = icmp eq i8* %r13.i8, null
  %any.null = or i1 %rbx.null, %r13.null
  br i1 %any.null, label %loc_1455, label %check_r12

check_r12:
  %r12.null = icmp eq i8* %r12.i8, null
  br i1 %r12.null, label %loc_1455, label %init_structs

init_structs:
  %r12.i64 = bitcast i8* %r12.i8 to i64*
  store i64 0, i64* %r12.i64, align 8
  store i64 0, i64* %rdx_var, align 8
  store i64 1, i64* %rbp_var, align 8
  store i64 1, i64* %rdi_var, align 8
  %rbx.i32 = bitcast i8* %rbx.i8 to i32*
  store i32 1, i32* %rbx.i32, align 4
  %r0p = getelementptr inbounds [8 x i64], [8 x i64]* %result, i64 0, i64 0
  store i64 0, i64* %r0p, align 8
  br label %loc_120D

loc_1208:
  %rdi1 = load i64, i64* %rdi_var, align 8
  %dec = add i64 %rdi1, -1
  %stack.idx.ptr = getelementptr inbounds i64, i64* %r12.i64, i64 %dec
  %curr.rd = load i64, i64* %stack.idx.ptr, align 8
  store i64 %curr.rd, i64* %rdx_var, align 8
  br label %loc_120D

loc_120D:
  %rdx0 = load i64, i64* %rdx_var, align 8
  %next.ptr = bitcast i8* %r13.i8 to i64*
  %r8.ptrptr = getelementptr inbounds i64, i64* %next.ptr, i64 %rdx0
  store i64* %r8.ptrptr, i64** %r8_saved, align 8
  %rax.val = load i64, i64* %r8.ptrptr, align 8
  %cmp.rax.gt6 = icmp ugt i64 %rax.val, 6
  br i1 %cmp.rax.gt6, label %loc_1412, label %cont_1227

cont_1227:
  %mul7 = mul i64 %rdx0, 7
  %idx0 = add i64 %mul7, %rax.val
  %adj.idx0.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx0
  %v0 = load i32, i32* %adj.idx0.ptr, align 4
  %adj.nonzero0 = icmp ne i32 %v0, 0
  br i1 %adj.nonzero0, label %check_visited_0, label %loc_1248

check_visited_0:
  %rsi0 = getelementptr inbounds i32, i32* %rbx.i32, i64 %rax.val
  store i32* %rsi0, i32** %rsi_saved, align 8
  %vis0 = load i32, i32* %rsi0, align 4
  %vis0.is.zero = icmp eq i32 %vis0, 0
  br i1 %vis0.is.zero, label %loc_13EA, label %loc_1248

loc_1248:
  %rdx1 = add i64 %rax.val, 1
  %rax.eq6 = icmp eq i64 %rax.val, 6
  br i1 %rax.eq6, label %loc_133D, label %cont_1256

cont_1256:
  %idx1 = add i64 %mul7, %rdx1
  %adj.idx1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx1
  %v1 = load i32, i32* %adj.idx1.ptr, align 4
  %adj.nonzero1 = icmp ne i32 %v1, 0
  br i1 %adj.nonzero1, label %check_visited_1, label %loc_1274

check_visited_1:
  %rsi1 = getelementptr inbounds i32, i32* %rbx.i32, i64 %rdx1
  store i32* %rsi1, i32** %rsi_saved, align 8
  %vis1 = load i32, i32* %rsi1, align 4
  %vis1.zero = icmp eq i32 %vis1, 0
  br i1 %vis1.zero, label %set_rdx1_and_push, label %loc_1274

set_rdx1_and_push:
  store i64 %rdx1, i64* %rdx_var, align 8
  br label %loc_13F0

loc_1274:
  %rdx2 = add i64 %rax.val, 2
  %rax.eq5 = icmp eq i64 %rax.val, 5
  br i1 %rax.eq5, label %loc_133D, label %cont_1282

cont_1282:
  %idx2 = add i64 %mul7, %rdx2
  %adj.idx2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx2
  %v2 = load i32, i32* %adj.idx2.ptr, align 4
  %adj.nonzero2 = icmp ne i32 %v2, 0
  br i1 %adj.nonzero2, label %check_visited_2, label %loc_12A0

check_visited_2:
  %rsi2 = getelementptr inbounds i32, i32* %rbx.i32, i64 %rdx2
  store i32* %rsi2, i32** %rsi_saved, align 8
  %vis2 = load i32, i32* %rsi2, align 4
  %vis2.zero = icmp eq i32 %vis2, 0
  br i1 %vis2.zero, label %set_rdx2_and_push, label %loc_12A0

set_rdx2_and_push:
  store i64 %rdx2, i64* %rdx_var, align 8
  br label %loc_13F0

loc_12A0:
  %rdx3 = add i64 %rax.val, 3
  %rax.eq4 = icmp eq i64 %rax.val, 4
  br i1 %rax.eq4, label %loc_133D, label %cont_12AE

cont_12AE:
  %idx3 = add i64 %mul7, %rdx3
  %adj.idx3.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx3
  %v3 = load i32, i32* %adj.idx3.ptr, align 4
  %adj.nonzero3 = icmp ne i32 %v3, 0
  br i1 %adj.nonzero3, label %check_visited_3, label %loc_12CC

check_visited_3:
  %rsi3 = getelementptr inbounds i32, i32* %rbx.i32, i64 %rdx3
  store i32* %rsi3, i32** %rsi_saved, align 8
  %vis3 = load i32, i32* %rsi3, align 4
  %vis3.zero = icmp eq i32 %vis3, 0
  br i1 %vis3.zero, label %set_rdx3_and_push, label %loc_12CC

set_rdx3_and_push:
  store i64 %rdx3, i64* %rdx_var, align 8
  br label %loc_13F0

loc_12CC:
  %rdx4 = add i64 %rax.val, 4
  %rax.eq3 = icmp eq i64 %rax.val, 3
  br i1 %rax.eq3, label %loc_133D, label %cont_12D6

cont_12D6:
  %idx4 = add i64 %mul7, %rdx4
  %adj.idx4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx4
  %v4 = load i32, i32* %adj.idx4.ptr, align 4
  %adj.nonzero4 = icmp ne i32 %v4, 0
  br i1 %adj.nonzero4, label %check_visited_4, label %loc_12F4

check_visited_4:
  %rsi4 = getelementptr inbounds i32, i32* %rbx.i32, i64 %rdx4
  store i32* %rsi4, i32** %rsi_saved, align 8
  %vis4 = load i32, i32* %rsi4, align 4
  %vis4.zero = icmp eq i32 %vis4, 0
  br i1 %vis4.zero, label %set_rdx4_and_push, label %loc_12F4

set_rdx4_and_push:
  store i64 %rdx4, i64* %rdx_var, align 8
  br label %loc_13F0

loc_12F4:
  %rdx5 = add i64 %rax.val, 5
  %rax.eq2 = icmp eq i64 %rax.val, 2
  br i1 %rax.eq2, label %loc_133D, label %cont_12FE

cont_12FE:
  %idx5 = add i64 %mul7, %rdx5
  %adj.idx5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx5
  %v5 = load i32, i32* %adj.idx5.ptr, align 4
  %adj.nonzero5 = icmp ne i32 %v5, 0
  br i1 %adj.nonzero5, label %check_visited_5, label %loc_131C

check_visited_5:
  %rsi5 = getelementptr inbounds i32, i32* %rbx.i32, i64 %rdx5
  store i32* %rsi5, i32** %rsi_saved, align 8
  %vis5 = load i32, i32* %rsi5, align 4
  %vis5.zero = icmp eq i32 %vis5, 0
  br i1 %vis5.zero, label %set_rdx5_and_push, label %loc_131C

set_rdx5_and_push:
  store i64 %rdx5, i64* %rdx_var, align 8
  br label %loc_13F0

loc_131C:
  %rax.is.zero = icmp eq i64 %rax.val, 0
  br i1 %rax.is.zero, label %cont_1321, label %loc_133D

cont_1321:
  %idx6 = add i64 %mul7, 6
  %adj.idx6.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx6
  %v6 = load i32, i32* %adj.idx6.ptr, align 4
  %v6.zero = icmp eq i32 %v6, 0
  br i1 %v6.zero, label %loc_133D, label %cont_1329

cont_1329:
  %vis6.ptr = getelementptr inbounds i32, i32* %rbx.i32, i64 6
  %vis6 = load i32, i32* %vis6.ptr, align 4
  store i32* %vis6.ptr, i32** %rsi_saved, align 8
  store i64 6, i64* %rdx_var, align 8
  %vis6.zero = icmp eq i32 %vis6, 0
  br i1 %vis6.zero, label %loc_13F0, label %loc_133D

loc_133D:
  %rdi2 = load i64, i64* %rdi_var, align 8
  %rdi.dec = add i64 %rdi2, -1
  store i64 %rdi.dec, i64* %rdi_var, align 8
  br label %loc_1341

loc_1341:
  %rdi3 = load i64, i64* %rdi_var, align 8
  %rdi.nonzero = icmp ne i64 %rdi3, 0
  br i1 %rdi.nonzero, label %loc_1208, label %after_loop

after_loop:
  call void @free(i8* %rbx.i8)
  call void @free(i8* %r13.i8)
  call void @free(i8* %r12.i8)
  %fmtptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.dfs, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtptr, i64 0)
  %rbp1 = load i64, i64* %rbp_var, align 8
  %rbp.is.zero = icmp eq i64 %rbp1, 0
  br i1 %rbp.is.zero, label %loc_13AE, label %cont_137c

cont_137c:
  %res0 = load i64, i64* %r0p, align 8
  store i64 %res0, i64* %print_value, align 8
  %rbp.eq1 = icmp eq i64 %rbp1, 1
  br i1 %rbp.eq1, label %loc_1398, label %loc_1421

loc_1398:
  %empty = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 1
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %pv = load i64, i64* %print_value, align 8
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2, i64 %pv, i8* %empty)
  br label %loc_13AE

loc_13AE:
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call3 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nlptr)
  %canary.now = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %saved = load i64, i64* %canary.slot, align 8
  %cmp.can = icmp ne i64 %saved, %canary.now
  br i1 %cmp.can, label %loc_1487, label %ret_ok

ret_ok:
  ret i32 0

loc_13EA:
  store i64 %rax.val, i64* %rdx_var, align 8
  br label %loc_13F0

loc_13F0:
  %rdx.push = load i64, i64* %rdx_var, align 8
  %rax.incr = add i64 %rdx.push, 1
  %rbp2 = load i64, i64* %rbp_var, align 8
  %res.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %result, i64 0, i64 %rbp2
  store i64 %rdx.push, i64* %res.ptr, align 8
  %rbp.inc = add i64 %rbp2, 1
  store i64 %rbp.inc, i64* %rbp_var, align 8
  %rdi4 = load i64, i64* %rdi_var, align 8
  %stack.pos.ptr = getelementptr inbounds i64, i64* %r12.i64, i64 %rdi4
  store i64 %rdx.push, i64* %stack.pos.ptr, align 8
  %rdi.inc = add i64 %rdi4, 1
  store i64 %rdi.inc, i64* %rdi_var, align 8
  %r8p = load i64*, i64** %r8_saved, align 8
  store i64 %rax.incr, i64* %r8p, align 8
  %rsip = load i32*, i32** %rsi_saved, align 8
  store i32 1, i32* %rsip, align 4
  br label %loc_1341

loc_1412:
  %rax.eq7 = icmp eq i64 %rax.val, 7
  br i1 %rax.eq7, label %loc_133D, label %loc_1208

loc_1421:
  %i.var = alloca i64, align 8
  store i64 1, i64* %i.var, align 8
  br label %loc_1430

loc_1430:
  %space = getelementptr inbounds [24 x i8], [24 x i8]* @.str.dfs, i64 0, i64 22
  %fmt3 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %i.cur = load i64, i64* %i.var, align 8
  %idxm1 = add i64 %i.cur, -1
  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %result, i64 0, i64 %idxm1
  %val = load i64, i64* %val.ptr, align 8
  %call.loop = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt3, i64 %val, i8* %space)
  br label %inc_1442

inc_1442:
  %i2 = add i64 %i.cur, 1
  store i64 %i2, i64* %i.var, align 8
  %rbp3 = load i64, i64* %rbp_var, align 8
  %cmp.i.rbp = icmp ne i64 %i2, %rbp3
  br i1 %cmp.i.rbp, label %loc_1430, label %loc_1450

loc_1450:
  %last.idx = add i64 %rbp3, -1
  %last.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %result, i64 0, i64 %last.idx
  %last = load i64, i64* %last.ptr, align 8
  store i64 %last, i64* %print_value, align 8
  br label %loc_1398

loc_1455:
  call void @free(i8* %rbx.i8)
  call void @free(i8* %r13.i8)
  call void @free(i8* %r12.i8)
  %fmtptr.err = getelementptr inbounds [24 x i8], [24 x i8]* @.str.dfs, i64 0, i64 0
  %call.err = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtptr.err, i64 0)
  br label %loc_13AE

loc_1487:
  call void @__stack_chk_fail()
  unreachable
}