; ModuleID = 'reconstructed'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@qword_2028 = external global i64

@aDfsPreorderFro = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@asc_2022 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
bb_10e0:
  ; locals and “register” emulation
  %canary = alloca i64, align 8
  %matrix = alloca [49 x i32], align 16
  %order = alloca [8 x i64], align 16
  %rbx.ptr = alloca i8*, align 8
  %r12.ptr = alloca i8*, align 8
  %r13.ptr = alloca i8*, align 8
  %r8.ptr = alloca i8*, align 8
  %rsi.ptr = alloca i8*, align 8
  %v_rdi = alloca i64, align 8
  %v_rbp = alloca i64, align 8
  %v_rax = alloca i64, align 8
  %v_rdx = alloca i64, align 8
  %v_rcx = alloca i64, align 8
  %tmp64a = alloca i64, align 8
  %tmp64b = alloca i64, align 8

  ; stack canary load (fs:0x28 modeled via global)
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8

  ; zero-init matrix (rep stosq region)
  %m.cast = bitcast [49 x i32]* %matrix to i8*
  call void @llvm.memset.p0i8.i64(i8* %m.cast, i8 0, i64 196, i1 false)

  ; qword_2028 copied to two locals (var_F4 and var_D0 analogues)
  %q2028a = load i64, i64* @qword_2028, align 8
  store i64 %q2028a, i64* %tmp64a, align 8
  %q2028b = load i64, i64* @qword_2028, align 8
  store i64 %q2028b, i64* %tmp64b, align 8

  ; set scattered adjacency entries (var_* = 1)
  ; indices relative to var_F8 base: 7, 14, 22, 29, 19, 37, 33, 39, 41, 47
  %gep7 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 7
  store i32 1, i32* %gep7, align 4
  %gep14 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 14
  store i32 1, i32* %gep14, align 4
  %gep22 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 22
  store i32 1, i32* %gep22, align 4
  %gep29 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 29
  store i32 1, i32* %gep29, align 4
  %gep19 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 19
  store i32 1, i32* %gep19, align 4
  %gep37 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 37
  store i32 1, i32* %gep37, align 4
  %gep33 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 33
  store i32 1, i32* %gep33, align 4
  %gep39 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 39
  store i32 1, i32* %gep39, align 4
  %gep41 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 41
  store i32 1, i32* %gep41, align 4
  %gep47 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 47
  store i32 1, i32* %gep47, align 4

  ; explicitly set matrix[0] = 0 (already zeroed)
  %gep0 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 0
  store i32 0, i32* %gep0, align 4

  ; calloc(0x1C, 1)
  store i8* null, i8** %rbx.ptr, align 8
  store i8* null, i8** %r13.ptr, align 8
  store i8* null, i8** %r12.ptr, align 8
  %c1 = call i8* @calloc(i64 28, i64 1)
  store i8* %c1, i8** %rbx.ptr, align 8

  ; calloc(0x38, 1)
  %c2 = call i8* @calloc(i64 56, i64 1)
  store i8* %c2, i8** %r13.ptr, align 8

  ; malloc(0x38)
  %m1 = call i8* @malloc(i64 56)
  store i8* %m1, i8** %r12.ptr, align 8

  ; test rbx || r13
  %rbx.ld0 = load i8*, i8** %rbx.ptr, align 8
  %t0 = icmp eq i8* %rbx.ld0, null
  %r13.ld0 = load i8*, i8** %r13.ptr, align 8
  %t1 = icmp eq i8* %r13.ld0, null
  %or.null = or i1 %t0, %t1
  br i1 %or.null, label %bb_1455, label %bb_11d7

bb_11d7:
  ; test r12
  %r12.ld0 = load i8*, i8** %r12.ptr, align 8
  %t2 = icmp eq i8* %r12.ld0, null
  br i1 %t2, label %bb_1455, label %bb_11e0

