; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i32)
declare void @sub_140001700(i8*)

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*
@qword_140008290 = external global void (i8*, i8*, i32, i8*)*
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

define void @sub_1400018D0() local_unnamed_addr {
entry:
  %esi.slot = alloca i32, align 4
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %r13.slot = alloca i8*, align 8
  %g0 = load i32, i32* @dword_1400070A0, align 4
  store i32 %g0, i32* %esi.slot, align 4
  %tst0 = icmp eq i32 %g0, 0
  br i1 %tst0, label %bb_1900, label %bb_epilogue

bb_1900:                                          ; preds = %entry
  store i32 1, i32* @dword_1400070A0, align 4
  %c22 = call i32 @sub_1400022D0()
  %c22_sext = sext i32 %c22 to i64
  %mul5 = mul i64 %c22_sext, 5
  %mul8 = mul i64 %mul5, 8
  %add15 = add i64 %mul8, 15
  %and16 = and i64 %add15, -16
  %c2520 = call i64 @sub_140002520()
  %rdi0 = load i8*, i8** @off_1400043D0, align 8
  %rbx0 = load i8*, i8** @off_1400043E0, align 8
  %buf = alloca i8, i64 %c2520, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %buf, i8** @qword_1400070A8, align 8
  %rdi_int = ptrtoint i8* %rdi0 to i64
  %rbx_int = ptrtoint i8* %rbx0 to i64
  %diff = sub i64 %rdi_int, %rbx_int
  %le7 = icmp sle i64 %diff, 7
  br i1 %le7, label %bb_epilogue, label %bb_after7

bb_after7:                                        ; preds = %bb_1900
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %bb_1ae8, label %bb_1963

bb_1963:                                          ; preds = %bb_after7, %bb_1c22, %bb_1c17
  %rbx_sel = phi i8* [ %rbx0, %bb_after7 ], [ %rbx_add12_c17, %bb_1c22 ], [ %rbx0, %bb_1c17 ]
  %p_rbx_i32 = bitcast i8* %rbx_sel to i32*
  %ld0 = load i32, i32* %p_rbx_i32, align 4
  %is0 = icmp eq i32 %ld0, 0
  br i1 %is0, label %bb_196d, label %bb_1afd

bb_196d:                                          ; preds = %bb_1963
  %p_rbx_p4 = getelementptr inbounds i8, i8* %rbx_sel, i64 4
  %p_rbx_p4_i32 = bitcast i8* %p_rbx_p4 to i32*
  %ld1 = load i32, i32* %p_rbx_p4_i32, align 4
  %nz1 = icmp ne i32 %ld1, 0
  br i1 %nz1, label %bb_1afd, label %bb_1978

bb_1978:                                          ; preds = %bb_196d
  %p_rbx_p8 = getelementptr inbounds i8, i8* %rbx_sel, i64 8
  %p_rbx_p8_i32 = bitcast i8* %p_rbx_p8 to i32*
  %ld2 = load i32, i32* %p_rbx_p8_i32, align 4
  %is1 = icmp eq i32 %ld2, 1
  br i1 %is1, label %bb_1984, label %bb_1c53

bb_1984:                                          ; preds = %bb_1978
  %rbx_add12 = getelementptr inbounds i8, i8* %rbx_sel, i64 12
  %r14_base = load i8*, i8** @off_1400043C0, align 8
  %r12_loc = bitcast i64* %var48 to i8*
  %cmp_rbx_rdi = icmp ult i8* %rbx_add12, %rdi0
  br i1 %cmp_rbx_rdi, label %bb_1a14, label %bb_epilogue

bb_1a14:                                          ; preds = %bb_1984, %bb_1a07, %bb_1a80
  %rbx_c = phi i8* [ %rbx_add12, %bb_1984 ], [ %rbx_add12_loop, %bb_1a07 ], [ %rbx_c, %bb_1a80 ]
  %p_off0 = bitcast i8* %rbx_c to i32*
  %off0 = load i32, i32* %p_off0, align 4
  %p_off8 = getelementptr inbounds i8, i8* %rbx_c, i64 8
  %p_off8_i32 = bitcast i8* %p_off8 to i32*
  %ecx_val = load i32, i32* %p_off8_i32, align 4
  %p_off4 = getelementptr inbounds i8, i8* %rbx_c, i64 4
  %p_off4_i32 = bitcast i8* %p_off4 to i32*
  %r15off = load i32, i32* %p_off4_i32, align 4
  %off0_z = zext i32 %off0 to i64
  %r14_int = ptrtoint i8* %r14_base to i64
  %r8_addr_int = add i64 %r14_int, %off0_z
  %r8_addr = inttoptr i64 %r8_addr_int to i8*
  %r9_ptr = bitcast i8* %r8_addr to i64*
  %r9_val = load i64, i64* %r9_ptr, align 8
  %r15off_z = zext i32 %r15off to i64
  %r15_addr_int = add i64 %r14_int, %r15off_z
  %r15_addr = inttoptr i64 %r15_addr_int to i8*
  %edx_byte = and i32 %ecx_val, 255
  %is_32 = icmp eq i32 %edx_byte, 32
  br i1 %is_32, label %bb_1b60, label %bb_1a33

bb_1a33:                                          ; preds = %bb_1a14
  %le_32 = icmp ule i32 %edx_byte, 32
  br i1 %le_32, label %bb_19a0, label %bb_1a39

bb_1a39:                                          ; preds = %bb_1a33
  %is_64 = icmp eq i32 %edx_byte, 64
  br i1 %is_64, label %bb_1a42, label %bb_1c2b

bb_19a0:                                          ; preds = %bb_1a33
  %is_8 = icmp eq i32 %edx_byte, 8
  br i1 %is_8, label %bb_1bc8, label %bb_19a9

bb_19a9:                                          ; preds = %bb_19a0
  %is_16 = icmp eq i32 %edx_byte, 16
  br i1 %is_16, label %bb_19b2, label %bb_1c2b

bb_19b2:                                          ; preds = %bb_19a9
  %p_r15_i16 = bitcast i8* %r15_addr to i16*
  %w16 = load i16, i16* %p_r15_i16, align 2
  %w16_sext = sext i16 %w16 to i64
  %adj0 = sub i64 %w16_sext, %r8_addr_int
  %sum16 = add i64 %adj0, %r9_val
  store i64 %sum16, i64* %var48, align 8
  %maskC0_16 = and i32 %ecx_val, 192
  %nzC0_16 = icmp ne i32 %maskC0_16, 0
  br i1 %nzC0_16, label %bb_19eb, label %bb_19d3

bb_19d3:                                          ; preds = %bb_19b2
  %gtFFFF = icmp sgt i64 %sum16, 65535
  br i1 %gtFFFF, label %bb_1c3f, label %bb_19df

bb_19df:                                          ; preds = %bb_19d3
  %ltNeg32768 = icmp slt i64 %sum16, -32768
  br i1 %ltNeg32768, label %bb_1c3f, label %bb_19eb

bb_19eb:                                          ; preds = %bb_19df, %bb_19b2
  call void @sub_140001760(i8* %r15_addr)
  store i8* %r12_loc, i8** %r13.slot, align 8
  call void @sub_1400027B8(i8* %r15_addr, i8* %r12_loc, i32 2)
  br label %bb_1a07

bb_1a42:                                          ; preds = %bb_1a39
  %p_r15_i64 = bitcast i8* %r15_addr to i64*
  %q64 = load i64, i64* %p_r15_i64, align 8
  %adj64a = sub i64 %q64, %r8_addr_int
  %sum64 = add i64 %adj64a, %r9_val
  store i64 %sum64, i64* %var48, align 8
  %maskC0_64 = and i32 %ecx_val, 192
  %nzC0_64 = icmp ne i32 %maskC0_64, 0
  br i1 %nzC0_64, label %bb_1a60, label %bb_1a57

bb_1a57:                                          ; preds = %bb_1a42
  %nonneg = icmp sge i64 %sum64, 0
  br i1 %nonneg, label %bb_1c3f, label %bb_1a60

bb_1a60:                                          ; preds = %bb_1a57, %bb_1a42
  call void @sub_140001760(i8* %r15_addr)
  store i8* %r12_loc, i8** %r13.slot, align 8
  call void @sub_1400027B8(i8* %r15_addr, i8* %r12_loc, i32 8)
  br label %bb_1a80

bb_1a07:                                          ; preds = %bb_19eb, %bb_1ba0, %bb_1bf6
  %rbx_add12_loop = getelementptr inbounds i8, i8* %rbx_c, i64 12
  %nb = icmp uge i8* %rbx_add12_loop, %rdi0
  br i1 %nb, label %bb_1a90, label %bb_1a14

bb_1a80:                                          ; preds = %bb_1a60
  %cont = icmp ult i8* %rbx_c, %rdi0
  br i1 %cont, label %bb_1a14, label %bb_1a90

bb_1a90:                                          ; preds = %bb_1a80, %bb_1a07, %bb_1b51
  %a4 = load i32, i32* @dword_1400070A4, align 4
  %pos = icmp sgt i32 %a4, 0
  br i1 %pos, label %bb_1aa0, label %bb_epilogue

bb_1aa0:                                          ; preds = %bb_1a90
  %fp = load void (i8*, i8*, i32, i8*)*, void (i8*, i8*, i32, i8*)** @qword_140008290, align 8
  %idx0 = load i32, i32* %esi.slot, align 4
  %idx0_z = zext i32 %idx0 to i64
  br label %bb_1ab0

bb_1ab0:                                          ; preds = %bb_1acf, %bb_1aa0
  %i = phi i64 [ 0, %bb_1aa0 ], [ %i.next, %bb_1acf ]
  %esi_cur = phi i32 [ %idx0, %bb_1aa0 ], [ %esi_inc, %bb_1acf ]
  %base = load i8*, i8** @qword_1400070A8, align 8
  %rec = getelementptr inbounds i8, i8* %base, i64 %i
  %rec_i32 = bitcast i8* %rec to i32*
  %r8d_val = load i32, i32* %rec_i32, align 4
  %is_zero_r8d = icmp eq i32 %r8d_val, 0
  br i1 %is_zero_r8d, label %bb_1acf, label %bb_1ac2

bb_1ac2:                                          ; preds = %bb_1ab0
  %p_rcx = getelementptr inbounds i8, i8* %rec, i64 8
  %p_rcx_q = bitcast i8* %p_rcx to i8**
  %rcx_val = load i8*, i8** %p_rcx_q, align 8
  %p_rdx = getelementptr inbounds i8, i8* %rec, i64 16
  %p_rdx_q = bitcast i8* %p_rdx to i8**
  %rdx_val = load i8*, i8** %p_rdx_q, align 8
  %r13v = load i8*, i8** %r13.slot, align 8
  call void %fp(i8* %rcx_val, i8* %rdx_val, i32 %r8d_val, i8* %r13v)
  br label %bb_1acf

bb_1acf:                                          ; preds = %bb_1ac2, %bb_1ab0
  %esi_inc = add i32 %esi_cur, 1
  store i32 %esi_inc, i32* %esi.slot, align 4
  %i.next = add i64 %i, 40
  %a4.cur = load i32, i32* @dword_1400070A4, align 4
  %cond = icmp slt i32 %esi_inc, %a4.cur
  br i1 %cond, label %bb_1ab0, label %bb_epilogue

bb_1ae8:                                          ; preds = %bb_after7
  %p_rbx00 = bitcast i8* %rbx0 to i32*
  %r9d0 = load i32, i32* %p_rbx00, align 4
  %r9d_nz = icmp ne i32 %r9d0, 0
  br i1 %r9d_nz, label %bb_1afd, label %bb_1af0

bb_1af0:                                          ; preds = %bb_1ae8
  %p_rbx04 = getelementptr inbounds i8, i8* %rbx0, i64 4
  %p_rbx04_i32 = bitcast i8* %p_rbx04 to i32*
  %r8d0 = load i32, i32* %p_rbx04_i32, align 4
  %r8d0_is0 = icmp eq i32 %r8d0, 0
  br i1 %r8d0_is0, label %bb_1c17, label %bb_1afd

bb_1afd:                                          ; preds = %bb_1af0, %bb_196d, %bb_1963, %bb_1ae8
  %rbx_in = phi i8* [ %rbx0, %bb_1ae8 ], [ %rbx0, %bb_1af0 ], [ %rbx_sel, %bb_1963 ], [ %rbx_sel, %bb_196d ]
  %end_ge = icmp uge i8* %rbx_in, %rdi0
  br i1 %end_ge, label %bb_epilogue, label %bb_1b06

bb_1b06:                                          ; preds = %bb_1afd
  %r14_b = load i8*, i8** @off_1400043C0, align 8
  %r13_set = bitcast i64* %var48 to i8*
  store i8* %r13_set, i8** %r13.slot, align 8
  br label %bb_1b20

bb_1b20:                                          ; preds = %bb_1b20, %bb_1b06
  %rbx_v1 = phi i8* [ %rbx_in, %bb_1b06 ], [ %rbx_next8, %bb_1b20 ]
  %p_rbx_v1_4 = getelementptr inbounds i8, i8* %rbx_v1, i64 4
  %p_rbx_v1_4_i32 = bitcast i8* %p_rbx_v1_4 to i32*
  %r12d = load i32, i32* %p_rbx_v1_4_i32, align 4
  %p_rbx_v1_0 = bitcast i8* %rbx_v1 to i32*
  %eaxv = load i32, i32* %p_rbx_v1_0, align 4
  %rbx_next8 = getelementptr inbounds i8, i8* %rbx_v1, i64 8
  %r12d_z = zext i32 %r12d to i64
  %r14b_int = ptrtoint i8* %r14_b to i64
  %addr = add i64 %r14b_int, %r12d_z
  %addr_ptr = inttoptr i64 %addr to i32*
  %mem32 = load i32, i32* %addr_ptr, align 4
  %sum32 = add i32 %eaxv, %mem32
  %rcx_ptr = inttoptr i64 %addr to i8*
  %sum32_z = zext i32 %sum32 to i64
  store i64 %sum32_z, i64* %var48, align 8
  call void @sub_140001760(i8* %rcx_ptr)
  call void @sub_1400027B8(i8* %rcx_ptr, i8* %r13_set, i32 4)
  %cont_v1 = icmp ult i8* %rbx_next8, %rdi0
  br i1 %cont_v1, label %bb_1b20, label %bb_1b51

bb_1b51:                                          ; preds = %bb_1b20
  br label %bb_1a90

bb_1b60:                                          ; preds = %bb_1a14
  %p_r15_i32 = bitcast i8* %r15_addr to i32*
  %val32 = load i32, i32* %p_r15_i32, align 4
  %se32 = sext i32 %val32 to i64
  %adj = sub i64 %se32, %r8_addr_int
  %sum32b = add i64 %adj, %r9_val
  store i64 %sum32b, i64* %var48, align 8
  %maskC0_32 = and i32 %ecx_val, 192
  %nzC0_32 = icmp ne i32 %maskC0_32, 0
  br i1 %nzC0_32, label %bb_1ba0, label %bb_1b86

bb_1b86:                                          ; preds = %bb_1b60
  %gt_4294967295 = icmp sgt i64 %sum32b, 4294967295
  br i1 %gt_4294967295, label %bb_1c3f, label %bb_1b94

bb_1b94:                                          ; preds = %bb_1b86
  %lt_min32 = icmp slt i64 %sum32b, -2147483648
  br i1 %lt_min32, label %bb_1c3f, label %bb_1ba0

bb_1ba0:                                          ; preds = %bb_1b94, %bb_1b60
  call void @sub_140001760(i8* %r15_addr)
  store i8* %r12_loc, i8** %r13.slot, align 8
  call void @sub_1400027B8(i8* %r15_addr, i8* %r12_loc, i32 4)
  br label %bb_1a07

bb_1bc8:                                          ; preds = %bb_19a0
  %p_r15_i8 = bitcast i8* %r15_addr to i8*
  %b8 = load i8, i8* %p_r15_i8, align 1
  %se8 = sext i8 %b8 to i64
  %adj8 = sub i64 %se8, %r8_addr_int
  %sum8 = add i64 %adj8, %r9_val
  store i64 %sum8, i64* %var48, align 8
  %maskC0_8 = and i32 %ecx_val, 192
  %nzC0_8 = icmp ne i32 %maskC0_8, 0
  br i1 %nzC0_8, label %bb_1bf6, label %bb_1be8

bb_1be8:                                          ; preds = %bb_1bc8
  %gtFF = icmp sgt i64 %sum8, 255
  br i1 %gtFF, label %bb_1c3f, label %bb_1bf0

bb_1bf0:                                          ; preds = %bb_1be8
  %ltNeg128 = icmp slt i64 %sum8, -128
  br i1 %ltNeg128, label %bb_1c3f, label %bb_1bf6

bb_1bf6:                                          ; preds = %bb_1bf0, %bb_1bc8
  call void @sub_140001760(i8* %r15_addr)
  store i8* %r12_loc, i8** %r13.slot, align 8
  call void @sub_1400027B8(i8* %r15_addr, i8* %r12_loc, i32 1)
  br label %bb_1a07

bb_1c17:                                          ; preds = %bb_1af0
  %p_rbx08 = getelementptr inbounds i8, i8* %rbx0, i64 8
  %p_rbx08_i32 = bitcast i8* %p_rbx08 to i32*
  %ecx3 = load i32, i32* %p_rbx08_i32, align 4
  %nzecx3 = icmp ne i32 %ecx3, 0
  br i1 %nzecx3, label %bb_1963, label %bb_1c22

bb_1c22:                                          ; preds = %bb_1c17
  %rbx_add12_c17 = getelementptr inbounds i8, i8* %rbx0, i64 12
  br label %bb_1963

bb_1c2b:                                          ; preds = %bb_1a39, %bb_19a9
  %s1 = getelementptr inbounds i8, i8* @aUnknownPseudoR, i64 0
  store i64 0, i64* %var48, align 8
  call void @sub_140001700(i8* %s1)
  br label %bb_1c3f

bb_1c3f:                                          ; preds = %bb_1b94, %bb_1b86, %bb_19df, %bb_19d3, %bb_1a57, %bb_1be8, %bb_1bf0, %bb_1c2b
  %rax_to_store = load i64, i64* %var48, align 8
  store i64 %rax_to_store, i64* %var60, align 8
  %fmt2 = getelementptr inbounds i8, i8* @aDBitPseudoRelo, i64 0
  call void @sub_140001700(i8* %fmt2)
  br label %bb_epilogue

bb_1c53:                                          ; preds = %bb_1978
  %s3 = getelementptr inbounds i8, i8* @aUnknownPseudoR_0, i64 0
  call void @sub_140001700(i8* %s3)
  br label %bb_epilogue

bb_epilogue:                                      ; preds = %entry, %bb_1900, %bb_1984, %bb_1afd, %bb_1a90, %bb_1acf, %bb_1c3f, %bb_1c53
  ret void
}