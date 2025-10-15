; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8**)*

declare i8* @sub_140002B68(i32, i32)
declare void @sub_1400024E0()

define i32 @sub_140002080(i8** %rcx) local_unnamed_addr {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx_i32p = bitcast i8* %rdx to i32*
  %eax_val = load i32, i32* %rdx_i32p, align 4
  %masked = and i32 %eax_val, 553648127
  %cmp_magic = icmp eq i32 %masked, 541541187
  br i1 %cmp_magic, label %loc_140002130, label %loc_1400020A1

loc_140002130:                                      ; preds = %entry
  %ptr_plus4 = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %ptr_plus4, align 1
  %b_and1 = and i8 %b, 1
  %nz = icmp ne i8 %b_and1, 0
  br i1 %nz, label %loc_1400020A1, label %def_1400020C7

loc_1400020A1:                                      ; preds = %loc_140002130, %entry
  %eax_a1 = phi i32 [ %eax_val, %entry ], [ %eax_val, %loc_140002130 ]
  %cmp_ja = icmp ugt i32 %eax_a1, 3221225622
  br i1 %cmp_ja, label %loc_1400020EF, label %a1_2

a1_2:                                               ; preds = %loc_1400020A1
  %cmp_jbe = icmp ule i32 %eax_a1, 3221225611
  br i1 %cmp_jbe, label %loc_140002110, label %switch_prep

switch_prep:                                        ; preds = %a1_2
  %adj = add i32 %eax_a1, 1073741683
  %gt9 = icmp ugt i32 %adj, 9
  br i1 %gt9, label %def_1400020C7, label %switch_dispatch

switch_dispatch:                                    ; preds = %switch_prep
  switch i32 %adj, label %def_1400020C7 [
    i32 0, label %loc_1400020D0
    i32 1, label %loc_1400020D0
    i32 2, label %loc_1400020D0
    i32 3, label %loc_1400020D0
    i32 4, label %loc_1400020D0
    i32 5, label %def_1400020C7
    i32 6, label %loc_1400020D0
    i32 7, label %loc_140002190
    i32 8, label %def_1400020C7
    i32 9, label %loc_14000215E
  ]

loc_140002110:                                      ; preds = %a1_2
  %eq_av = icmp eq i32 %eax_a1, 3221225477
  br i1 %eq_av, label %loc_1400021C0, label %after_av_cmp

after_av_cmp:                                       ; preds = %loc_140002110
  %ugt_av = icmp ugt i32 %eax_a1, 3221225477
  br i1 %ugt_av, label %loc_140002150, label %check_80000002

check_80000002:                                     ; preds = %after_av_cmp
  %eq_80000002 = icmp eq i32 %eax_a1, 2147483650
  br i1 %eq_80000002, label %def_1400020C7, label %loc_1400020EF

loc_140002150:                                      ; preds = %after_av_cmp
  %eq_c0000008 = icmp eq i32 %eax_a1, 3221225480
  br i1 %eq_c0000008, label %def_1400020C7, label %check_c000001d

check_c000001d:                                     ; preds = %loc_140002150
  %eq_c000001d = icmp eq i32 %eax_a1, 3221225501
  br i1 %eq_c000001d, label %loc_14000215E, label %loc_1400020EF

loc_1400020D0:                                      ; preds = %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch
  %p_0D0 = call i8* @sub_140002B68(i32 8, i32 0)
  %p_0D0_int = ptrtoint i8* %p_0D0 to i64
  %is_one_0D0 = icmp eq i64 %p_0D0_int, 1
  br i1 %is_one_0D0, label %loc_140002224, label %after_one_0D0

after_one_0D0:                                      ; preds = %loc_1400020D0
  %is_zero_0D0 = icmp eq i8* %p_0D0, null
  br i1 %is_zero_0D0, label %loc_1400020EF, label %loc_1400021F0

loc_140002190:                                      ; preds = %switch_dispatch
  %p_0190 = call i8* @sub_140002B68(i32 8, i32 0)
  %p_0190_int = ptrtoint i8* %p_0190 to i64
  %is_one_0190 = icmp eq i64 %p_0190_int, 1
  br i1 %is_one_0190, label %loc_1400021A6, label %loc_1400020E6

loc_1400021A6:                                      ; preds = %loc_140002190
  %tmp_call_1A6 = call i8* @sub_140002B68(i32 8, i32 1)
  br label %def_1400020C7

loc_1400020E6:                                      ; preds = %loc_140002190
  %is_zero_0E6 = icmp eq i8* %p_0190, null
  br i1 %is_zero_0E6, label %loc_1400020EF, label %loc_1400021F0

loc_14000215E:                                      ; preds = %switch_dispatch, %check_c000001d
  %p_015E = call i8* @sub_140002B68(i32 4, i32 0)
  %p_015E_int = ptrtoint i8* %p_015E to i64
  %is_one_015E = icmp eq i64 %p_015E_int, 1
  br i1 %is_one_015E, label %loc_140002210, label %after_one_015E

after_one_015E:                                     ; preds = %loc_14000215E
  %is_zero_015E = icmp eq i8* %p_015E, null
  br i1 %is_zero_015E, label %loc_1400020EF, label %call_p_015E

call_p_015E:                                        ; preds = %after_one_015E
  %fp_4 = bitcast i8* %p_015E to void (i32)*
  call void %fp_4(i32 4)
  br label %def_1400020C7

loc_1400021C0:                                      ; preds = %loc_140002110
  %p_01C0 = call i8* @sub_140002B68(i32 11, i32 0)
  %p_01C0_int = ptrtoint i8* %p_01C0 to i64
  %is_one_01C0 = icmp eq i64 %p_01C0_int, 1
  br i1 %is_one_01C0, label %loc_1400021FC, label %after_one_01C0

after_one_01C0:                                     ; preds = %loc_1400021C0
  %is_zero_01C0 = icmp eq i8* %p_01C0, null
  br i1 %is_zero_01C0, label %loc_1400020EF, label %call_p_01C0

call_p_01C0:                                        ; preds = %after_one_01C0
  %fp_0B = bitcast i8* %p_01C0 to void (i32)*
  call void %fp_0B(i32 11)
  br label %def_1400020C7

loc_1400021FC:                                      ; preds = %loc_1400021C0
  %tmp_call_1FC = call i8* @sub_140002B68(i32 11, i32 1)
  br label %def_1400020C7

loc_140002210:                                      ; preds = %loc_14000215E
  %tmp_call_210 = call i8* @sub_140002B68(i32 4, i32 1)
  br label %def_1400020C7

loc_140002224:                                      ; preds = %loc_1400020D0
  %tmp_call_224 = call i8* @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %def_1400020C7

loc_1400021F0:                                      ; preds = %loc_1400020E6, %after_one_0D0
  %p_1F0 = phi i8* [ %p_0D0, %after_one_0D0 ], [ %p_0190, %loc_1400020E6 ]
  %fp_8 = bitcast i8* %p_1F0 to void (i32)*
  call void %fp_8(i32 8)
  br label %def_1400020C7

loc_1400020EF:                                      ; preds = %after_one_015E, %after_one_01C0, %loc_1400020E6, %after_one_0D0, %check_80000002, %loc_1400020A1, %check_c000001d
  %handler_fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %is_null_handler = icmp eq i32 (i8**)* %handler_fp, null
  br i1 %is_null_handler, label %loc_140002140, label %call_handler

loc_140002140:                                      ; preds = %loc_1400020EF
  ret i32 0

call_handler:                                       ; preds = %loc_1400020EF
  %retv = tail call i32 %handler_fp(i8** %rcx)
  ret i32 %retv

def_1400020C7:                                      ; preds = %loc_140002224, %loc_140002210, %loc_1400021FC, %call_p_01C0, %call_p_015E, %loc_1400021A6, %switch_dispatch, %switch_dispatch, %switch_prep, %check_80000002, %loc_140002130, %switch_dispatch, %switch_dispatch, %switch_dispatch
  ret i32 -1
}