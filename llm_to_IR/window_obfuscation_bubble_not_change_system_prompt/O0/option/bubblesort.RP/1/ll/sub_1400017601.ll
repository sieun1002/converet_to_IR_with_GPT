; ModuleID = 'sub_140001760'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = external constant i8
@aVirtualqueryFa = external constant i8
@aAddressPHasNoI = external constant i8

declare i8* @sub_140002250(i8* noundef)
declare i8* @sub_140002390()
declare void @sub_140001700(i8* noundef, ...)
declare i64 @VirtualQuery(i8* noundef, i8* noundef, i64 noundef)
declare i32 @VirtualProtect(i8* noundef, i64 noundef, i32 noundef, i32* noundef)
declare i32 @GetLastError()

define void @sub_140001760(i8* noundef %arg) {
entry:
  %Buffer = alloca [48 x i8], align 8
  %cnt0 = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %cnt0, 0
  br i1 %cmp_le, label %bb_890, label %bb_loop_init

bb_loop_init:                                            ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %ptr0 = getelementptr inbounds i8, i8* %base0, i64 24
  br label %bb_loop

bb_loop:                                                 ; preds = %bb_loop_inc, %bb_loop_init
  %ptrPhi = phi i8* [ %ptr0, %bb_loop_init ], [ %ptr_next, %bb_loop_inc ]
  %idxPhi = phi i32 [ 0, %bb_loop_init ], [ %idx_inc, %bb_loop_inc ]
  %r8_ptrptr = bitcast i8* %ptrPhi to i8**
  %r8_val = load i8*, i8** %r8_ptrptr, align 8
  %arg_int = ptrtoint i8* %arg to i64
  %r8_int = ptrtoint i8* %r8_val to i64
  %jb1 = icmp ult i64 %arg_int, %r8_int
  br i1 %jb1, label %bb_loop_inc, label %bb_check_end

bb_check_end:                                            ; preds = %bb_loop
  %rdxptr = getelementptr inbounds i8, i8* %ptrPhi, i64 8
  %rdxptr_cast = bitcast i8* %rdxptr to i8**
  %p = load i8*, i8** %rdxptr_cast, align 8
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %size32ptr = bitcast i8* %p_plus8 to i32*
  %size32 = load i32, i32* %size32ptr, align 4
  %size64 = zext i32 %size32 to i64
  %r8_end = getelementptr inbounds i8, i8* %r8_val, i64 %size64
  %r8_end_int = ptrtoint i8* %r8_end to i64
  %jb2 = icmp ult i64 %arg_int, %r8_end_int
  br i1 %jb2, label %bb_ret, label %bb_loop_inc

bb_loop_inc:                                             ; preds = %bb_check_end, %bb_loop
  %idx_inc = add i32 %idxPhi, 1
  %ptr_next = getelementptr inbounds i8, i8* %ptrPhi, i64 40
  %cnt1 = load i32, i32* @dword_1400070A4, align 4
  %cmp_ne = icmp ne i32 %idx_inc, %cnt1
  br i1 %cmp_ne, label %bb_loop, label %bb_7b8

bb_890:                                                  ; preds = %entry, %bb_878
  br label %bb_7b8

bb_7b8:                                                  ; preds = %bb_loop_inc, %bb_890
  %esi_phi = phi i32 [ 0, %bb_890 ], [ %cnt1, %bb_loop_inc ]
  %rdi = call i8* @sub_140002250(i8* noundef %arg)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %bb_8b2, label %bb_7cc

bb_7cc:                                                  ; preds = %bb_7b8
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %esi_sext = sext i32 %esi_phi to i64
  %mul5 = mul nsw i64 %esi_sext, 5
  %offset = shl i64 %mul5, 3
  %slot_base = getelementptr inbounds i8, i8* %base1, i64 %offset
  %off20 = getelementptr inbounds i8, i8* %slot_base, i64 32
  %off20_ptr = bitcast i8* %off20 to i8**
  store i8* %rdi, i8** %off20_ptr, align 8
  %slot_i32 = bitcast i8* %slot_base to i32*
  store i32 0, i32* %slot_i32, align 4
  %pbase = call i8* @sub_140002390()
  %rdi_c = getelementptr inbounds i8, i8* %rdi, i64 12
  %rdi_c_i32 = bitcast i8* %rdi_c to i32*
  %edx_c = load i32, i32* %rdi_c_i32, align 4
  %edx_c_z = zext i32 %edx_c to i64
  %rcx_addr = getelementptr inbounds i8, i8* %pbase, i64 %edx_c_z
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %slot2 = getelementptr inbounds i8, i8* %base2, i64 %offset
  %slot2_off18 = getelementptr inbounds i8, i8* %slot2, i64 24
  %slot2_off18_ptr = bitcast i8* %slot2_off18 to i8**
  store i8* %rcx_addr, i8** %slot2_off18_ptr, align 8
  %bufptr = getelementptr inbounds [48 x i8], [48 x i8]* %Buffer, i64 0, i64 0
  %vqret = call i64 @VirtualQuery(i8* noundef %rcx_addr, i8* noundef %bufptr, i64 noundef 48)
  %vqz = icmp eq i64 %vqret, 0
  br i1 %vqz, label %bb_897, label %bb_81a

bb_81a:                                                  ; preds = %bb_7cc
  %prot_ptr_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %Buffer, i64 0, i64 36
  %prot_ptr = bitcast i8* %prot_ptr_i8 to i32*
  %prot = load i32, i32* %prot_ptr, align 4
  %sub4 = sub i32 %prot, 4
  %and1 = and i32 %sub4, -5
  %jz1 = icmp eq i32 %and1, 0
  br i1 %jz1, label %bb_82e, label %bb_826

bb_826:                                                  ; preds = %bb_81a
  %sub40 = sub i32 %prot, 64
  %and2 = and i32 %sub40, -65
  %jnz2 = icmp ne i32 %and2, 0
  br i1 %jnz2, label %bb_840, label %bb_82e

bb_82e:                                                  ; preds = %bb_826, %bb_81a, %bb_840
  %cnt_old = load i32, i32* @dword_1400070A4, align 4
  %cnt_inc = add i32 %cnt_old, 1
  store i32 %cnt_inc, i32* @dword_1400070A4, align 4
  br label %bb_ret

bb_840:                                                  ; preds = %bb_826
  %cmp2 = icmp eq i32 %prot, 2
  %baseaddr_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %Buffer, i64 0, i64 0
  %baseaddr_ptr = bitcast i8* %baseaddr_i8 to i8**
  %vp_addr = load i8*, i8** %baseaddr_ptr, align 8
  %region_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %Buffer, i64 0, i64 24
  %region_ptr = bitcast i8* %region_i8 to i64*
  %vp_size = load i64, i64* %region_ptr, align 8
  %newprot = select i1 %cmp2, i32 4, i32 64
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %slot3 = getelementptr inbounds i8, i8* %base3, i64 %offset
  %slot3_off8 = getelementptr inbounds i8, i8* %slot3, i64 8
  %slot3_off8_ptr = bitcast i8* %slot3_off8 to i8**
  store i8* %vp_addr, i8** %slot3_off8_ptr, align 8
  %oldprot_ptr = bitcast i8* %slot3 to i32*
  %slot3_off16 = getelementptr inbounds i8, i8* %slot3, i64 16
  %slot3_off16_ptr = bitcast i8* %slot3_off16 to i64*
  store i64 %vp_size, i64* %slot3_off16_ptr, align 8
  %vp_ok = call i32 @VirtualProtect(i8* noundef %vp_addr, i64 noundef %vp_size, i32 noundef %newprot, i32* noundef %oldprot_ptr)
  %vp_nz = icmp ne i32 %vp_ok, 0
  br i1 %vp_nz, label %bb_82e, label %bb_878

bb_878:                                                  ; preds = %bb_840
  %gle = call i32 @GetLastError()
  call void (i8*, ...) @sub_140001700(i8* noundef @aVirtualprotect, i32 noundef %gle)
  br label %bb_890

bb_897:                                                  ; preds = %bb_7cc
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %rdi_8 = getelementptr inbounds i8, i8* %rdi, i64 8
  %rdi_8_i32 = bitcast i8* %rdi_8 to i32*
  %bytes = load i32, i32* %rdi_8_i32, align 4
  %slot4 = getelementptr inbounds i8, i8* %base4, i64 %offset
  %slot4_off18 = getelementptr inbounds i8, i8* %slot4, i64 24
  %slot4_off18_ptr = bitcast i8* %slot4_off18 to i8**
  %addr_vq = load i8*, i8** %slot4_off18_ptr, align 8
  call void (i8*, ...) @sub_140001700(i8* noundef @aVirtualqueryFa, i32 noundef %bytes, i8* noundef %addr_vq)
  br label %bb_ret

bb_8b2:                                                  ; preds = %bb_7b8
  call void (i8*, ...) @sub_140001700(i8* noundef @aAddressPHasNoI, i8* noundef %arg)
  br label %bb_ret

bb_ret:                                                  ; preds = %bb_897, %bb_82e, %bb_check_end, %bb_8b2
  ret void
}