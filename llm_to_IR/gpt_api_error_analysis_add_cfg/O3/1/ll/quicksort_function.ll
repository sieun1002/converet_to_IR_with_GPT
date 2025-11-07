; ModuleID = 'quick_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* %arr, i64 %left, i64 %right) {
loc_1220:
  ; allocas (model callee-saved regs and temporaries)
  %arr.addr = alloca i32*, align 8
  %rsi = alloca i64, align 8           ; left
  %rdx = alloca i64, align 8           ; right
  %r12 = alloca i64, align 8
  %r13 = alloca i64, align 8
  %r14 = alloca i64, align 8
  %rbp_arr = alloca i32*, align 8      ; saved base pointer (array)
  %rdi = alloca i64, align 8           ; i index
  %rbx = alloca i64, align 8           ; j index
  %rax_bytes = alloca i64, align 8     ; 4 * j
  %rcx_ptr = alloca i32*, align 8      ; pointer to arr[j]
  %rax_ptr = alloca i32*, align 8      ; scan pointer used in 1275/1280 loop
  %r9 = alloca i64, align 8            ; i + 1 tracker
  %r8d = alloca i32, align 4           ; arr[i]
  %edx32 = alloca i32, align 4         ; arr[j]
  %esi32 = alloca i32, align 4         ; pivot

  store i32* %arr, i32** %arr.addr, align 8
  store i64 %left, i64* %rsi, align 8
  store i64 %right, i64* %rdx, align 8

  ; 0x1220: cmp rsi, rdx ; 0x1223: jge locret_1312
  %_l = load i64, i64* %rsi, align 8
  %_r = load i64, i64* %rdx, align 8
  %cmp.ge.entry = icmp sge i64 %_l, %_r
  br i1 %cmp.ge.entry, label %locret_1312, label %loc_1229

loc_1229:                                           ; 0x1229
  ; push/pops omitted; save params into "callee-saved" locals
  %arr0 = load i32*, i32** %arr.addr, align 8
  store i32* %arr0, i32** %rbp_arr, align 8         ; 0x1236: mov rbp, rdi
  %right0 = load i64, i64* %rdx, align 8
  store i64 %right0, i64* %r13, align 8             ; 0x122d: mov r13, rdx
  %left0 = load i64, i64* %rsi, align 8
  store i64 %left0, i64* %r12, align 8              ; 0x1232: mov r12, rsi
  br label %loc_123A

loc_123A:                                           ; 0x123a
  ; rax = r13
  %r13_1 = load i64, i64* %r13, align 8
  store i64 %r13_1, i64* %rax_bytes, align 8        ; temporary, will be transformed below

  ; rdi = r12
  %r12_1 = load i64, i64* %r12, align 8
  store i64 %r12_1, i64* %rdi, align 8

  ; r9 = r12 + 1
  %r9_init = add i64 %r12_1, 1
  store i64 %r9_init, i64* %r9, align 8

  ; rbx = r13
  store i64 %r13_1, i64* %rbx, align 8

  ; rax = ((r13 - r12) >> 1) + r12     ; mid index
  %diff_13_12 = sub i64 %r13_1, %r12_1
  %mid_half = ashr i64 %diff_13_12, 1
  %mid_idx = add i64 %mid_half, %r12_1

  ; esi = [rbp + rax*4]  (pivot)
  %base1 = load i32*, i32** %rbp_arr, align 8
  %pivot.ptr = getelementptr inbounds i32, i32* %base1, i64 %mid_idx
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  store i32 %pivot.val, i32* %esi32, align 4

  ; rax = r13 * 4  (store 4*j for later address computations)
  %r13_2 = load i64, i64* %r13, align 8
  %rax_bytes_init_mul = mul i64 %r13_2, 4
  store i64 %rax_bytes_init_mul, i64* %rax_bytes, align 8

  br label %loc_1260

loc_1260:                                           ; 0x1260
  ; r8d = [rbp + rdi*4]
  %base2 = load i32*, i32** %rbp_arr, align 8
  %i_idx = load i64, i64* %rdi, align 8
  %i.ptr = getelementptr inbounds i32, i32* %base2, i64 %i_idx
  %i.val = load i32, i32* %i.ptr, align 4
  store i32 %i.val, i32* %r8d, align 4

  ; rcx = [rbp + rax + 0] where rax = 4*j  => rcx = &arr[j]
  %base3 = load i32*, i32** %rbp_arr, align 8
  %rax_b = load i64, i64* %rax_bytes, align 8
  %j_idx_from_bytes = lshr i64 %rax_b, 2
  %rcx.ptr.cur = getelementptr inbounds i32, i32* %base3, i64 %j_idx_from_bytes
  store i32* %rcx.ptr.cur, i32** %rcx_ptr, align 8

  ; edx = [rcx]
  %rcx.load.ptr = load i32*, i32** %rcx_ptr, align 8
  %j.val0 = load i32, i32* %rcx.load.ptr, align 4
  store i32 %j.val0, i32* %edx32, align 4

  ; cmp r8d, esi ; jl loc_12DB
  %i.val.c = load i32, i32* %r8d, align 4
  %pivot.c = load i32, i32* %esi32, align 4
  %cmp_i_lt_pivot = icmp slt i32 %i.val.c, %pivot.c
  br i1 %cmp_i_lt_pivot, label %loc_12DB, label %loc_1271