bb_11e0:
  ; [r12] = 0
  %r12.q = bitcast i8* %r12.ld0 to i64*
  store i64 0, i64* %r12.q, align 8
  ; edx = 0 (keep v_rdx clear)
  store i64 0, i64* %v_rdx, align 8
  ; ebp = 1
  store i64 1, i64* %v_rbp, align 8
  ; edi = 1
  store i64 1, i64* %v_rdi, align 8
  ; dword [rbx] = 1
  %rbx.ld1 = load i8*, i8** %rbx.ptr, align 8
  %rbx.i32 = bitcast i8* %rbx.ld1 to i32*
  store i32 1, i32* %rbx.i32, align 4
  ; order[0] = 0
  %ord0 = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 0
  store i64 0, i64* %ord0, align 8
  br label %bb_120d

; fall-in from multiple sites
bb_1208:
  ; rdx = [r12 + rdi*8 - 8]
  %r12.ld1 = load i8*, i8** %r12.ptr, align 8
  %rdi.ld0 = load i64, i64* %v_rdi, align 8
  %ofs.pre = mul i64 %rdi.ld0, 8
  %ofs = sub i64 %ofs.pre, 8
  %p.idx = getelementptr i8, i8* %r12.ld1, i64 %ofs
  %p.idx64 = bitcast i8* %p.idx to i64*
  %rdx.val = load i64, i64* %p.idx64, align 8
  store i64 %rdx.val, i64* %v_rdx, align 8
  br label %bb_120d

bb_120d:
  ; rcx = rdx * 8
  %rdx.ld0 = load i64, i64* %v_rdx, align 8
  %rcx.mul = shl i64 %rdx.ld0, 3
  store i64 %rcx.mul, i64* %v_rcx, align 8
  ; r8 = r13 + rcx
  %r13.ld1 = load i8*, i8** %r13.ptr, align 8
  %r8.addr = getelementptr i8, i8* %r13.ld1, i64 %rcx.mul
  store i8* %r8.addr, i8** %r8.ptr, align 8
  ; rax = [r8]
  %r8.qp = bitcast i8* %r8.addr to i64*
  %rax.ld = load i64, i64* %r8.qp, align 8
  store i64 %rax.ld, i64* %v_rax, align 8
  ; cmp rax, 6 ; ja -> bb_1412
  %cmp.a.6 = icmp ugt i64 %rax.ld, 6
  br i1 %cmp.a.6, label %bb_1412, label %bb_1227

; internal continuation for neighbor checks starting at 0x1227
bb_1227:
  ; rcx = rcx - rdx
  %rcx.ld0 = load i64, i64* %v_rcx, align 8
  %rdx.ld1 = load i64, i64* %v_rdx, align 8
  %rcx.sub = sub i64 %rcx.ld0, %rdx.ld1
  ; rdx2 = rax + rcx
  %rax.ld1 = load i64, i64* %v_rax, align 8
  %rdx2 = add i64 %rax.ld1, %rcx.sub
  ; load matrix[rdx2]
  %m.idx0 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %rdx2
  %m.v0 = load i32, i32* %m.idx0, align 4
  %m.v0.z = icmp eq i32 %m.v0, 0
  br i1 %m.v0.z, label %bb_1248, label %bb_1238

bb_1238:
  ; rsi = &visited[rax]
  %rbx.ld2 = load i8*, i8** %rbx.ptr, align 8
  %rax.ld2 = load i64, i64* %v_rax, align 8
  %vis.ofs0 = shl i64 %rax.ld2, 2
  %vis.ptr0.i8 = getelementptr i8, i8* %rbx.ld2, i64 %vis.ofs0
  store i8* %vis.ptr0.i8, i8** %rsi.ptr, align 8
  %vis.ptr0 = bitcast i8* %vis.ptr0.i8 to i32*
  %vis.val0 = load i32, i32* %vis.ptr0, align 4
  %vis.zero0 = icmp eq i32 %vis.val0, 0
  br i1 %vis.zero0, label %bb_13ea, label %bb_1248

bb_1248:
  ; rdx = rax + 1
  %rax.ld3 = load i64, i64* %v_rax, align 8
  %rdx.n1 = add i64 %rax.ld3, 1
  ; cmp rax, 6 ; jz 133D
  %cmp.eq.6 = icmp eq i64 %rax.ld3, 6
  br i1 %cmp.eq.6, label %bb_133d, label %bb_1256

