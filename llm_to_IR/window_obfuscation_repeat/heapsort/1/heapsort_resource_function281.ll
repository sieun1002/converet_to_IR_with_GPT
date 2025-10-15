; ModuleID = 'pe_section_search'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i8* @sub_140002520(i8* %base, i64 %rva) local_unnamed_addr {
entry:
  %dos_off_ptr = getelementptr inbounds i8, i8* %base, i64 60
  %dos_off_int32p = bitcast i8* %dos_off_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %dos_off_int32p, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %nt_ptr = getelementptr inbounds i8, i8* %base, i64 %e_lfanew_i64
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec_i16 = load i16, i16* %numsec_ptr, align 1
  %isZero = icmp eq i16 %numsec_i16, 0
  br i1 %isZero, label %ret_zero, label %have_sections

have_sections:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh_i16 = load i16, i16* %soh_ptr, align 1
  %soh_i64 = zext i16 %soh_i16 to i64
  %off_first_i64 = add i64 %soh_i64, 24
  %first_ptr = getelementptr inbounds i8, i8* %nt_ptr, i64 %off_first_i64
  %n_i64 = zext i16 %numsec_i16 to i64
  %n40_i64 = mul i64 %n_i64, 40
  %end_ptr = getelementptr inbounds i8, i8* %first_ptr, i64 %n40_i64
  br label %loop

loop:
  %cur = phi i8* [ %first_ptr, %have_sections ], [ %next, %loop_cont ]
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va_i32 = load i32, i32* %va_ptr, align 1
  %va_i64 = zext i32 %va_i32 to i64
  %rdx_lt_va = icmp ult i64 %rva, %va_i64
  br i1 %rdx_lt_va, label %loop_cont, label %check_upper

check_upper:
  %vs_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs_i32 = load i32, i32* %vs_ptr, align 1
  %sum32 = add i32 %va_i32, %vs_i32
  %sum_i64 = zext i32 %sum32 to i64
  %rva_below_sum = icmp ult i64 %rva, %sum_i64
  br i1 %rva_below_sum, label %found, label %loop_cont

loop_cont:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end_ptr
  br i1 %done, label %ret_zero, label %loop

found:
  ret i8* %cur

ret_zero:
  ret i8* null
}