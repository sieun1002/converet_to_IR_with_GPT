; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define dso_local i32 @sub_140001CB0(i8* %rcx) local_unnamed_addr {
entry:
  %rcx_cast = bitcast i8* %rcx to i8**
  %rdx = load i8*, i8** %rcx_cast, align 8
  %rdx_i32p = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %rdx_i32p, align 4
  %and = and i32 %eax, 552661887
  %cmp_magic = icmp eq i32 %and, 541608515
  br i1 %cmp_magic, label %bb_d60, label %bb_after_magic

bb_after_magic:                                    ; preds = %entry
  %cmp_ja_96 = icmp ugt i32 %eax, 3221225622
  br i1 %cmp_ja_96, label %bb_d1f, label %bb_cmp_8b

bb_cmp_8b:                                         ; preds = %bb_after_magic
  %cmp_jbe_8b = icmp ule i32 %eax, 3221225483
  br i1 %cmp_jbe_8b, label %bb_d40, label %bb_switch

bb_d40:                                            ; preds = %bb_cmp_8b
  %is_0005 = icmp eq i32 %eax, 3221225477
  br i1 %is_0005, label %bb_df0, label %bb_after_5

bb_after_5:                                        ; preds = %bb_d40
  %cmp_ja_0005 = icmp ugt i32 %eax, 3221225477
  br i1 %cmp_ja_0005, label %bb_d80, label %bb_cmp_80000002

bb_cmp_80000002:                                   ; preds = %bb_after_5
  %is_80000002 = icmp eq i32 %eax, 2147483650
  br i1 %is_80000002, label %bb_ret_minus1, label %bb_d1f

bb_ret_minus1:                                     ; preds = %bb_cmp_80000002
  ret i32 -1

bb_d80:                                            ; preds = %bb_after_5
  %is_c0000008 = icmp eq i32 %eax, 3221225480
  br i1 %is_c0000008, label %bb_d1f, label %bb_cmp_001d

bb_cmp_001d:                                       ; preds = %bb_d80
  %is_c000001d = icmp eq i32 %eax, 3221225501
  br i1 %is_c000001d, label %bb_d8e, label %bb_d1f

bb_switch:                                         ; preds = %bb_cmp_8b
  %ge_8d = icmp uge i32 %eax, 3221225485
  %le_91 = icmp ule i32 %eax, 3221225489
  %in_8d_to_91 = and i1 %ge_8d, %le_91
  %is_93 = icmp eq i32 %eax, 3221225491
  %to_d00 = or i1 %in_8d_to_91, %is_93
  br i1 %to_d00, label %bb_d00, label %bb_switch_rest

bb_switch_rest:                                    ; preds = %bb_switch
  %is_94 = icmp eq i32 %eax, 3221225492
  br i1 %is_94, label %bb_dc0, label %bb_switch_maybe_96

bb_switch_maybe_96:                                ; preds = %bb_switch_rest
  %is_96 = icmp eq i32 %eax, 3221225494
  br i1 %is_96, label %bb_d8e, label %bb_d1f

bb_d60:                                            ; preds = %entry
  %rdx_plus4 = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %rdx_plus4, align 1
  %b_and1 = and i8 %b, 1
  %flag = icmp ne i8 %b_and1, 0
  br i1 %flag, label %bb_after_magic, label %bb_d1f

bb_d00:                                            ; preds = %bb_switch
  %call_d00 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is1_d00 = icmp eq i64 %call_d00, 1
  br i1 %is1_d00, label %bb_e54, label %bb_d00_chk

bb_d00_chk:                                        ; preds = %bb_d00
  %is0_d00 = icmp eq i64 %call_d00, 0
  br i1 %is0_d00, label %bb_d1f, label %bb_e20_8

bb_e20_8:                                          ; preds = %bb_d00_chk
  %fp_8_raw = inttoptr i64 %call_d00 to i8*
  %fp_8_fun = bitcast i8* %fp_8_raw to void (i32)*
  call void %fp_8_fun(i32 8)
  br label %bb_d1f

bb_dc0:                                            ; preds = %bb_switch_rest
  %call_dc0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is1_dc0 = icmp eq i64 %call_dc0, 1
  br i1 %is1_dc0, label %bb_dd6, label %bb_dc0_chk

bb_dc0_chk:                                        ; preds = %bb_dc0
  %is0_dc0 = icmp eq i64 %call_dc0, 0
  br i1 %is0_dc0, label %bb_d1f, label %bb_e20_8_dc0

bb_e20_8_dc0:                                      ; preds = %bb_dc0_chk
  %fp_8_dc0_raw = inttoptr i64 %call_dc0 to i8*
  %fp_8_dc0_fun = bitcast i8* %fp_8_dc0_raw to void (i32)*
  call void %fp_8_dc0_fun(i32 8)
  br label %bb_d1f

bb_dd6:                                            ; preds = %bb_dc0
  %call_dc0_set = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %bb_d1f

bb_d8e:                                            ; preds = %bb_cmp_001d, %bb_switch_maybe_96
  %call_d8e = call i64 @sub_1400027A8(i32 4, i32 0)
  %is1_d8e = icmp eq i64 %call_d8e, 1
  br i1 %is1_d8e, label %bb_e40, label %bb_d8e_chk

bb_d8e_chk:                                        ; preds = %bb_d8e
  %is0_d8e = icmp eq i64 %call_d8e, 0
  br i1 %is0_d8e, label %bb_d1f, label %bb_call_fp4

bb_call_fp4:                                       ; preds = %bb_d8e_chk
  %fp4_raw = inttoptr i64 %call_d8e to i8*
  %fp4_fun = bitcast i8* %fp4_raw to void (i32)*
  call void %fp4_fun(i32 4)
  br label %bb_d1f

bb_df0:                                            ; preds = %bb_d40
  %call_df0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %is1_df0 = icmp eq i64 %call_df0, 1
  br i1 %is1_df0, label %bb_e2c, label %bb_df0_chk

bb_df0_chk:                                        ; preds = %bb_df0
  %is0_df0 = icmp eq i64 %call_df0, 0
  br i1 %is0_df0, label %bb_d1f, label %bb_call_fp11

bb_call_fp11:                                      ; preds = %bb_df0_chk
  %fp11_raw = inttoptr i64 %call_df0 to i8*
  %fp11_fun = bitcast i8* %fp11_raw to void (i32)*
  call void %fp11_fun(i32 11)
  br label %bb_d1f

bb_e40:                                            ; preds = %bb_d8e
  %call_e40 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %bb_d1f

bb_e2c:                                            ; preds = %bb_df0
  %call_e2c = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %bb_d1f

bb_e54:                                            ; preds = %bb_d00
  %call_e54 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %bb_d1f

bb_d1f:                                            ; preds = %bb_after_magic, %bb_cmp_80000002, %bb_cmp_001d, %bb_switch_maybe_96, %bb_switch_rest, %bb_switch, %bb_d60, %bb_e2c, %bb_e40, %bb_call_fp11, %bb_df0_chk, %bb_call_fp4, %bb_d8e_chk, %bb_dd6, %bb_e20_8_dc0, %bb_dc0_chk, %bb_e20_8, %bb_d00_chk, %bb_d80
  %fp_global = load i8*, i8** @qword_1400070D0, align 8
  %isnull = icmp eq i8* %fp_global, null
  br i1 %isnull, label %bb_ret0, label %bb_tail

bb_ret0:                                           ; preds = %bb_d1f
  ret i32 0

bb_tail:                                           ; preds = %bb_d1f
  %fn = bitcast i8* %fp_global to i32 (i8*)*
  %ret = tail call i32 %fn(i8* %rcx)
  ret i32 %ret
}