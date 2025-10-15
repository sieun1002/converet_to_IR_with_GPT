; Target: Windows x86-64 PE environment
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002790(i8* %ptr) local_unnamed_addr {
entry:
  %base_ptr_addr = load i8*, i8** @off_1400043A0
  %mzh_ptr = bitcast i8* %base_ptr_addr to i16*
  %mzh = load i16, i16* %mzh_ptr
  %is_mz = icmp eq i16 %mzh, 23117
  br i1 %is_mz, label %check_nt, label %ret0

check_nt:
  %e_lfanew_p = getelementptr i8, i8* %base_ptr_addr, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_p to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_p32
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %base_ptr_addr, i64 %e_lfanew64
  %sig_p32 = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_p32
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magic_p = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_p16 = bitcast i8* %magic_p to i16*
  %magic = load i16, i16* %magic_p16
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %cont_sections, label %ret0

cont_sections:
  %numsec_p = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_p16 = bitcast i8* %numsec_p to i16*
  %numsec16 = load i16, i16* %numsec_p16
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %have_sections

have_sections:
  %soh_p = getelementptr i8, i8* %nt_hdr, i64 20
  %soh_p16 = bitcast i8* %soh_p to i16*
  %soh16 = load i16, i16* %soh_p16
  %soh64 = zext i16 %soh16 to i64
  %first_off = add i64 %soh64, 24
  %first_sec = getelementptr i8, i8* %nt_hdr, i64 %first_off
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %table_sz = mul nuw i64 %numsec64, 40
  %end_sec = getelementptr i8, i8* %first_sec, i64 %table_sz
  %base_i = ptrtoint i8* %base_ptr_addr to i64
  %ptr_i = ptrtoint i8* %ptr to i64
  %rva = sub i64 %ptr_i, %base_i
  br label %loop

loop:
  %cur = phi i8* [ %first_sec, %have_sections ], [ %next, %cont_loop ]
  %va_p = getelementptr i8, i8* %cur, i64 12
  %va_p32 = bitcast i8* %va_p to i32*
  %va32 = load i32, i32* %va_p32
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %cont_loop, label %after_va_cmp

after_va_cmp:
  %vsz_p = getelementptr i8, i8* %cur, i64 8
  %vsz_p32 = bitcast i8* %vsz_p to i32*
  %vsz32 = load i32, i32* %vsz_p32
  %end32 = add i32 %va32, %vsz32
  %end64 = zext i32 %end32 to i64
  %rva_lt_end = icmp ult i64 %rva, %end64
  br i1 %rva_lt_end, label %found, label %cont_loop

cont_loop:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end_sec
  br i1 %done, label %ret0, label %loop

found:
  %ch_p = getelementptr i8, i8* %cur, i64 36
  %ch_p32 = bitcast i8* %ch_p to i32*
  %ch = load i32, i32* %ch_p32
  %ch_not = xor i32 %ch, -1
  %w = lshr i32 %ch_not, 31
  ret i32 %w

ret0:
  ret i32 0
}