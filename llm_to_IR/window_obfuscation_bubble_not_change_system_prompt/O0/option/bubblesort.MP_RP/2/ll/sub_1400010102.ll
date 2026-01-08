; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i32 @sub_140002670(i32)
declare void @sub_1400027A0(i32) noreturn
declare i32 @sub_140002880(i32, i8*, i8*)
declare i8** @sub_140002660()
declare void @sub_140002750()
declare void @sub_140002778(i32)
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i32 @sub_140001540()
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i32*, i8***, i8**, i32*, i32)
declare i8* @sub_1400027F8(i64)
declare void @sub_1400027B8(i8*, i8*, i64)
declare i64 @sub_140002700(i8*)
declare void @sub_140002780(i8*, i8*)
declare void @sub_140001520()
declare void @sub_1400027D0(i32)
declare void @sub_1400018D0()
declare void @sub_140002790(i8*)
declare void @sub_140002120()
declare void @sub_140001CA0(i8*)
declare void @sub_140001CB0()
declare void @sub_140001600()
declare void @nullsub_3()

@off_140004470 = external global i64*
@qword_140008280 = external global i8*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140007010 = external global i8*
@qword_140007018 = external global i8**
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@qword_140008278 = external global i8*
@off_140004460 = external global i8*
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@off_140004420 = external global i32*
@off_1400044F0 = external global i32*
@off_1400044D0 = external global i32*
@off_1400043A0 = external global i32*
@off_140004400 = external global i32*
@off_1400044C0 = external global i8*
@off_1400044B0 = external global i8*
@off_140004520 = external global i32*
@off_1400044E0 = external global i32*
@off_1400044A0 = external global i8*
@off_140004490 = external global i8*

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %var4C = alloca i32, align 4
  %var5C = alloca i32, align 4
  %tib_plus8 = call i64 asm sideeffect "mov rax, qword ptr gs:[0x30]; mov $0, qword ptr [rax+8]", "=r"()
  %off_lock = load i64*, i64** @off_140004470, align 8
  %sleep_fp_raw = load i8*, i8** @qword_140008280, align 8
  %sleep_fp = bitcast i8* %sleep_fp_raw to void (i32)*
  br label %lock_try

lock_try:
  %cmpx = cmpxchg i64* %off_lock, i64 0, i64 %tib_plus8 monotonic monotonic
  %old = extractvalue { i64, i1 } %cmpx, 0
  %succ = extractvalue { i64, i1 } %cmpx, 1
  br i1 %succ, label %lock_acquired, label %check_owner

check_owner:
  %is_self = icmp eq i64 %old, %tib_plus8
  br i1 %is_self, label %reentrant, label %sleep_then_retry

sleep_then_retry:
  call void %sleep_fp(i32 1000)
  br label %lock_try

lock_acquired:
  br label %after_lock

reentrant:
  br label %after_lock

after_lock:
  %r14flag = phi i32 [ 0, %lock_acquired ], [ 1, %reentrant ]
  %bp_ptr = load i32*, i32** @off_140004480, align 8
  %bp_val1 = load i32, i32* %bp_ptr, align 4
  %cmp_bp1 = icmp eq i32 %bp_val1, 1
  br i1 %cmp_bp1, label %state_one, label %chk_zero

state_one:
  %ret_2670_1 = call i32 @sub_140002670(i32 31)
  call void @sub_1400027A0(i32 %ret_2670_1)
  unreachable

chk_zero:
  %bp_val2 = load i32, i32* %bp_ptr, align 4
  %is_zero = icmp eq i32 %bp_val2, 0
  br i1 %is_zero, label %init_path, label %nonzero_path

nonzero_path:
  store i32 1, i32* @dword_140007004, align 4
  %r14_is_zero = icmp eq i32 %r14flag, 0
  br i1 %r14_is_zero, label %release_lock_then, label %cont_after_lock

release_lock_then:
  %old_xchg = atomicrmw xchg i64* %off_lock, i64 0 monotonic
  br label %cont_after_lock

