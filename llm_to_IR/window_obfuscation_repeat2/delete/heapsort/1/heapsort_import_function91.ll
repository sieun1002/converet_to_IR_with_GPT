; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i64 @sub_140002B68(i32, i32)
declare void @sub_1400024E0()

define i32 @sub_140002080(i8** %rcx) {
entry:
  %p = load i8*, i8** %rcx
  %p_i32 = bitcast i8* %p to i32*
  %exc = load i32, i32* %p_i32
  %masked = and i32 %exc, 553648127
  %cmp_magic = icmp eq i32 %masked, 541606723
  br i1 %cmp_magic, label %loc_140002130, label %loc_1400020A1

loc_140002130:                                    ; preds = %entry
  %byteptr = getelementptr i8, i8* %p, i64 4
  %b = load i8, i8* %byteptr
  %b_and = and i8 %b, 1
  %b_nz = icmp ne i8 %b_and, 0
  br i1 %b_nz, label %loc_1400020A1, label %ret_m1

loc_1400020A1:                                    ; preds = %loc_140002130, %entry
  %cmp1 = icmp ugt i32 %exc, 3221225622
  br i1 %cmp1, label %loc_1400020EF, label %range_check

range_check:                                      ; preds = %loc_1400020A1
  %cmp2 = icmp ule i32 %exc, 3221225611
  br i1 %cmp2, label %loc_140002110, label %switch_calc

switch_calc:                                      ; preds = %range_check
  %idx_add = add i32 %exc, 1073741683
  %idx_ugt9 = icmp ugt i32 %idx_add, 9
  br i1 %idx_ugt9, label %ret_m1, label %switch_dispatch

switch_dispatch:                                  ; preds = %switch_calc
  switch i32 %idx_add, label %ret_m1 [
    i32 0, label %loc_1400020D0
    i32 1, label %loc_1400020D0
    i32 2, label %loc_1400020D0
    i32 3, label %loc_1400020D0
    i32 4, label %loc_1400020D0
    i32 5, label %ret_m1
    i32 6, label %loc_1400020D0
    i32 7, label %loc_140002190
    i32 8, label %ret_m1
    i32 9, label %loc_14000215E
  ]

loc_1400020D0:                                    ; preds = %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch
  %call_d0 = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one_d0 = icmp eq i64 %call_d0, 1
  br i1 %is_one_d0, label %loc_140002224, label %loc_1400020E6

loc_1400020E6:                                    ; preds = %loc_140002190, %loc_1400020D0
  %phi_e6 = phi i64 [ %call_190, %loc_140002190 ], [ %call_d0, %loc_1400020D0 ]
  %is_nz_e6 = icmp ne i64 %phi_e6, 0
  br i1 %is_nz_e6, label %loc_1400021F0, label %loc_1400020EF

loc_1400020EF:                                    ; preds = %loc_1400020E6, %range_check, %loc_140002110, %loc_140002150, %loc_14000215E, %loc_1400021C0, %loc_140002190, %loc_1400020A1
  %h = load i8*, i8** @qword_1400070D0
  %h_isnull = icmp eq i8* %h, null
  br i1 %h_isnull, label %loc_140002140, label %tailcall

loc_140002110:                                    ; preds = %range_check
  %eq_5 = icmp eq i32 %exc, 3221225477
  br i1 %eq_5, label %loc_1400021C0, label %after_eq5

after_eq5:                                        ; preds = %loc_140002110
  %ugt_5 = icmp ugt i32 %exc, 3221225477
  br i1 %ugt_5, label %loc_140002150, label %le_5_path

le_5_path:                                        ; preds = %after_eq5
  %eq_80000002 = icmp eq i32 %exc, 2147483650
  br i1 %eq_80000002, label %ret_m1, label %loc_1400020EF

ret_m1:                                           ; preds = %switch_calc, %switch_dispatch, %loc_140002130, %le_5_path, %switch_dispatch, %switch_dispatch, %loc_14000215E, %loc_140002190, %loc_1400021F0, %loc_1400021FC, %loc_140002210, %loc_140002224
  ret i32 -1

loc_140002140:                                    ; preds = %loc_1400020EF
  ret i32 0

loc_140002150:                                    ; preds = %after_eq5
  %eq_8 = icmp eq i32 %exc, 3221225480
  br i1 %eq_8, label %ret_m1, label %check_1D

check_1D:                                         ; preds = %loc_140002150
  %eq_1d = icmp eq i32 %exc, 3221225501
  br i1 %eq_1d, label %loc_14000215E, label %loc_1400020EF

loc_14000215E:                                    ; preds = %switch_dispatch, %check_1D
  %call_15e = call i64 @sub_140002B68(i32 4, i32 0)
  %is_one_15e = icmp eq i64 %call_15e, 1
  br i1 %is_one_15e, label %loc_140002210, label %cont_15e

cont_15e:                                         ; preds = %loc_14000215E
  %is_zero_15e = icmp eq i64 %call_15e, 0
  br i1 %is_zero_15e, label %loc_1400020EF, label %call_ind_4

call_ind_4:                                       ; preds = %cont_15e
  %fp_4 = inttoptr i64 %call_15e to void (i32)*
  call void %fp_4(i32 4)
  br label %ret_m1

loc_140002190:                                    ; preds = %switch_dispatch
  %call_190 = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one_190 = icmp eq i64 %call_190, 1
  br i1 %is_one_190, label %loc_1400021A6_path, label %loc_1400020E6

loc_1400021A6_path:                               ; preds = %loc_140002190
  %call_190_again = call i64 @sub_140002B68(i32 8, i32 1)
  br label %ret_m1

loc_1400021C0:                                    ; preds = %loc_140002110
  %call_1c0 = call i64 @sub_140002B68(i32 11, i32 0)
  %is_one_1c0 = icmp eq i64 %call_1c0, 1
  br i1 %is_one_1c0, label %loc_1400021FC, label %cont_1c0

cont_1c0:                                         ; preds = %loc_1400021C0
  %is_zero_1c0 = icmp eq i64 %call_1c0, 0
  br i1 %is_zero_1c0, label %loc_1400020EF, label %call_ind_0b

call_ind_0b:                                      ; preds = %cont_1c0
  %fp_0b = inttoptr i64 %call_1c0 to void (i32)*
  call void %fp_0b(i32 11)
  br label %ret_m1

loc_1400021F0:                                    ; preds = %loc_1400020E6
  %fp_8 = inttoptr i64 %phi_e6 to void (i32)*
  call void %fp_8(i32 8)
  br label %ret_m1

loc_1400021FC:                                    ; preds = %loc_1400021C0
  %call_1fc = call i64 @sub_140002B68(i32 11, i32 1)
  br label %ret_m1

loc_140002210:                                    ; preds = %loc_14000215E
  %call_210 = call i64 @sub_140002B68(i32 4, i32 1)
  br label %ret_m1

loc_140002224:                                    ; preds = %loc_1400020D0
  %call_224 = call i64 @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_m1

tailcall:                                         ; preds = %loc_1400020EF
  %h_cast = bitcast i8* %h to i32 (i8**)*
  %ret = call i32 %h_cast(i8** %rcx)
  ret i32 %ret
}