; ModuleID = 'sub_140001760'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@qword_140008298 = external dso_local global i64 (i8*, i8*, i64)*
@qword_140008290 = external dso_local global i32 (i8*, i64, i32, i8*)*
@qword_140008260 = external dso_local global i32 ()*
@aVirtualprotect = external dso_local constant i8
@aVirtualqueryFa = external dso_local constant i8
@aAddressPHasNoI = external dso_local constant i8

declare dso_local i8* @sub_140002250(i8* noundef)
declare dso_local i8* @sub_140002390()
declare dso_local void @sub_140001700(i8* noundef, ...)

define dso_local void @sub_140001760(i8* noundef %rcx) local_unnamed_addr {
entry:
  %buf = alloca [48 x i8], align 8
  %addr = bitcast i8* %rcx to i8*
  %esi_val = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %esi_val, 0
  br i1 %cmp_le, label %loc_1890, label %loop_init

loc_1890:
  br label %create_entry_start

loop_init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %p0 = getelementptr i8, i8* %base0, i64 24
  br label %loop_top

loop_top:
  %p_phi = phi i8* [ %p0, %loop_init ], [ %p_tmp, %loop_advance ]
  %i_phi = phi i32 [ 0, %loop_init ], [ %i_tmp, %loop_advance ]
  %entry_start_ptr = bitcast i8* %p_phi to i8**
  %r8_val_p = load i8*, i8** %entry_start_ptr, align 8
  %rbx_u = ptrtoint i8* %addr to i64
  %r8_u = ptrtoint i8* %r8_val_p to i64
  %jb = icmp ult i64 %rbx_u, %r8_u
  br i1 %jb, label %loop_advance, label %check_inside

check_inside:
  %p_plus8 = getelementptr i8, i8* %p_phi, i64 8
  %rdx_ptrptr = bitcast i8* %p_plus8 to i8**
  %rdx_val2 = load i8*, i8** %rdx_ptrptr, align 8
  %rdx_off_ptr = getelementptr i8, i8* %rdx_val2, i64 8
  %edx_i32ptr = bitcast i8* %rdx_off_ptr to i32*
  %edx_i32 = load i32, i32* %edx_i32ptr, align 4
  %edx_zext = zext i32 %edx_i32 to i64
  %r8_plus = add i64 %r8_u, %edx_zext
  %cmp_in = icmp ult i64 %rbx_u, %r8_plus
  br i1 %cmp_in, label %epilogue_return, label %loop_advance

loop_advance:
  %i_tmp = add i32 %i_phi, 1
  %p_tmp = getelementptr i8, i8* %p_phi, i64 40
  %cont = icmp ne i32 %i_tmp, %esi_val
  br i1 %cont, label %loop_top, label %create_entry_start

create_entry_start:
  %esi_for_create = phi i32 [ 0, %loc_1890 ], [ %esi_val, %loop_advance ]
  %rdi_ptr = call i8* @sub_140002250(i8* %addr)
  %isnull = icmp eq i8* %rdi_ptr, null
  br i1 %isnull, label %print_address_no_section, label %create_cont

create_cont:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %esi_sext = sext i32 %esi_for_create to i64
  %mul = mul i64 %esi_sext, 40
  %entry_ptr = getelementptr i8, i8* %base1, i64 %mul
  %field20 = getelementptr i8, i8* %entry_ptr, i64 32
  %field20pp = bitcast i8* %field20 to i8**
  store i8* %rdi_ptr, i8** %field20pp, align 8
  %entry_i32p = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_i32p, align 4
  %mod_base = call i8* @sub_140002390()
  %rdi_off0Ch = getelementptr i8, i8* %rdi_ptr, i64 12
  %rdi_i32p = bitcast i8* %rdi_off0Ch to i32*
  %edx_val = load i32, i32* %rdi_i32p, align 4
  %edx_zext2 = zext i32 %edx_val to i64
  %rcx_target = getelementptr i8, i8* %mod_base, i64 %edx_zext2
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %buf_i8 = getelementptr [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %entry_plus18 = getelementptr i8, i8* %entry_ptr, i64 24
  %entry_plus18pp = bitcast i8* %entry_plus18 to i8**
  store i8* %rcx_target, i8** %entry_plus18pp, align 8
  %fp_vq_ptr = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @qword_140008298, align 8
  %vq_ret = call i64 %fp_vq_ptr(i8* %rcx_target, i8* %buf_i8, i64 48)
  %vq_is_zero = icmp eq i64 %vq_ret, 0
  br i1 %vq_is_zero, label %vquery_fail, label %vq_success

vq_success:
  %offs24 = getelementptr i8, i8* %buf_i8, i64 36
  %var24p = bitcast i8* %offs24 to i32*
  %eax_val = load i32, i32* %var24p, align 4
  %sub4 = sub i32 %eax_val, 4
  %and4 = and i32 %sub4, -5
  %cond1 = icmp eq i32 %and4, 0
  br i1 %cond1, label %inc_and_return, label %check2

check2:
  %sub64 = sub i32 %eax_val, 64
  %and64 = and i32 %sub64, -65
  %cond2 = icmp ne i32 %and64, 0
  br i1 %cond2, label %loc_1840, label %inc_and_return

inc_and_return:
  %old = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %old, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  br label %epilogue_return

loc_1840:
  %baseaddr_ptr = bitcast i8* %buf_i8 to i8**
  %baseaddr = load i8*, i8** %baseaddr_ptr, align 8
  %offs18p = getelementptr i8, i8* %buf_i8, i64 24
  %sizep = bitcast i8* %offs18p to i64*
  %size64 = load i64, i64* %sizep, align 8
  %cmp_eax_2 = icmp eq i32 %eax_val, 2
  %newprot_sel = select i1 %cmp_eax_2, i32 4, i32 64
  %entry_plus8 = getelementptr i8, i8* %entry_ptr, i64 8
  %entry_plus8pp = bitcast i8* %entry_plus8 to i8**
  store i8* %baseaddr, i8** %entry_plus8pp, align 8
  %entry_plus16 = getelementptr i8, i8* %entry_ptr, i64 16
  %entry_plus16p = bitcast i8* %entry_plus16 to i64*
  store i64 %size64, i64* %entry_plus16p, align 8
  %fp_vp_ptr = load i32 (i8*, i64, i32, i8*)*, i32 (i8*, i64, i32, i8*)** @qword_140008290, align 8
  %vp_ret = call i32 %fp_vp_ptr(i8* %baseaddr, i64 %size64, i32 %newprot_sel, i8* %entry_ptr)
  %vp_ok = icmp ne i32 %vp_ret, 0
  br i1 %vp_ok, label %inc_and_return, label %vp_fail

vp_fail:
  %fp_geterr_ptr = load i32 ()*, i32 ()** @qword_140008260, align 8
  %errcode = call i32 %fp_geterr_ptr()
  %str_vp = bitcast i8* @aVirtualprotect to i8*
  call void (i8*, ...) @sub_140001700(i8* %str_vp, i32 %errcode)
  br label %loc_1890

vquery_fail:
  %rdi_off8 = getelementptr i8, i8* %rdi_ptr, i64 8
  %rdi_i32p2 = bitcast i8* %rdi_off8 to i32*
  %edx_msg = load i32, i32* %rdi_i32p2, align 4
  %str_vq = bitcast i8* @aVirtualqueryFa to i8*
  %entry_p24_2 = getelementptr i8, i8* %entry_ptr, i64 24
  %entry_p24pp_2 = bitcast i8* %entry_p24_2 to i8**
  %r8_msg = load i8*, i8** %entry_p24pp_2, align 8
  call void (i8*, ...) @sub_140001700(i8* %str_vq, i32 %edx_msg, i8* %r8_msg)
  br label %print_address_no_section

print_address_no_section:
  %str_addr = bitcast i8* @aAddressPHasNoI to i8*
  call void (i8*, ...) @sub_140001700(i8* %str_addr, i8* %addr)
  br label %epilogue_return

epilogue_return:
  ret void
}