bb_1256:
  ; check matrix[u, rdx.n1]
  %rcx.sub1 = sub i64 %rcx.ld0, %rdx.ld1
  %si.idx1 = add i64 %rax.ld3, 1
  %rdx1 = add i64 %si.idx1, %rcx.sub1
  %m.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %rdx1
  %m.v1 = load i32, i32* %m.idx1, align 4
  %m.v1.z = icmp eq i32 %m.v1, 0
  br i1 %m.v1.z, label %bb_1274, label %bb_1264

bb_1264:
  ; rsi = &visited[rdx.n1]
  %rbx.ld3 = load i8*, i8** %rbx.ptr, align 8
  %vis.ofs1 = shl i64 %rdx.n1, 2
  %vis.ptr1.i8 = getelementptr i8, i8* %rbx.ld3, i64 %vis.ofs1
  store i8* %vis.ptr1.i8, i8** %rsi.ptr, align 8
  %vis.ptr1 = bitcast i8* %vis.ptr1.i8 to i32*
  %vis.val1 = load i32, i32* %vis.ptr1, align 4
  %vis.zero1 = icmp eq i32 %vis.val1, 0
  br i1 %vis.zero1, label %bb_13f0_from_n1, label %bb_1274

bb_1274:
  ; rdx = rax + 2
  %rdx.n2 = add i64 %rax.ld3, 2
  ; cmp rax, 5 ; jz 133D
  %cmp.eq.5 = icmp eq i64 %rax.ld3, 5
  br i1 %cmp.eq.5, label %bb_133d, label %bb_1282

bb_1282:
  ; check matrix[u, rdx.n2]
  %rcx.sub2 = sub i64 %rcx.ld0, %rdx.ld1
  %rdx2.idx = add i64 %rdx.n2, %rcx.sub2
  %m.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %rdx2.idx
  %m.v2 = load i32, i32* %m.idx2, align 4
  %m.v2.z = icmp eq i32 %m.v2, 0
  br i1 %m.v2.z, label %bb_12a0, label %bb_1290

bb_1290:
  ; rsi = &visited[rdx.n2]
  %rbx.ld4 = load i8*, i8** %rbx.ptr, align 8
  %vis.ofs2 = shl i64 %rdx.n2, 2
  %vis.ptr2.i8 = getelementptr i8, i8* %rbx.ld4, i64 %vis.ofs2
  store i8* %vis.ptr2.i8, i8** %rsi.ptr, align 8
  %vis.ptr2 = bitcast i8* %vis.ptr2.i8 to i32*
  %vis.val2 = load i32, i32* %vis.ptr2, align 4
  %vis.zero2 = icmp eq i32 %vis.val2, 0
  br i1 %vis.zero2, label %bb_13f0_from_n2, label %bb_12a0

bb_12a0:
  ; rdx = rax + 3
  %rdx.n3 = add i64 %rax.ld3, 3
  ; cmp rax, 4 ; jz 133D
  %cmp.eq.4 = icmp eq i64 %rax.ld3, 4
  br i1 %cmp.eq.4, label %bb_133d, label %bb_12ae

bb_12ae:
  ; check matrix[u, rdx.n3]
  %rcx.sub3 = sub i64 %rcx.ld0, %rdx.ld1
  %rdx3.idx = add i64 %rdx.n3, %rcx.sub3
  %m.idx3 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %rdx3.idx
  %m.v3 = load i32, i32* %m.idx3, align 4
  %m.v3.z = icmp eq i32 %m.v3, 0
  br i1 %m.v3.z, label %bb_12cc, label %bb_12bc

bb_12bc:
  ; rsi = &visited[rdx.n3]
  %rbx.ld5 = load i8*, i8** %rbx.ptr, align 8
  %vis.ofs3 = shl i64 %rdx.n3, 2
  %vis.ptr3.i8 = getelementptr i8, i8* %rbx.ld5, i64 %vis.ofs3
  store i8* %vis.ptr3.i8, i8** %rsi.ptr, align 8
  %vis.ptr3 = bitcast i8* %vis.ptr3.i8 to i32*
  %vis.val3 = load i32, i32* %vis.ptr3, align 4
  %vis.zero3 = icmp eq i32 %vis.val3, 0
  br i1 %vis.zero3, label %bb_13f0_from_n3, label %bb_12cc

