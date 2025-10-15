; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8**)*, align 8

declare i8* @sub_140002B68(i32, i32)
declare void @sub_1400024E0()

define i32 @sub_140002080(i8** %ctx) {
entry:
  %p_obj = load i8*, i8** %ctx
  %p_status32 = bitcast i8* %p_obj to i32*
  %status = load i32, i32* %p_status32, align 4
  %masked = and i32 %status, 0x20FFFFFF
  %is_sig = icmp eq i32 %masked, 0x20474343
  br i1 %is_sig, label %sig_match, label %after_sig

sig_match:
  %flag_ptr = getelementptr i8, i8* %p_obj, i64 4
  %flag_b = load i8, i8* %flag_ptr, align 1
  %flag_mask = and i8 %flag_b, 1
  %flag_nz = icmp ne i8 %flag_mask, 0
  br i1 %flag_nz, label %after_sig, label %default_return

after_sig:
  %cond_ja_0096 = icmp ugt i32 %status, 0xC0000096
  br i1 %cond_ja_0096, label %fallback, label %cmp_le_008B

cmp_le_008B:
  %cond_jbe_008B = icmp ule i32 %status, 0xC000008B
  br i1 %cond_jbe_008B, label %loc_110, label %switch_region

loc_110:
  %eq_0005 = icmp eq i32 %status, 0xC0000005
  br i1 %eq_0005, label %loc_1C0, label %loc_110_after_eq5

loc_110_after_eq5:
  %ugt_0005 = icmp ugt i32 %status, 0xC0000005
  br i1 %ugt_0005, label %loc_150, label %loc_110_cmp_80000002

loc_110_cmp_80000002:
  %eq_80000002 = icmp eq i32 %status, 0x80000002
  br i1 %eq_80000002, label %default_return, label %fallback

loc_150:
  %eq_0008 = icmp eq i32 %status, 0xC0000008
  br i1 %eq_0008, label %default_return, label %loc_150_after_eq8

loc_150_after_eq8:
  %eq_001D = icmp eq i32 %status, 0xC000001D
  br i1 %eq_001D, label %case_15E, label %fallback

switch_region:
  %idx = add i32 %status, 0x3FFFFF73
  %idx_ugt9 = icmp ugt i32 %idx, 9
  br i1 %idx_ugt9, label %default_return, label %jt_dispatch

jt_dispatch:
  switch i32 %idx, label %default_return [
    i32 0, label %case_0D0
    i32 1, label %case_0D0
    i32 2, label %case_0D0
    i32 3, label %case_0D0
    i32 4, label %case_0D0
    i32 5, label %default_return
    i32 6, label %case_0D0
    i32 7, label %case_190
    i32 8, label %default_return
    i32 9, label %case_15E
  ]

case_0D0:
  %h0 = call i8* @sub_140002B68(i32 8, i32 0)
  %h0_i = ptrtoint i8* %h0 to i64
  %h0_is1 = icmp eq i64 %h0_i, 1
  br i1 %h0_is1, label %loc_224, label %case_0D0_check_nonzero

case_0D0_check_nonzero:
  %h0_nz = icmp ne i8* %h0, null
  br i1 %h0_nz, label %loc_1F0_from0D0, label %fallback

case_190:
  %h190 = call i8* @sub_140002B68(i32 8, i32 0)
  %h190_i = ptrtoint i8* %h190 to i64
  %h190_is1 = icmp eq i64 %h190_i, 1
  br i1 %h190_is1, label %loc_190_if1, label %case_190_else

loc_190_if1:
  %tmp_190 = call i8* @sub_140002B68(i32 8, i32 1)
  br label %default_return

case_190_else:
  %h190_nz = icmp ne i8* %h190, null
  br i1 %h190_nz, label %loc_1F0_from190, label %fallback

loc_1C0:
  %h1c0 = call i8* @sub_140002B68(i32 11, i32 0)
  %h1c0_i = ptrtoint i8* %h1c0 to i64
  %h1c0_is1 = icmp eq i64 %h1c0_i, 1
  br i1 %h1c0_is1, label %loc_1FC, label %loc_1C0_after1

loc_1C0_after1:
  %h1c0_is0 = icmp eq i8* %h1c0, null
  br i1 %h1c0_is0, label %fallback, label %loc_1C0_callptr

loc_1C0_callptr:
  %fp1 = bitcast i8* %h1c0 to i32 (i32)*
  %call_fp1 = call i32 %fp1(i32 11)
  br label %default_return

loc_1FC:
  %tmp_1fc = call i8* @sub_140002B68(i32 11, i32 1)
  br label %default_return

case_15E:
  %h15e = call i8* @sub_140002B68(i32 4, i32 0)
  %h15e_i = ptrtoint i8* %h15e to i64
  %h15e_is1 = icmp eq i64 %h15e_i, 1
  br i1 %h15e_is1, label %loc_210, label %c15e_non1

c15e_non1:
  %h15e_is0 = icmp eq i8* %h15e, null
  br i1 %h15e_is0, label %fallback, label %c15e_call

c15e_call:
  %fp15 = bitcast i8* %h15e to i32 (i32)*
  %call_fp15 = call i32 %fp15(i32 4)
  br label %default_return

loc_210:
  %tmp_210 = call i8* @sub_140002B68(i32 4, i32 1)
  br label %default_return

loc_1F0_from0D0:
  br label %loc_1F0

loc_1F0_from190:
  br label %loc_1F0

loc_1F0:
  %fp_union = phi i8* [ %h0, %loc_1F0_from0D0 ], [ %h190, %loc_1F0_from190 ]
  %fp8 = bitcast i8* %fp_union to i32 (i32)*
  %call_fp8 = call i32 %fp8(i32 8)
  br label %default_return

loc_224:
  %tmp_224a = call i8* @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %default_return

fallback:
  %gfp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %gfp_null = icmp eq i32 (i8**)* %gfp, null
  br i1 %gfp_null, label %ret0, label %tailcall

ret0:
  ret i32 0

tailcall:
  %res = call i32 %gfp(i8** %ctx)
  ret i32 %res

default_return:
  ret i32 -1
}