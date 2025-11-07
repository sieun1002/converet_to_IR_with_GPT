; ModuleID = 'recovered_from_asm_main'
source_filename = "recovered_from_asm_main.ll"
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
declare void @__stack_chk_fail() noreturn

declare noalias i8* @calloc(i64 noundef, i64 noundef)
declare noalias i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i32 @__printf_chk(i32 noundef, i8* noundef, ...)

@asc_2022 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@aDfsPreorderFro = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@fmt_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() local_unnamed_addr {
loc_10e0:
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  %guard.slot = alloca i64, align 8
  store i64 %guard.load, i64* %guard.slot, align 8

  %mat = alloca [49 x i32], align 16
  %path = alloca [64 x i64], align 16

  %mat.i8 = bitcast [49 x i32]* %mat to i8*
  call void @llvm.memset.p0i8.i64(i8* %mat.i8, i8 0, i64 196, i1 false)

  %rbx.raw = call i8* @calloc(i64 28, i64 1)
  %r13.raw = call i8* @calloc(i64 56, i64 1)
  %r12.raw = call i8* @malloc(i64 56)

  %null.v = icmp eq i8* %rbx.raw, null
  %null.h = icmp eq i8* %r13.raw, null
  %or.null = or i1 %null.v, %null.h
  br i1 %or.null, label %loc_1455, label %loc_nonnull_after_first_checks

loc_nonnull_after_first_checks:
  %null.s = icmp eq i8* %r12.raw, null
  br i1 %null.s, label %loc_1455, label %loc_after_alloc_init

loc_after_alloc_init:
  %rbx = bitcast i8* %rbx.raw to i32*
  %r13 = bitcast i8* %r13.raw to i64*
  %r12 = bitcast i8* %r12.raw to i64*
  store i64 0, i64* %r12, align 8
  %visited0.ptr = getelementptr inbounds i32, i32* %rbx, i64 0
  store i32 1, i32* %visited0.ptr, align 4
  %path0.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %path, i64 0, i64 0
  store i64 0, i64* %path0.ptr, align 8
  br label %loc_120D

loc_1208:                                                   ; 0x1208
  %rdi.in.1208 = phi i64 [ %rdi.next, %loc_1341 ], [ %rdi.cur, %loc_1412 ]
  %rbp.in.1208 = phi i64 [ %rbp.next, %loc_1341 ], [ %rbp.cur, %loc_1412 ]
  %idx.top = add i64 %rdi.in.1208, -1
  %top.ptr = getelementptr inbounds i64, i64* %r12, i64 %idx.top
  %rdx.load = load i64, i64* %top.ptr, align 8
  br label %loc_120D

loc_120D:                                                   ; 0x120D
  %rdi.cur = phi i64 [ 1, %loc_after_alloc_init ], [ %rdi.in.1208, %loc_1208 ]
  %rbp.cur = phi i64 [ 1, %loc_after_alloc_init ], [ %rbp.in.1208, %loc_1208 ]
  %rdx.cur = phi i64 [ 0, %loc_after_alloc_init ], [ %rdx.load, %loc_1208 ]
  %r8.ptr = getelementptr inbounds i64, i64* %r13, i64 %rdx.cur
  %rax.val = load i64, i64* %r8.ptr, align 8
  %cmp.rax.gt6 = icmp ugt i64 %rax.val, 6
  br i1 %cmp.rax.gt6, label %loc_1412, label %loc_120D_after_cmp

loc_120D_after_cmp:
  %seven.rdx = mul i64 %rdx.cur, 7
  %idx0 = add i64 %seven.rdx, %rax.val
  %mat.base = getelementptr inbounds [49 x i32], [49 x i32]* %mat, i64 0, i64 0
  %mat0.ptr = getelementptr inbounds i32, i32* %mat.base, i64 %idx0
  %mat0 = load i32, i32* %mat0.ptr, align 4
  %mat0.iszero = icmp eq i32 %mat0, 0
  br i1 %mat0.iszero, label %loc_1248, label %loc_check_visited0

loc_check_visited0:
  %vptr0 = getelementptr inbounds i32, i32* %rbx, i64 %rax.val
  %v0 = load i32, i32* %vptr0, align 4
  %v0.iszero = icmp eq i32 %v0, 0
  br i1 %v0.iszero, label %loc_13EA, label %loc_1248

loc_1248:                                                   ; 0x1248
  %rdx.1 = add i64 %rax.val, 1
  %cmp.rax.eq6 = icmp eq i64 %rax.val, 6
  br i1 %cmp.rax.eq6, label %loc_133D, label %loc_1248_check_next

loc_1248_check_next:
  %idx1 = add i64 %seven.rdx, %rdx.1
  %mat1.ptr = getelementptr inbounds i32, i32* %mat.base, i64 %idx1
  %mat1 = load i32, i32* %mat1.ptr, align 4
  %mat1.iszero = icmp eq i32 %mat1, 0
  br i1 %mat1.iszero, label %loc_1274, label %loc_1248_check_visited

loc_1248_check_visited:
  %vptr1 = getelementptr inbounds i32, i32* %rbx, i64 %rdx.1
  %v1 = load i32, i32* %vptr1, align 4
  %v1.iszero = icmp eq i32 %v1, 0
  br i1 %v1.iszero, label %loc_13F0, label %loc_1274

loc_1274:                                                   ; 0x1274
  %rdx.2 = add i64 %rax.val, 2
  %cmp.rax.eq5 = icmp eq i64 %rax.val, 5
  br i1 %cmp.rax.eq5, label %loc_133D, label %loc_1274_check_next

loc_1274_check_next:
  %idx2 = add i64 %seven.rdx, %rdx.2
  %mat2.ptr = getelementptr inbounds i32, i32* %mat.base, i64 %idx2
  %mat2 = load i32, i32* %mat2.ptr, align 4
  %mat2.iszero = icmp eq i32 %mat2, 0
  br i1 %mat2.iszero, label %loc_12A0, label %loc_1274_check_visited

loc_1274_check_visited:
  %vptr2 = getelementptr inbounds i32, i32* %rbx, i64 %rdx.2
  %v2 = load i32, i32* %vptr2, align 4
  %v2.iszero = icmp eq i32 %v2, 0
  br i1 %v2.iszero, label %loc_13F0, label %loc_12A0

loc_12A0:                                                   ; 0x12A0
  %rdx.3 = add i64 %rax.val, 3
  %cmp.rax.eq4 = icmp eq i64 %rax.val, 4
  br i1 %cmp.rax.eq4, label %loc_133D, label %loc_12A0_check_next

loc_12A0_check_next:
  %idx3 = add i64 %seven.rdx, %rdx.3
  %mat3.ptr = getelementptr inbounds i32, i32* %mat.base, i64 %idx3
  %mat3 = load i32, i32* %mat3.ptr, align 4
  %mat3.iszero = icmp eq i32 %mat3, 0
  br i1 %mat3.iszero, label %loc_12CC, label %loc_12A0_check_visited

loc_12A0_check_visited:
  %vptr3 = getelementptr inbounds i32, i32* %rbx, i64 %rdx.3
  %v3 = load i32, i32* %vptr3, align 4
  %v3.iszero = icmp eq i32 %v3, 0
  br i1 %v3.iszero, label %loc_13F0, label %loc_12CC

loc_12CC:                                                   ; 0x12CC
  %rdx.4 = add i64 %rax.val, 4
  %cmp.rax.eq3 = icmp eq i64 %rax.val, 3
  br i1 %cmp.rax.eq3, label %loc_133D, label %loc_12CC_check_next

loc_12CC_check_next:
  %idx4 = add i64 %seven.rdx, %rdx.4
  %mat4.ptr = getelementptr inbounds i32, i32* %mat.base, i64 %idx4
  %mat4 = load i32, i32* %mat4.ptr, align 4
  %mat4.iszero = icmp eq i32 %mat4, 0
  br i1 %mat4.iszero, label %loc_12F4, label %loc_12CC_check_visited

loc_12CC_check_visited:
  %vptr4 = getelementptr inbounds i32, i32* %rbx, i64 %rdx.4
  %v4 = load i32, i32* %vptr4, align 4
  %v4.iszero = icmp eq i32 %v4, 0
  br i1 %v4.iszero, label %loc_13F0, label %loc_12F4

loc_12F4:                                                   ; 0x12F4
  %rdx.5 = add i64 %rax.val, 5
  %cmp.rax.eq2 = icmp eq i64 %rax.val, 2
  br i1 %cmp.rax.eq2, label %loc_133D, label %loc_12F4_check_next

loc_12F4_check_next:
  %idx5 = add i64 %seven.rdx, %rdx.5
  %mat5.ptr = getelementptr inbounds i32, i32* %mat.base, i64 %idx5
  %mat5 = load i32, i32* %mat5.ptr, align 4
  %mat5.iszero = icmp eq i32 %mat5, 0
  br i1 %mat5.iszero, label %loc_131C, label %loc_12F4_check_visited

loc_12F4_check_visited:
  %vptr5 = getelementptr inbounds i32, i32* %rbx, i64 %rdx.5
  %v5 = load i32, i32* %vptr5, align 4
  %v5.iszero = icmp eq i32 %v5, 0
  br i1 %v5.iszero, label %loc_13F0, label %loc_131C

loc_131C:                                                   ; 0x131C
  %rax.isnz = icmp ne i64 %rax.val, 0
  br i1 %rax.isnz, label %loc_133D, label %loc_131C_more

loc_131C_more:
  %idx6 = add i64 %seven.rdx, 6
  %mat6.ptr = getelementptr inbounds i32, i32* %mat.base, i64 %idx6
  %mat6 = load i32, i32* %mat6.ptr, align 4
  %mat6.iszero = icmp eq i32 %mat6, 0
  br i1 %mat6.iszero, label %loc_133D, label %loc_131C_check_vis6

loc_131C_check_vis6:
  %vptr6 = getelementptr inbounds i32, i32* %rbx, i64 6
  %v6 = load i32, i32* %vptr6, align 4
  %v6.iszero = icmp eq i32 %v6, 0
  br i1 %v6.iszero, label %loc_13F0, label %loc_133D

loc_133D:                                                   ; 0x133D
  %rdi.dec = sub i64 %rdi.cur, 1
  br label %loc_1341

loc_1341:                                                   ; 0x1341
  %rdi.next = phi i64 [ %rdi.dec, %loc_133D ], [ %rdi.inc, %loc_13F0 ]
  %rbp.next = phi i64 [ %rbp.cur, %loc_133D ], [ %rbp.inc, %loc_13F0 ]
  %rdi.nonzero = icmp ne i64 %rdi.next, 0
  br i1 %rdi.nonzero, label %loc_1208, label %loc_134A

loc_134A:
  call void @free(i8* %rbx.raw)
  call void @free(i8* %r13.raw)
  call void @free(i8* %r12.raw)
  %fmt.pre.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %zero.sz = add i64 0, 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.pre.ptr, i64 %zero.sz)
  %rbp.iszero = icmp eq i64 %rbp.next, 0
  br i1 %rbp.iszero, label %loc_13AE, label %loc_137C

