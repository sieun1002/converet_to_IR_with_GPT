target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @sub_140002AC0()
declare i32 @sub_140002AC8(i8*, i8*, i32)

define i8* @sub_140002570(i8* %arg) {
entry:
  %call = call i64 @sub_140002AC0()
  %cmp = icmp ugt i64 %call, 8
  br i1 %cmp, label %zero_ret, label %cont_mz

zero_ret:
  ret i8* null

cont_mz:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_i16ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_i16ptr, align 1
  %mz_cmp = icmp eq i16 %mz, 23117
  br i1 %mz_cmp, label %pe_check, label %zero_ret

pe_check:
  %e_lfanew_ptr_byte = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr_byte to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %pehdr_ptr = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew_i64
  %pe_sig_ptr = bitcast i8* %pehdr_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %opt_magic_check, label %zero_ret

opt_magic_check:
  %opt_magic_off = getelementptr inbounds i8, i8* %pehdr_ptr, i64 24
  %opt_magic_i16ptr = bitcast i8* %opt_magic_off to i16*
  %opt_magic = load i16, i16* %opt_magic_i16ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %numsec_check, label %zero_ret

numsec_check:
  %numsec_off = getelementptr inbounds i8, i8* %pehdr_ptr, i64 6
  %numsec_i16ptr = bitcast i8* %numsec_off to i16*
  %numsec_i16 = load i16, i16* %numsec_i16ptr, align 1
  %has_sections = icmp ne i16 %numsec_i16, 0
  br i1 %has_sections, label %prep_loop, label %zero_ret

prep_loop:
  %soh_off = getelementptr inbounds i8, i8* %pehdr_ptr, i64 20
  %soh_i16ptr = bitcast i8* %soh_off to i16*
  %soh = load i16, i16* %soh_i16ptr, align 1
  %soh_zext = zext i16 %soh to i64
  %sect_table_start = getelementptr inbounds i8, i8* %pehdr_ptr, i64 24
  %first_sect = getelementptr inbounds i8, i8* %sect_table_start, i64 %soh_zext
  br label %loop

loop:
  %idx = phi i32 [ 0, %prep_loop ], [ %idx_next, %loop_continue ]
  %rbx_cur = phi i8* [ %first_sect, %prep_loop ], [ %rbx_next, %loop_continue ]
  %call2 = call i32 @sub_140002AC8(i8* %rbx_cur, i8* %arg, i32 8)
  %is_zero = icmp eq i32 %call2, 0
  br i1 %is_zero, label %found, label %loop_continue

found:
  ret i8* %rbx_cur

loop_continue:
  %numsec_i32 = zext i16 %numsec_i16 to i32
  %idx_next = add nuw nsw i32 %idx, 1
  %rbx_next = getelementptr inbounds i8, i8* %rbx_cur, i64 40
  %cmp_more = icmp ult i32 %idx_next, %numsec_i32
  br i1 %cmp_more, label %loop, label %zero_ret
}