loc_1271:                                           ; 0x1271
  ; cmp esi, edx ; jge loc_1291 else fall through to 0x1275
  %pivot.c2 = load i32, i32* %esi32, align 4
  %jval.c2 = load i32, i32* %edx32, align 4
  %cmp_pivot_ge_j = icmp sge i32 %pivot.c2, %jval.c2
  br i1 %cmp_pivot_ge_j, label %loc_1291, label %loc_1275

loc_1275:                                           ; 0x1275
  ; rax = [rbp + rax - 4] -> use rcx_ptr - 1 element as starting scan pointer
  %rcx.for.scan = load i32*, i32** %rcx_ptr, align 8
  %scan.start = getelementptr inbounds i32, i32* %rcx.for.scan, i64 -1
  store i32* %scan.start, i32** %rax_ptr, align 8
  br label %loc_1280

loc_1280:                                           ; 0x1280
  ; rcx = rax
  %scan.cur = load i32*, i32** %rax_ptr, align 8
  store i32* %scan.cur, i32** %rcx_ptr, align 8

  ; edx = [rax]
  %val.scan = load i32, i32* %scan.cur, align 4
  store i32 %val.scan, i32* %edx32, align 4

  ; rax = rax - 4 (advance scan pointer left by one element)
  %scan.next = getelementptr inbounds i32, i32* %scan.cur, i64 -1
  store i32* %scan.next, i32** %rax_ptr, align 8

  ; rbx = rbx - 1
  %rbx.cur = load i64, i64* %rbx, align 8
  %rbx.dec = sub i64 %rbx.cur, 1
  store i64 %rbx.dec, i64* %rbx, align 8

  ; cmp edx, esi ; jg loc_1280 else proceed to loc_1291
  %jval.loop = load i32, i32* %edx32, align 4
  %pivot.loop = load i32, i32* %esi32, align 4
  %cmp_j_gt_pivot = icmp sgt i32 %jval.loop, %pivot.loop
  br i1 %cmp_j_gt_pivot, label %loc_1280, label %loc_1291

loc_1291:                                           ; 0x1291
  ; r14 = rdi
  %i.idx.cur = load i64, i64* %rdi, align 8
  store i64 %i.idx.cur, i64* %r14, align 8

  ; cmp rdi, rbx ; jle loc_12C0 else loc_1299
  %rbx.cur2 = load i64, i64* %rbx, align 8
  %cmp_i_le_j = icmp sle i64 %i.idx.cur, %rbx.cur2
  br i1 %cmp_i_le_j, label %loc_12C0, label %loc_1299

loc_12C0:                                           ; 0x12c0
  ; rbx = rbx - 1
  %rbx.c0 = load i64, i64* %rbx, align 8
  %rbx.c0.dec = sub i64 %rbx.c0, 1
  store i64 %rbx.c0.dec, i64* %rbx, align 8

  ; [rbp + rdi*4] = edx
  %base.c0 = load i32*, i32** %rbp_arr, align 8
  %i.idx.c0 = load i64, i64* %rdi, align 8
  %i.ptr.c0 = getelementptr inbounds i32, i32* %base.c0, i64 %i.idx.c0
  %jval.c0 = load i32, i32* %edx32, align 4
  store i32 %jval.c0, i32* %i.ptr.c0, align 4

  ; r14 = r9
  %r9.c0 = load i64, i64* %r9, align 8
  store i64 %r9.c0, i64* %r14, align 8

  ; [rcx] = r8d
  %rcx.ptr.c0 = load i32*, i32** %rcx_ptr, align 8
  %i.val.c0 = load i32, i32* %r8d, align 4
  store i32 %i.val.c0, i32* %rcx.ptr.c0, align 4

  ; cmp r9, rbx ; jg 1299 else 12d3 -> 12DB
  %rbx.after.dec = load i64, i64* %rbx, align 8
  %cmp_r9_gt_rbx = icmp sgt i64 %r9.c0, %rbx.after.dec
  br i1 %cmp_r9_gt_rbx, label %loc_1299, label %loc_12C0_to_12DB_prep

