; ModuleID = 'sub_140001010_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002670(i32)
declare i8** @sub_140002660()
declare void @sub_140002880(i32, i8**)
declare i8* @loc_140017DB5(i8*, ...)
declare void @sub_140002790()
declare void @sub_140002120()
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i32 @sub_140001540()
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i32*, i8***, i8**, i32, i32*)
declare i8* @sub_1400027F8(i64)
declare i64 @sub_140002700(i8*)
declare void @sub_1400027B8(i8*, i8*, i64)
declare void @sub_140002780(i8*, i8*)
declare void @sub_140001520()
declare void @sub_1400018D0()
declare void @sub_140001CA0(i8*)
declare void @sub_1400027D0(i32)
declare void @loc_140002778(i32)

@off_140004470 = external global i64*
@qword_140008280 = external global i8*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8**
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8*
@off_140004460 = external global i8*
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@dword_140007008 = external global i32
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

declare void @sub_140001600()
declare void @sub_140001CB0()
declare void @nullsub_1()

define void @sub_140001010() {
entry:
  %r14d = alloca i32, align 4
  %var54 = alloca i32, align 4
  %var80 = alloca i8*, align 8
  store i32 0, i32* %r14d, align 4

  %tib = call i8* asm sideeffect "movq %gs:0x30, $0", "=r"()
  %tib_pp = bitcast i8* %tib to i8**
  %tib_pp_next = getelementptr inbounds i8*, i8** %tib_pp, i64 1
  %rsi = load i8*, i8** %tib_pp_next, align 8
  %rbx_lockptr_addr = load i64*, i64** @off_140004470, align 8
  %sleep_fp_raw = load i8*, i8** @qword_140008280, align 8
  %sleep_fp = bitcast i8* %sleep_fp_raw to void (i32)*

  br label %try_lock

try_lock:
  %rsi_i64 = ptrtoint i8* %rsi to i64
  %cmpx = cmpxchg i64* %rbx_lockptr_addr, i64 0, i64 %rsi_i64 seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpx, 0
  %succ = extractvalue { i64, i1 } %cmpx, 1
  br i1 %succ, label %got_lock, label %lock_failed

lock_failed:
  %old_eq = icmp eq i64 %old, %rsi_i64
  br i1 %old_eq, label %already_owner, label %sleep_then_retry

sleep_then_retry:
  call void %sleep_fp(i32 1000)
  br label %try_lock

already_owner:
  store i32 1, i32* %r14d, align 4
  br label %after_05C

got_lock:
  store i32 0, i32* %r14d, align 4
  br label %after_05C

after_05C:
  %rbp_state = load i32*, i32** @off_140004480, align 8
  %state0 = load i32, i32* %rbp_state, align 4
  %state_eq1 = icmp eq i32 %state0, 1
  br i1 %state_eq1, label %state_is_1, label %state_test

state_is_1:
  call void @sub_140002670(i32 31)
  br label %common_cont_after_init

state_test:
  %state1 = load i32, i32* %rbp_state, align 4
  %state_is_zero = icmp eq i32 %state1, 0
  br i1 %state_is_zero, label %do_initialization, label %after_state_initcheck

do_initialization:
  store i32 1, i32* %rbp_state, align 4
  call void @sub_1400018D0()
  %cb_ptr = bitcast void ()* @sub_140001CB0 to i8*
  %rax_cb = call i8* (i8*, ...) @loc_140017DB5(i8* %cb_ptr)
  %p_off_4460 = load i8*, i8** @off_140004460, align 8
  %p_off_4460_cast = bitcast i8* %p_off_4460 to i8**
  store i8* %rax_cb, i8** %p_off_4460_cast, align 8
  call void @sub_140002790()
  call void @sub_140002120()
  %p_off_4430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p_off_4430, align 4
  %p_off_4440 = load i32*, i32** @off_140004440, align 8
  store i32 1, i32* %p_off_4440, align 4
  %p_off_4450 = load i32*, i32** @off_140004450, align 8
  store i32 1, i32* %p_off_4450, align 4
  %img_base = load i8*, i8** @off_1400043C0, align 8
  %mz_ptr = bitcast i8* %img_base to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_nt_hdr, label %pe_nope

pe_nt_hdr:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %img_base, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p32, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr = getelementptr inbounds i8, i8* %img_base, i64 %e_lfanew_sext
  %sig_p = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_p, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %pe_opt_hdr, label %pe_nope

pe_opt_hdr:
  %opt_magic_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 24
  %opt_magic_p16 = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_p16, align 1
  %is_pe32 = icmp eq i16 %opt_magic, 267
  %is_pe64 = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32, label %pe32_path, label %check_pe64

check_pe64:
  br i1 %is_pe64, label %pe64_path, label %pe_nope

pe32_path:
  %soh32_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 116
  %soh32_p32 = bitcast i8* %soh32_ptr to i32*
  %soh32 = load i32, i32* %soh32_p32, align 1
  %soh32_ge = icmp ugt i32 %soh32, 14
  br i1 %soh32_ge, label %pe32_field, label %pe_nope

pe32_field:
  %field32_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 232
  %field32_p32 = bitcast i8* %field32_ptr to i32*
  %field32 = load i32, i32* %field32_p32, align 1
  %nz32 = icmp ne i32 %field32, 0
  %cl32 = zext i1 %nz32 to i32
  store i32 %cl32, i32* @dword_140007008, align 4
  br label %after_pe_check

pe64_path:
  %soh64_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 132
  %soh64_p32 = bitcast i8* %soh64_ptr to i32*
  %soh64 = load i32, i32* %soh64_p32, align 1
  %soh64_ge = icmp ugt i32 %soh64, 14
  br i1 %soh64_ge, label %pe64_field, label %pe_nope

pe64_field:
  %field64_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 248
  %field64_p32 = bitcast i8* %field64_ptr to i32*
  %field64 = load i32, i32* %field64_p32, align 1
  %nz64 = icmp ne i32 %field64, 0
  %cl64 = zext i1 %nz64 to i32
  store i32 %cl64, i32* @dword_140007008, align 4
  br label %after_pe_check

pe_nope:
  store i32 0, i32* @dword_140007008, align 4
  br label %after_pe_check

after_pe_check:
  %p_off_4420 = load i32*, i32** @off_140004420, align 8
  %r8d_val = load i32, i32* %p_off_4420, align 4
  %r8d_nz = icmp ne i32 %r8d_val, 0
  br i1 %r8d_nz, label %cfg_path_two, label %cfg_path_one

cfg_path_one:
  call void @loc_140002778(i32 1)
  %p1 = call i32* @sub_140002720()
  %p_off_44F0 = load i32*, i32** @off_1400044F0, align 8
  %v44F0 = load i32, i32* %p_off_44F0, align 4
  store i32 %v44F0, i32* %p1, align 4
  %p2 = call i32* @sub_140002718()
  %p_off_44D0 = load i32*, i32** @off_1400044D0, align 8
  %v44D0 = load i32, i32* %p_off_44D0, align 4
  store i32 %v44D0, i32* %p2, align 4
  br label %post_cfg

cfg_path_two:
  call void @loc_140002778(i32 2)
  br label %post_cfg

post_cfg:
  %ret1540 = call i32 @sub_140001540()
  %neg = icmp slt i32 %ret1540, 0
  br i1 %neg, label %error_and_cleanup, label %check_43A0

check_43A0:
  %p_off_43A0 = load i32*, i32** @off_1400043A0, align 8
  %v43A0 = load i32, i32* %p_off_43A0, align 4
  %is1_43A0 = icmp eq i32 %v43A0, 1
  br i1 %is1_43A0, label %call_1CA0_then_cont, label %check_0400

call_1CA0_then_cont:
  %ptr_1600 = bitcast void ()* @sub_140001600 to i8*
  call void @sub_140001CA0(i8* %ptr_1600)
  br label %check_0400

check_0400:
  %p_off_0400 = load i32*, i32** @off_140004400, align 8
  %v0400 = load i32, i32* %p_off_0400, align 4
  %is_m1 = icmp eq i32 %v0400, -1
  br i1 %is_m1, label %call_27D0, label %call_2788

call_27D0:
  call void @sub_1400027D0(i32 -1)
  br label %call_2788

call_2788:
  %p_off_44B0 = load i8*, i8** @off_1400044B0, align 8
  %p_off_44C0 = load i8*, i8** @off_1400044C0, align 8
  %ret2788 = call i32 @sub_140002788(i8* %p_off_44B0, i8* %p_off_44C0)
  %nz2788 = icmp ne i32 %ret2788, 0
  br i1 %nz2788, label %set_eax_ff_and_ret, label %prepare_26A0

set_eax_ff_and_ret:
  br label %epilog

prepare_26A0:
  %p_off_4520 = load i32*, i32** @off_140004520, align 8
  %v4520 = load i32, i32* %p_off_4520, align 4
  store i32 %v4520, i32* %var54, align 4
  %p_off_44E0 = load i32*, i32** @off_1400044E0, align 8
  %v44E0 = load i32, i32* %p_off_44E0, align 4
  %var54_ptr = bitcast i32* %var54 to i8*
  store i8* %var54_ptr, i8** %var80, align 8
  %p_dword_7020 = getelementptr i32, i32* @dword_140007020, i64 0
  %p_qword_7018 = bitcast i8** @qword_140007018 to i8***
  %ret26A0 = call i32 @sub_1400026A0(i32* %p_dword_7020, i8*** %p_qword_7018, i8** @qword_140007010, i32 %v44E0, i32* %var54)
  %neg26A0 = icmp slt i32 %ret26A0, 0
  br i1 %neg26A0, label %error_and_cleanup, label %alloc_array

alloc_array:
  %r12d = load i32, i32* @dword_140007020, align 4
  %r12p1 = add i32 %r12d, 1
  %r12p1_64 = sext i32 %r12p1 to i64
  %bytes = shl i64 %r12p1_64, 3
  %r13 = call i8* @sub_1400027F8(i64 %bytes)
  %r13_is_null = icmp eq i8* %r13, null
  br i1 %r13_is_null, label %error_and_cleanup, label %maybe_loop

maybe_loop:
  %r12_le_zero = icmp sle i32 %r12d, 0
  br i1 %r12_le_zero, label %zero_term_and_install, label %loop_copy

loop_copy:
  %r15_base = load i8*, i8** @qword_140007018, align 8
  br label %loop_header

loop_header:
  %i = phi i32 [ 1, %loop_copy ], [ %i_next, %after_copy ]
  %idx = add i32 %i, -1
  %idx64 = sext i32 %idx to i64
  %mul_off = mul i64 %idx64, 8
  %src_slot_ptr = getelementptr inbounds i8, i8* %r15_base, i64 %mul_off
  %src_slot_pp = bitcast i8* %src_slot_ptr to i8**
  %src_ptr = load i8*, i8** %src_slot_pp, align 8
  %len = call i64 @sub_140002700(i8* %src_ptr)
  %need = add i64 %len, 1
  %dest = call i8* @sub_1400027F8(i64 %need)
  %mul_off2 = mul i64 %idx64, 8
  %dst_slot_ptr = getelementptr inbounds i8, i8* %r13, i64 %mul_off2
  %dst_slot_pp = bitcast i8* %dst_slot_ptr to i8**
  store i8* %dest, i8** %dst_slot_pp, align 8
  %dest_is_null = icmp eq i8* %dest, null
  br i1 %dest_is_null, label %error_and_cleanup, label %do_copy

do_copy:
  call void @sub_1400027B8(i8* %dest, i8* %src_ptr, i64 %need)
  %i_next = add i32 %i, 1
  %cont = icmp sle i32 %i_next, %r12d
  br i1 %cont, label %after_copy, label %zero_term_and_install

after_copy:
  br label %loop_header

zero_term_and_install:
  %first_ptr = bitcast i8* %r13 to i64*
  store i64 0, i64* %first_ptr, align 8
  store i8* %r13, i8** @qword_140007018, align 8
  %p_off_4490 = load i8*, i8** @off_140004490, align 8
  %p_off_44A0 = load i8*, i8** @off_1400044A0, align 8
  call void @sub_140002780(i8* %p_off_4490, i8* %p_off_44A0)
  call void @sub_140001520()
  store i32 2, i32* %rbp_state, align 4
  store i32 1, i32* @dword_140007004, align 4
  %r14v = load i32, i32* %r14d, align 4
  %r14_is_zero = icmp eq i32 %r14v, 0
  br i1 %r14_is_zero, label %unlock_and_loopend, label %epilog

after_state_initcheck:
  store i32 1, i32* @dword_140007004, align 4
  %r14v2 = load i32, i32* %r14d, align 4
  %r14_is_zero2 = icmp eq i32 %r14v2, 0
  br i1 %r14_is_zero2, label %unlock_and_continue, label %post_r14nz

post_r14nz:
  %p_off_43F0 = load i8**, i8*** @off_1400043F0, align 8
  %fp43 = load i8*, i8** %p_off_43F0, align 8
  %has_fp43 = icmp ne i8* %fp43, null
  br i1 %has_fp43, label %call_fp43, label %call_2660

call_fp43:
  %fp43_typed = bitcast i8* %fp43 to void (i32, i32, i32)*
  call void %fp43_typed(i32 0, i32 2, i32 0)
  br label %call_2660

call_2660:
  %rax_pp = call i8** @sub_140002660()
  %r8_q = load i8*, i8** @qword_140007010, align 8
  store i8* %r8_q, i8** %rax_pp, align 8
  %cnt = load i32, i32* @dword_140007020, align 4
  %arr = load i8*, i8** @qword_140007018, align 8
  %arr_pp = bitcast i8* %arr to i8**
  call void @sub_140002880(i32 %cnt, i8** %arr_pp)
  br label %epilog

unlock_and_continue:
  %old_x = atomicrmw xchg i64* %rbx_lockptr_addr, i64 0 seq_cst
  br label %post_r14nz

unlock_and_loopend:
  %old_x2 = atomicrmw xchg i64* %rbx_lockptr_addr, i64 0 seq_cst
  br label %epilog

error_and_cleanup:
  call void @sub_140002670(i32 8)
  %r14v3 = load i32, i32* %r14d, align 4
  %r14_is_zero3 = icmp eq i32 %r14v3, 0
  br i1 %r14_is_zero3, label %unlock_and_loopend, label %epilog

common_cont_after_init:
  br label %after_state_initcheck

epilog:
  ret void
}