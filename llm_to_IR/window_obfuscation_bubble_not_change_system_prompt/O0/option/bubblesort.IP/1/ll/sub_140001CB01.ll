; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i64 (i8*)*

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i64 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %p_i32 = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %p_i32, align 4
  %ecx_mask = and i32 %eax, 553648127
  %cmp_magic = icmp eq i32 %ecx_mask, 541541187
  br i1 %cmp_magic, label %d60, label %cd1

d60:                                              ; preds = %entry
  %p_byte4 = getelementptr i8, i8* %rdx, i64 4
  %b4 = load i8, i8* %p_byte4, align 1
  %and1 = and i8 %b4, 1
  %test = icmp ne i8 %and1, 0
  br i1 %test, label %cd1, label %default

cd1:                                              ; preds = %d60, %entry
  %cmp_ugt_96 = icmp ugt i32 %eax, 3221225622
  br i1 %cmp_ugt_96, label %d1f, label %range_le_96

range_le_96:                                      ; preds = %cd1
  %cmp_ule_8b = icmp ule i32 %eax, 3221225611
  br i1 %cmp_ule_8b, label %d40, label %switch_range

switch_range:                                     ; preds = %range_le_96
  switch i32 %eax, label %default [
    i32 3221225613, label %d00
    i32 3221225614, label %d00
    i32 3221225615, label %d00
    i32 3221225616, label %d00
    i32 3221225617, label %d00
    i32 3221225619, label %d00
    i32 3221225620, label %dc0
    i32 3221225622, label %d8e
  ]

d40:                                              ; preds = %range_le_96
  %cmp_eq_0005 = icmp eq i32 %eax, 3221225477
  br i1 %cmp_eq_0005, label %df0, label %d40_after_0005

d40_after_0005:                                   ; preds = %d40
  %cmp_ugt_0005 = icmp ugt i32 %eax, 3221225477
  br i1 %cmp_ugt_0005, label %d80, label %d40_check80000002

d40_check80000002:                                ; preds = %d40_after_0005
  %cmp_eq_80000002 = icmp eq i32 %eax, 2147483650
  br i1 %cmp_eq_80000002, label %ret_minus1, label %d1f

d80:                                              ; preds = %d40_after_0005
  %cmp_eq_0008 = icmp eq i32 %eax, 3221225480
  br i1 %cmp_eq_0008, label %default, label %d80_check001D

d80_check001D:                                    ; preds = %d80
  %cmp_eq_001d = icmp eq i32 %eax, 3221225501
  br i1 %cmp_eq_001d, label %d8e, label %d1f

d00:                                              ; preds = %switch_range, %switch_range, %switch_range, %switch_range, %switch_range, %switch_range
  %call_d00 = call i64 @sub_1400027A8(i32 8, i32 0)
  %cmp1_d00 = icmp eq i64 %call_d00, 1
  br i1 %cmp1_d00, label %e54, label %d16

dc0:                                              ; preds = %switch_range
  %call_dc0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %cmp1_dc0 = icmp eq i64 %call_dc0, 1
  br i1 %cmp1_dc0, label %dc0_eq1, label %d16

dc0_eq1:                                          ; preds = %dc0
  %call_dc0_set = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %default

d16:                                              ; preds = %dc0, %d00
  %phi_rax = phi i64 [ %call_d00, %d00 ], [ %call_dc0, %dc0 ]
  %cmp_zero = icmp ne i64 %phi_rax, 0
  br i1 %cmp_zero, label %e20, label %d1f

d8e:                                              ; preds = %switch_range, %d80_check001D
  %call_d8e = call i64 @sub_1400027A8(i32 4, i32 0)
  %cmp1_d8e = icmp eq i64 %call_d8e, 1
  br i1 %cmp1_d8e, label %e40, label %d8e_after

d8e_after:                                        ; preds = %d8e
  %cmpzero_d8e = icmp eq i64 %call_d8e, 0
  br i1 %cmpzero_d8e, label %d1f, label %d8e_callfp

d8e_callfp:                                       ; preds = %d8e_after
  %fp_d8e = inttoptr i64 %call_d8e to i64 (i32)*
  %call_ind_d8e = call i64 %fp_d8e(i32 4)
  br label %default

df0:                                              ; preds = %d40
  %call_df0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %cmp1_df0 = icmp eq i64 %call_df0, 1
  br i1 %cmp1_df0, label %e2c, label %df0_after

df0_after:                                        ; preds = %df0
  %cmpzero_df0 = icmp eq i64 %call_df0, 0
  br i1 %cmpzero_df0, label %d1f, label %df0_callfp

df0_callfp:                                       ; preds = %df0_after
  %fp_df0 = inttoptr i64 %call_df0 to i64 (i32)*
  %call_ind_df0 = call i64 %fp_df0(i32 11)
  br label %default

e20:                                              ; preds = %d16
  %fp_e20 = inttoptr i64 %phi_rax to i64 (i32)*
  %call_ind_e20 = call i64 %fp_e20(i32 8)
  br label %default

e2c:                                              ; preds = %df0
  %call_e2c = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %default

e40:                                              ; preds = %d8e
  %call_e40 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %default

e54:                                              ; preds = %d00
  %call_e54 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %default

default:                                          ; preds = %e54, %e40, %e2c, %e20, %df0_callfp, %d8e_callfp, %dc0_eq1, %d80, %switch_range, %d60
  br label %d1f

d1f:                                              ; preds = %default, %d8e_after, %df0_after, %d16, %d80_check001D, %d40_check80000002, %cd1
  %fp_global = load i64 (i8*)*, i64 (i8*)** @qword_1400070D0, align 8
  %isnull = icmp eq i64 (i8*)* %fp_global, null
  br i1 %isnull, label %ret_zero, label %call_global

call_global:                                      ; preds = %d1f
  %rcx_as_i8 = bitcast i8** %rcx to i8*
  %ret_from_global = call i64 %fp_global(i8* %rcx_as_i8)
  ret i64 %ret_from_global

ret_zero:                                         ; preds = %d1f
  ret i64 0

ret_minus1:                                       ; preds = %d40_check80000002
  ret i64 4294967295
}