bb_12cc:
  ; rdx = rax + 4
  %rdx.n4 = add i64 %rax.ld3, 4
  ; cmp rax, 3 ; jz 133D
  %cmp.eq.3 = icmp eq i64 %rax.ld3, 3
  br i1 %cmp.eq.3, label %bb_133d, label %bb_12d6

bb_12d6:
  ; check matrix[u, rdx.n4]
  %rcx.sub4 = sub i64 %rcx.ld0, %rdx.ld1
  %rdx4.idx = add i64 %rdx.n4, %rcx.sub4
  %m.idx4 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %rdx4.idx
  %m.v4 = load i32, i32* %m.idx4, align 4
  %m.v4.z = icmp eq i32 %m.v4, 0
  br i1 %m.v4.z, label %bb_12f4, label %bb_12e4

bb_12e4:
  ; rsi = &visited[rdx.n4]
  %rbx.ld6 = load i8*, i8** %rbx.ptr, align 8
  %vis.ofs4 = shl i64 %rdx.n4, 2
  %vis.ptr4.i8 = getelementptr i8, i8* %rbx.ld6, i64 %vis.ofs4
  store i8* %vis.ptr4.i8, i8** %rsi.ptr, align 8
  %vis.ptr4 = bitcast i8* %vis.ptr4.i8 to i32*
  %vis.val4 = load i32, i32* %vis.ptr4, align 4
  %vis.zero4 = icmp eq i32 %vis.val4, 0
  br i1 %vis.zero4, label %bb_13f0_from_n4, label %bb_12f4

bb_12f4:
  ; rdx = rax + 5
  %rdx.n5 = add i64 %rax.ld3, 5
  ; cmp rax, 2 ; jz 133D
  %cmp.eq.2 = icmp eq i64 %rax.ld3, 2
  br i1 %cmp.eq.2, label %bb_133d, label %bb_12fe

bb_12fe:
  ; check matrix[u, rdx.n5]
  %rcx.sub5 = sub i64 %rcx.ld0, %rdx.ld1
  %rdx5.idx = add i64 %rdx.n5, %rcx.sub5
  %m.idx5 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %rdx5.idx
  %m.v5 = load i32, i32* %m.idx5, align 4
  %m.v5.z = icmp eq i32 %m.v5, 0
  br i1 %m.v5.z, label %bb_131c, label %bb_130c

bb_130c:
  ; rsi = &visited[rdx.n5]
  %rbx.ld7 = load i8*, i8** %rbx.ptr, align 8
  %vis.ofs5 = shl i64 %rdx.n5, 2
  %vis.ptr5.i8 = getelementptr i8, i8* %rbx.ld7, i64 %vis.ofs5
  store i8* %vis.ptr5.i8, i8** %rsi.ptr, align 8
  %vis.ptr5 = bitcast i8* %vis.ptr5.i8 to i32*
  %vis.val5 = load i32, i32* %vis.ptr5, align 4
  %vis.zero5 = icmp eq i32 %vis.val5, 0
  br i1 %vis.zero5, label %bb_13f0_from_n5, label %bb_131c

bb_131c:
  ; test rax ; jnz 133D
  %rax.ld4 = load i64, i64* %v_rax, align 8
  %rax.zero = icmp ne i64 %rax.ld4, 0
  br i1 %rax.zero, label %bb_133d, label %bb_1321

bb_1321:
  ; edx = matrix[(u*7) + 6]
  ; rcx currently = u*8; recompute u*7 via rdx*7
  %rdx.ld2 = load i64, i64* %v_rdx, align 8
  %r7mul = mul i64 %rdx.ld2, 7
  %idx.last = add i64 %r7mul, 6
  %m.idx6 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %idx.last
  %m.v6 = load i32, i32* %m.idx6, align 4
  %m.v6.z = icmp eq i32 %m.v6, 0
  br i1 %m.v6.z, label %bb_133d, label %bb_1329

