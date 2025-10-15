; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()

define void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx_i32ptr = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %rdx_i32ptr, align 4
  %mask = and i32 %eax, 553648127
  %is_magic = icmp eq i32 %mask, 541541187
  br i1 %is_magic, label %bb_magic, label %bb_mainpath

bb_magic:                                            ; preds = %entry
  %byteptr = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %byteptr, align 1
  %b1 = and i8 %b, 1
  %is_set = icmp ne i8 %b1, 0
  br i1 %is_set, label %bb_mainpath, label %bb_default

bb_mainpath:                                         ; preds = %bb_magic, %entry
  %cmp_ja_96 = icmp ugt i32 %eax, 3221225622
  br i1 %cmp_ja_96, label %bb_callback_or_zero, label %bb_cmpC000008B

bb_cmpC000008B:                                      ; preds = %bb_mainpath
  %le_8B = icmp ule i32 %eax, 3221225611
  br i1 %le_8B, label %bb_110, label %bb_switch_range

bb_110:                                              ; preds = %bb_cmpC000008B
  %eq_5 = icmp eq i32 %eax, 3221225477
  br i1 %eq_5, label %bb_SIGSEGV, label %bb_110_part2

bb_110_part2:                                        ; preds = %bb_110
  %gt_5 = icmp ugt i32 %eax, 3221225477
  br i1 %gt_5, label %bb_150, label %bb_110_part3

bb_110_part3:                                        ; preds = %bb_110_part2
  %eq_80000002 = icmp eq i32 %eax, 2147483650
  br i1 %eq_80000002, label %bb_return_minus1, label %bb_callback_or_zero

bb_150:                                              ; preds = %bb_110_part2
  %eq_8 = icmp eq i32 %eax, 3221225480
  br i1 %eq_8, label %bb_default, label %bb_150_part2

bb_150_part2:                                        ; preds = %bb_150
  %eq_1D = icmp eq i32 %eax, 3221225501
  br i1 %eq_1D, label %bb_SIGILL, label %bb_callback_or_zero

bb_switch_range:                                     ; preds = %bb_cmpC000008B
  %is_94 = icmp eq i32 %eax, 3221225620
  br i1 %is_94, label %bb_2190, label %bb_switch_part2

bb_switch_part2:                                     ; preds = %bb_switch_range
  %is_96 = icmp eq i32 %eax, 3221225622
  br i1 %is_96, label %bb_SIGILL, label %bb_switch_part3

bb_switch_part3:                                     ; preds = %bb_switch_part2
  %is_92 = icmp eq i32 %eax, 3221225618
  %is_95 = icmp eq i32 %eax, 3221225621
  %is_8C = icmp eq i32 %eax, 3221225612
  %or_def1 = or i1 %is_92, %is_95
  %or_def2 = or i1 %or_def1, %is_8C
  br i1 %or_def2, label %bb_default, label %bb_switch_part4

bb_switch_part4:                                     ; preds = %bb_switch_part3
  %is_8D = icmp eq i32 %eax, 3221225613
  %is_8E = icmp eq i32 %eax, 3221225614
  %is_8F = icmp eq i32 %eax, 3221225615
  %is_90 = icmp eq i32 %eax, 3221225616
  %is_91 = icmp eq i32 %eax, 3221225617
  %is_93 = icmp eq i32 %eax, 3221225619
  %or1 = or i1 %is_8D, %is_8E
  %or2 = or i1 %is_8F, %is_90
  %or3 = or i1 %or1, %or2
  %or4 = or i1 %is_91, %is_93
  %or_all = or i1 %or3, %or4
  br i1 %or_all, label %bb_20D0, label %bb_default

bb_SIGILL:                                           ; preds = %bb_150_part2, %bb_switch_part2
  %call_sig_ill = call i8* @signal(i32 4, i8* null)
  %sig_ign_val_ill = inttoptr i64 1 to i8*
  %is_ign_ill = icmp eq i8* %call_sig_ill, %sig_ign_val_ill
  br i1 %is_ign_ill, label %loc_210, label %sigill_not_ign

sigill_not_ign:                                      ; preds = %bb_SIGILL
  %is_null_ill = icmp eq i8* %call_sig_ill, null
  br i1 %is_null_ill, label %bb_callback_or_zero, label %call_prev_ill

call_prev_ill:                                       ; preds = %sigill_not_ign
  %handler_ill = bitcast i8* %call_sig_ill to void (i32)*
  call void %handler_ill(i32 4)
  br label %bb_default

