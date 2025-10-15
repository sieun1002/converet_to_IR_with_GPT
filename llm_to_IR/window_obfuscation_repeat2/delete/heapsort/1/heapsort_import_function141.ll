; ModuleID: 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i32 @sub_140002610(i8* %rcx) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %base_i16ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %base_i16ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret

check_pe:                                             ; preds = %entry
  %off_3c_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %off_3c_i32ptr = bitcast i8* %off_3c_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %off_3c_i32ptr, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %pe_hdr_ptr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_i64
  %sig_i32ptr = bitcast i8* %pe_hdr_ptr to i32*
  %sig_load = load i32, i32* %sig_i32ptr, align 1
  %is_pe = icmp eq i32 %sig_load, 17744
  br i1 %is_pe, label %check_opt, label %ret

check_opt:                                            ; preds = %check_pe
  %opt_magic_off = getelementptr i8, i8* %pe_hdr_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_off to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %cont1, label %ret

cont1:                                                ; preds = %check_opt
  %numsec_ptr = getelementptr i8, i8* %pe_hdr_ptr, i64 6
  %numsec_i16ptr = bitcast i8* %numsec_ptr to i16*
  %numsec16 = load i16, i16* %numsec_i16ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret, label %cont2

cont2:                                                ; preds = %cont1
  %soh_ptr = getelementptr i8, i8* %pe_hdr_ptr, i64 20
  %soh_i16ptr = bitcast i8* %soh_ptr to i16*
  %soh16 = load i16, i16* %soh_i16ptr, align 1
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %base_ptr to i64
  %rva = sub i64 %rcx_int, %base_int
  %soh64 = zext i16 %soh16 to i64
  %optplus = add i64 %soh64, 24
  %first_sec_ptr = getelementptr i8, i8* %pe_hdr_ptr, i64 %optplus
  %numsec64 = zext i16 %numsec16 to i64
  %numsec_bytes = mul i64 %numsec64, 40
  %end_ptr = getelementptr i8, i8* %first_sec_ptr, i64 %numsec_bytes
  br label %loop

loop:                                                 ; preds = %loop_next, %cont2
  %cur = phi i8* [ %first_sec_ptr, %cont2 ], [ %next, %loop_next ]
  %at_end = icmp eq i8* %cur, %end_ptr
  br i1 %at_end, label %done, label %check_section

check_section:                                        ; preds = %loop
  %va_off = getelementptr i8, i8* %cur, i64 12
  %va_i32ptr = bitcast i8* %va_off to i32*
  %va_i32 = load i32, i32* %va_i32ptr, align 1
  %va_i64 = zext i32 %va_i32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va_i64
  br i1 %rva_lt_va, label %loop_next, label %check_within

check_within:                                         ; preds = %check_section
  %vs_off = getelementptr i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_off to i32*
  %vs_i32 = load i32, i32* %vs_ptr, align 1
  %vs_i64 = zext i32 %vs_i32 to i64
  %end_va = add i64 %va_i64, %vs_i64
  %rva_lt_end = icmp ult i64 %rva, %end_va
  br i1 %rva_lt_end, label %ret, label %loop_next

loop_next:                                            ; preds = %check_within, %check_section
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

done:                                                 ; preds = %loop
  br label %ret

ret:                                                  ; preds = %done, %check_within, %cont1, %check_opt, %check_pe, %entry
  ret i32 0
}