bb_1329:
  ; eax = visited[6]; rsi = &visited[6]; edx = 6; test eax ; jz 13F0
  %rbx.ld8 = load i8*, i8** %rbx.ptr, align 8
  %vis6.ptr.i8 = getelementptr i8, i8* %rbx.ld8, i64 24
  %vis6.ptr = bitcast i8* %vis6.ptr.i8 to i32*
  %vis6.val = load i32, i32* %vis6.ptr, align 4
  %vis6.zero = icmp eq i32 %vis6.val, 0
  store i8* %vis6.ptr.i8, i8** %rsi.ptr, align 8
  store i64 6, i64* %v_rdx, align 8
  br i1 %vis6.zero, label %bb_13f0_from_last, label %bb_133d

bb_133d:
  ; sub rdi, 1
  %rdi.ld1 = load i64, i64* %v_rdi, align 8
  %rdi.dec = sub i64 %rdi.ld1, 1
  store i64 %rdi.dec, i64* %v_rdi, align 8
  br label %bb_1341

bb_1341:
  ; test rdi ; jnz 1208 else proceed to frees/prints
  %rdi.ld2 = load i64, i64* %v_rdi, align 8
  %rdi.nz = icmp ne i64 %rdi.ld2, 0
  br i1 %rdi.nz, label %bb_1208, label %bb_134a

bb_134a:
  ; free(rbx); free(r13); free(r12)
  %rbx.ld9 = load i8*, i8** %rbx.ptr, align 8
  call void @free(i8* %rbx.ld9)
  %r13.ld2 = load i8*, i8** %r13.ptr, align 8
  call void @free(i8* %r13.ld2)
  %r12.ld2 = load i8*, i8** %r12.ptr, align 8
  call void @free(i8* %r12.ld2)
  ; print header: __printf_chk(2, "DFS preorder from %zu: ", 0)
  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt1, i64 0)
  ; if (rbp == 0) goto 13AE
  %rbp.ld0 = load i64, i64* %v_rbp, align 8
  %rbp.zero = icmp eq i64 %rbp.ld0, 0
  br i1 %rbp.zero, label %bb_13ae, label %bb_137c

bb_137c:
  ; rdx = order[0]; r12 <- "%zu%s"
  %ord0.ld = load i64, i64* %ord0, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  ; if (rbp != 1) goto 1421 else 1398
  %cmp.rbp1 = icmp ne i64 %rbp.ld0, 1
  br i1 %cmp.rbp1, label %bb_1421, label %bb_1398

bb_1398:
  ; rcx = asc_2022+1 (empty string), print single element with empty suffix
  %empty = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 1
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2, i64 %ord0.ld, i8* %empty)
  br label %bb_13ae

bb_13ae:
  ; print newline
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 0
  %call3 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl)
  ; stack check epilogue
  %canary.ld = load i64, i64* %canary, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %canary.ok = icmp eq i64 %canary.ld, %guard.now
  br i1 %canary.ok, label %bb_13d8_ret, label %bb_1487

bb_13d8_ret:
  ret i32 0

bb_13ea:
  ; rdx = rax
  %rax.ld5 = load i64, i64* %v_rax, align 8
  store i64 %rax.ld5, i64* %v_rdx, align 8
  br label %bb_13f0

; joins from n1..n5 and last candidate before unified push
bb_13f0_from_n1:
  store i64 %rdx.n1, i64* %v_rdx, align 8
  br label %bb_13f0

bb_13f0_from_n2:
  store i64 %rdx.n2, i64* %v_rdx, align 8
  br label %bb_13f0

bb_13f0_from_n3:
  store i64 %rdx.n3, i64* %v_rdx, align 8
  br label %bb_13f0

bb_13f0_from_n4:
  store i64 %rdx.n4, i64* %v_rdx, align 8
  br label %bb_13f0

bb_13f0_from_n5:
  store i64 %rdx.n5, i64* %v_rdx, align 8
  br label %bb_13f0

bb_13f0_from_last:
  ; rdx already set to 6 in bb_1329
  br label %bb_13f0

