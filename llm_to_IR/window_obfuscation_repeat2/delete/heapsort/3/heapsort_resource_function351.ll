; ModuleID = 'pe_utils'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

define dso_local i8* @sub_140002820(i64 %rva, i32 %count) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_zext = zext i32 %e_lfanew to i64
  %nt_hdr = getelementptr inbounds i8, i8* %base_ptr, i64 %e_lfanew_zext
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %is_peplus = icmp eq i16 %magic, 523
  br i1 %is_peplus, label %check_dir, label %ret_zero

check_dir:
  %dir_imp_rva_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 144
  %dir_imp_rva_ptr = bitcast i8* %dir_imp_rva_ptr_i8 to i32*
  %dir_imp_rva = load i32, i32* %dir_imp_rva_ptr, align 4
  %has_imp = icmp ne i32 %dir_imp_rva, 0
  br i1 %has_imp, label %check_sections, label %ret_zero

check_sections:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 2
  %has_sections = icmp ne i16 %numsec, 0
  br i1 %has_sections, label %compute_sections, label %ret_zero

compute_sections:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 2
  %soh_z = zext i16 %soh to i64
  %sec_start_off = add i64 %soh_z, 24
  %sec_start = getelementptr inbounds i8, i8* %nt_hdr, i64 %sec_start_off
  %numsec_z = zext i16 %numsec to i64
  %secs_size = mul i64 %numsec_z, 40
  %sec_end = getelementptr inbounds i8, i8* %sec_start, i64 %secs_size
  br label %sec_loop

sec_loop:
  %cur_sec = phi i8* [ %sec_start, %compute_sections ], [ %next_sec, %sec_advance ]
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur_sec, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 4
  %va_z = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva, %va_z
  br i1 %rva_lt_va, label %sec_advance, label %check_in_sec

check_in_sec:
  %vsize_ptr_i8 = getelementptr inbounds i8, i8* %cur_sec, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 4
  %vsize_z = zext i32 %vsize to i64
  %end_va = add i64 %va_z, %vsize_z
  %rva_lt_end = icmp ult i64 %rva, %end_va
  br i1 %rva_lt_end, label %found_section, label %sec_advance

sec_advance:
  %next_sec = getelementptr inbounds i8, i8* %cur_sec, i64 40
  %cont = icmp ne i8* %next_sec, %sec_end
  br i1 %cont, label %sec_loop, label %ret_zero

found_section:
  %table_ptr = getelementptr inbounds i8, i8* %base_ptr, i64 %rva
  br label %scan_loop

scan_loop:
  %p = phi i8* [ %table_ptr, %found_section ], [ %p_next, %scan_iter ]
  %cnt = phi i32 [ %count, %found_section ], [ %cnt_next, %scan_iter ]
  %td_ptr_i8 = getelementptr inbounds i8, i8* %p, i64 4
  %td_ptr = bitcast i8* %td_ptr_i8 to i32*
  %time_date_stamp = load i32, i32* %td_ptr, align 4
  %td_is_zero = icmp eq i32 %time_date_stamp, 0
  br i1 %td_is_zero, label %check_name_zero, label %check_count

check_name_zero:
  %name_ptr_i8_0 = getelementptr inbounds i8, i8* %p, i64 12
  %name_ptr_0 = bitcast i8* %name_ptr_i8_0 to i32*
  %name_rva_0 = load i32, i32* %name_ptr_0, align 4
  %name_zero = icmp eq i32 %name_rva_0, 0
  br i1 %name_zero, label %ret_zero, label %check_count

check_count:
  %cnt_pos = icmp sgt i32 %cnt, 0
  br i1 %cnt_pos, label %scan_iter, label %done

scan_iter:
  %cnt_next = add nsw i32 %cnt, -1
  %p_next = getelementptr inbounds i8, i8* %p, i64 20
  br label %scan_loop

done:
  %name_ptr_i8 = getelementptr inbounds i8, i8* %p, i64 12
  %name_ptr = bitcast i8* %name_ptr_i8 to i32*
  %name_rva = load i32, i32* %name_ptr, align 4
  %name_rva_z = zext i32 %name_rva to i64
  %result = getelementptr inbounds i8, i8* %base_ptr, i64 %name_rva_z
  ret i8* %result

ret_zero:
  ret i8* null
}