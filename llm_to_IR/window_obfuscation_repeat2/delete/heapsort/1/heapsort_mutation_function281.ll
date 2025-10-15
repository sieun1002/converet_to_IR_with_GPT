; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i32 @sub_140002610(i8* %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0
  %base_i16ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_i16ptr
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %e_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_ptr_i32 = bitcast i8* %e_ptr_i8 to i32*
  %e = load i32, i32* %e_ptr_i32
  %e64 = sext i32 %e to i64
  %base_i64 = ptrtoint i8* %baseptr to i64
  %pe_i64 = add i64 %base_i64, %e64
  %pe_ptr = inttoptr i64 %pe_i64 to i8*
  %sig_ptr = bitcast i8* %pe_ptr to i32*
  %sig = load i32, i32* %sig_ptr
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_opt, label %ret0

check_opt:
  %optmagic_ptr_i8 = getelementptr i8, i8* %pe_ptr, i64 24
  %optmagic_ptr = bitcast i8* %optmagic_ptr_i8 to i16*
  %optmagic = load i16, i16* %optmagic_ptr
  %opt_ok = icmp eq i16 %optmagic, 523
  br i1 %opt_ok, label %get_counts, label %ret0

get_counts:
  %numsec_ptr_i8 = getelementptr i8, i8* %pe_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret0, label %calc_headers

calc_headers:
  %soh_ptr_i8 = getelementptr i8, i8* %pe_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr
  %soh_z = zext i16 %soh to i64
  %rcx_i64 = ptrtoint i8* %rcx to i64
  %rva = sub i64 %rcx_i64, %base_i64
  %first_off = add i64 %soh_z, 24
  %first_i64 = add i64 %pe_i64, %first_off
  %first_ptr = inttoptr i64 %first_i64 to i8*
  %numsec_z = zext i16 %numsec to i64
  %n_minus1 = add i64 %numsec_z, -1
  %mul5 = mul i64 %n_minus1, 5
  %mul40 = mul i64 %mul5, 8
  %end_off = add i64 %mul40, 40
  %end_i64 = add i64 %first_i64, %end_off
  %end_ptr = inttoptr i64 %end_i64 to i8*
  br label %loop

loop:
  %cur = phi i8* [ %first_ptr, %calc_headers ], [ %next_ptr, %loop_inc ]
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr
  %va_z64 = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva, %va_z64
  br i1 %rva_lt_va, label %loop_inc, label %check_inside

check_inside:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr
  %vsize_z64 = zext i32 %vsize to i64
  %endva = add i64 %va_z64, %vsize_z64
  %rva_lt_endva = icmp ult i64 %rva, %endva
  br i1 %rva_lt_endva, label %ret0, label %loop_inc

loop_inc:
  %cur_i64 = ptrtoint i8* %cur to i64
  %next_i64 = add i64 %cur_i64, 40
  %next_ptr = inttoptr i64 %next_i64 to i8*
  %done = icmp eq i8* %next_ptr, %end_ptr
  br i1 %done, label %ret0_xor, label %loop

ret0:
  ret i32 0

ret0_xor:
  ret i32 0
}