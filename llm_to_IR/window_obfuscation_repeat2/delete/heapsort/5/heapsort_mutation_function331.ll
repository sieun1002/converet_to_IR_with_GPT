; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002820(i64 %rva, i32 %index) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %lfanew, label %ret_null

lfanew:
  %e_lfanew_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr_i32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr_i32, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_base = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_base to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_magic, label %ret_null

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_base, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %check_import_dir, label %ret_null

check_import_dir:
  %impdir_ptr_i8 = getelementptr i8, i8* %nt_base, i64 144
  %impdir_ptr = bitcast i8* %impdir_ptr_i8 to i32*
  %impdir = load i32, i32* %impdir_ptr, align 4
  %has_imp = icmp ne i32 %impdir, 0
  br i1 %has_imp, label %load_sections, label %ret_null

load_sections:
  %nsec_ptr_i8 = getelementptr i8, i8* %nt_base, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec16 = load i16, i16* %nsec_ptr, align 2
  %nsec_zero = icmp eq i16 %nsec16, 0
  br i1 %nsec_zero, label %ret_null, label %have_nsec

have_nsec:
  %szopt_ptr_i8 = getelementptr i8, i8* %nt_base, i64 20
  %szopt_ptr = bitcast i8* %szopt_ptr_i8 to i16*
  %szopt16 = load i16, i16* %szopt_ptr, align 2
  %szopt64 = zext i16 %szopt16 to i64
  %firstsect_pre = getelementptr i8, i8* %nt_base, i64 24
  %firstsect = getelementptr i8, i8* %firstsect_pre, i64 %szopt64
  %nsec32 = zext i16 %nsec16 to i32
  %nsec64 = zext i32 %nsec32 to i64
  %totalbytes = mul nuw i64 %nsec64, 40
  %endptr = getelementptr i8, i8* %firstsect, i64 %totalbytes
  br label %sect_loop

sect_loop:
  %curr = phi i8* [ %firstsect, %have_nsec ], [ %next_sect, %advance ]
  %at_end = icmp eq i8* %curr, %endptr
  br i1 %at_end, label %ret_null, label %sect_check

sect_check:
  %vs_ptr_i8 = getelementptr i8, i8* %curr, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 4
  %va_ptr_i8 = getelementptr i8, i8* %curr, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va to i64
  %cmp_rva_va = icmp ult i64 %rva, %va64
  br i1 %cmp_rva_va, label %advance, label %ge_va

ge_va:
  %sum32 = add i32 %va, %vs
  %sum64 = zext i32 %sum32 to i64
  %cmp_rva_sum = icmp ult i64 %rva, %sum64
  br i1 %cmp_rva_sum, label %in_section, label %advance

advance:
  %next_sect = getelementptr i8, i8* %curr, i64 40
  br label %sect_loop

in_section:
  %ptr = getelementptr i8, i8* %base_ptr, i64 %rva
  br label %desc_header

desc_header:
  %desc_ptr = phi i8* [ %ptr, %in_section ], [ %desc_ptr_next, %desc_advance ]
  %idx_phi = phi i32 [ %index, %in_section ], [ %idx_next, %desc_advance ]
  %td_ptr_i8 = getelementptr i8, i8* %desc_ptr, i64 4
  %td_ptr = bitcast i8* %td_ptr_i8 to i32*
  %td = load i32, i32* %td_ptr, align 4
  %td_nonzero = icmp ne i32 %td, 0
  br i1 %td_nonzero, label %desc_check_count, label %desc_check_name

desc_check_name:
  %name_ptr_i8_chk = getelementptr i8, i8* %desc_ptr, i64 12
  %name_ptr_chk = bitcast i8* %name_ptr_i8_chk to i32*
  %name_chk = load i32, i32* %name_ptr_chk, align 4
  %name_zero = icmp eq i32 %name_chk, 0
  br i1 %name_zero, label %ret_null, label %desc_check_count

desc_check_count:
  %idx_pos = icmp sgt i32 %idx_phi, 0
  br i1 %idx_pos, label %desc_advance, label %desc_return

desc_advance:
  %idx_next = add nsw i32 %idx_phi, -1
  %desc_ptr_next = getelementptr i8, i8* %desc_ptr, i64 20
  br label %desc_header

desc_return:
  %name_ptr_i8 = getelementptr i8, i8* %desc_ptr, i64 12
  %name_ptr = bitcast i8* %name_ptr_i8 to i32*
  %name = load i32, i32* %name_ptr, align 4
  %name64 = zext i32 %name to i64
  %retptr = getelementptr i8, i8* %base_ptr, i64 %name64
  ret i8* %retptr

ret_null:
  ret i8* null
}