cont_after_lock:
  %off_cb_tbl = load i8*, i8** @off_1400043F0, align 8
  %p_cb_tbl = bitcast i8* %off_cb_tbl to i8**
  %cb_fp_raw = load i8*, i8** %p_cb_tbl, align 8
  %cb_is_null = icmp eq i8* %cb_fp_raw, null
  br i1 %cb_is_null, label %skip_cb, label %do_cb

do_cb:
  %cb_fp = bitcast i8* %cb_fp_raw to void (i32, i32, i32)*
  call void %cb_fp(i32 0, i32 2, i32 0)
  br label %skip_cb

skip_cb:
  %p_store = call i8** @sub_140002660()
  %g_qw_7010 = load i8*, i8** @qword_140007010, align 8
  store i8* %g_qw_7010, i8** %p_store, align 8
  %g_dw_7020 = load i32, i32* @dword_140007020, align 4
  %g_qw_7018 = load i8**, i8*** @qword_140007018, align 8
  %g_qw_7018_cast = bitcast i8** %g_qw_7018 to i8*
  %res_2880 = call i32 @sub_140002880(i32 %g_dw_7020, i8* %g_qw_7018_cast, i8* %g_qw_7010)
  %g_dw_7008_now = load i32, i32* @dword_140007008, align 4
  %is_zero_7008 = icmp eq i32 %g_dw_7008_now, 0
  br i1 %is_zero_7008, label %fatal_3d2, label %check_7004

fatal_3d2:
  call void @sub_1400027A0(i32 %res_2880)
  unreachable

check_7004:
  %g_dw_7004_now = load i32, i32* @dword_140007004, align 4
  %is_zero_7004 = icmp eq i32 %g_dw_7004_now, 0
  br i1 %is_zero_7004, label %save_then_return, label %ret_norm

save_then_return:
  store i32 %res_2880, i32* %var5C, align 4
  call void @sub_140002750()
  %ret_saved = load i32, i32* %var5C, align 4
  ret i32 %ret_saved

ret_norm:
  ret i32 %res_2880

init_path:
  store i32 1, i32* %bp_ptr, align 4
  call void @sub_1400018D0()
  %fp_reg_raw = load i8*, i8** @qword_140008278, align 8
  %fp_reg = bitcast i8* %fp_reg_raw to i8* (i8*)*
  %cb_target = bitcast void ()* @sub_140001CB0 to i8*
  %reg_handle = call i8* %fp_reg(i8* %cb_target)
  %off_4460 = load i8*, i8** @off_140004460, align 8
  %p_handle = bitcast i8* %off_4460 to i8**
  store i8* %reg_handle, i8** %p_handle, align 8
  %null_ptr = bitcast void ()* @nullsub_3 to i8*
  call void @sub_140002790(i8* %null_ptr)
  call void @sub_140002120()
  %p_4430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p_4430, align 4
  %p_4440 = load i32*, i32** @off_140004440, align 8
  store i32 1, i32* %p_4440, align 4
  %p_4450 = load i32*, i32** @off_140004450, align 8
  store i32 1, i32* %p_4450, align 4
  %img_base_ptr = load i8*, i8** @off_1400043C0, align 8
  %ecx0 = add i32 0, 0
  %mz_ptr = bitcast i8* %img_base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 2
  %is_mz = icmp eq i16 %mz, -10673
  br i1 %is_mz, label %pe_nt, label %set_conf

pe_nt:
  %e_lfanew_ptr = getelementptr i8, i8* %img_base_ptr, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p32, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr = getelementptr i8, i8* %img_base_ptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %set_conf

check_magic:
  %magic_ptrb = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptrb to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %is_10b = icmp eq i16 %magic, 267
  br i1 %is_10b, label %opt32, label %chk_20b

chk_20b:
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %opt64, label %set_conf

opt64:
  %sz_ptr64b = getelementptr i8, i8* %nt_hdr, i64 132
  %sz_ptr64 = bitcast i8* %sz_ptr64b to i32*
  %sz64 = load i32, i32* %sz_ptr64, align 4
  %gt_sz64 = icmp ugt i32 %sz64, 14
  br i1 %gt_sz64, label %opt64_have, label %set_conf

