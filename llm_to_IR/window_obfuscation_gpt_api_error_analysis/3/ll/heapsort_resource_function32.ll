target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %rcx) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pe_header_ptr = getelementptr inbounds i8, i8* %base_ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %pe_header_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %pe_match = icmp eq i32 %pe_sig, 17744
  br i1 %pe_match, label %check_opt, label %ret0

check_opt:
  %magic_ptr = getelementptr inbounds i8, i8* %pe_header_ptr, i64 24
  %magic_i16ptr = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_i16ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %read_counts, label %ret0

read_counts:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %pe_header_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %has_sections = icmp ne i16 %numsec16, 0
  br i1 %has_sections, label %calc_headers, label %ret0

calc_headers:
  %sizeopt_ptr_i8 = getelementptr inbounds i8, i8* %pe_header_ptr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt_zext = zext i16 %sizeopt16 to i64
  %first_sec_hdr_base = getelementptr inbounds i8, i8* %pe_header_ptr, i64 24
  %first_sec_hdr = getelementptr inbounds i8, i8* %first_sec_hdr_base, i64 %sizeopt_zext
  %numsec_zext = zext i16 %numsec16 to i64
  %numsec_mul40 = mul nuw nsw i64 %numsec_zext, 40
  %end_ptr = getelementptr inbounds i8, i8* %first_sec_hdr, i64 %numsec_mul40
  br label %loop

loop:
  %cur = phi i8* [ %first_sec_hdr, %calc_headers ], [ %next, %loop_next ]
  %cnt = phi i64 [ %rcx, %calc_headers ], [ %cnt_next, %loop_next ]
  %flag_byte_ptr = getelementptr inbounds i8, i8* %cur, i64 39
  %flag_byte = load i8, i8* %flag_byte_ptr, align 1
  %masked = and i8 %flag_byte, 32
  %is_set = icmp ne i8 %masked, 0
  br i1 %is_set, label %if_set, label %loop_next

if_set:
  %cnt_is_zero = icmp eq i64 %cnt, 0
  br i1 %cnt_is_zero, label %ret0, label %decrement

decrement:
  %cnt_dec = add i64 %cnt, -1
  br label %loop_next

loop_next:
  %cnt_next = phi i64 [ %cnt, %loop ], [ %cnt_dec, %decrement ]
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %end_ptr, %next
  br i1 %done, label %exit, label %loop

exit:
  br label %ret0

ret0:
  ret i32 0
}