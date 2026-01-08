; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external dso_local global i32 (i8*)*

declare dso_local i64 @sub_1400027A8(i32 noundef, i32 noundef)
declare dso_local void @sub_140002120()

define dso_local i32 @sub_140001CB0(i8** noundef %rcx) local_unnamed_addr {
entry:
  %rdx0 = load i8*, i8** %rcx, align 8
  %codeptr = bitcast i8* %rdx0 to i32*
  %eax0 = load i32, i32* %codeptr, align 4
  %rbx_as_i8 = bitcast i8** %rcx to i8*
  %mask_and = and i32 %eax0, 553648127
  %cmp_sig = icmp eq i32 %mask_and, 541541187
  br i1 %cmp_sig, label %sig_matched, label %cd1

sig_matched:
  %flags_p = getelementptr i8, i8* %rdx0, i64 4
  %flags_b = load i8, i8* %flags_p, align 1
  %flags_and1 = and i8 %flags_b, 1
  %flag_is_set = icmp ne i8 %flags_and1, 0
  br i1 %flag_is_set, label %cd1, label %fallback

cd1:
  %cmp_ja_96 = icmp ugt i32 %eax0, 3221225622
  br i1 %cmp_ja_96, label %fallback, label %range_check

range_check:
  %cmp_jbe_8B = icmp ule i32 %eax0, 3221225611
  br i1 %cmp_jbe_8B, label %d40, label %switch_range

switch_range:
  %is_0094 = icmp eq i32 %eax0, 3221225620
  br i1 %is_0094, label %dc0, label %d00_group_check

d00_group_check:
  %ge_008D = icmp uge i32 %eax0, 3221225613
  %le_0091 = icmp ule i32 %eax0, 3221225617
  %in_008D_0091 = and i1 %ge_008D, %le_0091
  %is_0093 = icmp eq i32 %eax0, 3221225619
  %d00_sel = or i1 %in_008D_0091, %is_0093
  br i1 %d00_sel, label %d00, label %fallback

d00:
  %call_d00 = call i64 @sub_1400027A8(i32 noundef 8, i32 noundef 0)
  %eq1_d00 = icmp eq i64 %call_d00, 1
  br i1 %eq1_d00, label %e54, label %d00_test

d00_test:
  %is_nonzero_d00 = icmp ne i64 %call_d00, 0
  br i1 %is_nonzero_d00, label %e20, label %fallback

d40:
  %eq_0005 = icmp eq i32 %eax0, 3221225477
  br i1 %eq_0005, label %df0, label %d40_next

d40_next:
  %ugt_0005 = icmp ugt i32 %eax0, 3221225477
  br i1 %ugt_0005, label %d80, label %d40_low

d40_low:
  %eq_80000002 = icmp eq i32 %eax0, 2147483650
  br i1 %eq_80000002, label %ret_neg1, label %fallback

d80:
  %eq_0008 = icmp eq i32 %eax0, 3221225480
  br i1 %eq_0008, label %fallback, label %d80_next

d80_next:
  %eq_001D = icmp eq i32 %eax0, 3221225501
  br i1 %eq_001D, label %d8e, label %fallback

d8e:
  %call_d8e = call i64 @sub_1400027A8(i32 noundef 4, i32 noundef 0)
  %eq1_d8e = icmp eq i64 %call_d8e, 1
  br i1 %eq1_d8e, label %e40, label %d8e_test

d8e_test:
  %is_nonzero_d8e = icmp ne i64 %call_d8e, 0
  br i1 %is_nonzero_d8e, label %d8e_callfp, label %fallback

d8e_callfp:
  %fp_d8e = inttoptr i64 %call_d8e to void (i32)*
  call void %fp_d8e(i32 noundef 4)
  br label %fallback

dc0:
  %call_dc0 = call i64 @sub_1400027A8(i32 noundef 8, i32 noundef 0)
  %eq1_dc0 = icmp eq i64 %call_dc0, 1
  br i1 %eq1_dc0, label %dc0_one, label %dc0_test

dc0_test:
  %is_nonzero_dc0 = icmp ne i64 %call_dc0, 0
  br i1 %is_nonzero_dc0, label %e20, label %fallback

dc0_one:
  %tmp_dc0_one = call i64 @sub_1400027A8(i32 noundef 8, i32 noundef 1)
  br label %fallback

df0:
  %call_df0 = call i64 @sub_1400027A8(i32 noundef 11, i32 noundef 0)
  %eq1_df0 = icmp eq i64 %call_df0, 1
  br i1 %eq1_df0, label %e2c, label %df0_test

df0_test:
  %is_nonzero_df0 = icmp ne i64 %call_df0, 0
  br i1 %is_nonzero_df0, label %df0_callfp, label %fallback

df0_callfp:
  %fp_df0 = inttoptr i64 %call_df0 to void (i32)*
  call void %fp_df0(i32 noundef 11)
  br label %fallback

e20:
  %fp_i64 = phi i64 [ %call_d00, %d00_test ], [ %call_dc0, %dc0_test ]
  %fp = inttoptr i64 %fp_i64 to void (i32)*
  call void %fp(i32 noundef 8)
  br label %fallback

e2c:
  %tmp_e2c = call i64 @sub_1400027A8(i32 noundef 11, i32 noundef 1)
  br label %fallback

e40:
  %tmp_e40 = call i64 @sub_1400027A8(i32 noundef 4, i32 noundef 1)
  br label %fallback

e54:
  %tmp_e54 = call i64 @sub_1400027A8(i32 noundef 8, i32 noundef 1)
  call void @sub_140002120()
  br label %fallback

ret_neg1:
  ret i32 -1

fallback:
  %cbptr = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %cb_isnull = icmp eq i32 (i8*)* %cbptr, null
  br i1 %cb_isnull, label %ret0, label %tailcall

ret0:
  ret i32 0

tailcall:
  %arg = bitcast i8** %rcx to i8*
  %res = call i32 %cbptr(i8* noundef %arg)
  ret i32 %res
}