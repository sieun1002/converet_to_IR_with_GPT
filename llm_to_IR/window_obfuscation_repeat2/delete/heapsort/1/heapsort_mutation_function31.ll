; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare void (i32)* @signal(i32, void (i32)*)
declare void @sub_1400024E0()

define dso_local void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @sub_140002080(i8** %rcx) {
entry:
  %param = alloca i8**, align 8
  store i8** %rcx, i8*** %param, align 8
  %rdx.ptr = load i8*, i8** %rcx
  %code.ptr = bitcast i8* %rdx.ptr to i32*
  %code = load i32, i32* %code.ptr, align 4
  %masked = and i32 %code, 553648127                 ; 0x20FFFFFF
  %cmp_magic = icmp eq i32 %masked, 541474883        ; 0x20474343
  br i1 %cmp_magic, label %check_second_chance, label %cont_A1

check_second_chance:                                   ; 0x140002130
  %off4 = getelementptr i8, i8* %rdx.ptr, i64 4
  %b = load i8, i8* %off4, align 1
  %b1 = and i8 %b, 1
  %tst = icmp ne i8 %b1, 0
  br i1 %tst, label %cont_A1, label %default_path

cont_A1:                                               ; 0x1400020A1
  %cmp_gt_96 = icmp ugt i32 %code, 3221225622         ; 0xC0000096
  br i1 %cmp_gt_96, label %default_path, label %cmp_le_8B

cmp_le_8B:                                             ; 0x1400020A8
  %cmp_le = icmp ule i32 %code, 3221225611            ; 0xC000008B
  br i1 %cmp_le, label %loc_110, label %range_switch_prep

range_switch_prep:                                     ; 0x1400020AF
  %idx_pre = add i32 %code, 1073741683                ; 0x3FFFFF73
  %idx_ok = icmp ule i32 %idx_pre, 9
  br i1 %idx_ok, label %switch_range, label %default_path

switch_range:                                          ; 0x1400020C7 via table
  switch i32 %idx_pre, label %default_path [
    i32 0, label %case_fpe_common     ; 0xC000008D
    i32 1, label %case_fpe_common     ; 0xC000008E
    i32 2, label %case_fpe_common     ; 0xC000008F
    i32 3, label %case_fpe_common     ; 0xC0000090
    i32 4, label %case_fpe_common     ; 0xC0000091
    i32 5, label %default_path        ; 0xC0000092
    i32 6, label %case_fpe_common     ; 0xC0000093
    i32 7, label %case_fpe_divzero    ; 0xC0000094
    i32 8, label %default_path        ; 0xC0000095
    i32 9, label %case_illegal_inst   ; 0xC0000096
  ]

loc_110:                                               ; 0x140002110
  %is_av = icmp eq i32 %code, 3221225477              ; 0xC0000005
  br i1 %is_av, label %case_segv, label %loc_150

loc_150:                                               ; 0x14000211B -> 0x150
  %gt_0005 = icmp ugt i32 %code, 3221225477           ; 0xC0000005
  br i1 %gt_0005, label %loc_150_more, label %check_80000002

check_80000002:                                        ; 0x14000211D
  %is_80000002 = icmp eq i32 %code, 2147483650        ; 0x80000002
  br i1 %is_80000002, label %ret_neg1, label %default_path

loc_150_more:                                          ; 0x140002150
  %is_c0000008 = icmp eq i32 %code, 3221225480        ; 0xC0000008
  br i1 %is_c0000008, label %default_path, label %check_c000001d

check_c000001d:                                        ; 0x140002157
  %is_c000001d = icmp eq i32 %code, 3221225501        ; 0xC000001D
  br i1 %is_c000001d, label %case_illegal_inst, label %default_path

; Cases

case_fpe_common:                                       ; 0x1400020D0
  %sig_null_fpe = call void (i32)* @signal(i32 8, void (i32)* null)
  %cmp_one_fpe = icmp eq void (i32)* %sig_null_fpe, inttoptr (i64 1 to void (i32)*)
  br i1 %cmp_one_fpe, label %loc_2224, label %fpe_after_test

fpe_after_test:                                        ; 0x1400020E6
  %nonzero_handler_fpe = icmp ne void (i32)* %sig_null_fpe, null
  br i1 %nonzero_handler_fpe, label %call_prev_fpe, label %default_path

case_fpe_divzero:                                      ; 0x140002190
  %sig_null_div = call void (i32)* @signal(i32 8, void (i32)* null)
  %cmp_one_div = icmp eq void (i32)* %sig_null_div, inttoptr (i64 1 to void (i32)*)
  br i1 %cmp_one_div, label %set_ignore_fpe, label %div_after_test

div_after_test:                                        ; 0x1400020E6 path
  %nonzero_handler_div = icmp ne void (i32)* %sig_null_div, null
  br i1 %nonzero_handler_div, label %call_prev_fpe_from_div, label %default_path

set_ignore_fpe:                                        ; 0x1400021A6
  %tmp_set_fpe = call void (i32)* @signal(i32 8, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %default_path

case_illegal_inst:                                     ; 0x14000215E
  %sig_null_ill = call void (i32)* @signal(i32 4, void (i32)* null)
  %cmp_one_ill = icmp eq void (i32)* %sig_null_ill, inttoptr (i64 1 to void (i32)*)
  br i1 %cmp_one_ill, label %set_ignore_ill, label %ill_after_test

ill_after_test:                                        ; 0x140002174
  %nonzero_handler_ill = icmp ne void (i32)* %sig_null_ill, null
  br i1 %nonzero_handler_ill, label %call_prev_ill, label %default_path

set_ignore_ill:                                        ; 0x140002210
  %tmp_set_ill = call void (i32)* @signal(i32 4, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %default_path

case_segv:                                             ; 0x1400021C0
  %sig_null_segv = call void (i32)* @signal(i32 11, void (i32)* null)
  %cmp_one_segv = icmp eq void (i32)* %sig_null_segv, inttoptr (i64 1 to void (i32)*)
  br i1 %cmp_one_segv, label %set_ignore_segv, label %segv_after_test

segv_after_test:                                       ; 0x1400021D2
  %nonzero_handler_segv = icmp ne void (i32)* %sig_null_segv, null
  br i1 %nonzero_handler_segv, label %call_prev_segv, label %default_path

set_ignore_segv:                                       ; 0x1400021FC
  %tmp_set_segv = call void (i32)* @signal(i32 11, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %default_path

; Calls to previous handlers

call_prev_fpe:                                         ; 0x1400021F0
  call void %sig_null_fpe(i32 8)
  br label %default_path

call_prev_fpe_from_div:                                ; 0x1400021F0 via div path
  call void %sig_null_div(i32 8)
  br label %default_path

call_prev_ill:                                         ; 0x14000217D
  call void %sig_null_ill(i32 4)
  br label %default_path

call_prev_segv:                                        ; 0x1400021DB
  call void %sig_null_segv(i32 11)
  br label %default_path

loc_2224:                                              ; 0x140002224
  %tmp_set_fpe2 = call void (i32)* @signal(i32 8, void (i32)* inttoptr (i64 1 to void (i32)*))
  call void @sub_1400024E0()
  br label %default_path

ret_neg1:                                              ; 0x140002124
  ret i32 -1

default_path:                                          ; 0x1400020EF and related defaults
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0
  %has_fp = icmp ne i32 (i8**)* %fp, null
  br i1 %has_fp, label %tailcall_ext, label %ret_zero

tailcall_ext:                                          ; 0x1400020FB tail jump
  %saved = load i8**, i8*** %param, align 8
  %res = tail call i32 %fp(i8** %saved)
  ret i32 %res

ret_zero:                                              ; 0x140002140
  ret i32 0
}