loc_12C0_to_12DB_prep:                              ; corresponds to 0x12d3
  ; rax = rbx * 4
  %rbx.for.bytes = load i64, i64* %rbx, align 8
  %rax.new.bytes = mul i64 %rbx.for.bytes, 4
  store i64 %rax.new.bytes, i64* %rax_bytes, align 8
  br label %loc_12DB

loc_12DB:                                           ; 0x12db
  ; r9 = r9 + 1
  %r9.cur = load i64, i64* %r9, align 8
  %r9.inc = add i64 %r9.cur, 1
  store i64 %r9.inc, i64* %r9, align 8

  ; rdi = rdi + 1
  %rdi.cur = load i64, i64* %rdi, align 8
  %rdi.inc = add i64 %rdi.cur, 1
  store i64 %rdi.inc, i64* %rdi, align 8

  ; jmp loc_1260
  br label %loc_1260

loc_1299:                                           ; 0x1299
  ; rdx = rbx
  %rbx.k = load i64, i64* %rbx, align 8
  store i64 %rbx.k, i64* %rdx, align 8

  ; rax = r13
  %r13.k = load i64, i64* %r13, align 8
  store i64 %r13.k, i64* %rax_bytes, align 8   ; reuse as temp scalar

  ; rdx = rdx - r12
  %rdx.k0 = load i64, i64* %rdx, align 8
  %r12.k0 = load i64, i64* %r12, align 8
  %len.left = sub i64 %rdx.k0, %r12.k0
  store i64 %len.left, i64* %rdx, align 8

  ; rax = r13 - r14
  %r13.k1 = load i64, i64* %r13, align 8
  %r14.k1 = load i64, i64* %r14, align 8
  %len.right = sub i64 %r13.k1, %r14.k1
  store i64 %len.right, i64* %rax_bytes, align 8

  ; cmp rdx, rax ; jge 12E8 else continue
  %lenL = load i64, i64* %rdx, align 8
  %lenR = load i64, i64* %rax_bytes, align 8
  %cmp_len_ge = icmp sge i64 %lenL, %lenR
  br i1 %cmp_len_ge, label %loc_12E8, label %loc_1299_to_12AA

loc_1299_to_12AA:                                   ; corresponds to 0x12aa..0x12ad
  ; cmp rbx, r12 ; jg 12F2 else 12AF
  %rbx.aa = load i64, i64* %rbx, align 8
  %r12.aa = load i64, i64* %r12, align 8
  %cmp_rbx_gt_r12 = icmp sgt i64 %rbx.aa, %r12.aa
  br i1 %cmp_rbx_gt_r12, label %loc_12F2, label %loc_12AF

loc_12AF:                                           ; 0x12af
  ; r12 = r14
  %r14.to12 = load i64, i64* %r14, align 8
  store i64 %r14.to12, i64* %r12, align 8
  br label %loc_12B2

loc_12B2:                                           ; 0x12b2
  ; cmp r13, r12 ; jg 123A else return
  %r13.b2 = load i64, i64* %r13, align 8
  %r12.b2 = load i64, i64* %r12, align 8
  %cmp_r13_gt_r12 = icmp sgt i64 %r13.b2, %r12.b2
  br i1 %cmp_r13_gt_r12, label %loc_123A, label %locret_1312

loc_12E8:                                           ; 0x12e8
  ; cmp r14, r13 ; jl 1302 else 12ED
  %r14.e8 = load i64, i64* %r14, align 8
  %r13.e8 = load i64, i64* %r13, align 8
  %cmp_r14_lt_r13 = icmp slt i64 %r14.e8, %r13.e8
  br i1 %cmp_r14_lt_r13, label %loc_1302, label %loc_12ED

loc_12ED:                                           ; 0x12ed
  ; r13 = rbx
  %rbx.ed = load i64, i64* %rbx, align 8
  store i64 %rbx.ed, i64* %r13, align 8
  br label %loc_12B2

loc_12F2:                                           ; 0x12f2
  ; call quick_sort(rbp, r12, rbx)
  %base.f2 = load i32*, i32** %rbp_arr, align 8
  %left.f2 = load i64, i64* %r12, align 8
  %right.f2 = load i64, i64* %rbx, align 8
  call void @quick_sort(i32* %base.f2, i64 %left.f2, i64 %right.f2)
  br label %loc_12AF

loc_1302:                                           ; 0x1302
  ; call quick_sort(rbp, r14, r13)
  %base.302 = load i32*, i32** %rbp_arr, align 8
  %left.302 = load i64, i64* %r14, align 8
  %right.302 = load i64, i64* %r13, align 8
  call void @quick_sort(i32* %base.302, i64 %left.302, i64 %right.302)
  br label %loc_12ED

locret_1312:                                        ; 0x1312
  ret void
}