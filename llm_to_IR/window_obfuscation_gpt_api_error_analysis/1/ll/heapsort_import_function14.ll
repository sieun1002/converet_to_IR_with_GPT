; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002610(i8* %rcx) {
entry:
  %img_base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr_i8 = getelementptr i8, i8* %img_base_ptr, i64 0
  %mz_ptr = bitcast i8* %mz_ptr_i8 to i16*
  %mz_val = load i16, i16* %mz_ptr, align 2
  %is_mz = icmp eq i16 %mz_val, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %img_base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %img_base_ptr, i64 %e_lfanew64
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt_magic, label %ret0

check_opt_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %load_counts, label %ret0

load_counts:
  %numsecs_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %numsecs_ptr = bitcast i8* %numsecs_ptr_i8 to i16*
  %numsecs16 = load i16, i16* %numsecs_ptr, align 2
  %numsecs_is_zero = icmp eq i16 %numsecs16, 0
  br i1 %numsecs_is_zero, label %ret0, label %have_num

have_num:
  %soh_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %opt_start = getelementptr i8, i8* %nt_hdr, i64 24
  %first_sec = getelementptr i8, i8* %opt_start, i64 %soh64
  %numsecs32 = zext i16 %numsecs16 to i32
  %numsecs64 = zext i32 %numsecs32 to i64
  %total_secs_bytes = mul nuw nsw i64 %numsecs64, 40
  %end_ptr = getelementptr i8, i8* %first_sec, i64 %total_secs_bytes
  %rcx_int = ptrtoint i8* %rcx to i64
  %img_int = ptrtoint i8* %img_base_ptr to i64
  %rva = sub i64 %rcx_int, %img_int
  br label %loop

loop:
  %cur = phi i8* [ %first_sec, %have_num ], [ %next, %advance ]
  %done = icmp eq i8* %cur, %end_ptr
  br i1 %done, label %after_loop, label %check_section

check_section:
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %advance, label %check_end

check_end:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 4
  %end32 = add i32 %va32, %vsize32
  %end64 = zext i32 %end32 to i64
  %rva_lt_end = icmp ult i64 %rva, %end64
  br i1 %rva_lt_end, label %ret0, label %advance

advance:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

after_loop:
  br label %ret0

ret0:
  ret i32 0
}