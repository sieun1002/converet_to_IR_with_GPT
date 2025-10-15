; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %count) local_unnamed_addr {
entry:
  %base_ptr_ptr = bitcast i8** @off_1400043A0 to i8**
  %base_ptr = load i8*, i8** %base_ptr_ptr, align 8
  %magic_ptr = bitcast i8* %base_ptr to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_mz = icmp eq i16 %magic, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_headers_ptr = getelementptr inbounds i8, i8* %base_ptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_headers_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_headers_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %cont1, label %ret0

cont1:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %nt_headers_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_zero, label %ret0, label %have_secs

have_secs:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nt_headers_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh to i64
  %first_sec_offset = add i64 %soh_zext, 24
  %first_sec_ptr = getelementptr inbounds i8, i8* %nt_headers_ptr, i64 %first_sec_offset
  %numsec_zext = zext i16 %numsec to i64
  %total_sec_bytes = mul i64 %numsec_zext, 40
  %end_ptr = getelementptr inbounds i8, i8* %first_sec_ptr, i64 %total_sec_bytes
  br label %loop

loop:
  %cur = phi i8* [ %first_sec_ptr, %have_secs ], [ %next, %loop2 ]
  %end = phi i8* [ %end_ptr, %have_secs ], [ %end, %loop2 ]
  %countphi = phi i64 [ %count, %have_secs ], [ %count_next, %loop2 ]
  %char_ptr_off = getelementptr inbounds i8, i8* %cur, i64 39
  %char_byte = load i8, i8* %char_ptr_off, align 1
  %masked = and i8 %char_byte, 32
  %has_code = icmp ne i8 %masked, 0
  br i1 %has_code, label %code_case, label %no_code

code_case:
  %is_zero = icmp eq i64 %countphi, 0
  br i1 %is_zero, label %ret0, label %dec_then

dec_then:
  %count_dec = add i64 %countphi, -1
  br label %after_case

no_code:
  br label %after_case

after_case:
  %count_m_phi = phi i64 [ %count_dec, %dec_then ], [ %countphi, %no_code ]
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %cont = icmp ne i8* %end, %next
  br i1 %cont, label %loop2, label %ret0

loop2:
  %count_next = phi i64 [ %count_m_phi, %after_case ]
  br label %loop

ret0:
  ret i32 0
}