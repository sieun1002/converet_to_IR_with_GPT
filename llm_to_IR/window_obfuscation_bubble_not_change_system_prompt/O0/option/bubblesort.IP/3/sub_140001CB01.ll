; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define dso_local i32 @sub_140001CB0(i8** %arg_rcx) {
entry:
  %p_rdx = load i8*, i8** %arg_rcx
  %p_rdx_i32 = bitcast i8* %p_rdx to i32*
  %val_eax = load i32, i32* %p_rdx_i32
  %masked = and i32 %val_eax, 551157247
  %cmp_magic = icmp eq i32 %masked, 541868227
  br i1 %cmp_magic, label %blk_d60, label %cmp_dispatch

blk_d60:                                           ; 0x140001d60
  %p_rdx_plus4 = getelementptr i8, i8* %p_rdx, i64 4
  %byte4 = load i8, i8* %p_rdx_plus4
  %bit0 = and i8 %byte4, 1
  %flag_set = icmp ne i8 %bit0, 0
  br i1 %flag_set, label %cmp_dispatch, label %ret_default_minus1

cmp_dispatch:                                      ; corresponds to 0x140001cd1 onward
  %cmp_hi = icmp ugt i32 %val_eax, 3221225622
  br i1 %cmp_hi, label %fallback_callback, label %range_8B

range_8B:
  %le_8B = icmp ule i32 %val_eax, 3221225611
  br i1 %le_8B, label %path_le_8B, label %switch_path

switch_path:
  switch i32 %val_eax, label %ret_default_minus1 [
    i32 3221225613, label %case_d00        ; 0xC000008D
    i32 3221225614, label %case_d00        ; 0xC000008E
    i32 3221225615, label %case_d00        ; 0xC000008F
    i32 3221225616, label %case_d00        ; 0xC0000090
    i32 3221225617, label %case_d00        ; 0xC0000091
    i32 3221225619, label %case_d00        ; 0xC0000093
    i32 3221225620, label %case_dc0        ; 0xC0000094
    i32 3221225622, label %case_d8e        ; 0xC0000096
  ]

path_le_8B:
  %eq_0005 = icmp eq i32 %val_eax, 3221225477
  br i1 %eq_0005, label %case_df0, label %gt_0005

gt_0005:
  %ugt_0005 = icmp ugt i32 %val_eax, 3221225477
  br i1 %ugt_0005, label %mid_range, label %check_80000002

check_80000002:
  %eq_80000002 = icmp eq i32 %val_eax, 2147483650
  br i1 %eq_80000002, label %ret_default_minus1, label %fallback_callback

mid_range:
  %eq_0008 = icmp eq i32 %val_eax, 3221225480
  br i1 %eq_0008, label %ret_default_minus1, label %check_001D

check_001D:
  %eq_001D = icmp eq i32 %val_eax, 3221225501
  br i1 %eq_001D, label %case_d8e, label %fallback_callback

; case group at 0x140001d00
case_d00:
  %call_d00 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is_one_d00 = icmp eq i64 %call_d00, 1
  br i1 %is_one_d00, label %blk_e54, label %test_d00

test_d00:
  %is_zero_d00 = icmp eq i64 %call_d00, 0
  br i1 %is_zero_d00, label %fallback_callback, label %blk_e20_8

blk_e20_8:                                         ; 0x140001e20 with ecx=8
  %fp8_i64 = phi i64 [ %call_d00, %test_d00 ]
  %fp8 = inttoptr i64 %fp8_i64 to void (i32)*
  call void %fp8(i32 8)
  br label %ret_default_minus1

blk_e54:                                           ; 0x140001e54
  %call_set1_8 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_default_minus1

; case at 0x140001dc0
case_dc0:
  %call_dc0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is_one_dc0 = icmp eq i64 %call_dc0, 1
  br i1 %is_one_dc0, label %blk_dd6, label %test_dc0

test_dc0:
  %is_zero_dc0 = icmp eq i64 %call_dc0, 0
  br i1 %is_zero_dc0, label %fallback_callback, label %blk_call8_then_default

blk_call8_then_default:
  %fp8b = inttoptr i64 %call_dc0 to void (i32)*
  call void %fp8b(i32 8)
  br label %ret_default_minus1

blk_dd6:                                           ; 0x140001dd6..0x140001de5
  %call_set1_8_b = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %ret_default_minus1

; case at 0x140001d8e (also used from mid_range == 0xC000001D)
case_d8e:
  %call_d8e = call i64 @sub_1400027A8(i32 4, i32 0)
  %is_one_d8e = icmp eq i64 %call_d8e, 1
  br i1 %is_one_d8e, label %blk_e40, label %test_d8e

blk_e40:                                           ; 0x140001e40
  %call_set1_4 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %ret_default_minus1

test_d8e:
  %is_zero_d8e = icmp eq i64 %call_d8e, 0
  br i1 %is_zero_d8e, label %fallback_callback, label %blk_call4_then_default

blk_call4_then_default:
  %fp4 = inttoptr i64 %call_d8e to void (i32)*
  call void %fp4(i32 4)
  br label %ret_default_minus1

; access violation case at 0x140001df0
case_df0:
  %call_df0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %is_one_df0 = icmp eq i64 %call_df0, 1
  br i1 %is_one_df0, label %blk_e2c, label %test_df0

blk_e2c:                                           ; 0x140001e2c
  %call_set1_0b = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %ret_default_minus1

test_df0:
  %is_zero_df0 = icmp eq i64 %call_df0, 0
  br i1 %is_zero_df0, label %fallback_callback, label %blk_callb_then_default

blk_callb_then_default:
  %fpb = inttoptr i64 %call_df0 to void (i32)*
  call void %fpb(i32 11)
  br label %ret_default_minus1

fallback_callback:                                 ; 0x140001d1f path
  %cb_ptr = load i8*, i8** @qword_1400070D0
  %cb_isnull = icmp eq i8* %cb_ptr, null
  br i1 %cb_isnull, label %ret_zero, label %tail_cb

tail_cb:
  %cb_fn = bitcast i8* %cb_ptr to i32 (i8**)*
  %res_cb = call i32 %cb_fn(i8** %arg_rcx)
  ret i32 %res_cb

ret_default_minus1:                                ; 0x140001d54 path
  ret i32 -1

ret_zero:                                          ; 0x140001d70 path
  ret i32 0
}