opt64_have:
  %v_ptr64b = getelementptr i8, i8* %nt_hdr, i64 248
  %v_ptr64 = bitcast i8* %v_ptr64b to i32*
  %v64 = load i32, i32* %v_ptr64, align 4
  %nz64 = icmp ne i32 %v64, 0
  %ecx_set64 = zext i1 %nz64 to i32
  br label %set_conf_with

opt32:
  %sz_ptr32b = getelementptr i8, i8* %nt_hdr, i64 116
  %sz_ptr32 = bitcast i8* %sz_ptr32b to i32*
  %sz32 = load i32, i32* %sz_ptr32, align 4
  %gt_sz32 = icmp ugt i32 %sz32, 14
  br i1 %gt_sz32, label %opt32_have, label %set_conf

opt32_have:
  %v_ptr32b = getelementptr i8, i8* %nt_hdr, i64 232
  %v_ptr32 = bitcast i8* %v_ptr32b to i32*
  %v32 = load i32, i32* %v_ptr32, align 4
  %nz32 = icmp ne i32 %v32, 0
  %ecx_set32 = zext i1 %nz32 to i32
  br label %set_conf_with

set_conf_with:
  %ecx_from = phi i32 [ %ecx_set32, %opt32_have ], [ %ecx_set64, %opt64_have ]
  br label %set_conf

set_conf:
  %ecx_final = phi i32 [ %ecx0, %init_path ], [ %ecx0, %pe_nt ], [ %ecx0, %chk_20b ], [ %ecx0, %opt64 ], [ %ecx0, %opt32 ], [ %ecx_from, %set_conf_with ]
  store i32 %ecx_final, i32* @dword_140007008, align 4
  %p_4420 = load i32*, i32** @off_140004420, align 8
  %r8d_val = load i32, i32* %p_4420, align 4
  %r8d_nz = icmp ne i32 %r8d_val, 0
  br i1 %r8d_nz, label %do_2778_2, label %cont_1e3

do_2778_2:
  call void @sub_140002778(i32 2)
  br label %cont_1e3

cont_1e3:
  %p1 = call i32* @sub_140002720()
  %p_44F0 = load i32*, i32** @off_1400044F0, align 8
  %v_44F0 = load i32, i32* %p_44F0, align 4
  store i32 %v_44F0, i32* %p1, align 4
  %p2 = call i32* @sub_140002718()
  %p_44D0 = load i32*, i32** @off_1400044D0, align 8
  %v_44D0 = load i32, i32* %p_44D0, align 4
  store i32 %v_44D0, i32* %p2, align 4
  %res_1540 = call i32 @sub_140001540()
  %neg_1540 = icmp slt i32 %res_1540, 0
  br i1 %neg_1540, label %error_301, label %chk_43A0

error_301:
  %ret_2670_8 = call i32 @sub_140002670(i32 8)
  store i32 %ret_2670_8, i32* %var5C, align 4
  call void @sub_140002750()
  %ret_err = load i32, i32* %var5C, align 4
  ret i32 %ret_err

chk_43A0:
  %p_43A0 = load i32*, i32** @off_1400043A0, align 8
  %v_43A0 = load i32, i32* %p_43A0, align 4
  %is_one_43A0 = icmp eq i32 %v_43A0, 1
  br i1 %is_one_43A0, label %do_1CA0, label %chk_4400

do_1CA0:
  %p_1600 = bitcast void ()* @sub_140001600 to i8*
  call void @sub_140001CA0(i8* %p_1600)
  br label %chk_4400

chk_4400:
  %p_4400 = load i32*, i32** @off_140004400, align 8
  %v_4400 = load i32, i32* %p_4400, align 4
  %is_m1 = icmp eq i32 %v_4400, -1
  br i1 %is_m1, label %do_27D0, label %cont_1230

do_27D0:
  call void @sub_1400027D0(i32 -1)
  br label %cont_1230

