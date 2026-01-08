; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_140002250(i64 %rcx_in) {
entry:
  %base_ptr = load i8*, i8** @off_1400043C0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %pe_check, label %ret0

pe_check:
  %e_lfanew_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %nt_hdr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_i64
  %pesig_ptr = bitcast i8* %nt_hdr to i32*
  %pesig = load i32, i32* %pesig_ptr, align 1
  %cmp_pe = icmp eq i32 %pesig, 17744
  br i1 %cmp_pe, label %opt_check, label %ret0

opt_check:
  %magic_ptr = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_i16ptr = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_i16ptr, align 1
  %is_pe64 = icmp eq i16 %magic, 523
  br i1 %is_pe64, label %sections_prep, label %ret0

sections_prep:
  %numsec_ptr = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_i16ptr = bitcast i8* %numsec_ptr to i16*
  %numsec_i16 = load i16, i16* %numsec_i16ptr, align 1
  %numsec_zero = icmp eq i16 %numsec_i16, 0
  br i1 %numsec_zero, label %ret0, label %cont_prep

cont_prep:
  %opthdrsize_ptr = getelementptr i8, i8* %nt_hdr, i64 20
  %opthdrsize_i16ptr = bitcast i8* %opthdrsize_ptr to i16*
  %opthdrsize_i16 = load i16, i16* %opthdrsize_i16ptr, align 1
  %retval = zext i16 %opthdrsize_i16 to i32
  %base_int = ptrtoint i8* %base_ptr to i64
  %rcx_minus = sub i64 %rcx_in, %base_int
  %sect_table_base_off = zext i16 %opthdrsize_i16 to i64
  %sect_table_base_ptr_tmp = getelementptr i8, i8* %nt_hdr, i64 24
  %sect_table_base = getelementptr i8, i8* %sect_table_base_ptr_tmp, i64 %sect_table_base_off
  %numsec_i64 = zext i16 %numsec_i16 to i64
  %bytes_sections = mul i64 %numsec_i64, 40
  %sect_table_end = getelementptr i8, i8* %sect_table_base, i64 %bytes_sections
  br label %loop

loop:
  %p = phi i8* [ %sect_table_base, %cont_prep ], [ %p_next, %step ]
  %va_ptr_off = getelementptr i8, i8* %p, i64 12
  %va_i32ptr = bitcast i8* %va_ptr_off to i32*
  %va_i32 = load i32, i32* %va_i32ptr, align 1
  %va_i64 = zext i32 %va_i32 to i64
  %cmp_before = icmp ult i64 %rcx_minus, %va_i64
  br i1 %cmp_before, label %step, label %in_or_after

in_or_after:
  %vsize_ptr_off = getelementptr i8, i8* %p, i64 8
  %vsize_i32ptr = bitcast i8* %vsize_ptr_off to i32*
  %vsize_i32 = load i32, i32* %vsize_i32ptr, align 1
  %sum_i32 = add i32 %va_i32, %vsize_i32
  %sum_i64 = zext i32 %sum_i32 to i64
  %cmp_inside = icmp ult i64 %rcx_minus, %sum_i64
  br i1 %cmp_inside, label %ret_found, label %step

step:
  %p_next = getelementptr i8, i8* %p, i64 40
  %done = icmp eq i8* %p_next, %sect_table_end
  br i1 %done, label %ret0, label %loop

ret_found:
  ret i32 %retval

ret0:
  ret i32 0
}