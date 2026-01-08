; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@qword_140008298 = external global i64 (i8*, i8*, i64)*
@qword_140008290 = external global i32 (i8*, i64, i32, i32*)*
@qword_140008260 = external global i32 ()*

@aVirtualprotect = internal constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = external constant [0 x i8]
@aAddressPHasNoI = internal constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %rcx) local_unnamed_addr {
entry:
  %buf = alloca [48 x i8], align 8
  %count = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %count, 0
  br i1 %cmp_le, label %bb_890, label %bb_loop_init

bb_loop_init:                                         ; preds = %entry
  %base0_ptr = load i8*, i8** @qword_1400070A8, align 8
  %scan_start = getelementptr inbounds i8, i8* %base0_ptr, i64 24
  br label %bb_loop

bb_loop:                                              ; preds = %bb_loop_iter, %bb_loop_init
  %scan_ptr = phi i8* [ %scan_start, %bb_loop_init ], [ %scan_ptr_next, %bb_loop_iter ]
  %idx = phi i32 [ 0, %bb_loop_init ], [ %idx_next, %bb_loop_iter ]
  %field0_ptrptr = bitcast i8* %scan_ptr to i8**
  %r8 = load i8*, i8** %field0_ptrptr, align 8
  %cmp_jb = icmp ult i8* %rcx, %r8
  br i1 %cmp_jb, label %bb_loop_iter, label %bb_check_range

bb_check_range:                                       ; preds = %bb_loop
  %p_plus8 = getelementptr inbounds i8, i8* %scan_ptr, i64 8
  %rdxptr_ptr = bitcast i8* %p_plus8 to i8**
  %rdxptr = load i8*, i8** %rdxptr_ptr, align 8
  %rdx_plus8 = getelementptr inbounds i8, i8* %rdxptr, i64 8
  %edx_32ptr = bitcast i8* %rdx_plus8 to i32*
  %size32 = load i32, i32* %edx_32ptr, align 4
  %size64 = zext i32 %size32 to i64
  %r8_end = getelementptr inbounds i8, i8* %r8, i64 %size64
  %cmp_jb2 = icmp ult i8* %rcx, %r8_end
  br i1 %cmp_jb2, label %bb_ret, label %bb_loop_iter

bb_loop_iter:                                         ; preds = %bb_check_range, %bb_loop
  %idx_next = add i32 %idx, 1
  %scan_ptr_next = getelementptr inbounds i8, i8* %scan_ptr, i64 40
  %cmp_ne = icmp ne i32 %idx_next, %count
  br i1 %cmp_ne, label %bb_loop, label %bb_7B8

bb_890:                                               ; preds = %entry
  br label %bb_7B8

bb_7B8:                                               ; preds = %bb_loop_iter, %bb_890
  %rsi_for_entry = phi i32 [ 0, %bb_890 ], [ %count, %bb_loop_iter ]
  %rdi = call i8* @sub_140002250(i8* %rcx)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %bb_8B2, label %bb_after_alloc

bb_after_alloc:                                       ; preds = %bb_7B8
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %rsi64 = sext i32 %rsi_for_entry to i64
  %mul5 = mul i64 %rsi64, 5
  %offset = shl i64 %mul5, 3
  %entry_ptr = getelementptr inbounds i8, i8* %base2, i64 %offset
  %entry_plus20 = getelementptr inbounds i8, i8* %entry_ptr, i64 32
  %entry_plus20_ptr = bitcast i8* %entry_plus20 to i8**
  store i8* %rdi, i8** %entry_plus20_ptr, align 8
  %entry_i32ptr = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_i32ptr, align 4
  %retmem = call i8* @sub_140002390()
  %rdi_plusC = getelementptr inbounds i8, i8* %rdi, i64 12
  %size2_ptr = bitcast i8* %rdi_plusC to i32*
  %size2 = load i32, i32* %size2_ptr, align 4
  %size2_z = zext i32 %size2 to i64
  %rcx_addr = getelementptr inbounds i8, i8* %retmem, i64 %size2_z
  %entry_plus18 = getelementptr inbounds i8, i8* %entry_ptr, i64 24
  %entry_plus18_ptr = bitcast i8* %entry_plus18 to i8**
  store i8* %rcx_addr, i8** %entry_plus18_ptr, align 8
  %buf_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %vq_fn_ptrptr = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @qword_140008298, align 8
  %vq_ret = call i64 %vq_fn_ptrptr(i8* %rcx_addr, i8* %buf_i8, i64 48)
  %vq_zero = icmp eq i64 %vq_ret, 0
  br i1 %vq_zero, label %bb_1897, label %bb_vq_success

bb_vq_success:                                        ; preds = %bb_after_alloc
  %prot_ptr_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 36
  %prot_ptr = bitcast i8* %prot_ptr_i8 to i32*
  %protect = load i32, i32* %prot_ptr, align 4
  %edx1 = add i32 %protect, -4
  %edx1_mask = and i32 %edx1, -5
  %cond1 = icmp eq i32 %edx1_mask, 0
  br i1 %cond1, label %bb_inc_ret, label %bb_after1

bb_after1:                                            ; preds = %bb_vq_success
  %edx2 = add i32 %protect, -64
  %edx2_mask = and i32 %edx2, -65
  %cond2 = icmp ne i32 %edx2_mask, 0
  br i1 %cond2, label %bb_840, label %bb_inc_ret

bb_inc_ret:                                           ; preds = %bb_after1, %bb_vq_success
  %old_count = load i32, i32* @dword_1400070A4, align 4
  %new_count = add i32 %old_count, 1
  store i32 %new_count, i32* @dword_1400070A4, align 4
  ret void

bb_840:                                               ; preds = %bb_after1
  %isRO = icmp eq i32 %protect, 2
  %newProt_sel = select i1 %isRO, i32 4, i32 64
  %baseaddr_ptr = bitcast i8* %buf_i8 to i8**
  %baseaddr = load i8*, i8** %baseaddr_ptr, align 8
  %regionsize_i8 = getelementptr inbounds i8, i8* %buf_i8, i64 24
  %regionsize_ptr = bitcast i8* %regionsize_i8 to i64*
  %regionsize = load i64, i64* %regionsize_ptr, align 8
  %entry_plus8 = getelementptr inbounds i8, i8* %entry_ptr, i64 8
  %entry_plus8_ptr = bitcast i8* %entry_plus8 to i8**
  store i8* %baseaddr, i8** %entry_plus8_ptr, align 8
  %entry_plus10 = getelementptr inbounds i8, i8* %entry_ptr, i64 16
  %entry_plus10_ptr = bitcast i8* %entry_plus10 to i64*
  store i64 %regionsize, i64* %entry_plus10_ptr, align 8
  %vp_fn_ptrptr = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @qword_140008290, align 8
  %oldProtPtr = bitcast i8* %entry_ptr to i32*
  %vp_ret = call i32 %vp_fn_ptrptr(i8* %baseaddr, i64 %regionsize, i32 %newProt_sel, i32* %oldProtPtr)
  %vp_ok = icmp ne i32 %vp_ret, 0
  br i1 %vp_ok, label %bb_inc_ret, label %bb_vp_fail

bb_vp_fail:                                           ; preds = %bb_840
  %gle_fn_ptrptr = load i32 ()*, i32 ()** @qword_140008260, align 8
  %err = call i32 %gle_fn_ptrptr()
  %fmt1 = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt1, i32 %err)
  br label %bb_890

bb_1897:                                              ; preds = %bb_after_alloc
  %rdi_plus8 = getelementptr inbounds i8, i8* %rdi, i64 8
  %rdi_plus8_i32 = bitcast i8* %rdi_plus8 to i32*
  %edx_sz = load i32, i32* %rdi_plus8_i32, align 4
  %fmt2 = getelementptr inbounds [0 x i8], [0 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %addr_for_fmt_ptr = load i8*, i8** %entry_plus18_ptr, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt2, i32 %edx_sz, i8* %addr_for_fmt_ptr)
  ret void

bb_8B2:                                               ; preds = %bb_7B8
  %fmt3 = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt3, i8* %rcx)
  ret void

bb_ret:                                               ; preds = %bb_check_range
  ret void
}