; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

; External/undefined functions (declares only)
declare void @sub_1400018D0()
declare void @sub_140002790()
declare void @sub_140002120()
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i32 @sub_140001540()
declare void @sub_140001520()
declare void @sub_140001CA0(i8*)
declare void @sub_140002780(i8*, i8*)
declare void @sub_140002778(i32)
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i32*, i8**, i8**, i32, i32*)
declare i8* @sub_1400027F8(i64)
declare i64 @sub_140002700(i8*)
declare void @sub_1400027B8(i8*, i8*, i64)
declare i32 @sub_140002670(i32)
declare void @sub_1400027A0(i32)
declare void @sub_1400027D0(i32)
declare void @sub_140002750()
declare i8** @sub_140002660()
declare i32 @sub_140002880(i32, i8*, i8*)

; Referenced function symbols whose addresses are taken
declare void @sub_140001600()
declare void @sub_140001CB0()
declare void @nullsub_3()

; External globals
@off_140004470 = external global i64***         ; -> pointer to pointer to lock variable (i64*)
@qword_140008280 = external global i8*          ; function pointer
@off_140004480 = external global i32**          ; -> pointer to state (i32*)
@dword_140007004 = external global i32
@off_1400043F0 = external global i8***          ; -> pointer to function pointer
@qword_140007010 = external global i8*          ; data pointer
@dword_140007020 = external global i32
@qword_140007018 = external global i8*          ; pointer to array (i8**)
@dword_140007008 = external global i32
@qword_140008278 = external global i8*          ; function pointer
@off_140004460 = external global i8***          ; -> pointer to (i8*) storage
@off_140004430 = external global i32**          ; -> pointer to i32
@off_140004440 = external global i32**          ; -> pointer to i32
@off_140004450 = external global i32**          ; -> pointer to i32
@off_1400043C0 = external global i8**           ; -> pointer to PE base (i8*)
@off_140004420 = external global i32**          ; -> pointer to i32
@off_1400044F0 = external global i32**          ; -> pointer to i32
@off_1400044D0 = external global i32**          ; -> pointer to i32
@off_1400043A0 = external global i32**          ; -> pointer to i32
@off_140004400 = external global i32**          ; -> pointer to i32
@off_1400044C0 = external global i8**           ; -> pointer to i8
@off_1400044B0 = external global i8**           ; -> pointer to i8
@off_140004520 = external global i32**          ; -> pointer to i32
@off_1400044E0 = external global i32**          ; -> pointer to i32
@off_1400044A0 = external global i8**           ; -> pointer to i8
@off_140004490 = external global i8**           ; -> pointer to i8

