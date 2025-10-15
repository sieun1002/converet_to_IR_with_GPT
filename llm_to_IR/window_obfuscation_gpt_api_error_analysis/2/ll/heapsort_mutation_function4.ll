; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.EXCEPTION_RECORD = type { i32, i32 }
%struct.EXCEPTION_POINTERS = type { %struct.EXCEPTION_RECORD*, i8* }

@off_140004400 = external dso_local global i32*, align 8
@qword_1400070D0 = external dso_local global i32 (%struct.EXCEPTION_POINTERS*)*, align 8

declare dso_local void (i32)* @signal(i32 noundef, void (i32)* noundef) local_unnamed_addr
declare dso_local i32 @sub_140001010() local_unnamed_addr
declare dso_local i32 @sub_1400024E0() local_unnamed_addr

define dso_local i32 @start() local_unnamed_addr {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %0, align 4
  %1 = call i32 @sub_140001010()
  ret i32 %1
}

define dso_local i32 @TopLevelExceptionFilter(%struct.EXCEPTION_POINTERS* noundef %exc) local_unnamed_addr {
entry:
  %exc_rec_ptrptr = getelementptr inbounds %struct.EXCEPTION_POINTERS, %struct.EXCEPTION_POINTERS* %exc, i32 0, i32 0
  %exc_rec_ptr = load %struct.EXCEPTION_RECORD*, %struct.EXCEPTION_RECORD** %exc_rec_ptrptr, align 8
  %code_ptr = getelementptr inbounds %struct.EXCEPTION_RECORD, %struct.EXCEPTION_RECORD* %exc_rec_ptr, i32 0, i32 0
  %code = load i32, i32* %code_ptr, align 4
  %masked = and i32 %code, 553648127
  %is_magic = icmp eq i32 %masked, 541541187
  br i1 %is_magic, label %check_flags, label %range_start

check_flags:                                            ; if ((ExceptionCode & 0x20FFFFFF) == 0x20474343)
  %flags_ptr = getelementptr inbounds %struct.EXCEPTION_RECORD, %struct.EXCEPTION_RECORD* %exc_rec_ptr, i32 0, i32 1
  %flags = load i32, i32* %flags_ptr, align 4
  %flag0 = and i32 %flags, 1
  %flag0_set = icmp ne i32 %flag0, 0
  br i1 %flag0_set, label %range_start, label %ret_m1

range_start:
  %gt_96 = icmp ugt i32 %code, 3221225622
  br i1 %gt_96, label %call_unhandled, label %leq_8B_check

leq_8B_check:
  %leq_8B = icmp ule i32 %code, 3221225611
  br i1 %leq_8B, label %leq_8B_path, label %switch_prep

leq_8B_path:
  %eq_0005 = icmp eq i32 %code, 3221225477
  br i1 %eq_0005, label %sig11_handle, label %after_0005

after_0005:
  %above_0005 = icmp ugt i32 %code, 3221225477
  br i1 %above_0005, label %case_0150, label %check_80000002

check_80000002:
  %eq_80000002 = icmp eq i32 %code, 2147483650
  br i1 %eq_80000002, label %ret_m1, label %call_unhandled

case_0150:
  %eq_0008 = icmp eq i32 %code, 3221225480
  br i1 %eq_0008, label %ret_m1, label %check_001D

check_001D:
  %eq_001D = icmp eq i32 %code, 3221225501
  br i1 %eq_001D, label %sig4_handle, label %call_unhandled

switch_prep:
  %idx = add i32 %code, 1073741683
  %idx_gt9 = icmp ugt i32 %idx, 9
  br i1 %idx_gt9, label %ret_m1, label %switch_dispatch

switch_dispatch:
  switch i32 %idx, label %ret_m1 [
    i32 0, label %sig8_generic
    i32 1, label %sig8_generic
    i32 2, label %sig8_generic
    i32 3, label %sig8_generic
    i32 4, label %sig8_generic
    i32 6, label %sig8_generic
    i32 7, label %sig8_divzero_special
    i32 9, label %sig4_handle
  ]

sig8_generic:                                           ; loc_1400020D0
  %h_sig8_g = call void (i32)* @signal(i32 8, void (i32)* null)
  %is_ign_sig8_g = icmp eq void (i32)* %h_sig8_g, inttoptr (i64 1 to void (i32)*)
  br i1 %is_ign_sig8_g, label %sig8_set_ign_and_call_sub, label %sig8_generic_check_null

sig8_set_ign_and_call_sub:                              ; loc_140002224
  %set_ign8_g = call void (i32)* @signal(i32 8, void (i32)* inttoptr (i64 1 to void (i32)*))
  %call_sub_24E0_g = call i32 @sub_1400024E0()
  br label %ret_m1

sig8_generic_check_null:
  %is_null_sig8_g = icmp eq void (i32)* %h_sig8_g, null
  br i1 %is_null_sig8_g, label %call_unhandled, label %call_prev_sig8

sig8_divzero_special:                                   ; loc_140002190
  %h_sig8_d = call void (i32)* @signal(i32 8, void (i32)* null)
  %is_ign_sig8_d = icmp eq void (i32)* %h_sig8_d, inttoptr (i64 1 to void (i32)*)
  br i1 %is_ign_sig8_d, label %sig8_div_set_ign, label %sig8_div_check_null

sig8_div_set_ign:
  %set_ign8_d = call void (i32)* @signal(i32 8, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

sig8_div_check_null:
  %is_null_sig8_d = icmp eq void (i32)* %h_sig8_d, null
  br i1 %is_null_sig8_d, label %call_unhandled, label %call_prev_sig8

call_prev_sig8:                                         ; loc_1400021F0
  %h_phi_sig8 = phi void (i32)* [ %h_sig8_g, %sig8_generic_check_null ], [ %h_sig8_d, %sig8_div_check_null ]
  call void %h_phi_sig8(i32 8)
  br label %ret_m1

sig4_handle:                                            ; loc_14000215E
  %h_sig4 = call void (i32)* @signal(i32 4, void (i32)* null)
  %is_ign_sig4 = icmp eq void (i32)* %h_sig4, inttoptr (i64 1 to void (i32)*)
  br i1 %is_ign_sig4, label %sig4_set_ign, label %sig4_check_null

sig4_set_ign:                                           ; loc_140002210
  %set_ign4 = call void (i32)* @signal(i32 4, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

sig4_check_null:
  %is_null_sig4 = icmp eq void (i32)* %h_sig4, null
  br i1 %is_null_sig4, label %call_unhandled, label %call_prev_sig4

call_prev_sig4:
  call void %h_sig4(i32 4)
  br label %ret_m1

sig11_handle:                                           ; loc_1400021C0
  %h_sig11 = call void (i32)* @signal(i32 11, void (i32)* null)
  %is_ign_sig11 = icmp eq void (i32)* %h_sig11, inttoptr (i64 1 to void (i32)*)
  br i1 %is_ign_sig11, label %sig11_set_ign, label %sig11_check_null

sig11_check_null:
  %is_null_sig11 = icmp eq void (i32)* %h_sig11, null
  br i1 %is_null_sig11, label %call_unhandled, label %call_prev_sig11

call_prev_sig11:
  call void %h_sig11(i32 11)
  br label %ret_m1

sig11_set_ign:                                          ; loc_1400021FC
  %set_ign11 = call void (i32)* @signal(i32 11, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

call_unhandled:                                         ; loc_1400020EF
  %cb = load i32 (%struct.EXCEPTION_POINTERS*)*, i32 (%struct.EXCEPTION_POINTERS*)** @qword_1400070D0, align 8
  %cb_is_null = icmp eq i32 (%struct.EXCEPTION_POINTERS*)* %cb, null
  br i1 %cb_is_null, label %ret_0, label %tail_to_cb

tail_to_cb:
  %ret_cb = call i32 %cb(%struct.EXCEPTION_POINTERS* %exc)
  ret i32 %ret_cb

ret_0:                                                  ; loc_140002140
  ret i32 0

ret_m1:                                                 ; def_1400020C7
  ret i32 -1
}