loc_137C:
  %first.val.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %path, i64 0, i64 0
  %first.val = load i64, i64* %first.val.ptr, align 8
  %fmt.val.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @fmt_zu_s, i64 0, i64 0
  %rbp.ne.one = icmp ne i64 %rbp.next, 1
  br i1 %rbp.ne.one, label %loc_1421, label %loc_1398

loc_1398:                                                   ; 0x1398
  %empty.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 1
  call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.val.ptr, i64 %first.val, i8* %empty.ptr)
  br label %loc_13AE

loc_13AE:                                                   ; 0x13AE
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %guard.slot, align 8
  %guard.diff = icmp ne i64 %guard.now, %guard.saved
  br i1 %guard.diff, label %loc_1487, label %loc_ret

loc_ret:
  ret i32 0

loc_13EA:                                                   ; 0x13EA
  %vptr0.ea = getelementptr inbounds i32, i32* %rbx, i64 %rax.val
  br label %loc_13F0

loc_13F0:                                                   ; 0x13F0
  %rdx.neigh = phi i64 [ %rax.val, %loc_13EA ], [ %rdx.1, %loc_1248_check_visited ], [ %rdx.2, %loc_1274_check_visited ], [ %rdx.3, %loc_12A0_check_visited ], [ %rdx.4, %loc_12CC_check_visited ], [ %rdx.5, %loc_12F4_check_visited ], [ 6, %loc_131C_check_vis6 ]
  %rsi.vis.ptr = phi i32* [ %vptr0.ea, %loc_13EA ], [ %vptr1, %loc_1248_check_visited ], [ %vptr2, %loc_1274_check_visited ], [ %vptr3, %loc_12A0_check_visited ], [ %vptr4, %loc_12CC_check_visited ], [ %vptr5, %loc_12F4_check_visited ], [ %vptr6, %loc_131C_check_vis6 ]
  %r8.head.ptr = phi i64* [ %r8.ptr, %loc_13EA ], [ %r8.ptr, %loc_1248_check_visited ], [ %r8.ptr, %loc_1274_check_visited ], [ %r8.ptr, %loc_12A0_check_visited ], [ %r8.ptr, %loc_12CC_check_visited ], [ %r8.ptr, %loc_12F4_check_visited ], [ %r8.ptr, %loc_131C_check_vis6 ]
  %rax.next = add i64 %rdx.neigh, 1
  %path.store.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %path, i64 0, i64 %rbp.cur
  store i64 %rdx.neigh, i64* %path.store.ptr, align 8
  %rbp.inc = add i64 %rbp.cur, 1
  %stack.store.ptr = getelementptr inbounds i64, i64* %r12, i64 %rdi.cur
  store i64 %rdx.neigh, i64* %stack.store.ptr, align 8
  %rdi.inc = add i64 %rdi.cur, 1
  store i64 %rax.next, i64* %r8.head.ptr, align 8
  store i32 1, i32* %rsi.vis.ptr, align 4
  br label %loc_1341