define dso_local i32 @sub_140001010() personality i8* null {
entry:
  %ret = alloca i32, align 4
  %var_4C = alloca i32, align 4
  %var_5C = alloca i32, align 4
  store i32 0, i32* %ret, align 4

  %rsi_val = call i64 asm sideeffect inteldialect "mov eax, 0x30; mov rax, qword ptr gs:[rax]; mov rax, qword ptr [rax+8]", "={rax}"()

  %lock_ptr_ptrptr = load i64**, i64*** @off_140004470
  %lock_ptr = load i64*, i64** %lock_ptr_ptrptr

  %sleep_fn_ptr_raw = load i8*, i8** @qword_140008280
  br label %acquire_loop

acquire_loop:
  %cmpxchg = cmpxchg i64* %lock_ptr, i64 0, i64 %rsi_val monotonic monotonic
  %old = extractvalue { i64, i1 } %cmpxchg, 0
  %success = extractvalue { i64, i1 } %cmpxchg, 1
  br i1 %success, label %acquired, label %acquire_failed

acquire_failed:
  %already_owned = icmp eq i64 %old, %rsi_val
  br i1 %already_owned, label %owned_reentrant, label %sleep_then_retry

sleep_then_retry:
  %sleep_fn = bitcast i8* %sleep_fn_ptr_raw to void (i32)*
  call void %sleep_fn(i32 1000)
  br label %acquire_loop

owned_reentrant:
  br label %after_lock

acquired:
  br label %after_lock

after_lock:
  %r14d = phi i32 [ 1, %owned_reentrant ], [ 0, %acquired ]
  %state_ptr = load i32*, i32** @off_140004480
  %state0 = load i32, i32* %state_ptr
  %is_one = icmp eq i32 %state0, 1
  br i1 %is_one, label %state_eq_1, label %check_state_zero

state_eq_1:
  %e1 = call i32 @sub_140002670(i32 31)
  store i32 %e1, i32* %ret, align 4
  %e1_load = load i32, i32* %ret, align 4
  call void @sub_1400027A0(i32 %e1_load)
  br label %epilogue

check_state_zero:
  %is_zero = icmp eq i32 %state0, 0
  br i1 %is_zero, label %init_path, label %post_init_flag

init_path:
  store i32 1, i32* %state_ptr
  call void @sub_1400018D0()
  %cb0_ptr = bitcast void ()* @sub_140001CB0 to i8*
  %fn_q_8278 = load i8*, i8** @qword_140008278
  %fn_8278 = bitcast i8* %fn_q_8278 to i8* (i8*)*
  %res_8278 = call i8* %fn_8278(i8* %cb0_ptr)
  %dst_slot_ptrptr = load i8**, i8*** @off_140004460
  store i8* %res_8278, i8** %dst_slot_ptrptr

  call void @sub_140002790()
  call void @sub_140002120()

  %p430 = load i32*, i32** @off_140004430
  store i32 1, i32* %p430
  %p440 = load i32*, i32** @off_140004440
  store i32 1, i32* %p440
  %p450 = load i32*, i32** @off_140004450
  store i32 1, i32* %p450

  %base_ptr = load i8*, i8** @off_1400043C0
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_check_nt, label %set_ecx_zero

pe_check_nt:
  %pe_off_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %pe_off_i32ptr = bitcast i8* %pe_off_ptr to i32*
  %pe_off = load i32, i32* %pe_off_i32ptr
  %pe_off64 = sext i32 %pe_off to i64
  %pe_hdr = getelementptr i8, i8* %base_ptr, i64 %pe_off64
  %sig_ptr = bitcast i8* %pe_hdr to i32*
  %sig = load i32, i32* %sig_ptr
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt_hdr, label %set_ecx_zero

check_opt_hdr:
  %oh_magic_ptr = getelementptr i8, i8* %pe_hdr, i64 24
  %oh_magic_i16ptr = bitcast i8* %oh_magic_ptr to i16*
  %oh_magic = load i16, i16* %oh_magic_i16ptr
  %is_pe32 = icmp eq i16 %oh_magic, 267
  br i1 %is_pe32, label %pe32_path, label %check_pe32plus

check_pe32plus:
  %is_pe32p = icmp eq i16 %oh_magic, 523
  br i1 %is_pe32p, label %pe32plus_path, label %set_ecx_zero

pe32plus_path:
  %sz_ptr64 = getelementptr i8, i8* %pe_hdr, i64 132
  %sz_i32ptr64 = bitcast i8* %sz_ptr64 to i32*
  %sz64 = load i32, i32* %sz_i32ptr64
  %gt_e_64 = icmp ugt i32 %sz64, 14
  br i1 %gt_e_64, label %pe32plus_field, label %set_ecx_zero

pe32plus_field:
  %fld_ptr64 = getelementptr i8, i8* %pe_hdr, i64 248
  %fld_i32ptr64 = bitcast i8* %fld_ptr64 to i32*
  %fld64 = load i32, i32* %fld_i32ptr64
  %nz64 = icmp ne i32 %fld64, 0
  %ecx_from_pe64 = zext i1 %nz64 to i32
  br label %have_ecx_flag

pe32_path:
  %sz_ptr32 = getelementptr i8, i8* %pe_hdr, i64 116
  %sz_i32ptr32 = bitcast i8* %sz_ptr32 to i32*
  %sz32 = load i32, i32* %sz_i32ptr32
  %gt_e_32 = icmp ugt i32 %sz32, 14
  br i1 %gt_e_32, label %pe32_field, label %set_ecx_zero

pe32_field:
  %fld_ptr32 = getelementptr i8, i8* %pe_hdr, i64 232
  %fld_i32ptr32 = bitcast i8* %fld_ptr32 to i32*
  %fld32 = load i32, i32* %fld_i32ptr32
  %nz32 = icmp ne i32 %fld32, 0
  %ecx_from_pe32 = zext i1 %nz32 to i32
  br label %have_ecx_flag

set_ecx_zero:
  %ecx_zero = phi i32 [ 0, %pe_check_nt ], [ 0, %check_opt_hdr ], [ 0, %check_pe32plus ], [ 0, %pe32_path ]
  br label %have_ecx_flag

have_ecx_flag:
  %ecx_phi = phi i32 [ %ecx_from_pe64, %pe32plus_field ], [ %ecx_from_pe32, %pe32_field ], [ %ecx_zero, %set_ecx_zero ]
  store i32 %ecx_phi, i32* @dword_140007008

  %p420 = load i32*, i32** @off_140004420
  %r8d_val = load i32, i32* %p420
  %r8d_nz = icmp ne i32 %r8d_val, 0
  br i1 %r8d_nz, label %call_2778_ecx2, label %after_2778

call_2778_ecx2:
  call void @sub_140002778(i32 2)
  br label %after_2778

after_2778:
  %p_ret1 = call i32* @sub_140002720()
  %p4f0 = load i32*, i32** @off_1400044F0
  %v4f0 = load i32, i32* %p4f0
  store i32 %v4f0, i32* %p_ret1

  %p_ret2 = call i32* @sub_140002718()
  %p4d0 = load i32*, i32** @off_1400044D0
  %v4d0 = load i32, i32* %p4d0
  store i32 %v4d0, i32* %p_ret2

  %e540 = call i32 @sub_140001540()
  store i32 %e540, i32* %ret, align 4
  %neg540 = icmp slt i32 %e540, 0
  br i1 %neg540, label %error_8, label %after_1540

after_1540:
  %p3a0 = load i32*, i32** @off_1400043A0
  %v3a0 = load i32, i32* %p3a0
  %is1 = icmp eq i32 %v3a0, 1
  br i1 %is1, label %call_1CA0, label %check_400

call_1CA0:
  %f1600 = bitcast void ()* @sub_140001600 to i8*
  call void @sub_140001CA0(i8* %f1600)
  br label %check_400

check_400:
  %p400 = load i32*, i32** @off_140004400
  %v400 = load i32, i32* %p400
  %isneg1 = icmp eq i32 %v400, -1
  br i1 %isneg1, label %do_27D0_neg1, label %after_27D0

do_27D0_neg1:
  call void @sub_1400027D0(i32 -1)
  br label %after_27D0

after_27D0:
  %p4b0 = load i8*, i8** @off_1400044B0
  %p4c0 = load i8*, i8** @off_1400044C0
  %e788 = call i32 @sub_140002788(i8* %p4b0, i8* %p4c0)
  store i32 %e788, i32* %ret, align 4
  %nz788 = icmp ne i32 %e788, 0
  br i1 %nz788, label %ret_ff, label %prep_26A0

ret_ff:
  store i32 255, i32* %ret, align 4
  br label %epilogue

prep_26A0:
  %v520_ptr = load i32*, i32** @off_140004520
  %v520 = load i32, i32* %v520_ptr
  store i32 %v520, i32* %var_4C, align 4
  %v4e0_ptr = load i32*, i32** @off_1400044E0
  %v4e0 = load i32, i32* %v4e0_ptr
  %e6A0 = call i32 @sub_1400026A0(i32* @dword_140007020, i8** @qword_140007018, i8** @qword_140007010, i32 %v4e0, i32* %var_4C)
  store i32 %e6A0, i32* %ret, align 4
  %neg6A0 = icmp slt i32 %e6A0, 0
  br i1 %neg6A0, label %error_8, label %alloc_array

alloc_array:
  %n = load i32, i32* @dword_140007020
  %n64 = sext i32 %n to i64
  %nplus1 = add i64 %n64, 1
  %bytes = shl i64 %nplus1, 3
  %arr_bytes = call i8* @sub_1400027F8(i64 %bytes)
  %arr_null = icmp eq i8* %arr_bytes, null
  br i1 %arr_null, label %error_8, label %maybe_loop

maybe_loop:
  %arr_base = bitcast i8* %arr_bytes to i8**
  %has_elems = icmp sgt i32 %n, 0
  br i1 %has_elems, label %loop_init, label %terminate_array

loop_init:
  %r15 = load i8*, i8** @qword_140007018
  %r15_arr = bitcast i8* %r15 to i8**
  br label %loop_head

loop_head:
  %i = phi i32 [ 1, %loop_init ], [ %i_next, %inc_i ]
  %idx0 = sext i32 %i to i64
  %idxm1 = add i64 %idx0, -1
  %src_slot = getelementptr i8*, i8** %r15_arr, i64 %idxm1
  %src_ptr = load i8*, i8** %src_slot
  %len = call i64 @sub_140002700(i8* %src_ptr)
  %need = add i64 %len, 1
  %dst = call i8* @sub_1400027F8(i64 %need)
  %dst_slot_addr = getelementptr i8*, i8** %arr_base, i64 %idxm1
  store i8* %dst, i8** %dst_slot_addr
  %dst_null = icmp eq i8* %dst, null
  br i1 %dst_null, label %error_8, label %loop_body

loop_body:
  call void @sub_1400027B8(i8* %dst, i8* %src_ptr, i64 %need)
  %i64 = sext i32 %i to i64
  %n_eq_i = icmp eq i64 %n64, %i64
  br i1 %n_eq_i, label %after_loop, label %inc_i

inc_i:
  %i_next = add i32 %i, 1
  br label %loop_head

after_loop:
  br label %terminate_array

terminate_array:
  %term_slot = getelementptr i8*, i8** %arr_base, i64 %n64
  store i8* null, i8** %term_slot
  %p4a0 = load i8*, i8** @off_1400044A0
  %p4490 = load i8*, i8** @off_140004490
  store i8* %arr_bytes, i8** @qword_140007018
  call void @sub_140002780(i8* %p4490, i8* %p4a0)
  call void @sub_140001520()
  store i32 2, i32* %state_ptr
  br label %post_init_flag

error_8:
  %e670_8 = call i32 @sub_140002670(i32 8)
  store i32 %e670_8, i32* %ret, align 4
  store i32 %e670_8, i32* %var_5C, align 4
  call void @sub_140002750()
  %e_final_err = load i32, i32* %var_5C, align 4
  store i32 %e_final_err, i32* %ret, align 4
  br label %epilogue

post_init_flag:
  store i32 1, i32* @dword_140007004
  %r14_is_zero = icmp eq i32 %r14d, 0
  br i1 %r14_is_zero, label %release_lock, label %after_release

release_lock:
  %oldx = atomicrmw xchg i64* %lock_ptr, i64 0 monotonic
  br label %after_release

after_release:
  %ppfn = load i8**, i8*** @off_1400043F0
  %pfn = load i8*, i8** %ppfn
  %has_cb = icmp ne i8* %pfn, null
  br i1 %has_cb, label %do_cb, label %after_cb

do_cb:
  %cb = bitcast i8* %pfn to void (i32, i32, i32)*
  call void %cb(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  %pp_out = call i8** @sub_140002660()
  %p0010 = load i8*, i8** @qword_140007010
  store i8* %p0010, i8** %pp_out

  %n_now = load i32, i32* @dword_140007020
  %ptr_list = load i8*, i8** @qword_140007018
  %ptr_seed = load i8*, i8** @qword_140007010
  %e880 = call i32 @sub_140002880(i32 %n_now, i8* %ptr_list, i8* %ptr_seed)
  store i32 %e880, i32* %ret, align 4

  %flag8 = load i32, i32* @dword_140007008
  %flag8_zero = icmp eq i32 %flag8, 0
  br i1 %flag8_zero, label %do_27A0_ret, label %check_flag4

do_27A0_ret:
  %eax_to_27A0 = load i32, i32* %ret, align 4
  call void @sub_1400027A0(i32 %eax_to_27A0)
  br label %epilogue

check_flag4:
  %flag4 = load i32, i32* @dword_140007004
  %flag4_zero = icmp eq i32 %flag4, 0
  br i1 %flag4_zero, label %savecall_2750, label %epilogue

savecall_2750:
  %eax_cur = load i32, i32* %ret, align 4
  store i32 %eax_cur, i32* %var_5C, align 4
  call void @sub_140002750()
  %eax_after = load i32, i32* %var_5C, align 4
  store i32 %eax_after, i32* %ret, align 4
  br label %epilogue

epilogue:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}