cont_1230:
  %p_44B0 = load i8*, i8** @off_1400044B0, align 8
  %p_44A0 = load i8*, i8** @off_1400044A0, align 8
  %res_2788 = call i32 @sub_140002788(i8* %p_44B0, i8* %p_44A0)
  %nz_2788 = icmp ne i32 %res_2788, 0
  br i1 %nz_2788, label %ret_ff, label %cont_124b

ret_ff:
  ret i32 255

cont_124b:
  %p_4520 = load i32*, i32** @off_140004520, align 8
  %v_4520 = load i32, i32* %p_4520, align 4
  store i32 %v_4520, i32* %var4C, align 4
  %p_44E0 = load i32*, i32** @off_1400044E0, align 8
  %v_44E0 = load i32, i32* %p_44E0, align 4
  %addr_7018 = bitcast i8*** @qword_140007018 to i8***
  %addr_7010 = bitcast i8** @qword_140007010 to i8**
  %res_26A0 = call i32 @sub_1400026A0(i32* @dword_140007020, i8*** %addr_7018, i8** %addr_7010, i32* %var4C, i32 %v_44E0)
  %neg_26A0 = icmp slt i32 %res_26A0, 0
  br i1 %neg_26A0, label %error_301, label %alloc_arr

alloc_arr:
  %cnt = load i32, i32* @dword_140007020, align 4
  %cnt64 = sext i32 %cnt to i64
  %cntp1 = add i64 %cnt64, 1
  %bytes = shl i64 %cntp1, 3
  %mem_arr = call i8* @sub_1400027F8(i64 %bytes)
  %r13arr = bitcast i8* %mem_arr to i8**
  %is_null_arr = icmp eq i8* %mem_arr, null
  br i1 %is_null_arr, label %error_301, label %chk_loop

chk_loop:
  %le_zero = icmp sle i32 %cnt, 0
  br i1 %le_zero, label %finalize_no_loop, label %loop_prep

loop_prep:
  %r15 = load i8**, i8*** @qword_140007018, align 8
  br label %loop_head

loop_head:
  %i = phi i64 [ 1, %loop_prep ], [ %inc, %loop_cont ]
  %idx = add i64 %i, -1
  %src_ptr_p = getelementptr inbounds i8*, i8** %r15, i64 %idx
  %src_ptr = load i8*, i8** %src_ptr_p, align 8
  %len = call i64 @sub_140002700(i8* %src_ptr)
  %rdi = add i64 %len, 1
  %dest = call i8* @sub_1400027F8(i64 %rdi)
  %dst_slot = getelementptr inbounds i8*, i8** %r13arr, i64 %idx
  store i8* %dest, i8** %dst_slot, align 8
  %dest_is_null = icmp eq i8* %dest, null
  br i1 %dest_is_null, label %error_301, label %do_copy

do_copy:
  call void @sub_1400027B8(i8* %dest, i8* %src_ptr, i64 %rdi)
  %i_is_last = icmp eq i64 %i, %cnt64
  br i1 %i_is_last, label %finalize_from_loop, label %loop_cont

loop_cont:
  %inc = add i64 %i, 1
  br label %loop_head

finalize_from_loop:
  %term_slot = getelementptr inbounds i8*, i8** %r13arr, i64 %cnt64
  store i8* null, i8** %term_slot, align 8
  br label %finalize_common

finalize_no_loop:
  %term_slot_nl = getelementptr inbounds i8*, i8** %r13arr, i64 %cnt64
  store i8* null, i8** %term_slot_nl, align 8
  br label %finalize_common

finalize_common:
  store i8** %r13arr, i8*** @qword_140007018, align 8
  %p_4490 = load i8*, i8** @off_140004490, align 8
  %p_44A0_b = load i8*, i8** @off_1400044A0, align 8
  call void @sub_140002780(i8* %p_4490, i8* %p_44A0_b)
  call void @sub_140001520()
  store i32 2, i32* %bp_ptr, align 4
  %r14chk = icmp eq i32 %r14flag, 0
  br i1 %r14chk, label %release_after_init, label %after_release_init

release_after_init:
  %old_xchg2 = atomicrmw xchg i64* %off_lock, i64 0 monotonic
  br label %after_release_init

after_release_init:
  br label %skip_cb
}