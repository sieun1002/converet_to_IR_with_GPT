; ModuleID = 'pe_scan'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i8* @sub_1400026D0(i64 %idx) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mzval = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mzval, 23117
  br i1 %mz_ok, label %mz_ok_bb, label %ret_null

mz_ok_bb:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr32, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %ntptr = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %ntptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %nt_ok, label %ret_null

nt_ok:
  %magic_ptr = getelementptr inbounds i8, i8* %ntptr, i64 24
  %magic_ptr16 = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_ptr16, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %pe32p, label %ret_null

pe32p:
  %numsec_ptr = getelementptr inbounds i8, i8* %ntptr, i64 6
  %numsec16_ptr = bitcast i8* %numsec_ptr to i16*
  %numsec16 = load i16, i16* %numsec16_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret_null, label %have_numsec

have_numsec:
  %soh_ptr = getelementptr inbounds i8, i8* %ntptr, i64 20
  %soh16_ptr = bitcast i8* %soh_ptr to i16*
  %soh16 = load i16, i16* %soh16_ptr, align 1
  %soh_zext = zext i16 %soh16 to i64
  %first_sh_ptr = getelementptr inbounds i8, i8* %ntptr, i64 24
  %first_sh_idx = getelementptr inbounds i8, i8* %first_sh_ptr, i64 %soh_zext
  %numsec64 = zext i16 %numsec16 to i64
  %headers_size = mul nuw nsw i64 %numsec64, 40
  %end_ptr = getelementptr inbounds i8, i8* %first_sh_idx, i64 %headers_size
  br label %loop

loop:
  %cur = phi i8* [ %first_sh_idx, %have_numsec ], [ %cur_next, %loop_latch ]
  %idx_phi = phi i64 [ %idx, %have_numsec ], [ %idx_dec, %loop_latch ]
  %done = icmp eq i8* %cur, %end_ptr
  br i1 %done, label %not_found, label %check_section

check_section:
  %char_ptr = getelementptr inbounds i8, i8* %cur, i64 39
  %char = load i8, i8* %char_ptr, align 1
  %mask = and i8 %char, 32
  %is_exec = icmp ne i8 %mask, 0
  br i1 %is_exec, label %exec_check, label %loop_latch

exec_check:
  %is_zero = icmp eq i64 %idx_phi, 0
  br i1 %is_zero, label %ret_cur, label %dec_and_continue

ret_cur:
  ret i8* %cur

dec_and_continue:
  %idx_dec = add i64 %idx_phi, -1
  br label %loop_latch

loop_latch:
  %cur_next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

not_found:
  ret i8* null

ret_null:
  ret i8* null
}