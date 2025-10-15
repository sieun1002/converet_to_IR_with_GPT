; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002790(i8* %p) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_i16_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_i16_ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %e_off_ptr = getelementptr i8, i8* %baseptr, i64 60
  %e_off_ptr32 = bitcast i8* %e_off_ptr to i32*
  %e_off = load i32, i32* %e_off_ptr32, align 1
  %e_off_z = zext i32 %e_off to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_off_z
  %nt_sig_ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %nt_sig_ptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %get_counts, label %ret0

get_counts:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %have_num

have_num:
  %soh_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %sec_start_off = add i64 %soh64, 24
  %sec_ptr_start = getelementptr i8, i8* %nt_ptr, i64 %sec_start_off
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %secs_bytes = mul i64 %numsec64, 40
  %sec_end_ptr = getelementptr i8, i8* %sec_ptr_start, i64 %secs_bytes
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %p_int, %base_int
  br label %loop

loop:
  %cur = phi i8* [ %sec_ptr_start, %have_num ], [ %sec_next, %next ]
  %at_end = icmp eq i8* %cur, %sec_end_ptr
  br i1 %at_end, label %ret0, label %check_section

check_section:
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %next, label %check_upper

check_upper:
  %vs_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs32 = load i32, i32* %vs_ptr, align 1
  %vs64 = zext i32 %vs32 to i64
  %va_plus_vs = add i64 %va64, %vs64
  %in_range = icmp ult i64 %rva, %va_plus_vs
  br i1 %in_range, label %found, label %next

next:
  %sec_next = getelementptr i8, i8* %cur, i64 40
  br label %loop

found:
  %ch_ptr_i8 = getelementptr i8, i8* %cur, i64 36
  %ch_ptr = bitcast i8* %ch_ptr_i8 to i32*
  %chars = load i32, i32* %ch_ptr, align 1
  %notchars = xor i32 %chars, -1
  %shr = lshr i32 %notchars, 31
  ret i32 %shr

ret0:
  ret i32 0
}