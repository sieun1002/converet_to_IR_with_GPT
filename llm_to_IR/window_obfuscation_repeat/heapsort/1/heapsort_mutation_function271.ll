; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare i64 @strlen(i8*)
declare i32 @strncmp(i8*, i8*, i64)

define i8* @sub_140002570(i8* %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %len_gt8 = icmp ugt i64 %len, 8
  br i1 %len_gt8, label %ret_zero, label %load_base

ret_zero:
  ret i8* null

load_base:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base_is_null = icmp eq i8* %base, null
  br i1 %base_is_null, label %ret_zero, label %check_mz

check_mz:
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %read_nt, label %ret_zero

read_nt:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt = getelementptr inbounds i8, i8* %base, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %opt_magic_off = getelementptr inbounds i8, i8* %nt, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_off to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %check_sections, label %ret_zero

check_sections:
  %numsec_off = getelementptr inbounds i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_off to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %no_sections = icmp eq i16 %numsec, 0
  br i1 %no_sections, label %ret_zero, label %compute_first_section

compute_first_section:
  %sizeopt_off = getelementptr inbounds i8, i8* %nt, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_off to i16*
  %sizeopt = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt_z = zext i16 %sizeopt to i64
  %sec_base_off = add i64 %sizeopt_z, 24
  %sec_base = getelementptr inbounds i8, i8* %nt, i64 %sec_base_off
  br label %loop

loop:
  %sect_ptr = phi i8* [ %sec_base, %compute_first_section ], [ %next_sect, %loop_next ]
  %idx = phi i32 [ 0, %compute_first_section ], [ %idx_next, %loop_next ]
  %cmpcall = call i32 @strncmp(i8* %sect_ptr, i8* %str, i64 8)
  %eq = icmp eq i32 %cmpcall, 0
  br i1 %eq, label %found, label %loop_next

loop_next:
  %numsec2 = load i16, i16* %numsec_ptr, align 1
  %idx_next = add i32 %idx, 1
  %numsec2_z = zext i16 %numsec2 to i32
  %next_sect = getelementptr inbounds i8, i8* %sect_ptr, i64 40
  %cont = icmp ult i32 %idx_next, %numsec2_z
  br i1 %cont, label %loop, label %ret_zero

found:
  ret i8* %sect_ptr
}