; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare void (i32)* @signal(i32, void (i32)*)
declare void @sub_1400024E0()

define dso_local void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @sub_140002080(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx_i32p = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %rdx_i32p, align 4
  %masked = and i32 %eax, 0x20FFFFFF
  %is_magic = icmp eq i32 %masked, 0x20474343
  br i1 %is_magic, label %check_flag, label %classify_start

check_flag:                                         ; preds = %entry
  %flag_ptr = getelementptr i8, i8* %rdx, i64 4
  %flag_byte = load i8, i8* %flag_ptr, align 1
  %flag_and = and i8 %flag_byte, 1
  %flag_set = icmp ne i8 %flag_and, 0
  br i1 %flag_set, label %classify_start, label %ret_m1

classify_start:                                     ; preds = %check_flag, %entry
  %cmp_gt_0096 = icmp ugt i32 %eax, 0xC0000096
  br i1 %cmp_gt_0096, label %fallback, label %cmp_le_008B

cmp_le_008B:                                        ; preds = %classify_start
  %cmp_le = icmp ule i32 %eax, 0xC000008B
  br i1 %cmp_le, label %le_path, label %range_008C_0096

le_path:                                            ; preds = %cmp_le_008B
  %is_c0000005 = icmp eq i32 %eax, 0xC0000005
  br i1 %is_c0000005, label %case_1C0, label %le_else

le_else:                                            ; preds = %le_path
  %gt_c0000005 = icmp ugt i32 %eax, 0xC0000005
  br i1 %gt_c0000005, label %block_150, label %check_80000002

check_80000002:                                     ; preds = %le_else
  %is_80000002 = icmp eq i32 %eax, 0x80000002
  br i1 %is_80000002, label %ret_m1, label %fallback

block_150:                                          ; preds = %le_else
  %is_c0000008 = icmp eq i32 %eax, 0xC0000008
  br i1 %is_c0000008, label %ret_m1, label %check_c000001d

check_c000001d:                                     ; preds = %block_150
  %is_c000001d = icmp eq i32 %eax, 0xC000001D
  br i1 %is_c000001d, label %case_15E, label %fallback

range_008C_0096:                                    ; preds = %cmp_le_008B
  switch i32 %eax, label %ret_m1 [
    i32 0xC000008D, label %case_D0
    i32 0xC000008E, label %case_D0
    i32 0xC000008F, label %case_D0
    i32 0xC0000090, label %case_D0
    i32 0xC0000091, label %case_D0
    i32 0xC0000093, label %case_D0
    i32 0xC0000094, label %case_190
    i32 0xC000008C, label %ret_m1
    i32 0xC0000092, label %ret_m1
    i32 0xC0000095, label %ret_m1
  ]

case_D0:                                            ; preds = %range_008C_0096, %range_008C_0096, %range_008C_0096, %range_008C_0096, %range_008C_0096, %range_008C_0096
  %sigret_d0 = call void (i32)* @signal(i32 8, void (i32)* null)
  %sig_dfl = inttoptr i64 1 to void (i32)*
  %is_dfl_d0 = icmp eq void (i32)* %sigret_d0, %sig_dfl
  br i1 %is_dfl_d0, label %case_224, label %d0_check_null

d0_check_null:                                      ; preds = %case_D0
  %non_null_d0 = icmp ne void (i32)* %sigret_d0, null
  br i1 %non_null_d0, label %call_handler8, label %fallback

call_handler8:                                      ; preds = %d0_check_null
  call void %sigret_d0(i32 8)
  br label %ret_m1

case_190:                                           ; preds = %range_008C_0096
  %sigret_190 = call void (i32)* @signal(i32 8, void (i32)* null)
  %sig_dfl_190 = inttoptr i64 1 to void (i32)*
  %is_dfl_190 = icmp eq void (i32)* %sigret_190, %sig_dfl_190
  br i1 %is_dfl_190, label %case_210_set, label %e6_path

e6_path:                                            ; preds = %case_190
  %non_null_190 = icmp ne void (i32)* %sigret_190, null
  br i1 %non_null_190, label %call_handler8_again, label %fallback

call_handler8_again:                                ; preds = %e6_path
  call void %sigret_190(i32 8)
  br label %ret_m1

case_1C0:                                           ; preds = %le_path
  %sigret_1c0 = call void (i32)* @signal(i32 11, void (i32)* null)
  %sig_dfl_1c0 = inttoptr i64 1 to void (i32)*
  %is_dfl_1c0 = icmp eq void (i32)* %sigret_1c0, %sig_dfl_1c0
  br i1 %is_dfl_1c0, label %case_1FC_set, label %c1c0_check

c1c0_check:                                         ; preds = %case_1C0
  %non_null_1c0 = icmp ne void (i32)* %sigret_1c0, null
  br i1 %non_null_1c0, label %call_handler11, label %fallback

call_handler11:                                     ; preds = %c1c0_check
  call void %sigret_1c0(i32 11)
  br label %ret_m1

case_15E:                                           ; preds = %check_c000001d
  %sigret_15e = call void (i32)* @signal(i32 4, void (i32)* null)
  %sig_dfl_15e = inttoptr i64 1 to void (i32)*
  %is_dfl_15e = icmp eq void (i32)* %sigret_15e, %sig_dfl_15e
  br i1 %is_dfl_15e, label %case_210_set, label %c15e_check

c15e_check:                                         ; preds = %case_15E
  %non_null_15e = icmp ne void (i32)* %sigret_15e, null
  br i1 %non_null_15e, label %call_handler4, label %fallback

call_handler4:                                      ; preds = %c15e_check
  call void %sigret_15e(i32 4)
  br label %ret_m1

case_224:                                           ; preds = %case_D0
  %sig_dfl_val = inttoptr i64 1 to void (i32)*
  %set_224 = call void (i32)* @signal(i32 8, void (i32)* %sig_dfl_val)
  call void @sub_1400024E0()
  br label %ret_m1

case_210_set:                                       ; preds = %case_15E, %case_190
  %sig_dfl_val2 = inttoptr i64 1 to void (i32)*
  %set_210 = call void (i32)* @signal(i32 4, void (i32)* %sig_dfl_val2)
  br label %ret_m1

case_1FC_set:                                       ; preds = %case_1C0
  %sig_dfl_val3 = inttoptr i64 1 to void (i32)*
  %set_1fc = call void (i32)* @signal(i32 11, void (i32)* %sig_dfl_val3)
  br label %ret_m1

fallback:                                           ; preds = %c15e_check, %c1c0_check, %e6_path, %d0_check_null, %check_80000002, %check_c000001d, %block_150, %cmp_le_008B, %classify_start
  %handler = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %has_handler = icmp ne i32 (i8**)* %handler, null
  br i1 %has_handler, label %do_tail, label %ret_0

do_tail:                                            ; preds = %fallback
  %res = tail call i32 %handler(i8** %rcx)
  ret i32 %res

ret_0:                                              ; preds = %fallback
  ret i32 0

ret_m1:                                             ; preds = %case_1FC_set, %case_210_set, %case_224, %call_handler4, %call_handler11, %call_handler8_again, %call_handler8, %check_80000002, %block_150, %range_008C_0096, %check_flag
  ret i32 -1
}