; ModuleID = 'sub_140001CB0.ll'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

@qword_1400070D0 = external global i32 (i8*)*

define dso_local i32 @sub_140001CB0(i8* %p) local_unnamed_addr {
entry:
  %pp = bitcast i8* %p to i8**
  %rdx = load i8*, i8** %pp, align 8
  %codeptr = bitcast i8* %rdx to i32*
  %code = load i32, i32* %codeptr, align 4
  %masked = and i32 %code, 553648127
  %is_magic = icmp eq i32 %masked, 541541187
  br i1 %is_magic, label %check_flag, label %chain_start

check_flag:                                        ; corresponds to 0x140001D60
  %p4 = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %p4, align 1
  %b1 = and i8 %b, 1
  %flag_set = icmp ne i8 %b1, 0
  br i1 %flag_set, label %chain_start, label %ret_m1

chain_start:                                       ; corresponds to loc_140001CD1 onward
  %cmp_hi = icmp ugt i32 %code, 3221225622
  br i1 %cmp_hi, label %fallback, label %le_8B

le_8B:
  %cmp_le_8B = icmp ule i32 %code, 3221225611
  br i1 %cmp_le_8B, label %block_1d40, label %switch_range

switch_range:
  %idx = add i32 %code, 1073741683
  %in_range = icmp ule i32 %idx, 9
  br i1 %in_range, label %switch_dispatch, label %ret_m1

switch_dispatch:
  switch i32 %idx, label %ret_m1 [
    i32 0, label %case_1d00
    i32 1, label %case_1d00
    i32 2, label %case_1d00
    i32 3, label %case_1d00
    i32 4, label %case_1d00
    i32 6, label %case_1d00
    i32 7, label %case_1dc0
    i32 9, label %case_1d8e
  ]

block_1d40:                                        ; corresponds to 0x140001D40
  %is_av = icmp eq i32 %code, 3221225477
  br i1 %is_av, label %case_1df0, label %gt_0005

gt_0005:
  %is_gt_0005 = icmp ugt i32 %code, 3221225477
  br i1 %is_gt_0005, label %block_1d80, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %ret_m1, label %fallback

block_1d80:                                        ; corresponds to 0x140001D80
  %is_0008 = icmp eq i32 %code, 3221225480
  br i1 %is_0008, label %ret_m1, label %check_001D

check_001D:
  %is_001D = icmp eq i32 %code, 3221225501
  br i1 %is_001D, label %case_1d8e, label %fallback

; case group -> 0x140001D00
case_1d00:
  %r_1d00 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is1_1d00 = icmp eq i64 %r_1d00, 1
  br i1 %is1_1d00, label %do_e54, label %nz_1d00

nz_1d00:
  %is0_1d00 = icmp eq i64 %r_1d00, 0
  br i1 %is0_1d00, label %fallback, label %callptr_e20_8

callptr_e20_8:
  %fp_1d00 = inttoptr i64 %r_1d00 to void (i32)*
  call void %fp_1d00(i32 8)
  br label %ret_m1

do_e54:                                            ; corresponds to 0x140001E54
  %commit1_8 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_m1

; case 7 -> 0x140001DC0
case_1dc0:
  %r_1dc0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is1_1dc0 = icmp eq i64 %r_1dc0, 1
  br i1 %is1_1dc0, label %do_dd6, label %nz_1dc0

nz_1dc0:
  %is0_1dc0 = icmp eq i64 %r_1dc0, 0
  br i1 %is0_1dc0, label %fallback, label %callptr_e20_8_dc0

callptr_e20_8_dc0:
  %fp_1dc0 = inttoptr i64 %r_1dc0 to void (i32)*
  call void %fp_1dc0(i32 8)
  br label %ret_m1

do_dd6:                                            ; corresponds to 0x140001DD6
  %commit_8 = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %ret_m1

; case 9 -> 0x140001D8E
case_1d8e:
  %r_1d8e = call i64 @sub_1400027A8(i32 4, i32 0)
  %is1_1d8e = icmp eq i64 %r_1d8e, 1
  br i1 %is1_1d8e, label %do_e40, label %nz_1d8e

nz_1d8e:
  %is0_1d8e = icmp eq i64 %r_1d8e, 0
  br i1 %is0_1d8e, label %fallback, label %callptr_4

callptr_4:
  %fp_1d8e = inttoptr i64 %r_1d8e to void (i32)*
  call void %fp_1d8e(i32 4)
  br label %ret_m1

do_e40:                                            ; corresponds to 0x140001E40
  %commit_4 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %ret_m1

; access violation -> 0x140001DF0
case_1df0:
  %r_1df0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %is1_1df0 = icmp eq i64 %r_1df0, 1
  br i1 %is1_1df0, label %do_e2c, label %nz_1df0

nz_1df0:
  %is0_1df0 = icmp eq i64 %r_1df0, 0
  br i1 %is0_1df0, label %fallback, label %callptr_0b

callptr_0b:
  %fp_1df0 = inttoptr i64 %r_1df0 to void (i32)*
  call void %fp_1df0(i32 11)
  br label %ret_m1

do_e2c:                                            ; corresponds to 0x140001E2C
  %commit_0b = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %ret_m1

fallback:                                          ; corresponds to 0x140001D1F
  %fp_g = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8*)* %fp_g, null
  br i1 %isnull, label %ret_0, label %tail_fallback

tail_fallback:
  %ret = tail call i32 %fp_g(i8* %p)
  ret i32 %ret

ret_m1:                                            ; default return -1
  ret i32 -1

ret_0:
  ret i32 0
}