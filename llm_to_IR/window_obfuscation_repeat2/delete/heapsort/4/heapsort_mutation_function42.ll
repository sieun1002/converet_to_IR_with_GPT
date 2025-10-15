; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare void @sub_140001010()
declare void @sub_1400024E0()
declare void (i32)* @signal(i32, void (i32)*)

define void @start() {
entry:
  %p0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %p) {
entry:
  %erptrptr = bitcast i8* %p to i8**
  %erptr = load i8*, i8** %erptrptr, align 8
  %codeptr = bitcast i8* %erptr to i32*
  %code = load i32, i32* %codeptr, align 4
  %masked = and i32 %code, 553648127
  %is_cgc = icmp eq i32 %masked, 541541187
  br i1 %is_cgc, label %cgc_check, label %range_entry

cgc_check:
  %flags_ptr_i8 = getelementptr i8, i8* %erptr, i64 4
  %flags = load i8, i8* %flags_ptr_i8, align 1
  %flag_and = and i8 %flags, 1
  %flag_nz = icmp ne i8 %flag_and, 0
  br i1 %flag_nz, label %range_entry, label %ret_m1

range_entry:
  %ugt_96 = icmp ugt i32 %code, 3221225622
  br i1 %ugt_96, label %fallback, label %le_96

le_96:
  %ule_8B = icmp ule i32 %code, 3221225611
  br i1 %ule_8B, label %loc_2110, label %mid_switch

mid_switch:
  %is_8d = icmp eq i32 %code, 3221225613
  %is_8e = icmp eq i32 %code, 3221225614
  %is_8f = icmp eq i32 %code, 3221225615
  %is_90 = icmp eq i32 %code, 3221225616
  %is_91 = icmp eq i32 %code, 3221225617
  %is_93 = icmp eq i32 %code, 3221225619
  %grp_d0_a = or i1 %is_8d, %is_8e
  %grp_d0_b = or i1 %is_8f, %is_90
  %grp_d0_c = or i1 %is_91, %is_93
  %grp_d0_ab = or i1 %grp_d0_a, %grp_d0_b
  %grp_d0 = or i1 %grp_d0_ab, %grp_d0_c
  br i1 %grp_d0, label %loc_0D0, label %mid_switch_cont

mid_switch_cont:
  %is_94 = icmp eq i32 %code, 3221225620
  br i1 %is_94, label %loc_0190, label %mid_switch_cont2

mid_switch_cont2:
  %is_96 = icmp eq i32 %code, 3221225622
  br i1 %is_96, label %loc_015E, label %ret_m1

loc_2110:
  %eq_05 = icmp eq i32 %code, 3221225477
  br i1 %eq_05, label %loc_01C0, label %after_eq05

after_eq05:
  %ugt_05 = icmp ugt i32 %code, 3221225477
  br i1 %ugt_05, label %loc_0150, label %le_05

le_05:
  %eq_80000002 = icmp eq i32 %code, 2147483650
  br i1 %eq_80000002, label %ret_m1, label %fallback

loc_0150:
  %eq_08 = icmp eq i32 %code, 3221225480
  br i1 %eq_08, label %ret_m1, label %cont_0150

cont_0150:
  %eq_1D = icmp eq i32 %code, 3221225501
  br i1 %eq_1D, label %loc_015E, label %fallback

loc_0D0:
  %h0 = call void (i32)* @signal(i32 8, void (i32)* null)
  %h0_int = ptrtoint void (i32)* %h0 to i64
  %h0_is1 = icmp eq i64 %h0_int, 1
  br i1 %h0_is1, label %loc_0224, label %loc_0D0_after

loc_0D0_after:
  %h0_isnull = icmp eq void (i32)* %h0, null
  br i1 %h0_isnull, label %fallback, label %loc_01F0_h0

loc_01F0_h0:
  call void %h0(i32 8)
  br label %ret_m1

loc_0190:
  %h1 = call void (i32)* @signal(i32 8, void (i32)* null)
  %h1_int = ptrtoint void (i32)* %h1 to i64
  %h1_is1 = icmp eq i64 %h1_int, 1
  br i1 %h1_is1, label %loc_0210, label %loc_0190_after

loc_0190_after:
  %h1_isnull = icmp eq void (i32)* %h1, null
  br i1 %h1_isnull, label %fallback, label %loc_01F0_h1

loc_01F0_h1:
  call void %h1(i32 8)
  br label %ret_m1

loc_015E:
  %h2 = call void (i32)* @signal(i32 4, void (i32)* null)
  %h2_int = ptrtoint void (i32)* %h2 to i64
  %h2_is1 = icmp eq i64 %h2_int, 1
  br i1 %h2_is1, label %loc_0210_4, label %loc_015E_after

loc_015E_after:
  %h2_isnull = icmp eq void (i32)* %h2, null
  br i1 %h2_isnull, label %fallback, label %loc_015E_call

loc_015E_call:
  call void %h2(i32 4)
  br label %ret_m1

loc_01C0:
  %h3 = call void (i32)* @signal(i32 11, void (i32)* null)
  %h3_int = ptrtoint void (i32)* %h3 to i64
  %h3_is1 = icmp eq i64 %h3_int, 1
  br i1 %h3_is1, label %loc_01FC, label %loc_01C0_after

loc_01C0_after:
  %h3_isnull = icmp eq void (i32)* %h3, null
  br i1 %h3_isnull, label %fallback, label %loc_01C0_call

loc_01C0_call:
  call void %h3(i32 11)
  br label %ret_m1

loc_0224:
  %h_set_8 = call void (i32)* @signal(i32 8, void (i32)* inttoptr (i64 1 to void (i32)*))
  call void @sub_1400024E0()
  br label %ret_m1

loc_0210:
  %h_set_8_2 = call void (i32)* @signal(i32 8, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

loc_0210_4:
  %h_set_4 = call void (i32)* @signal(i32 4, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

loc_01FC:
  %h_set_11 = call void (i32)* @signal(i32 11, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

fallback:
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %fp_isnull = icmp eq i32 (i8*)* %fp, null
  br i1 %fp_isnull, label %ret_0, label %tailcall_fp

tailcall_fp:
  %res = tail call i32 %fp(i8* %p)
  ret i32 %res

ret_m1:
  ret i32 -1

ret_0:
  ret i32 0
}