loc_1412:                                                   ; 0x1412
  %cmp.rax.ne7 = icmp ne i64 %rax.val, 7
  br i1 %cmp.rax.ne7, label %loc_1208, label %loc_133D

loc_1421:                                                   ; 0x1421
  br label %loc_1430

loc_1430:                                                   ; 0x1430
  %i.loop = phi i64 [ 1, %loc_1421 ], [ %i.next, %loc_1430 ]
  %i.prev = add i64 %i.loop, -1
  %val.ptr.loop = getelementptr inbounds [64 x i64], [64 x i64]* %path, i64 0, i64 %i.prev
  %val.loop = load i64, i64* %val.ptr.loop, align 8
  %space.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 22
  %fmt.val.loop.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @fmt_zu_s, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.val.loop.ptr, i64 %val.loop, i8* %space.ptr)
  %i.next = add i64 %i.loop, 1
  %cmp.cont = icmp ne i64 %i.next, %rbp.next
  br i1 %cmp.cont, label %loc_1430, label %loc_1398

loc_1455:                                                   ; 0x1455
  call void @free(i8* %rbx.raw)
  call void @free(i8* %r13.raw)
  call void @free(i8* %r12.raw)
  %fmt.pre.ptr2 = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %zero.sz.2 = add i64 0, 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.pre.ptr2, i64 %zero.sz.2)
  br label %loc_13AE

loc_1487:                                                   ; 0x1487
  call void @__stack_chk_fail()
  unreachable
}