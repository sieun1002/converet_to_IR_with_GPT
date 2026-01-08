; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32, align 4
@qword_1400070A8 = external dso_local global i8*, align 8
@qword_140008260 = external dso_local global i8*, align 8
@aVirtualprotect = external dso_local global i8, align 1
@aVirtualqueryFa = external dso_local global i8, align 1
@aAddressPHasNoI = external dso_local global i8, align 1

declare dso_local i8* @sub_140002250(i8*)
declare dso_local i8* @sub_140002390()
declare dso_local i64 @loc_1403D6CC2(i8*, i8*, i32)
declare dso_local i32 @sub_1400E9A25(i8*, i64, i32, i8*, ...)
declare dso_local void @sub_140001700(i8*, ...)

define dso_local void @sub_140001760(i8* %rcx) {
entry:
  %mbi = alloca [48 x i8], align 8
  %count = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %count, 0
  br i1 %cmp_le, label %loc_1890, label %loop_init

loop_init:                                            ; preds = %entry
  %baseptr0 = load i8*, i8** @qword_1400070A8, align 8
  %rax0 = getelementptr i8, i8* %baseptr0, i64 24
  br label %loop

loop:                                                 ; preds = %loop_continue, %loop_init
  %rax_phi = phi i8* [ %rax0, %loop_init ], [ %rax_inc, %loop_continue ]
  %i_phi = phi i32 [ 0, %loop_init ], [ %i_next, %loop_continue ]
  %field18_ptr = bitcast i8* %rax_phi to i8**
  %r8_load = load i8*, i8** %field18_ptr, align 8
  %rbx_int = ptrtoint i8* %rcx to i64
  %r8_int = ptrtoint i8* %r8_load to i64
  %cmp1 = icmp ult i64 %rbx_int, %r8_int
  br i1 %cmp1, label %next_in_loop, label %check_range

check_range:                                          ; preds = %loop
  %ptr_rax_plus8 = getelementptr i8, i8* %rax_phi, i64 8
  %ptr_rax_plus8_cast = bitcast i8* %ptr_rax_plus8 to i8**
  %info_ptr = load i8*, i8** %ptr_rax_plus8_cast, align 8
  %info_plus8 = getelementptr i8, i8* %info_ptr, i64 8
  %size32ptr = bitcast i8* %info_plus8 to i32*
  %size32 = load i32, i32* %size32ptr, align 4
  %size64z = zext i32 %size32 to i64
  %endaddr = add i64 %r8_int, %size64z
  %cmp2 = icmp ult i64 %rbx_int, %endaddr
  br i1 %cmp2, label %epilogue, label %next_in_loop

next_in_loop:                                         ; preds = %check_range, %loop
  %i_next = add i32 %i_phi, 1
  %rax_inc = getelementptr i8, i8* %rax_phi, i64 40
  %cmp_i_esi = icmp ne i32 %i_next, %count
  br i1 %cmp_i_esi, label %loop_continue, label %call_2250_pre

loop_continue:                                        ; preds = %next_in_loop
  br label %loop

loc_1890:                                             ; preds = %entry
  br label %call_2250_pre

call_2250_pre:                                        ; preds = %next_in_loop, %loc_1890
  %esi_phi = phi i32 [ 0, %loc_1890 ], [ %count, %next_in_loop ]
  %rdi_val = call i8* @sub_140002250(i8* %rcx)
  %rdi_isnull = icmp eq i8* %rdi_val, null
  br i1 %rdi_isnull, label %err_no_section, label %have_section

have_section:                                         ; preds = %call_2250_pre
  %baseptr1 = load i8*, i8** @qword_1400070A8, align 8
  %esi_i64 = sext i32 %esi_phi to i64
  %mul5 = mul nsw i64 %esi_i64, 5
  %offset_bytes = shl i64 %mul5, 3
  %entry_ptr = getelementptr i8, i8* %baseptr1, i64 %offset_bytes
  %ptr_plus_32 = getelementptr i8, i8* %entry_ptr, i64 32
  %ptr_plus_32_cast = bitcast i8* %ptr_plus_32 to i8**
  store i8* %rdi_val, i8** %ptr_plus_32_cast, align 8
  %entry_dword_ptr = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_dword_ptr, align 4
  %retptr = call i8* @sub_140002390()
  %rdi_plus_12 = getelementptr i8, i8* %rdi_val, i64 12
  %rdi_plus_12_i32ptr = bitcast i8* %rdi_plus_12 to i32*
  %edx_val = load i32, i32* %rdi_plus_12_i32ptr, align 4
  %edx_i64 = zext i32 %edx_val to i64
  %rcx_ptr = getelementptr i8, i8* %retptr, i64 %edx_i64
  %baseptr2 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr2 = getelementptr i8, i8* %baseptr2, i64 %offset_bytes
  %ptr_plus_24 = getelementptr i8, i8* %entry_ptr2, i64 24
  %ptr_plus_24_cast = bitcast i8* %ptr_plus_24 to i8**
  store i8* %rcx_ptr, i8** %ptr_plus_24_cast, align 8
  %mbi_ptr = getelementptr [48 x i8], [48 x i8]* %mbi, i64 0, i64 0
  %retv = call i64 @loc_1403D6CC2(i8* %rcx_ptr, i8* %mbi_ptr, i32 48)
  %iszero = icmp eq i64 %retv, 0
  br i1 %iszero, label %loc_1897, label %after_query

after_query:                                          ; preds = %have_section
  %mbi_plus_36 = getelementptr i8, i8* %mbi_ptr, i64 36
  %mbi_plus_36_i32ptr = bitcast i8* %mbi_plus_36 to i32*
  %eax_val = load i32, i32* %mbi_plus_36_i32ptr, align 4
  %eax_minus_4 = sub i32 %eax_val, 4
  %mask_fb = and i32 %eax_minus_4, -5
  %is_zero1 = icmp eq i32 %mask_fb, 0
  br i1 %is_zero1, label %inc_count, label %check2

check2:                                               ; preds = %after_query
  %eax_minus_64 = sub i32 %eax_val, 64
  %mask_bf = and i32 %eax_minus_64, -65
  %jnz = icmp ne i32 %mask_bf, 0
  br i1 %jnz, label %loc_1840, label %inc_count

inc_count:                                            ; preds = %loc_1840, %after_query
  %oldcnt = load i32, i32* @dword_1400070A4, align 4
  %newcnt = add i32 %oldcnt, 1
  store i32 %newcnt, i32* @dword_1400070A4, align 4
  br label %epilogue

loc_1840:                                             ; preds = %check2
  %is_eq2 = icmp eq i32 %eax_val, 2
  %r8d_val = select i1 %is_eq2, i32 4, i32 64
  %mbi_base_ptrptr = bitcast i8* %mbi_ptr to i8**
  %rcx_base = load i8*, i8** %mbi_base_ptrptr, align 8
  %mbi_plus_24 = getelementptr i8, i8* %mbi_ptr, i64 24
  %mbi_plus_24_i64ptr = bitcast i8* %mbi_plus_24 to i64*
  %rdx_region_size = load i64, i64* %mbi_plus_24_i64ptr, align 8
  %baseptr3 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr3 = getelementptr i8, i8* %baseptr3, i64 %offset_bytes
  %entry_plus_8 = getelementptr i8, i8* %entry_ptr3, i64 8
  %entry_plus_8_ptr = bitcast i8* %entry_plus_8 to i8**
  store i8* %rcx_base, i8** %entry_plus_8_ptr, align 8
  %entry_plus_16 = getelementptr i8, i8* %entry_ptr3, i64 16
  %entry_plus_16_ptr = bitcast i8* %entry_plus_16 to i64*
  store i64 %rdx_region_size, i64* %entry_plus_16_ptr, align 8
  %ret_e9 = call i32 (i8*, i64, i32, i8*, ...) @sub_1400E9A25(i8* %rcx_base, i64 %rdx_region_size, i32 %r8d_val, i8* %entry_ptr3, i64 %rdx_region_size)
  %ret_e9_ne0 = icmp ne i32 %ret_e9, 0
  br i1 %ret_e9_ne0, label %inc_count, label %prot_fail

prot_fail:                                            ; preds = %loc_1840
  %impfp_ptr = load i8*, i8** @qword_140008260, align 8
  %impfp = bitcast i8* %impfp_ptr to i32 ()*
  %gle = call i32 %impfp()
  call void (i8*, ...) @sub_140001700(i8* @aVirtualprotect, i32 %gle)
  br label %epilogue

loc_1897:                                             ; preds = %have_section
  %baseptr4 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr4 = getelementptr i8, i8* %baseptr4, i64 %offset_bytes
  %entry_plus_24_b = getelementptr i8, i8* %entry_ptr4, i64 24
  %entry_plus_24_b_ptr = bitcast i8* %entry_plus_24_b to i8**
  %r8_val = load i8*, i8** %entry_plus_24_b_ptr, align 8
  %rdi_plus8 = getelementptr i8, i8* %rdi_val, i64 8
  %rdi_plus8_i32ptr = bitcast i8* %rdi_plus8 to i32*
  %edx_vq = load i32, i32* %rdi_plus8_i32ptr, align 4
  call void (i8*, ...) @sub_140001700(i8* @aVirtualqueryFa, i32 %edx_vq, i8* %r8_val)
  br label %err_no_section

err_no_section:                                       ; preds = %loc_1897, %call_2250_pre
  call void (i8*, ...) @sub_140001700(i8* @aAddressPHasNoI, i8* %rcx)
  br label %epilogue

epilogue:                                             ; preds = %prot_fail, %inc_count, %check_range
  ret void
}