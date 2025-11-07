; ModuleID = 'quick_sort_ir'
target triple = "x86_64-unknown-linux-gnu"

define void @quick_sort(i32* %base, i64 %left, i64 %right) {
block_1220:
  %cmp0 = icmp sge i64 %left, %right
  br i1 %cmp0, label %locret_1312, label %block_1229

block_1229:
  %r13_0 = add i64 %right, 0
  %r12_0 = add i64 %left, 0
  %rbx_0 = add i64 %r13_0, 0
  %rdi_0 = add i64 %r12_0, 0
  %r9_0 = add i64 %r12_0, 1
  %diff0 = sub i64 %r13_0, %r12_0
  %half0 = ashr i64 %diff0, 1
  %mid0 = add i64 %half0, %r12_0
  %pivot_ptr0 = getelementptr inbounds i32, i32* %base, i64 %mid0
  %pivot_0 = load i32, i32* %pivot_ptr0, align 4
  br label %loc_1260

loc_123A:
  %r12_123A = phi i64 [ %r12_after, %loc_12B2 ]
  %r13_123A = phi i64 [ %r13_after, %loc_12B2 ]
  %rbx_123A = add i64 %r13_123A, 0
  %rdi_123A = add i64 %r12_123A, 0
  %r9_123A = add i64 %r12_123A, 1
  %diff2 = sub i64 %r13_123A, %r12_123A
  %half2 = ashr i64 %diff2, 1
  %mid2 = add i64 %half2, %r12_123A
  %pivot_ptr2 = getelementptr inbounds i32, i32* %base, i64 %mid2
  %pivot_2 = load i32, i32* %pivot_ptr2, align 4
  br label %loc_1260

loc_1260:
  %r12_phi = phi i64 [ %r12_0, %block_1229 ], [ %r12_123A, %loc_123A ], [ %r12_phi_12DB, %loc_12DB ]
  %r13_phi = phi i64 [ %r13_0, %block_1229 ], [ %r13_123A, %loc_123A ], [ %r13_phi_12DB, %loc_12DB ]
  %rbx_phi = phi i64 [ %rbx_0, %block_1229 ], [ %rbx_123A, %loc_123A ], [ %rbx_phi_12DB, %loc_12DB ]
  %rdi_phi = phi i64 [ %rdi_0, %block_1229 ], [ %rdi_123A, %loc_123A ], [ %rdi_inc, %loc_12DB ]
  %r9_phi = phi i64 [ %r9_0, %block_1229 ], [ %r9_123A, %loc_123A ], [ %r9_inc, %loc_12DB ]
  %pivot_phi = phi i32 [ %pivot_0, %block_1229 ], [ %pivot_2, %loc_123A ], [ %pivot_phi_12DB, %loc_12DB ]
  %left_ptr0 = getelementptr inbounds i32, i32* %base, i64 %rdi_phi
  %r8_val0 = load i32, i32* %left_ptr0, align 4
  %rcx_ptr0 = getelementptr inbounds i32, i32* %base, i64 %rbx_phi
  %edx_val0 = load i32, i32* %rcx_ptr0, align 4
  %cmp_a = icmp slt i32 %r8_val0, %pivot_phi
  br i1 %cmp_a, label %loc_12DB, label %block_1271

block_1271:
  %cmp_b = icmp sge i32 %pivot_phi, %edx_val0
  br i1 %cmp_b, label %loc_1291, label %block_1275

block_1275:
  %rbx_minus1 = add i64 %rbx_phi, -1
  %raxptr1 = getelementptr inbounds i32, i32* %base, i64 %rbx_minus1
  br label %loc_1280

loc_1280:
  %raxptr_phi = phi i32* [ %raxptr1, %block_1275 ], [ %raxptr_next, %loc_1280 ]
  %rbx_in_phi = phi i64 [ %rbx_phi, %block_1275 ], [ %rbx_next2, %loc_1280 ]
  %edx_loop = load i32, i32* %raxptr_phi, align 4
  %raxptr_next = getelementptr inbounds i32, i32* %raxptr_phi, i64 -1
  %rbx_next2 = add i64 %rbx_in_phi, -1
  %cmp_loop2 = icmp sgt i32 %edx_loop, %pivot_phi
  br i1 %cmp_loop2, label %loc_1280, label %loc_1291

loc_1291:
  %rcx_ptr_phi = phi i32* [ %rcx_ptr0, %block_1271 ], [ %raxptr_phi, %loc_1280 ]
  %edx_phi = phi i32 [ %edx_val0, %block_1271 ], [ %edx_loop, %loc_1280 ]
  %rbx_for_1291 = phi i64 [ %rbx_phi, %block_1271 ], [ %rbx_next2, %loc_1280 ]
  %r14_from_1291 = add i64 %rdi_phi, 0
  %cmp_c = icmp sle i64 %rdi_phi, %rbx_for_1291
  br i1 %cmp_c, label %loc_12C0, label %loc_1299

loc_12C0:
  %rbx_dec = add i64 %rbx_for_1291, -1
  %left_ptr1 = getelementptr inbounds i32, i32* %base, i64 %rdi_phi
  store i32 %edx_phi, i32* %left_ptr1, align 4
  %r14_from_12C0 = add i64 %r9_phi, 0
  store i32 %r8_val0, i32* %rcx_ptr_phi, align 4
  %cmp_d = icmp sgt i64 %r9_phi, %rbx_dec
  br i1 %cmp_d, label %loc_1299, label %loc_12DB

loc_12DB:
  %r12_phi_12DB = phi i64 [ %r12_phi, %loc_1260 ], [ %r12_phi, %loc_12C0 ]
  %r13_phi_12DB = phi i64 [ %r13_phi, %loc_1260 ], [ %r13_phi, %loc_12C0 ]
  %pivot_phi_12DB = phi i32 [ %pivot_phi, %loc_1260 ], [ %pivot_phi, %loc_12C0 ]
  %rbx_phi_12DB = phi i64 [ %rbx_phi, %loc_1260 ], [ %rbx_dec, %loc_12C0 ]
  %rdi_phi_12DB = phi i64 [ %rdi_phi, %loc_1260 ], [ %rdi_phi, %loc_12C0 ]
  %r9_phi_12DB = phi i64 [ %r9_phi, %loc_1260 ], [ %r9_phi, %loc_12C0 ]
  %r9_inc = add i64 %r9_phi_12DB, 1
  %rdi_inc = add i64 %rdi_phi_12DB, 1
  br label %loc_1260

loc_1299:
  %rbx_phi_1299 = phi i64 [ %rbx_for_1291, %loc_1291 ], [ %rbx_dec, %loc_12C0 ]
  %r14_phi_1299 = phi i64 [ %r14_from_1291, %loc_1291 ], [ %r14_from_12C0, %loc_12C0 ]
  %rdx_size = sub i64 %rbx_phi_1299, %r12_phi
  %rax_size = sub i64 %r13_phi, %r14_phi_1299
  %cmp_e = icmp sge i64 %rdx_size, %rax_size
  br i1 %cmp_e, label %loc_12E8, label %block_12AA

block_12AA:
  %cmp_f = icmp sgt i64 %rbx_phi_1299, %r12_phi
  br i1 %cmp_f, label %loc_12F2, label %loc_12AF

loc_12F2:
  call void @quick_sort(i32* %base, i64 %r12_phi, i64 %rbx_phi_1299)
  br label %loc_12AF

loc_12AF:
  %r12_after_12AF = phi i64 [ %r14_phi_1299, %loc_12F2 ], [ %r14_phi_1299, %block_12AA ]
  br label %loc_12B2

loc_12E8:
  %cmp_g = icmp slt i64 %r14_phi_1299, %r13_phi
  br i1 %cmp_g, label %loc_1302, label %block_12E8_else

block_12E8_else:
  %r13_after_else = add i64 %rbx_phi_1299, 0
  br label %loc_12B2

loc_1302:
  call void @quick_sort(i32* %base, i64 %r14_phi_1299, i64 %r13_phi)
  br label %loc_12ED

loc_12ED:
  %r13_after_12ED = add i64 %rbx_phi_1299, 0
  br label %loc_12B2

loc_12B2:
  %r12_after = phi i64 [ %r12_after_12AF, %loc_12AF ], [ %r12_phi, %block_12E8_else ], [ %r12_phi, %loc_12ED ]
  %r13_after = phi i64 [ %r13_phi, %loc_12AF ], [ %r13_after_else, %block_12E8_else ], [ %r13_after_12ED, %loc_12ED ]
  %cmp_h = icmp sgt i64 %r13_after, %r12_after
  br i1 %cmp_h, label %loc_123A, label %block_12B7

block_12B7:
  br label %block_12BF

block_12BF:
  ret void

locret_1312:
  ret void
}