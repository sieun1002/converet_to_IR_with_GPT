; ModuleID = 'quick_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* %arr, i64 %lo, i64 %hi) {
entry:
  %loVar = alloca i64, align 8
  %hiVar = alloca i64, align 8
  %iVar = alloca i64, align 8
  %r9Var = alloca i64, align 8
  %rbxVar = alloca i64, align 8
  %r14Var = alloca i64, align 8
  %pivotVar = alloca i32, align 4
  %rcxVar = alloca i32*, align 8
  %edxVar = alloca i32, align 4
  %r8Var = alloca i32, align 4
  store i64 %lo, i64* %loVar, align 8
  store i64 %hi, i64* %hiVar, align 8
  br label %loc_1220

loc_1220:                                            ; 0x1220
  %lo0 = load i64, i64* %loVar, align 8
  %hi0 = load i64, i64* %hiVar, align 8
  %cmp_1220 = icmp sge i64 %lo0, %hi0
  br i1 %cmp_1220, label %locret_1312, label %bb_1229

bb_1229:                                             ; 0x1229
  br label %loc_123A

loc_123A:                                            ; 0x123A
  %lo1 = load i64, i64* %loVar, align 8
  %hi1 = load i64, i64* %hiVar, align 8
  store i64 %lo1, i64* %iVar, align 8
  %r9init = add i64 %lo1, 1
  store i64 %r9init, i64* %r9Var, align 8
  store i64 %hi1, i64* %rbxVar, align 8
  %diff = sub i64 %hi1, %lo1
  %diff_half = ashr i64 %diff, 1
  %mid = add i64 %lo1, %diff_half
  %pivot_ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot_ptr, align 4
  store i32 %pivot, i32* %pivotVar, align 4
  br label %loc_1260

loc_1260:                                            ; 0x1260
  %i_cur = load i64, i64* %iVar, align 8
  %rbx_cur = load i64, i64* %rbxVar, align 8
  %elem_i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_cur
  %elem_i_val = load i32, i32* %elem_i_ptr, align 4
  store i32 %elem_i_val, i32* %r8Var, align 4
  %rbx_ptr = getelementptr inbounds i32, i32* %arr, i64 %rbx_cur
  store i32* %rbx_ptr, i32** %rcxVar, align 8
  %elem_rbx_val = load i32, i32* %rbx_ptr, align 4
  store i32 %elem_rbx_val, i32* %edxVar, align 4
  %pivot1 = load i32, i32* %pivotVar, align 4
  %cmp_126c = icmp slt i32 %elem_i_val, %pivot1
  br i1 %cmp_126c, label %loc_12DB, label %bb_1271

bb_1271:                                             ; 0x1271
  %pivot2 = load i32, i32* %pivotVar, align 4
  %edx2 = load i32, i32* %edxVar, align 4
  %cmp_1271 = icmp sge i32 %pivot2, %edx2
  br i1 %cmp_1271, label %loc_1291, label %bb_1275

bb_1275:                                             ; 0x1275
  %rbx_for_scan = load i64, i64* %rbxVar, align 8
  %ptr_rbx = getelementptr inbounds i32, i32* %arr, i64 %rbx_for_scan
  %ptr_before = getelementptr inbounds i32, i32* %ptr_rbx, i64 -1
  br label %loc_1280

loc_1280:                                            ; 0x1280
  %rax_ptr_phi = phi i32* [ %ptr_before, %bb_1275 ], [ %rax_ptr_next, %loc_1280 ]
  %rbx_phi = phi i64 [ %rbx_for_scan, %bb_1275 ], [ %rbx_dec, %loc_1280 ]
  store i32* %rax_ptr_phi, i32** %rcxVar, align 8
  %edx_load = load i32, i32* %rax_ptr_phi, align 4
  store i32 %edx_load, i32* %edxVar, align 4
  %rax_ptr_next = getelementptr inbounds i32, i32* %rax_ptr_phi, i64 -1
  %rbx_dec = add i64 %rbx_phi, -1
  store i64 %rbx_dec, i64* %rbxVar, align 8
  %pivot3 = load i32, i32* %pivotVar, align 4
  %cmp_128f = icmp sgt i32 %edx_load, %pivot3
  br i1 %cmp_128f, label %loc_1280, label %loc_1291

loc_1291:                                            ; 0x1291
  %i_for_1291 = load i64, i64* %iVar, align 8
  store i64 %i_for_1291, i64* %r14Var, align 8
  %rbx_for_1291 = load i64, i64* %rbxVar, align 8
  %cmp_1294 = icmp sle i64 %i_for_1291, %rbx_for_1291
  br i1 %cmp_1294, label %loc_12C0, label %loc_1299