loc_210:                                             ; preds = %bb_SIGILL
  %set_ill_ign = call i8* @signal(i32 4, i8* inttoptr (i64 1 to i8*))
  br label %bb_default

bb_20D0:                                             ; preds = %bb_switch_part4
  %call_sig_fpe = call i8* @signal(i32 8, i8* null)
  %sig_ign_val = inttoptr i64 1 to i8*
  %is_ign_fpe = icmp eq i8* %call_sig_fpe, %sig_ign_val
  br i1 %is_ign_fpe, label %loc_224, label %fpeA_after

fpeA_after:                                          ; preds = %bb_20D0
  %not_null_fpe = icmp ne i8* %call_sig_fpe, null
  br i1 %not_null_fpe, label %call_prev_fpe, label %bb_callback_or_zero

call_prev_fpe:                                       ; preds = %fpeA_after
  %handler_fpe = bitcast i8* %call_sig_fpe to void (i32)*
  call void %handler_fpe(i32 8)
  br label %bb_default

loc_224:                                             ; preds = %bb_20D0
  %set_fpe_ign = call i8* @signal(i32 8, i8* inttoptr (i64 1 to i8*))
  call void @sub_1400024E0()
  br label %bb_default

bb_2190:                                             ; preds = %bb_switch_range
  %call_sig_fpe2 = call i8* @signal(i32 8, i8* null)
  %sig_ign_val2 = inttoptr i64 1 to i8*
  %is_ign_fpe2 = icmp eq i8* %call_sig_fpe2, %sig_ign_val2
  br i1 %is_ign_fpe2, label %set_ign_and_def, label %after_0E6

set_ign_and_def:                                     ; preds = %bb_2190
  %set_fpe_ign2 = call i8* @signal(i32 8, i8* inttoptr (i64 1 to i8*))
  br label %bb_default

after_0E6:                                           ; preds = %bb_2190
  %not_zero3 = icmp ne i8* %call_sig_fpe2, null
  br i1 %not_zero3, label %call_prev_fpe3, label %bb_callback_or_zero

call_prev_fpe3:                                      ; preds = %after_0E6
  %handler_fpe3 = bitcast i8* %call_sig_fpe2 to void (i32)*
  call void %handler_fpe3(i32 8)
  br label %bb_default

bb_SIGSEGV:                                          ; preds = %bb_110
  %call_sig_segv = call i8* @signal(i32 11, i8* null)
  %sig_ign_val_segv = inttoptr i64 1 to i8*
  %is_ign_segv = icmp eq i8* %call_sig_segv, %sig_ign_val_segv
  br i1 %is_ign_segv, label %loc_1FC, label %segv_not_ign

segv_not_ign:                                        ; preds = %bb_SIGSEGV
  %is_null_segv = icmp eq i8* %call_sig_segv, null
  br i1 %is_null_segv, label %bb_callback_or_zero, label %call_prev_segv

call_prev_segv:                                      ; preds = %segv_not_ign
  %handler_segv = bitcast i8* %call_sig_segv to void (i32)*
  call void %handler_segv(i32 11)
  br label %bb_default

loc_1FC:                                             ; preds = %bb_SIGSEGV
  %set_segv_ign = call i8* @signal(i32 11, i8* inttoptr (i64 1 to i8*))
  br label %bb_default

bb_callback_or_zero:                                 ; preds = %segv_not_ign, %after_0E6, %sigill_not_ign, %fpeA_after, %bb_mainpath, %bb_110_part3, %bb_150_part2, %bb_cmpC000008B
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %is_cb_null = icmp eq i32 (i8**)* %fp, null
  br i1 %is_cb_null, label %ret_zero, label %tailcall_cb

ret_zero:                                            ; preds = %bb_callback_or_zero
  ret i32 0

tailcall_cb:                                         ; preds = %bb_callback_or_zero
  %res = tail call i32 %fp(i8** %rcx)
  ret i32 %res

bb_default:                                          ; preds = %loc_1FC, %call_prev_segv, %set_ign_and_def, %call_prev_fpe3, %loc_224, %call_prev_fpe, %call_prev_ill, %bb_switch_part4, %bb_switch_part3, %bb_150, %bb_magic
  ret i32 -1

bb_return_minus1:                                    ; preds = %bb_110_part3
  ret i32 -1
}