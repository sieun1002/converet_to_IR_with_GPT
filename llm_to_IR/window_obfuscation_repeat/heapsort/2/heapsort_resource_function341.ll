; ModuleID = 'pe_section_check'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002790(i8* %p) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %chk_pe, label %ret0

chk_pe:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_i32ptr, align 4
  %e_lfanew = sext i32 %e_lfanew_i32 to i64
  %nt = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew
  %sigptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sigptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %after_sig, label %ret0

after_sig:
  %magicptr8 = getelementptr inbounds i8, i8* %nt, i64 24
  %magicptr = bitcast i8* %magicptr8 to i16*
  %magic = load i16, i16* %magicptr, align 2
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %get_sections, label %ret0

get_sections:
  %nsec_ptr8 = getelementptr inbounds i8, i8* %nt, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr8 to i16*
  %nsec16 = load i16, i16* %nsec_ptr, align 2
  %nsec_is_zero = icmp eq i16 %nsec16, 0
  br i1 %nsec_is_zero, label %ret0, label %cont1

cont1:
  %soh_ptr8 = getelementptr inbounds i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh64 = zext i16 %soh16 to i64
  %p_i64 = ptrtoint i8* %p to i64
  %base_i64 = ptrtoint i8* %baseptr to i64
  %delta = sub i64 %p_i64, %base_i64
  %sec_table_start_off = add i64 %soh64, 24
  %sec_table_start = getelementptr inbounds i8, i8* %nt, i64 %sec_table_start_off
  %nsec64 = zext i16 %nsec16 to i64
  %nbytes = mul i64 %nsec64, 40
  %sec_table_end = getelementptr inbounds i8, i8* %sec_table_start, i64 %nbytes
  br label %loop

loop:
  %cur = phi i8* [ %sec_table_start, %cont1 ], [ %next, %loopcont ]
  %at_end = icmp eq i8* %cur, %sec_table_end
  br i1 %at_end, label %return0_from_loop, label %check_section

check_section:
  %va_ptr8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr8 to i32*
  %va32 = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va32 to i64
  %delta_lt_va = icmp ult i64 %delta, %va64
  br i1 %delta_lt_va, label %loopcont, label %after_va_check

after_va_check:
  %vsize_ptr8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 4
  %vsize64 = zext i32 %vsize32 to i64
  %end_rva = add i64 %va64, %vsize64
  %in_range = icmp ult i64 %delta, %end_rva
  br i1 %in_range, label %found, label %loopcont

loopcont:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

found:
  %ch_ptr8 = getelementptr inbounds i8, i8* %cur, i64 36
  %ch_ptr = bitcast i8* %ch_ptr8 to i32*
  %chars = load i32, i32* %ch_ptr, align 4
  %notchars = xor i32 %chars, -1
  %shifted = lshr i32 %notchars, 31
  ret i32 %shifted

return0_from_loop:
  ret i32 0

ret0:
  ret i32 0
}