target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %call = call i64 @sub_140002700()
  %cmp1 = icmp ugt i64 %call, 8
  br i1 %cmp1, label %ret_zero, label %check_mz

check_mz:                                            ; preds = %entry
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_header, label %ret_zero

pe_header:                                           ; preds = %check_mz
  %e_lfanew_p = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_p to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p32, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %peptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %pe_sig_p = bitcast i8* %peptr to i32*
  %pe_sig = load i32, i32* %pe_sig_p, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret_zero

check_optmagic:                                      ; preds = %pe_header
  %optmagic_p = getelementptr i8, i8* %peptr, i64 24
  %optmagic_p16 = bitcast i8* %optmagic_p to i16*
  %optmagic = load i16, i16* %optmagic_p16, align 1
  %is_20b = icmp eq i16 %optmagic, 523
  br i1 %is_20b, label %check_numsects, label %ret_zero

check_numsects:                                      ; preds = %check_optmagic
  %numsec_p = getelementptr i8, i8* %peptr, i64 6
  %numsec_p16 = bitcast i8* %numsec_p to i16*
  %numsec = load i16, i16* %numsec_p16, align 1
  %is_zero = icmp eq i16 %numsec, 0
  br i1 %is_zero, label %ret_zero, label %prep_loop

prep_loop:                                           ; preds = %check_numsects
  %szopt_p = getelementptr i8, i8* %peptr, i64 20
  %szopt_p16 = bitcast i8* %szopt_p to i16*
  %szopt = load i16, i16* %szopt_p16, align 1
  %szopt_z = zext i16 %szopt to i64
  %optend = add i64 %szopt_z, 24
  %secptr0 = getelementptr i8, i8* %peptr, i64 %optend
  br label %loop

loop:                                                ; preds = %loop_next, %prep_loop
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %loop_next ]
  %curr_sec = phi i8* [ %secptr0, %prep_loop ], [ %sec_next, %loop_next ]
  %call2 = call i32 @sub_140002708(i8* %curr_sec, i8* %0, i32 8)
  %is_zero_eax = icmp eq i32 %call2, 0
  br i1 %is_zero_eax, label %ret_curr, label %loop_next

loop_next:                                           ; preds = %loop
  %numsec2_p = getelementptr i8, i8* %peptr, i64 6
  %numsec2_p16 = bitcast i8* %numsec2_p to i16*
  %numsec2 = load i16, i16* %numsec2_p16, align 1
  %i_next = add i32 %i, 1
  %sec_next = getelementptr i8, i8* %curr_sec, i64 40
  %numsec2_z = zext i16 %numsec2 to i32
  %more = icmp ult i32 %i_next, %numsec2_z
  br i1 %more, label %loop, label %ret_zero

ret_curr:                                            ; preds = %loop
  ret i8* %curr_sec

ret_zero:                                            ; preds = %loop_next, %check_numsects, %check_optmagic, %pe_header, %check_mz, %entry
  ret i8* null
}