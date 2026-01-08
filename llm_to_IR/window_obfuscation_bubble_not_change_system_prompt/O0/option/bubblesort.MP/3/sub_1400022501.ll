; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_140002250(i8* %arg) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %base_i64 = ptrtoint i8* %baseptr to i64
  %mz_ptr = bitcast i8* %baseptr to i16*
  %mz_val = load i16, i16* %mz_ptr, align 2
  %is_mz = icmp eq i16 %mz_val, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_off = add i64 %base_i64, 60
  %e_lfanew_ptr = inttoptr i64 %e_lfanew_off to i32*
  %e_lfanew_val = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew_val to i64
  %pehdr_i64 = add i64 %base_i64, %e_lfanew_sext
  %pehdr_ptr = inttoptr i64 %pehdr_i64 to i8*
  %pe_sig_ptr = bitcast i8* %pehdr_ptr to i32*
  %pe_sig_val = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig_val, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %optmagic_off = add i64 %pehdr_i64, 24
  %optmagic_ptr = inttoptr i64 %optmagic_off to i16*
  %optmagic_val = load i16, i16* %optmagic_ptr, align 2
  %is_pe32p = icmp eq i16 %optmagic_val, 523
  br i1 %is_pe32p, label %cont1, label %ret0

cont1:
  %numsecs_off = add i64 %pehdr_i64, 6
  %numsecs_ptr = inttoptr i64 %numsecs_off to i16*
  %numsecs_val16 = load i16, i16* %numsecs_ptr, align 2
  %numsecs_is_zero = icmp eq i16 %numsecs_val16, 0
  br i1 %numsecs_is_zero, label %ret0, label %cont2

cont2:
  %soh_off = add i64 %pehdr_i64, 20
  %soh_ptr = inttoptr i64 %soh_off to i16*
  %soh_val16 = load i16, i16* %soh_ptr, align 2
  %soh_zext64 = zext i16 %soh_val16 to i64
  %arg_i64 = ptrtoint i8* %arg to i64
  %rva = sub i64 %arg_i64, %base_i64
  %numsecs_zext32 = zext i16 %numsecs_val16 to i32
  %numsecs_minus1 = add i32 %numsecs_zext32, -1
  %mul5_i32 = mul i32 %numsecs_minus1, 5
  %mul5_i64 = zext i32 %mul5_i32 to i64
  %firstsec_base = add i64 %pehdr_i64, %soh_zext64
  %firstsec_ptr_i64 = add i64 %firstsec_base, 24
  %rdx_times8 = shl i64 %mul5_i64, 3
  %end_tmp = add i64 %firstsec_ptr_i64, %rdx_times8
  %end_ptr_i64 = add i64 %end_tmp, 40
  br label %loop

loop:
  %cur_phi = phi i64 [ %firstsec_ptr_i64, %cont2 ], [ %next_ptr_i64, %inc ]
  %va_off = add i64 %cur_phi, 12
  %va_ptr = inttoptr i64 %va_off to i32*
  %va_val32 = load i32, i32* %va_ptr, align 4
  %va_zext64 = zext i32 %va_val32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va_zext64
  br i1 %rva_lt_va, label %inc, label %range_check

range_check:
  %vsize_off = add i64 %cur_phi, 8
  %vsize_ptr = inttoptr i64 %vsize_off to i32*
  %vsize_val32 = load i32, i32* %vsize_ptr, align 4
  %vsize_zext64 = zext i32 %vsize_val32 to i64
  %end_range = add i64 %va_zext64, %vsize_zext64
  %rva_in = icmp ult i64 %rva, %end_range
  br i1 %rva_in, label %ret0, label %inc

inc:
  %next_ptr_i64 = add i64 %cur_phi, 40
  %not_done = icmp ne i64 %next_ptr_i64, %end_ptr_i64
  br i1 %not_done, label %loop, label %ret0

ret0:
  ret i32 0
}