bb_13f0:
  ; rax = rdx + 1
  %rdx.ld.final = load i64, i64* %v_rdx, align 8
  %rax.next = add i64 %rdx.ld.final, 1
  ; order[rbp] = rdx
  %rbp.ld1 = load i64, i64* %v_rbp, align 8
  %ord.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 %rbp.ld1
  store i64 %rdx.ld.final, i64* %ord.ptr, align 8
  ; rbp += 1
  %rbp.inc = add i64 %rbp.ld1, 1
  store i64 %rbp.inc, i64* %v_rbp, align 8
  ; [r12 + rdi*8] = rdx
  %r12.ld3 = load i8*, i8** %r12.ptr, align 8
  %rdi.ld3 = load i64, i64* %v_rdi, align 8
  %stk.ofs = mul i64 %rdi.ld3, 8
  %stk.ptr.i8 = getelementptr i8, i8* %r12.ld3, i64 %stk.ofs
  %stk.ptr = bitcast i8* %stk.ptr.i8 to i64*
  store i64 %rdx.ld.final, i64* %stk.ptr, align 8
  ; rdi += 1
  %rdi.inc = add i64 %rdi.ld3, 1
  store i64 %rdi.inc, i64* %v_rdi, align 8
  ; [r8] = rax.next
  %r8.ld = load i8*, i8** %r8.ptr, align 8
  %r8.q = bitcast i8* %r8.ld to i64*
  store i64 %rax.next, i64* %r8.q, align 8
  ; *rsi = 1 (visited mark)
  %rsi.ld = load i8*, i8** %rsi.ptr, align 8
  %rsi.i32 = bitcast i8* %rsi.ld to i32*
  store i32 1, i32* %rsi.i32, align 4
  br label %bb_1341

bb_1412:
  ; comes from 0x120d when (rax > 6)
  ; cmp rax, 7 ; jnz 1208 ; else jmp 133D
  %rax.ld6 = load i64, i64* %v_rax, align 8
  %cmp.neq7 = icmp ne i64 %rax.ld6, 7
  br i1 %cmp.neq7, label %bb_1208, label %bb_133d

bb_1421:
  ; ebx = 1 ; r14 = aDfsPreorderFro+0x16 ; loop prints elements with " "
  %space = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 22
  br label %bb_1430

bb_1430:
  ; print "%zu%s", order[rbx-1], " "
  ; we need a loop index; we’ll keep it in a phi
  %phi.bx = phi i64 [ 1, %bb_1421 ], [ %bx.inc, %bb_144b ]
  %elem.idx = sub i64 %phi.bx, 1
  %ord.ptr.loop = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 %elem.idx
  %elem.val = load i64, i64* %ord.ptr.loop, align 8
  %fmt2b = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call.loop = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2b, i64 %elem.val, i8* %space)
  br label %bb_1442

bb_1442:
  ; ebx++
  %phi.bx2 = phi i64 [ %phi.bx, %bb_1430 ]
  %bx.inc = add i64 %phi.bx2, 1
  br label %bb_1446

bb_1446:
  ; rdx = order[rbx-1]
  %idx.last2 = sub i64 %bx.inc, 1
  %ord.ptr2 = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 %idx.last2
  %last.val = load i64, i64* %ord.ptr2, align 8
  br label %bb_144b

bb_144b:
  ; cmp ebx, rbp ; jnz 1430
  %rbp.ld2 = load i64, i64* %v_rbp, align 8
  %cmp.loop = icmp ne i64 %bx.inc, %rbp.ld2
  br i1 %cmp.loop, label %bb_1430, label %bb_1450

bb_1450:
  ; jump to 1398 to print last element with empty suffix
  ; set up ord0.ld equivalent
  br label %bb_1398.setup

bb_1398.setup:
  ; ensure ord0.ld = last.val
  %last.phi = phi i64 [ %last.val, %bb_1450 ]
  %empty2 = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 1
  %fmt2c = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call2c = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2c, i64 %last.phi, i8* %empty2)
  br label %bb_13ae

bb_1455:
  ; error/early free path
  %rbx.ldE = load i8*, i8** %rbx.ptr, align 8
  call void @free(i8* %rbx.ldE)
  %r13.ldE = load i8*, i8** %r13.ptr, align 8
  call void @free(i8* %r13.ldE)
  %r12.ldE = load i8*, i8** %r12.ptr, align 8
  call void @free(i8* %r12.ldE)
  ; __printf_chk(2, "DFS preorder from %zu: ", 0)
  %fmt.err = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %call.err = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.err, i64 0)
  br label %bb_13ae

bb_1487:
  call void @__stack_chk_fail()
  unreachable
}

; memset intrinsic
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)