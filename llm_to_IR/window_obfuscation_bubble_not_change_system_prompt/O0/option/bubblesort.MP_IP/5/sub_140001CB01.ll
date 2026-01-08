; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define dso_local i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx_as_i32ptr = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %rdx_as_i32ptr, align 4
  %masked = and i32 %eax, 553648127
  %magic_cmp = icmp eq i32 %masked, 541541187
  br i1 %magic_cmp, label %checkflag, label %cond1

checkflag:                                        ; corresponds to loc_140001D60
  %flagptr = getelementptr i8, i8* %rdx, i64 4
  %flagbyte = load i8, i8* %flagptr, align 1
  %flagand = and i8 %flagbyte, 1
  %flagnz = icmp ne i8 %flagand, 0
  br i1 %flagnz, label %cond1, label %ret_m1

cond1:                                            ; corresponds to loc_140001CD1
  %eax_zext = zext i32 %eax to i64
  %cmp_ugt_0096 = icmp ugt i64 %eax_zext, 3221225622
  br i1 %cmp_ugt_0096, label %delegate, label %le_0096

le_0096:
  %cmp_ule_008B = icmp ule i64 %eax_zext, 3221225611
  br i1 %cmp_ule_008B, label %blockD40, label %switchRange

blockD40:                                         ; corresponds to loc_140001D40
  %eq_0005 = icmp eq i32 %eax, -1073741819        ; 0xC0000005
  br i1 %eq_0005, label %case_DF0, label %after_eq0005

after_eq0005:
  %ugt_0005 = icmp ugt i64 %eax_zext, 3221225477  ; 0xC0000005
  br i1 %ugt_0005, label %blockD80, label %check_80000002

check_80000002:
  %eq_80000002 = icmp eq i32 %eax, -2147483646    ; 0x80000002
  br i1 %eq_80000002, label %ret_m1, label %delegate

blockD80:                                         ; corresponds to loc_140001D80
  %eq_0008 = icmp eq i32 %eax, -1073741816        ; 0xC0000008
  br i1 %eq_0008, label %ret_m1, label %after_0008

after_0008:
  %eq_001D = icmp eq i32 %eax, -1073741795        ; 0xC000001D
  br i1 %eq_001D, label %case_D8E, label %delegate

case_DF0:                                         ; corresponds to loc_140001DF0
  %call_df0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %is_one_df0 = icmp eq i64 %call_df0, 1
  br i1 %is_one_df0, label %loc_E2C, label %check_zero_df0

check_zero_df0:
  %is_zero_df0 = icmp eq i64 %call_df0, 0
  br i1 %is_zero_df0, label %delegate, label %callptr_df0

callptr_df0:
  %fp_df0 = inttoptr i64 %call_df0 to void (i32)*
  call void %fp_df0(i32 11)
  br label %ret_m1

loc_E2C:                                          ; corresponds to loc_140001E2C
  %tmp_e2c = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %ret_m1

case_D8E:                                         ; corresponds to loc_140001D8E (case -1073741674)
  %call_d8e = call i64 @sub_1400027A8(i32 4, i32 0)
  %is_one_d8e = icmp eq i64 %call_d8e, 1
  br i1 %is_one_d8e, label %loc_E40, label %check_zero_d8e

check_zero_d8e:
  %is_zero_d8e = icmp eq i64 %call_d8e, 0
  br i1 %is_zero_d8e, label %delegate, label %callptr_d8e

callptr_d8e:
  %fp_d8e = inttoptr i64 %call_d8e to void (i32)*
  call void %fp_d8e(i32 4)
  br label %ret_m1

loc_E40:                                          ; corresponds to loc_140001E40
  %tmp_e40 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %ret_m1

switchRange:                                      ; corresponds to loc_140001CDF..jumptable
  %eq_0094 = icmp eq i32 %eax, -1073741676        ; 0xC0000094
  br i1 %eq_0094, label %case_DC0, label %not_0094

not_0094:
  %eq_0096 = icmp eq i32 %eax, -1073741674        ; 0xC0000096
  br i1 %eq_0096, label %case_D8E, label %group_G1_or_default

group_G1_or_default:
  %is_0092 = icmp eq i32 %eax, -1073741678        ; 0xC0000092
  %is_0095 = icmp eq i32 %eax, -1073741675        ; 0xC0000095
  %is_def = or i1 %is_0092, %is_0095
  br i1 %is_def, label %ret_m1, label %case_D00

case_D00:                                         ; corresponds to loc_140001D00 (group cases)
  %call_d00 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is_one_d00 = icmp eq i64 %call_d00, 1
  br i1 %is_one_d00, label %loc_E54, label %check_zero_d00

check_zero_d00:
  %is_zero_d00 = icmp eq i64 %call_d00, 0
  br i1 %is_zero_d00, label %delegate, label %loc_E20_from_d00

loc_E20_from_d00:                                 ; corresponds to loc_140001E20
  %fp_d00 = inttoptr i64 %call_d00 to void (i32)*
  call void %fp_d00(i32 8)
  br label %ret_m1

loc_E54:                                          ; corresponds to loc_140001E54
  %tmp_e54_call1 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_m1

case_DC0:                                         ; corresponds to loc_140001DC0 (case -1073741676)
  %call_dc0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is_one_dc0 = icmp eq i64 %call_dc0, 1
  br i1 %is_one_dc0, label %loc_DC0_one, label %loc_DC0_not_one

loc_DC0_not_one:
  %is_zero_dc0 = icmp eq i64 %call_dc0, 0
  br i1 %is_zero_dc0, label %delegate, label %loc_E20_from_dc0

loc_E20_from_dc0:
  %fp_dc0 = inttoptr i64 %call_dc0 to void (i32)*
  call void %fp_dc0(i32 8)
  br label %ret_m1

loc_DC0_one:
  %tmp_dc0_two = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %ret_m1

delegate:                                         ; corresponds to loc_140001D1F and loc_140001D70 paths
  %fpglob = load i8*, i8** @qword_1400070D0, align 8
  %isnull = icmp eq i8* %fpglob, null
  br i1 %isnull, label %ret_zero, label %tailcall

ret_zero:                                         ; corresponds to loc_140001D70
  ret i32 0

tailcall:
  %callee = bitcast i8* %fpglob to i32 (i8**)*
  %res = tail call i32 %callee(i8** %rcx)
  ret i32 %res

ret_m1:                                           ; default return path
  ret i32 -1
}