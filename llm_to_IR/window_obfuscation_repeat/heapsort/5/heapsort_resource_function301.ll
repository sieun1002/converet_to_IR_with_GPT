; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002610(i8* %rcx) local_unnamed_addr {
entry:
  %baseptrptr = load i8*, i8** @off_1400043A0, align 8
  %mzp = getelementptr i8, i8* %baseptrptr, i64 0
  %mzp16ptr = bitcast i8* %mzp to i16*
  %mz = load i16, i16* %mzp16ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptrptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr_i8 = getelementptr i8, i8* %baseptrptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %pehdr_i8 to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %get_sections, label %ret0

get_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %cont_sections

cont_sections:
  %soh_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh16 to i64
  %first_sect_i8 = getelementptr i8, i8* %pehdr_i8, i64 24
  %sect_base = getelementptr i8, i8* %first_sect_i8, i64 %soh_zext
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %size_per = mul nuw nsw i64 %numsec64, 40
  %sect_end = getelementptr i8, i8* %sect_base, i64 %size_per
  %rcx_i64 = ptrtoint i8* %rcx to i64
  %base_i64 = ptrtoint i8* %baseptrptr to i64
  %rva = sub i64 %rcx_i64, %base_i64
  br label %loop

loop:
  %cur = phi i8* [ %sect_base, %cont_sections ], [ %next, %loop_continue ]
  %at_end = icmp eq i8* %cur, %sect_end
  br i1 %at_end, label %done, label %check_section

check_section:
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va_zext = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva, %va_zext
  br i1 %rva_lt_va, label %loop_continue, label %check_within

check_within:
  %vs_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 1
  %vs_zext = zext i32 %vs to i64
  %va_plus_vs = add i64 %va_zext, %vs_zext
  %inrange = icmp ult i64 %rva, %va_plus_vs
  br i1 %inrange, label %ret0, label %loop_continue

loop_continue:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

done:
  br label %ret0

ret0:
  ret i32 0
}