loc_12C0:                                            ; 0x12C0
  %rbx_before_dec2 = load i64, i64* %rbxVar, align 8
  %rbx_new2 = add i64 %rbx_before_dec2, -1
  store i64 %rbx_new2, i64* %rbxVar, align 8
  %edx_sw = load i32, i32* %edxVar, align 4
  %i_sw = load i64, i64* %iVar, align 8
  %i_ptr_sw = getelementptr inbounds i32, i32* %arr, i64 %i_sw
  store i32 %edx_sw, i32* %i_ptr_sw, align 4
  %r9_val = load i64, i64* %r9Var, align 8
  store i64 %r9_val, i64* %r14Var, align 8
  %r8_sw = load i32, i32* %r8Var, align 4
  %rcx_ptr_sw = load i32*, i32** %rcxVar, align 8
  store i32 %r8_sw, i32* %rcx_ptr_sw, align 4
  %rbx_for_cmp = load i64, i64* %rbxVar, align 8
  %cmp_12ce = icmp sgt i64 %r9_val, %rbx_for_cmp
  br i1 %cmp_12ce, label %loc_1299, label %bb_12d3

bb_12d3:                                             ; 0x12D3
  br label %loc_12DB

loc_12DB:                                            ; 0x12DB
  %r9_old = load i64, i64* %r9Var, align 8
  %r9_next = add i64 %r9_old, 1
  store i64 %r9_next, i64* %r9Var, align 8
  %i_old = load i64, i64* %iVar, align 8
  %i_next = add i64 %i_old, 1
  store i64 %i_next, i64* %iVar, align 8
  br label %loc_1260

loc_1299:                                            ; 0x1299
  %rbx_1299 = load i64, i64* %rbxVar, align 8
  %lo_1299 = load i64, i64* %loVar, align 8
  %hi_1299 = load i64, i64* %hiVar, align 8
  %r14_1299 = load i64, i64* %r14Var, align 8
  %left_len = sub i64 %rbx_1299, %lo_1299
  %right_len = sub i64 %hi_1299, %r14_1299
  %cmp_12a5 = icmp sge i64 %left_len, %right_len
  br i1 %cmp_12a5, label %loc_12E8, label %bb_12aa

bb_12aa:                                             ; 0x12AA
  %rbx_cmp = load i64, i64* %rbxVar, align 8
  %lo_cmp = load i64, i64* %loVar, align 8
  %cmp_12aa = icmp sgt i64 %rbx_cmp, %lo_cmp
  br i1 %cmp_12aa, label %loc_12F2, label %loc_12AF

loc_12F2:                                            ; 0x12F2
  %lo_call_L = load i64, i64* %loVar, align 8
  %rbx_call_L = load i64, i64* %rbxVar, align 8
  call void @quick_sort(i32* %arr, i64 %lo_call_L, i64 %rbx_call_L)
  br label %loc_12AF

loc_12AF:                                            ; 0x12AF
  %r14_to_lo = load i64, i64* %r14Var, align 8
  store i64 %r14_to_lo, i64* %loVar, align 8
  br label %loc_12B2

loc_12E8:                                            ; 0x12E8
  %r14_cmp = load i64, i64* %r14Var, align 8
  %hi_cmp = load i64, i64* %hiVar, align 8
  %cmp_12e8 = icmp slt i64 %r14_cmp, %hi_cmp
  br i1 %cmp_12e8, label %loc_1302, label %loc_12ED

loc_1302:                                            ; 0x1302
  %r14_call_R = load i64, i64* %r14Var, align 8
  %hi_call_R = load i64, i64* %hiVar, align 8
  call void @quick_sort(i32* %arr, i64 %r14_call_R, i64 %hi_call_R)
  br label %loc_12ED

loc_12ED:                                            ; 0x12ED
  %rbx_to_hi = load i64, i64* %rbxVar, align 8
  store i64 %rbx_to_hi, i64* %hiVar, align 8
  br label %loc_12B2

loc_12B2:                                            ; 0x12B2
  %hi_check = load i64, i64* %hiVar, align 8
  %lo_check = load i64, i64* %loVar, align 8
  %cmp_12b2 = icmp sgt i64 %hi_check, %lo_check
  br i1 %cmp_12b2, label %loc_123A, label %epilogue

epilogue:
  br label %locret_1312

locret_1312:                                         ; 0x1312
  ret void
}