; ModuleID = 'sub_140001CB0'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8**)*, align 8

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx_ptr = load i8*, i8** %rcx, align 8
  %rdx_i32p = bitcast i8* %rdx_ptr to i32*
  %eax0 = load i32, i32* %rdx_i32p, align 4
  %mask = and i32 %eax0, 0x20FFFFFF
  %sig_ok = icmp eq i32 %mask, 0x20474343
  br i1 %sig_ok, label %L_D60, label %L_CD1

L_D60:                                            ; test byte ptr [rdx+4],1
  %byte4ptr = getelementptr i8, i8* %rdx_ptr, i64 4
  %b4 = load i8, i8* %byte4ptr, align 1
  %b4_and1 = and i8 %b4, 1
  %b4_nz = icmp ne i8 %b4_and1, 0
  br i1 %b4_nz, label %L_CD1, label %L_DefaultRetMinus1

L_CD1:
  %cmp_ja_0096 = icmp ugt i32 %eax0, 0xC0000096
  br i1 %cmp_ja_0096, label %L_D1F, label %L_Cmp_008B

L_Cmp_008B:
  %cmp_jbe_008B = icmp ule i32 %eax0, 0xC000008B
  br i1 %cmp_jbe_008B, label %L_D40, label %L_SwitchGroup

L_SwitchGroup:
  %t = add i32 %eax0, 0x3FFFFF73
  %t_gt9 = icmp ugt i32 %t, 9
  br i1 %t_gt9, label %L_DefaultRetMinus1, label %L_SwitchDispatch

L_SwitchDispatch:
  switch i32 %t, label %L_DefaultRetMinus1 [
    i32 0, label %L_D00
    i32 1, label %L_D00
    i32 2, label %L_D00
    i32 3, label %L_D00
    i32 4, label %L_D00
    i32 6, label %L_D00
    i32 7, label %L_DC0
    i32 5, label %L_DefaultRetMinus1
    i32 8, label %L_DefaultRetMinus1
    i32 9, label %L_D8E
  ]

L_D40:
  %is_0005 = icmp eq i32 %eax0, 0xC0000005
  br i1 %is_0005, label %L_DF0, label %L_D40_cont

L_D40_cont:
  %ugt_0005 = icmp ugt i32 %eax0, 0xC0000005
  br i1 %ugt_0005, label %L_D80, label %L_D40_low

L_D40_low:
  %is_80000002 = icmp eq i32 %eax0, 0x80000002
  br i1 %is_80000002, label %L_DefaultRetMinus1, label %L_D1F

L_D80:
  %is_0008 = icmp eq i32 %eax0, 0xC0000008
  br i1 %is_0008, label %L_DefaultRetMinus1, label %L_D80_chk2

L_D80_chk2:
  %is_001D = icmp eq i32 %eax0, 0xC000001D
  br i1 %is_001D, label %L_D8E, label %L_D1F

; jumptable case handler group: ecx=8
L_D00:
  %r_d00 = call i64 @sub_1400027A8(i32 8, i32 0)
  %r_d00_is1 = icmp eq i64 %r_d00, 1
  br i1 %r_d00_is1, label %L_E54, label %L_D16

; jumptable case: ecx=8 special
L_DC0:
  %r_dc0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %r_dc0_is1 = icmp eq i64 %r_dc0, 1
  br i1 %r_dc0_is1, label %L_E54_setonly, label %L_D16

; shared test rax, rax from 0x140001D16
L_D16:
  %r_phi = phi i64 [ %r_d00, %L_D00 ], [ %r_dc0, %L_DC0 ]
  %r_nz = icmp ne i64 %r_phi, 0
  br i1 %r_nz, label %L_E20, label %L_D1F

; ecx=4 handler (also used by 0xC000001D)
L_D8E:
  %r_d8e = call i64 @sub_1400027A8(i32 4, i32 0)
  %r_d8e_is1 = icmp eq i64 %r_d8e, 1
  br i1 %r_d8e_is1, label %L_E40, label %L_D8E_test

L_D8E_test:
  %r_d8e_nz = icmp ne i64 %r_d8e, 0
  br i1 %r_d8e_nz, label %L_CallRax_ecx4, label %L_D1F

L_CallRax_ecx4:
  %fn4 = inttoptr i64 %r_d8e to void (i32)*
  call void %fn4(i32 4)
  br label %L_DefaultRetMinus1

; access violation handler ecx=0xB
L_DF0:
  %r_df0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %r_df0_is1 = icmp eq i64 %r_df0, 1
  br i1 %r_df0_is1, label %L_E2C, label %L_DF0_test

L_DF0_test:
  %r_df0_nz = icmp ne i64 %r_df0, 0
  br i1 %r_df0_nz, label %L_CallRax_ecxB, label %L_D1F

L_CallRax_ecxB:
  %fnB = inttoptr i64 %r_df0 to void (i32)*
  call void %fnB(i32 11)
  br label %L_DefaultRetMinus1

; call rax with ecx=8
L_E20:
  %fn8 = inttoptr i64 %r_phi to void (i32)*
  call void %fn8(i32 8)
  br label %L_DefaultRetMinus1

; edx=1, ecx=0xB then return -1
L_E2C:
  call i64 @sub_1400027A8(i32 11, i32 1)
  br label %L_DefaultRetMinus1

; edx=1, ecx=4 then return -1
L_E40:
  call i64 @sub_1400027A8(i32 4, i32 1)
  br label %L_DefaultRetMinus1

; edx=1, ecx=8; then call sub_140002120; then return -1
L_E54:
  call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %L_DefaultRetMinus1

; edx=1, ecx=8 only (from 0x140001DC0 path) then return -1
L_E54_setonly:
  call i64 @sub_1400027A8(i32 8, i32 1)
  br label %L_DefaultRetMinus1

L_D1F:
  %p = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %p_isnull = icmp eq i32 (i8**)* %p, null
  br i1 %p_isnull, label %L_ret0, label %L_tail

L_tail:
  %res = tail call i32 %p(i8** %rcx)
  ret i32 %res

L_ret0:
  ret i32 0

L_DefaultRetMinus1:
  ret i32 -1
}