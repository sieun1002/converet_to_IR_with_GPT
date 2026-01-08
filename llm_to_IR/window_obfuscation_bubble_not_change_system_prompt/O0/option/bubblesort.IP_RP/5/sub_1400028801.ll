; ModuleID = 'sub_140002880'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external constant <4 x i32>, align 16
@xmmword_140004020 = external constant <4 x i32>, align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

define dso_local void @sub_140002880() local_unnamed_addr {
entry:
  %buf = alloca [48 x i8], align 16
  %buf0 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  call void @sub_140001520()
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  %p_v1 = bitcast i8* %buf0 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %p_v1, align 16
  %ptr_var28_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 32
  %ptr_var28 = bitcast i8* %ptr_var28_i8 to i32*
  store i32 4, i32* %ptr_var28, align 4
  %v2 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  %buf16 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 16
  %p_v2 = bitcast i8* %buf16 to <4 x i32>*
  store <4 x i32> %v2, <4 x i32>* %p_v2, align 16
  br label %outer_header

outer_header:                                     ; preds = %outer_latch, %entry
  %r9_cur = phi i64 [ 10, %entry ], [ %r10_after, %outer_latch ]
  %r10_init = add i64 0, 0
  %rax_init = add i64 0, 1
  %rdx_init = getelementptr inbounds i8, i8* %buf0, i64 0
  br label %inner_loop

inner_loop:                                       ; preds = %after_if, %outer_header
  %rax_phi = phi i64 [ %rax_init, %outer_header ], [ %rax_next, %after_if ]
  %rdx_phi = phi i8* [ %rdx_init, %outer_header ], [ %rdx_next, %after_if ]
  %r10_phi = phi i64 [ %r10_init, %outer_header ], [ %r10_after, %after_if ]
  %rdx_i64ptr = bitcast i8* %rdx_phi to i64*
  %qw = load i64, i64* %rdx_i64ptr, align 1
  %v_lo2 = bitcast i64 %qw to <2 x i32>
  %lane0 = extractelement <2 x i32> %v_lo2, i32 0
  %lane1 = extractelement <2 x i32> %v_lo2, i32 1
  %vec_tmp0 = insertelement <4 x i32> undef, i32 %lane0, i32 0
  %vec_tmp1 = insertelement <4 x i32> %vec_tmp0, i32 %lane1, i32 1
  %vec_tmp2 = insertelement <4 x i32> %vec_tmp1, i32 0, i32 2
  %v4 = insertelement <4 x i32> %vec_tmp2, i32 0, i32 3
  %shufE5 = shufflevector <4 x i32> %v4, <4 x i32> undef, <4 x i32> <i32 1, i32 1, i32 2, i32 3>
  %ecx = extractelement <4 x i32> %v4, i32 0
  %r8d = extractelement <4 x i32> %shufE5, i32 0
  %cmp = icmp slt i32 %r8d, %ecx
  br i1 %cmp, label %swap, label %noswap

swap:                                             ; preds = %inner_loop
  %shufE1 = shufflevector <4 x i32> %v4, <4 x i32> undef, <4 x i32> <i32 1, i32 0, i32 2, i32 3>
  %sw_l0 = extractelement <4 x i32> %shufE1, i32 0
  %sw_l1 = extractelement <4 x i32> %shufE1, i32 1
  %sw_l0_z = zext i32 %sw_l0 to i64
  %sw_l1_z = zext i32 %sw_l1 to i64
  %sw_l1_shl = shl i64 %sw_l1_z, 32
  %q_sw = or i64 %sw_l0_z, %sw_l1_shl
  store i64 %q_sw, i64* %rdx_i64ptr, align 1
  br label %after_if

noswap:                                           ; preds = %inner_loop
  br label %after_if

after_if:                                         ; preds = %noswap, %swap
  %r10_after = phi i64 [ %rax_phi, %swap ], [ %r10_phi, %noswap ]
  %rax_next = add i64 %rax_phi, 1
  %rdx_next = getelementptr inbounds i8, i8* %rdx_phi, i64 4
  %cmp_ne = icmp ne i64 %rax_next, %r9_cur
  br i1 %cmp_ne, label %inner_loop, label %after_inner

after_inner:                                      ; preds = %after_if
  %cond_jbe = icmp ule i64 %r10_after, 1
  br i1 %cond_jbe, label %loc_93B, label %outer_latch

outer_latch:                                      ; preds = %after_inner
  br label %outer_header

loc_93B:                                          ; preds = %after_inner
  %ptr_var20_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 40
  %rbx_i32ptr = bitcast i8* %buf0 to i32*
  %val = load i32, i32* %rbx_i32ptr, align 4
  %rbx1 = getelementptr inbounds i8, i8* %buf0, i64 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %val)
  ret void
}