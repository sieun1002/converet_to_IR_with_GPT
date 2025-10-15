; ModuleID = 'sub_140002610.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i32 @sub_140002610(i8* %p) {
entry:
  %baseptr.ptr = load i8*, i8** @off_1400043A0, align 1
  %dos_magic_ptr = bitcast i8* %baseptr.ptr to i16*
  %dos_magic = load i16, i16* %dos_magic_ptr, align 1
  %is_mz = icmp eq i16 %dos_magic, 23117
  br i1 %is_mz, label %check_pe_sig, label %ret

check_pe_sig:
  %e_lfanew_ptr = getelementptr i8, i8* %baseptr.ptr, i64 60
  %e_lfanew_iptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_iptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %baseptr.ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt_magic, label %ret

check_opt_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %load_file_header, label %ret

load_file_header:
  %num_sec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %num_sec_ptr = bitcast i8* %num_sec_ptr_i8 to i16*
  %num_sec16 = load i16, i16* %num_sec_ptr, align 1
  %num_zero = icmp eq i16 %num_sec16, 0
  br i1 %num_zero, label %ret, label %cont

cont:
  %opt_size_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr_i8 to i16*
  %opt_size16 = load i16, i16* %opt_size_ptr, align 1
  %rcx_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %baseptr.ptr to i64
  %rva = sub i64 %rcx_int, %base_int
  %opt_size_zext = zext i16 %opt_size16 to i64
  %sec_table_off = add i64 %opt_size_zext, 24
  %first_sec_ptr = getelementptr i8, i8* %nt_ptr, i64 %sec_table_off
  %num_sec_zext = zext i16 %num_sec16 to i64
  %sec_table_size = mul i64 %num_sec_zext, 40
  %end_ptr = getelementptr i8, i8* %first_sec_ptr, i64 %sec_table_size
  br label %loop

loop:
  %cur_phi = phi i8* [ %first_sec_ptr, %cont ], [ %next_ptr, %loop_next ]
  %cmp_end = icmp eq i8* %cur_phi, %end_ptr
  br i1 %cmp_end, label %loop_end, label %check_section

check_section:
  %va_ptr_i8 = getelementptr i8, i8* %cur_phi, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp_rva_va = icmp ult i64 %rva, %va64
  br i1 %cmp_rva_va, label %loop_next, label %check_within

check_within:
  %vs_ptr_i8 = getelementptr i8, i8* %cur_phi, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs32 = load i32, i32* %vs_ptr, align 1
  %vs64 = zext i32 %vs32 to i64
  %end_va = add i64 %va64, %vs64
  %in_range = icmp ult i64 %rva, %end_va
  br i1 %in_range, label %ret, label %loop_next

loop_next:
  %next_ptr = getelementptr i8, i8* %cur_phi, i64 40
  br label %loop

loop_end:
  br label %ret

ret:
  ret i32 0
}