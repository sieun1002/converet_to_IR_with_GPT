; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700(i8*)
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %arg) {
entry:
  %call_len = call i64 @sub_140002700(i8* %arg)
  %cmp_len = icmp ugt i64 %call_len, 8
  br i1 %cmp_len, label %ret_zero, label %check_mz

check_mz:                                           ; preds = %entry
  %base_ptr_ptr = load i8*, i8** @off_1400043C0
  %mz_ptr16 = bitcast i8* %base_ptr_ptr to i16*
  %mz_val = load i16, i16* %mz_ptr16, align 1
  %is_mz = icmp eq i16 %mz_val, 23117
  br i1 %is_mz, label %calc_nt, label %ret_zero

calc_nt:                                            ; preds = %check_mz
  %e_lfanew_i8 = getelementptr i8, i8* %base_ptr_ptr, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p32, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr = getelementptr i8, i8* %base_ptr_ptr, i64 %e_lfanew_sext
  %pe_sig_p32 = bitcast i8* %nt_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig_p32, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:                                        ; preds = %calc_nt
  %opt_magic_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %opt_magic_p16 = bitcast i8* %opt_magic_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_p16, align 1
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %check_sections_nonzero, label %ret_zero

check_sections_nonzero:                             ; preds = %check_magic
  %numsec_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_p16 = bitcast i8* %numsec_i8 to i16*
  %numsec_val = load i16, i16* %numsec_p16, align 1
  %numsec_is_zero = icmp eq i16 %numsec_val, 0
  br i1 %numsec_is_zero, label %ret_zero, label %prep_loop

prep_loop:                                          ; preds = %check_sections_nonzero
  %sizeopt_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %sizeopt_p16 = bitcast i8* %sizeopt_i8 to i16*
  %sizeopt_val = load i16, i16* %sizeopt_p16, align 1
  %sizeopt_zext64 = zext i16 %sizeopt_val to i64
  %first_sh_base = getelementptr i8, i8* %nt_hdr, i64 24
  %first_sh = getelementptr i8, i8* %first_sh_base, i64 %sizeopt_zext64
  br label %loop

loop:                                               ; preds = %loop_latch, %prep_loop
  %cur_ptr = phi i8* [ %first_sh, %prep_loop ], [ %next_ptr, %loop_latch ]
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %loop_latch ]
  %call_708 = call i32 @sub_140002708(i8* %cur_ptr, i8* %arg, i32 8)
  %is_zero_708 = icmp eq i32 %call_708, 0
  br i1 %is_zero_708, label %return_cur, label %loop_latch

loop_latch:                                         ; preds = %loop
  %numsec_reload = load i16, i16* %numsec_p16, align 1
  %numsec_reload_z = zext i16 %numsec_reload to i32
  %i_next = add i32 %i, 1
  %next_ptr = getelementptr i8, i8* %cur_ptr, i64 40
  %cont = icmp ult i32 %i_next, %numsec_reload_z
  br i1 %cont, label %loop, label %ret_zero

return_cur:                                         ; preds = %loop
  ret i8* %cur_ptr

ret_zero:                                           ; preds = %loop_latch, %check_sections_nonzero, %check_magic, %calc_nt, %check_mz, %entry
  ret i8* null
}