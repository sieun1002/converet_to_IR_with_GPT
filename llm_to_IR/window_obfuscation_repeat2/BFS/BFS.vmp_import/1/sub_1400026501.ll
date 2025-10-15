; ModuleID = 'pe_section_find'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002BA0(i8* %arg)
declare i32 @sub_140002BA8(i8* %hdr, i8* %name, i32 %len)

define i8* @sub_140002650(i8* %rcx) {
entry:
  %len = call i64 @sub_140002BA0(i8* %rcx)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %fail_zero, label %check_mz

fail_zero:
  ret i8* null

check_mz:
  %base_ptr_ptr = load i8*, i8** @off_1400043C0, align 8
  %dos_hdr_ptr = bitcast i8* %base_ptr_ptr to i16*
  %dos_magic = load i16, i16* %dos_hdr_ptr, align 2
  %is_mz = icmp eq i16 %dos_magic, 23117
  br i1 %is_mz, label %nt_hdr, label %fail_zero

nt_hdr:
  %e_lfanew_ptr = getelementptr i8, i8* %base_ptr_ptr, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p32, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %base_ptr_ptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %fail_zero

check_opt:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_sections_nonzero, label %fail_zero

check_sections_nonzero:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 2
  %is_zero = icmp eq i16 %numsec, 0
  br i1 %is_zero, label %fail_zero, label %prep_loop

prep_loop:
  %soh_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 2
  %soh_zext = zext i16 %soh to i64
  %opt_end = add i64 %soh_zext, 24
  %first_sec_ptr = getelementptr i8, i8* %nt_ptr, i64 %opt_end
  %numsec_zext = zext i16 %numsec to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %continue ]
  %cur_sec_ptr = phi i8* [ %first_sec_ptr, %prep_loop ], [ %next_sec_ptr, %continue ]
  %callcmp = call i32 @sub_140002BA8(i8* %cur_sec_ptr, i8* %rcx, i32 8)
  %is_zero_cmp = icmp eq i32 %callcmp, 0
  br i1 %is_zero_cmp, label %found, label %continue

found:
  ret i8* %cur_sec_ptr

continue:
  %i_next = add i32 %i, 1
  %next_sec_ptr = getelementptr i8, i8* %cur_sec_ptr, i64 40
  %cond = icmp ult i32 %i_next, %numsec_zext
  br i1 %cond, label %loop, label %fail_zero
}