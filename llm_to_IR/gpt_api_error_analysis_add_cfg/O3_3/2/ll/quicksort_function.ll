; ModuleID = 'quick_sort_ir'
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @quick_sort(i32* %arr, i64 %rsi_in, i64 %rdx_in) {
entry_1220:
  %cmp_entry = icmp sge i64 %rsi_in, %rdx_in
  br i1 %cmp_entry, label %locret_1312, label %b1229

b1229:
  %r13_0 = add i64 %rdx_in, 0
  %r12_0 = add i64 %rsi_in, 0
  br label %loc_123A

loc_123A:
  %r12_phi_123A = phi i64 [ %r12_0, %b1229 ], [ %r12_in_12B2, %loc_12B2 ], [ %r14_phi_1299, %loc_12AF ]
  %r13_phi_123A = phi i64 [ %r13_0, %b1229 ], [ %r13_in_12B2, %loc_12B2 ], [ %r13_phi_1299, %loc_12AF ]
  %rdi_i0 = add i64 %r12_phi_123A, 0
  %r9_0 = add i64 %r12_phi_123A, 1
  %rbx_init = add i64 %r13_phi_123A, 0
  %diff = sub i64 %r13_phi_123A, %r12_phi_123A
  %half = ashr i64 %diff, 1
  %mid = add i64 %half, %r12_phi_123A
  %pivot_ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot_ptr, align 4
  br label %loc_1260

loc_1260:
  %r12_phi_1260 = phi i64 [ %r12_phi_123A, %loc_123A ], [ %r12_phi_12DB, %loc_12DB ]
  %r13_phi_1260 = phi i64 [ %r13_phi_123A, %loc_123A ], [ %r13_phi_12DB, %loc_12DB ]
  %rdi_phi_1260 = phi i64 [ %rdi_i0, %loc_123A ], [ %rdi_inc, %loc_12DB ]
  %r9_phi_1260  = phi i64 [ %r9_0, %loc_123A ], [ %r9_inc, %loc_12DB ]
  %rbx_phi_1260 = phi i64 [ %rbx_init, %loc_123A ], [ %rbx_phi_12DB, %loc_12DB ]
  %pivot_phi_1260 = phi i32 [ %pivot, %loc_123A ], [ %pivot_phi_12DB, %loc_12DB ]
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %rdi_phi_1260
  %left_val = load i32, i32* %left_ptr, align 4
  %rcx_ptr0 = getelementptr inbounds i32, i32* %arr, i64 %rbx_phi_1260
  %edx0 = load i32, i32* %rcx_ptr0, align 4
  %cmp_jl_12DB = icmp slt i32 %left_val, %pivot_phi_1260
  br i1 %cmp_jl_12DB, label %loc_12DB, label %b1271

b1271:
  %cmp_jge_1291 = icmp sge i32 %pivot_phi_1260, %edx0
  br i1 %cmp_jge_1291, label %loc_1291, label %b1275

b1275:
  %rbx_minus1_for_ptr = add i64 %rbx_phi_1260, -1
  %rax_ptr1 = getelementptr inbounds i32, i32* %arr, i64 %rbx_minus1_for_ptr
  br label %loc_1280

loc_1280:
  %rax_ptr_phi = phi i32* [ %rax_ptr1, %b1275 ], [ %rax_ptr_next, %loc_1280 ]
  %rbx_phi_1280 = phi i64 [ %rbx_phi_1260, %b1275 ], [ %rbx_dec, %loc_1280 ]
  %left_val_phi = phi i32 [ %left_val, %b1275 ], [ %left_val_phi, %loc_1280 ]
  %pivot_phi_1280 = phi i32 [ %pivot_phi_1260, %b1275 ], [ %pivot_phi_1280, %loc_1280 ]
  %edx_loop = load i32, i32* %rax_ptr_phi, align 4
  %rax_ptr_next = getelementptr inbounds i32, i32* %rax_ptr_phi, i64 -1
  %rbx_dec = add i64 %rbx_phi_1280, -1
  %cmp_jg_1280 = icmp sgt i32 %edx_loop, %pivot_phi_1280
  br i1 %cmp_jg_1280, label %loc_1280, label %loc_1291

loc_1291:
  %r12_phi_1291 = phi i64 [ %r12_phi_1260, %b1271 ], [ %r12_phi_1260, %loc_1280 ]
  %r13_phi_1291 = phi i64 [ %r13_phi_1260, %b1271 ], [ %r13_phi_1260, %loc_1280 ]
  %rdi_phi_1291 = phi i64 [ %rdi_phi_1260, %b1271 ], [ %rdi_phi_1260, %loc_1280 ]
  %r9_phi_1291  = phi i64 [ %r9_phi_1260, %b1271 ],  [ %r9_phi_1260,  %loc_1280 ]
  %rbx_phi_1291 = phi i64 [ %rbx_phi_1260, %b1271 ], [ %rbx_dec, %loc_1280 ]
  %pivot_phi_1291 = phi i32 [ %pivot_phi_1260, %b1271 ], [ %pivot_phi_1280, %loc_1280 ]
  %edx_sel = phi i32 [ %edx0, %b1271 ], [ %edx_loop, %loc_1280 ]
  %rcx_ptr_sel = phi i32* [ %rcx_ptr0, %b1271 ], [ %rax_ptr_phi, %loc_1280 ]
  %left_val_sel = phi i32 [ %left_val, %b1271 ], [ %left_val_phi, %loc_1280 ]
  %cmp_jle_12C0 = icmp sle i64 %rdi_phi_1291, %rbx_phi_1291
  br i1 %cmp_jle_12C0, label %loc_12C0, label %loc_1299

loc_12C0:
  %rbx_after_sub = add i64 %rbx_phi_1291, -1
  %left_ptr_store = getelementptr inbounds i32, i32* %arr, i64 %rdi_phi_1291
  store i32 %edx_sel, i32* %left_ptr_store, align 4
  store i32 %left_val_sel, i32* %rcx_ptr_sel, align 4
  %cmp_jg_1299 = icmp sgt i64 %r9_phi_1291, %rbx_after_sub
  br i1 %cmp_jg_1299, label %loc_1299, label %b12D3

b12D3:
  br label %loc_12DB

loc_12DB:
  %r12_phi_12DB = phi i64 [ %r12_phi_1260, %loc_1260 ], [ %r12_phi_1291, %b12D3 ]
  %r13_phi_12DB = phi i64 [ %r13_phi_1260, %loc_1260 ], [ %r13_phi_1291, %b12D3 ]
  %rdi_phi_12DB = phi i64 [ %rdi_phi_1260, %loc_1260 ], [ %rdi_phi_1291, %b12D3 ]
  %r9_phi_12DB  = phi i64 [ %r9_phi_1260, %loc_1260 ],  [ %r9_phi_1291,  %b12D3 ]
  %rbx_phi_12DB = phi i64 [ %rbx_phi_1260, %loc_1260 ], [ %rbx_after_sub, %b12D3 ]
  %pivot_phi_12DB = phi i32 [ %pivot_phi_1260, %loc_1260 ], [ %pivot_phi_1291, %b12D3 ]
  %r9_inc = add i64 %r9_phi_12DB, 1
  %rdi_inc = add i64 %rdi_phi_12DB, 1
  br label %loc_1260

loc_1299:
  %r12_phi_1299 = phi i64 [ %r12_phi_1291, %loc_1291 ], [ %r12_phi_1291, %loc_12C0 ]
  %r13_phi_1299 = phi i64 [ %r13_phi_1291, %loc_1291 ], [ %r13_phi_1291, %loc_12C0 ]
  %rbx_phi_1299 = phi i64 [ %rbx_phi_1291, %loc_1291 ], [ %rbx_after_sub, %loc_12C0 ]
  %r14_phi_1299 = phi i64 [ %rdi_phi_1291, %loc_1291 ], [ %r9_phi_1291, %loc_12C0 ]
  %rdx_minus_r12 = sub i64 %rbx_phi_1299, %r12_phi_1299
  %rax_minus_r14 = sub i64 %r13_phi_1299, %r14_phi_1299
  %cmp_jge_12E8 = icmp sge i64 %rdx_minus_r12, %rax_minus_r14
  br i1 %cmp_jge_12E8, label %loc_12E8, label %b12AA

b12AA:
  %cmp_jg_12F2 = icmp sgt i64 %rbx_phi_1299, %r12_phi_1299
  br i1 %cmp_jg_12F2, label %loc_12F2, label %loc_12AF

loc_12F2:
  call void @quick_sort(i32* %arr, i64 %r12_phi_1299, i64 %rbx_phi_1299)
  br label %loc_12AF

loc_12AF:
  %cmp_jg_123A_from_12AF = icmp sgt i64 %r13_phi_1299, %r14_phi_1299
  br i1 %cmp_jg_123A_from_12AF, label %loc_123A, label %loc_12B2

loc_12E8:
  %cmp_jl_1302 = icmp slt i64 %r14_phi_1299, %r13_phi_1299
  br i1 %cmp_jl_1302, label %loc_1302, label %loc_12ED

loc_1302:
  call void @quick_sort(i32* %arr, i64 %r14_phi_1299, i64 %r13_phi_1299)
  br label %loc_12ED

loc_12ED:
  %r12_phi_12ED = phi i64 [ %r12_phi_1299, %loc_12E8 ], [ %r12_phi_1299, %loc_1302 ]
  %rbx_phi_12ED = phi i64 [ %rbx_phi_1299, %loc_12E8 ], [ %rbx_phi_1299, %loc_1302 ]
  br label %loc_12B2

loc_12B2:
  %r12_in_12B2 = phi i64 [ %r14_phi_1299, %loc_12AF ], [ %r12_phi_12ED, %loc_12ED ]
  %r13_in_12B2 = phi i64 [ %r13_phi_1299, %loc_12AF ], [ %rbx_phi_12ED, %loc_12ED ]
  %cmp_jg_123A = icmp sgt i64 %r13_in_12B2, %r12_in_12B2
  br i1 %cmp_jg_123A, label %loc_123A, label %epilogue_12BF

epilogue_12BF:
  ret void

locret_1312:
  ret void
}