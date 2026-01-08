; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx.i32p = bitcast i8* %rdx to i32*
  %status = load i32, i32* %rdx.i32p, align 4
  %mask = and i32 %status, 553648127
  %sigcmp = icmp eq i32 %mask, 541541187
  br i1 %sigcmp, label %sigcheck, label %after_sig

sigcheck:                                         ; loc_140001D60 path
  %field2.ptr = getelementptr i8, i8* %rdx, i64 4
  %field2.i32p = bitcast i8* %field2.ptr to i32*
  %field2 = load i32, i32* %field2.i32p, align 4
  %bit0 = and i32 %field2, 1
  %bit0nz = icmp ne i32 %bit0, 0
  br i1 %bit0nz, label %after_sig, label %ret_minus1

after_sig:                                        ; loc_140001CD1 path
  %cmp_ugt_0096 = icmp ugt i32 %status, 3221225622
  br i1 %cmp_ugt_0096, label %fallback, label %range_check1

range_check1:
  %cmp_ule_008B = icmp ule i32 %status, 3221225611
  br i1 %cmp_ule_008B, label %block1d40, label %midrange

block1d40:                                        ; loc_140001D40 group
  %eq_0005 = icmp eq i32 %status, 3221225477
  br i1 %eq_0005, label %case_access_violation, label %block1d40_after

block1d40_after:
  %cmp_ja_0005 = icmp ugt i32 %status, 3221225477
  br i1 %cmp_ja_0005, label %block1d80, label %block1d4d

block1d4d:
  %eq_80000002 = icmp eq i32 %status, 2147483650
  br i1 %eq_80000002, label %ret_minus1, label %fallback

block1d80:                                        ; loc_140001D80
  %eq_0008 = icmp eq i32 %status, 3221225480
  br i1 %eq_0008, label %ret_minus1, label %block1d87

block1d87:
  %eq_001D = icmp eq i32 %status, 3221225501
  br i1 %eq_001D, label %case_ecx4, label %fallback

midrange:                                         ; 0xC000008C..0xC0000096
  %ge_008D = icmp uge i32 %status, 3221225613
  %le_0091 = icmp ule i32 %status, 3221225617
  %in_008D_0091 = and i1 %ge_008D, %le_0091
  br i1 %in_008D_0091, label %case_group8_with_2120, label %midrange_chk2

midrange_chk2:
  %eq_0093 = icmp eq i32 %status, 3221225619
  br i1 %eq_0093, label %case_group8_with_2120, label %midrange_chk3

midrange_chk3:
  %eq_0094 = icmp eq i32 %status, 3221225620
  br i1 %eq_0094, label %case_group8_no2120, label %midrange_chk4

midrange_chk4:
  %eq_0096 = icmp eq i32 %status, 3221225622
  br i1 %eq_0096, label %case_ecx4, label %ret_minus1

; case: STATUS_ACCESS_VIOLATION (0xC0000005)
case_access_violation:                            ; loc_140001DF0
  %r_av_0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %r_av_is1 = icmp eq i64 %r_av_0, 1
  br i1 %r_av_is1, label %av_do1, label %av_check0

av_check0:
  %r_av_is0 = icmp eq i64 %r_av_0, 0
  br i1 %r_av_is0, label %fallback, label %av_callfp

av_do1:                                           ; loc_140001E2C
  %r_av_1 = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %ret_minus1

av_callfp:
  %fp_av = inttoptr i64 %r_av_0 to void (i32)*
  call void %fp_av(i32 11)
  br label %ret_minus1

; case: group {0xC000008D..0xC0000091, 0xC0000093}
case_group8_with_2120:                            ; loc_140001D00 path with 1E54
  %r_g8_0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %r_g8_is1 = icmp eq i64 %r_g8_0, 1
  br i1 %r_g8_is1, label %g8_do1_2120, label %g8_check0_2120

g8_check0_2120:
  %r_g8_is0 = icmp eq i64 %r_g8_0, 0
  br i1 %r_g8_is0, label %fallback, label %g8_callfp_2120

g8_do1_2120:                                      ; loc_140001E54
  %r_g8_1 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_minus1

g8_callfp_2120:
  %fp_g8 = inttoptr i64 %r_g8_0 to void (i32)*
  call void %fp_g8(i32 8)
  br label %ret_minus1

; case: 0xC0000094
case_group8_no2120:                               ; loc_140001DC0
  %r_g8n_0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %r_g8n_is1 = icmp eq i64 %r_g8n_0, 1
  br i1 %r_g8n_is1, label %g8n_do1, label %g8n_check0

g8n_check0:
  %r_g8n_is0 = icmp eq i64 %r_g8n_0, 0
  br i1 %r_g8n_is0, label %fallback, label %g8n_callfp

g8n_do1:                                          ; loc_140001DD6..1DE0
  %r_g8n_1 = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %ret_minus1

g8n_callfp:
  %fp_g8n = inttoptr i64 %r_g8n_0 to void (i32)*
  call void %fp_g8n(i32 8)
  br label %ret_minus1

; case: 0xC000001D or 0xC0000096 -> ecx=4 handler
case_ecx4:                                        ; loc_140001D8E
  %r_c4_0 = call i64 @sub_1400027A8(i32 4, i32 0)
  %r_c4_is1 = icmp eq i64 %r_c4_0, 1
  br i1 %r_c4_is1, label %c4_do1, label %c4_check0

c4_check0:
  %r_c4_is0 = icmp eq i64 %r_c4_0, 0
  br i1 %r_c4_is0, label %fallback, label %c4_callfp

c4_do1:                                           ; loc_140001E40
  %r_c4_1 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %ret_minus1

c4_callfp:
  %fp_c4 = inttoptr i64 %r_c4_0 to void (i32)*
  call void %fp_c4(i32 4)
  br label %ret_minus1

fallback:                                         ; loc_140001D1F
  %fp = load i8*, i8** @qword_1400070D0, align 8
  %isnull = icmp eq i8* %fp, null
  br i1 %isnull, label %ret0, label %tail

tail:
  %callee = bitcast i8* %fp to i32 (i8**)*
  %res = tail call i32 %callee(i8** %rcx)
  ret i32 %res

ret0:                                             ; loc_140001D70
  ret i32 0

ret_minus1:                                       ; default/various returns
  ret i32 -1
}