; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002790(i8* %addr) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mz_ptr, align 2
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %get_nt, label %ret0

get_nt:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_z = zext i32 %e_lfanew to i64
  %nt = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew_z
  %pe_ptr = bitcast i8* %nt to i32*
  %pe_sig = load i32, i32* %pe_ptr, align 4
  %pe_ok = icmp eq i32 %pe_sig, 17744
  br i1 %pe_ok, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %magic_ok = icmp eq i16 %opt_magic, 523
  br i1 %magic_ok, label %get_counts, label %ret0

get_counts:
  %nsec_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec16 = load i16, i16* %nsec_ptr, align 2
  %has_sections = icmp ne i16 %nsec16, 0
  br i1 %has_sections, label %calc_tables, label %ret0

calc_tables:
  %opt_size_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr_i8 to i16*
  %opt_size16 = load i16, i16* %opt_size_ptr, align 2
  %addr_int = ptrtoint i8* %addr to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva64 = sub i64 %addr_int, %base_int
  %nsec32 = zext i16 %nsec16 to i32
  %nminus1_32 = add i32 %nsec32, -1
  %nminus1_64 = zext i32 %nminus1_32 to i64
  %scale5 = mul i64 %nminus1_64, 5
  %opt_size64 = zext i16 %opt_size16 to i64
  %first_sec_base = getelementptr inbounds i8, i8* %nt, i64 24
  %first_sec = getelementptr inbounds i8, i8* %first_sec_base, i64 %opt_size64
  %f40 = mul i64 %scale5, 8
  %end_offset = add i64 %f40, 40
  %end_ptr = getelementptr inbounds i8, i8* %first_sec, i64 %end_offset
  br label %loop

loop:
  %cur = phi i8* [ %first_sec, %calc_tables ], [ %next, %cont ]
  %at_end = icmp eq i8* %cur, %end_ptr
  br i1 %at_end, label %ret0, label %check_section

check_section:
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 4
  %va64_a = zext i32 %va to i64
  %rva_vs_va = icmp ult i64 %rva64, %va64_a
  br i1 %rva_vs_va, label %cont, label %check_end

check_end:
  %vs_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 4
  %va64_b = zext i32 %va to i64
  %vs64 = zext i32 %vs to i64
  %endva = add i64 %va64_b, %vs64
  %in_range = icmp ult i64 %rva64, %endva
  br i1 %in_range, label %found, label %cont

cont:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

found:
  %ch_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 36
  %ch_ptr = bitcast i8* %ch_ptr_i8 to i32*
  %ch = load i32, i32* %ch_ptr, align 4
  %notch = xor i32 %ch, -1
  %wr = lshr i32 %notch, 31
  ret i32 %wr

ret0:
  ret i32 0
}