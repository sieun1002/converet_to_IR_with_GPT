; ModuleID: 'pe_section_scan'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002670(i64 %rcx) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr16 = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr16, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_i16ptr = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_i16ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %cont1, label %ret0

cont1:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %after_numsec

after_numsec:
  %size_opt_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %size_opt_ptr = bitcast i8* %size_opt_ptr_i8 to i16*
  %size_opt16 = load i16, i16* %size_opt_ptr, align 1
  %size_opt_zext = zext i16 %size_opt16 to i64
  %first_sect_base = getelementptr i8, i8* %nt_ptr, i64 24
  %first_sect_ptr = getelementptr i8, i8* %first_sect_base, i64 %size_opt_zext
  %numsec_zext = zext i16 %numsec16 to i64
  %numsec_minus1 = add i64 %numsec_zext, -1
  %tmp_times4 = shl i64 %numsec_minus1, 2
  %times5 = add i64 %tmp_times4, %numsec_minus1
  %times40 = shl i64 %times5, 3
  %end_ptr_pre = getelementptr i8, i8* %first_sect_ptr, i64 %times40
  %end_ptr = getelementptr i8, i8* %end_ptr_pre, i64 40
  br label %loop

loop:
  %cur_ptr = phi i8* [ %first_sect_ptr, %after_numsec ], [ %next_ptr, %inc ]
  %cnt = phi i64 [ %rcx, %after_numsec ], [ %cnt_next, %inc ]
  %flag_byte_ptr = getelementptr i8, i8* %cur_ptr, i64 39
  %flag_byte = load i8, i8* %flag_byte_ptr, align 1
  %masked = and i8 %flag_byte, 32
  %is_zero_mask = icmp eq i8 %masked, 0
  br i1 %is_zero_mask, label %inc, label %check_counter

check_counter:
  %is_cnt_zero = icmp eq i64 %cnt, 0
  br i1 %is_cnt_zero, label %ret0, label %decr

decr:
  %cnt_dec = add i64 %cnt, -1
  br label %inc

inc:
  %cnt_next = phi i64 [ %cnt, %loop ], [ %cnt_dec, %decr ]
  %next_ptr = getelementptr i8, i8* %cur_ptr, i64 40
  %cmp_end = icmp ne i8* %end_ptr, %next_ptr
  br i1 %cmp_end, label %loop, label %ret0

ret0:
  ret i32 0
}