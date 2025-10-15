; ModuleID = 'pe_section_check'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002610(i8* %ptr) local_unnamed_addr {
entry:
  %imgbase_ptr.addr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %imgbase_ptr.addr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %nt_check, label %ret0

nt_check:                                          ; preds = %entry
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %imgbase_ptr.addr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_ext = sext i32 %e_lfanew to i64
  %nt_hdr = getelementptr i8, i8* %imgbase_ptr.addr, i64 %e_lfanew_ext
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %opt_check, label %ret0

opt_check:                                         ; preds = %nt_check
  %magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %sect_info, label %ret0

sect_info:                                         ; preds = %opt_check
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 2
  %has_sections = icmp ne i16 %numsec, 0
  br i1 %has_sections, label %calc_first_section, label %ret0

calc_first_section:                                ; preds = %sect_info
  %soh_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 2
  %ptr64 = ptrtoint i8* %ptr to i64
  %base64 = ptrtoint i8* %imgbase_ptr.addr to i64
  %rva = sub i64 %ptr64, %base64
  %numsec32 = zext i16 %numsec to i32
  %nminus1 = add i32 %numsec32, -1
  %edx_times4 = mul i32 %nminus1, 4
  %edx5 = add i32 %nminus1, %edx_times4
  %soh64 = zext i16 %soh to i64
  %first_off64 = add i64 %soh64, 24
  %first_section_ptr = getelementptr i8, i8* %nt_hdr, i64 %first_off64
  %rdx8 = zext i32 %edx5 to i64
  %mul8 = mul i64 %rdx8, 8
  %end_sections_temp = getelementptr i8, i8* %first_section_ptr, i64 %mul8
  %end_sections = getelementptr i8, i8* %end_sections_temp, i64 40
  br label %loop

loop:                                              ; preds = %loop_after_cmp, %calc_first_section
  %cur = phi i8* [ %first_section_ptr, %calc_first_section ], [ %next, %loop_after_cmp ]
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va to i64
  %lt_start = icmp ult i64 %rva, %va64
  br i1 %lt_start, label %loop_after_cmp, label %check_end

check_end:                                         ; preds = %loop
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 4
  %vsize64 = zext i32 %vsize to i64
  %end = add i64 %va64, %vsize64
  %inrange = icmp ult i64 %rva, %end
  br i1 %inrange, label %ret0, label %loop_after_cmp

loop_after_cmp:                                    ; preds = %check_end, %loop
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end_sections
  br i1 %done, label %final, label %loop

ret0:                                              ; preds = %check_end, %sect_info, %opt_check, %nt_check, %entry
  ret i32 0

final:                                             ; preds = %loop_after_cmp
  ret i32 0
}