; ModuleID = 'sub_140001010.ll'
source_filename = "sub_140001010"
target triple = "x86_64-w64-windows-gnu"
; Note: compile with -fno-stack-protector to avoid stack protector refs

; External intrinsics
declare i8* @llvm.thread.pointer()

; External/internal functions (prototypes are conservative; many are varargs because exact signatures are unknown)
declare void @sub_140002B60(i32)
declare i32 @sub_140002A30(i32)
declare i8* @sub_140002A20()
declare void @sub_14000171D(...)
declare i32 @sub_140002B38(i32)
declare i8* @sub_140002AE0()
declare i8* @sub_140002AD8()
declare i32 @sub_140001910()
declare i32 @sub_140002B48(i8*, i8*)
declare i32 @sub_140002A60(...)
declare i8* @sub_140002BB8(i64)
declare i64 @sub_140002AC0(i8*)
declare void @sub_140002B78(i8*, i8*, i8*)
declare void @sub_140002B40(i8*, i8*)
declare i32 @sub_1400018F0()
declare i32 @sub_140001CA0()
declare void @loc_1403DADE6(...)
declare void @loc_140002B4D()
declare i32 @sub_1400024E0()
declare void @sub_140002070(i8*)
declare void @loc_140002B0D()
declare void @loc_140002B90(i32)

; External globals (pointers-to-where-to-read/write, matching the assembly indirections)
@off_140004450 = external global i8**          ; -> points to lock slot (which stores i8* owner)
@qword_140008280 = external global void (i32)*  ; Sleep-like function pointer storage
@off_140004460 = external global i32**          ; -> points to init-state dword
@dword_140007004 = external global i32
@off_1400043D0 = external global i8**           ; -> IAT slot holding callback pointer
@qword_140007010 = external global i8*          ; single pointer
@qword_140007018 = external global i8**         ; pointer-to-array of i8*
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@off_140004440 = external global i8**           ; -> pointer to where to store a ptr
@off_140004410 = external global i32**          ; -> points to dword flag
@off_140004420 = external global i32**          ; -> points to dword flag
@off_140004430 = external global i32**          ; -> points to dword flag
@off_1400043A0 = external global i8**           ; -> image base pointer
@off_140004400 = external global i32**          ; -> points to config dword
@off_1400044D0 = external global i32**          ; -> points to dword
@off_1400044B0 = external global i32**          ; -> points to dword
@off_140004380 = external global i32**          ; -> points to dword
@off_1400043E0 = external global i32**          ; -> points to dword
@off_1400044A0 = external global i8**           ; -> arbitrary pointer
@off_140004490 = external global i8**           ; -> arbitrary pointer
@off_140004500 = external global i32**          ; -> points to dword
@off_1400044C0 = external global i32**          ; -> points to dword
@off_140004480 = external global i8**           ; -> arbitrary pointer
@off_140004470 = external global i8**           ; -> arbitrary pointer

; Local stubs referenced by lea in asm (treated as opaque pointers)
@sub_140002080 = external global i8
@nullsub_1 = external global i8
@sub_1400019D0 = external global i8

; int sub_140001010(void)
define i32 @sub_140001010() local_unnamed_addr {
entry:
  ; Compute "owner" key: rsi = [gs:0x30] -> rax, then [rax+8]
  %tp0 = call i8* @llvm.thread.pointer()
  %peb_ptr_slot = getelementptr i8, i8* %tp0, i64 48           ; 0x30
  %peb_pp = bitcast i8* %peb_ptr_slot to i8**
  %peb = load i8*, i8** %peb_pp, align 8
  %owner_slot = getelementptr i8, i8* %peb, i64 8
  %owner_pp = bitcast i8* %owner_slot to i8**
  %owner = load i8*, i8** %owner_pp, align 8

  ; Load lock slot address: rbx = [off_140004450]
  %lock_slot_ptr_ptr = load i8**, i8*** @off_140004450, align 8
  %lock_slot_pp = bitcast i8** %lock_slot_ptr_ptr to i8**

  ; Load Sleep-like function pointer: rdi = qword_140008280
  %sleep_fp = load void (i32)*, void (i32)** @qword_140008280, align 8

  br label %spin_try

; Spin until acquired or detected re-entrant
spin_try:
  ; cmpxchg [lock], 0 -> owner
  %old_and_succ = cmpxchg i8** %lock_slot_pp, i8* null, i8* %owner monotonic monotonic
  %old_val = extractvalue { i8*, i1 } %old_and_succ, 0
  %acq_ok = extractvalue { i8*, i1 } %old_and_succ, 1
  br i1 %acq_ok, label %acquired, label %cmp_old

cmp_old:
  ; if previous == owner then reentrant
  %same_owner = icmp eq i8* %old_val, %owner
  br i1 %same_owner, label %reentrant, label %sleep_then_retry

sleep_then_retry:
  ; call sleep(1000)
  call void %sleep_fp(i32 1000)
  br label %spin_try

reentrant:
  ; r14d = 1
  br label %post_lock

acquired:
  ; r14d = 0
  br label %post_lock

post_lock:
  ; r14 flag phi
  %r14_flag = phi i1 [ true, %reentrant ], [ false, %acquired ]

  ; rbp = [off_140004460]
  %state_ptr_ptr = load i32**, i32*** @off_140004460, align 8
  %state = load i32, i32* %state_ptr_ptr, align 4
  %is_one = icmp eq i32 %state, 1
  br i1 %is_one, label %state_one, label %check_zero

check_zero:
  %is_zero = icmp eq i32 %state, 0
  br i1 %is_zero, label %state_zero_init, label %state_nonzero

state_one:
  ; ecx = 0x1F ; call sub_140002A30(ecx)
  %rv_1f = call i32 @sub_140002A30(i32 31)
  ; ecx = eax ; call sub_140002B60(ecx) ; likely terminates/throws
  call void @sub_140002B60(i32 %rv_1f)
  ; If returns, fall through as a safety net
  br label %maybe_return

state_zero_init:
  ; [rbp] = 1
  store i32 1, i32* %state_ptr_ptr, align 4

  ; call sub_140001CA0
  %tmp_ca0 = call i32 @sub_140001CA0()

  ; call loc_1403DADE6(sub_140002080, tmp_ca0 pushed) -> returns rax
  %p_sub_140002080 = bitcast i8* @sub_140002080 to i8*
  call void @loc_1403DADE6(i8* %p_sub_140002080, i32 %tmp_ca0)

  ; [*off_140004440] = rax (model as clearing/placeholder since rax is not materialized by vararg call here)
  %dst_ptr_loc = load i8**, i8*** @off_140004440, align 8
  ; store null as placeholder for rax (unknown)
  store i8* null, i8** %dst_ptr_loc, align 8

  ; call near ptr loc_140002B4D+3 (unknown exact) and sub_1400024E0
  call void @loc_140002B4D()
  %tmp_24e0 = call i32 @sub_1400024E0()

  ; Set a few global flags: [*off_140004410] = 1, [*off_140004420] = 1, [*off_140004430] = 1
  %p_4410_p = load i32**, i32*** @off_140004410, align 8
  store i32 1, i32* %p_4410_p, align 4
  %p_4420_p = load i32**, i32*** @off_140004420, align 8
  store i32 1, i32* %p_4420_p, align 4
  %p_4430_p = load i32**, i32*** @off_140004430, align 8
  store i32 1, i32* %p_4430_p, align 4

  ; Minimal PE header checks omitted; ecx computed flag -> we conservatively set ecx=0
  br label %after_image_checks

state_nonzero:
  ; dword_140007004 = 1
  store i32 1, i32* @dword_140007004, align 4
  br label %lock_release_check

after_image_checks:
  ; ecx flag based on image checks (set to 0 here)
  ; cs:dword_140007008 = ecx
  store i32 0, i32* @dword_140007008, align 4

  ; r8d = [*off_140004400]
  %cfg_ptr = load i32**, i32*** @off_140004400, align 8
  %cfg_val = load i32, i32* %cfg_ptr, align 4
  %cfg_is_nonzero = icmp ne i32 %cfg_val, 0
  br i1 %cfg_is_nonzero, label %do_b38_2, label %do_b38_1

do_b38_1:
  %tmp_b38_1 = call i32 @sub_140002B38(i32 1)
  br label %after_b38

do_b38_2:
  %tmp_b38_2 = call i32 @sub_140002B38(i32 2)
  br label %after_b38

after_b38:
  ; sub_140002AE0 -> returns a writable slot; write [slot] = [*off_1400044D0]
  %slot1 = call i8* @sub_140002AE0()
  %src1p = load i32**, i32*** @off_1400044D0, align 8
  %src1 = load i32, i32* %src1p, align 4
  %slot1_i32p = bitcast i8* %slot1 to i32*
  store i32 %src1, i32* %slot1_i32p, align 4

  ; sub_140002AD8 -> write [slot] = [*off_1400044B0]
  %slot2 = call i8* @sub_140002AD8()
  %src2p = load i32**, i32*** @off_1400044B0, align 8
  %src2 = load i32, i32* %src2p, align 4
  %slot2_i32p = bitcast i8* %slot2 to i32*
  store i32 %src2, i32* %slot2_i32p, align 4

  ; sub_140001910()
  %rv_1910 = call i32 @sub_140001910()
  %neg_1910 = icmp slt i32 %rv_1910, 0
  br i1 %neg_1910, label %err_path, label %cont_after_1910

cont_after_1910:
  ; if [*off_140004380] == 1, call sub_140002070(&sub_1400019D0)
  %p_4380 = load i32**, i32*** @off_140004380, align 8
  %v_4380 = load i32, i32* %p_4380, align 4
  %is_one_4380 = icmp eq i32 %v_4380, 1
  br i1 %is_one_4380, label %call_2070, label %check_43E0

call_2070:
  %p_19d0 = bitcast i8* @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %p_19d0)
  br label %check_43E0

check_43E0:
  ; if [*off_1400043E0] == -1 then loc_140002B90(-1)
  %p_43E0 = load i32**, i32*** @off_1400043E0, align 8
  %v_43E0 = load i32, i32* %p_43E0, align 4
  %is_m1_43E0 = icmp eq i32 %v_43E0, -1
  br i1 %is_m1_43E0, label %do_b90, label %after_b90

do_b90:
  call void @loc_140002B90(i32 -1)
  br label %after_b90

after_b90:
  ; sub_140002B48(*off_140004490, *off_1400044A0)
  %p_4490 = load i8**, i8*** @off_140004490, align 8
  %v_4490 = load i8*, i8** %p_4490, align 8
  %p_44A0 = load i8**, i8*** @off_1400044A0, align 8
  %v_44A0 = load i8*, i8** %p_44A0, align 8
  %rv_b48 = call i32 @sub_140002B48(i8* %v_4490, i8* %v_44A0)
  %b48_ok = icmp eq i32 %rv_b48, 0
  br i1 %b48_ok, label %cont_after_b48, label %ret_ff

cont_after_b48:
  ; Collect values for sub_140002A60(...) (opaque)
  %p_4500 = load i32**, i32*** @off_140004500, align 8
  %v_4500 = load i32, i32* %p_4500, align 4
  %p_44C0 = load i32**, i32*** @off_1400044C0, align 8
  %v_44C0 = load i32, i32* %p_44C0, align 4
  ; Addresses of globals
  %addr_dword_7020 = bitcast i32* @dword_140007020 to i8*
  %addr_qword_7018 = bitcast i8** @qword_140007018 to i8*
  %addr_qword_7010 = bitcast i8* @qword_140007010 to i8*
  ; Pass via varargs
  %rv_a60 = call i32 ( ... ) @sub_140002A60(i8* %addr_dword_7020, i8* %addr_qword_7018, i8* %addr_qword_7010, i32 %v_44C0, i32 %v_4500)
  %a60_neg = icmp slt i32 %rv_a60, 0
  br i1 %a60_neg, label %err_path, label %alloc_array

alloc_array:
  ; r12 = dword_140007020
  %count = load i32, i32* @dword_140007020, align 4
  ; allocate (r12+1)*8 bytes
  %count_plus1 = add i32 %count, 1
  %count_plus1_64 = sext i32 %count_plus1 to i64
  %bytes = shl i64 %count_plus1_64, 3
  %arr = call i8* @sub_140002BB8(i64 %bytes)
  %arr_pp = bitcast i8* %arr to i8**
  %arr_is_null = icmp eq i8** %arr_pp, null
  br i1 %arr_is_null, label %err_path, label %copy_loop_init

copy_loop_init:
  ; if count <= 0, skip to terminate
  %count_pos = icmp sgt i32 %count, 0
  br i1 %count_pos, label %loop_body, label %terminate_array

; i loop from 0 to count-1
loop_body:
  ; src = qword_140007018[i]
  %i0 = phi i32 [ 0, %copy_loop_init ], [ %i_next, %loop_next ]
  %i0_64 = sext i32 %i0 to i64
  %src_base = load i8**, i8*** @qword_140007018, align 8
  %src_ptr_ptr = getelementptr i8*, i8** %src_base, i64 %i0_64
  %src_ptr = load i8*, i8** %src_ptr_ptr, align 8

  ; len = sub_140002AC0(src)
  %len = call i64 @sub_140002AC0(i8* %src_ptr)
  ; n = len + 1
  %n = add i64 %len, 1
  ; dst = malloc(n)
  %dst = call i8* @sub_140002BB8(i64 %n)
  ; arr[i] = dst
  %dst_slot = getelementptr i8*, i8** %arr_pp, i64 %i0_64
  store i8* %dst, i8** %dst_slot, align 8
  ; if dst != null, copy
  %dst_nonnull = icmp ne i8* %dst, null
  br i1 %dst_nonnull, label %do_copy, label %err_path

do_copy:
  ; sub_140002B78(dst, src, n)
  %n_as_ptr = inttoptr i64 %n to i8*
  call void @sub_140002B78(i8* %dst, i8* %src_ptr, i8* %n_as_ptr)
  ; i++
  %i_next = add i32 %i0, 1
  %done = icmp eq i32 %i_next, %count
  br i1 %done, label %terminate_array, label %loop_next

loop_next:
  br label %loop_body

terminate_array:
  ; arr[count] = null terminator
  %count_64 = sext i32 %count to i64
  %term_slot = getelementptr i8*, i8** %arr_pp, i64 %count_64
  store i8* null, i8** %term_slot, align 8

  ; qword_140007018 = arr
  store i8** %arr_pp, i8*** @qword_140007018, align 8

  ; sub_140002B40(*off_140004470, *off_140004480)
  %p_4470 = load i8**, i8*** @off_140004470, align 8
  %v_4470 = load i8*, i8** %p_4470, align 8
  %p_4480 = load i8**, i8*** @off_140004480, align 8
  %v_4480 = load i8*, i8** %p_4480, align 8
  call void @sub_140002B40(i8* %v_4470, i8* %v_4480)

  ; sub_1400018F0(); [rbp]=2
  %tmp_18f0 = call i32 @sub_1400018F0()
  store i32 2, i32* %state_ptr_ptr, align 4
  br label %lock_release_check

ret_ff:
  ; return 0xFF (and release lock if held non-reentrant)
  br label %cleanup_ret_ff

err_path:
  ; error: sub_140002A30(8), then call loc_140002B0D, then return original eax (unknown -> 0)
  %tmp_a30 = call i32 @sub_140002A30(i32 8)
  call void @loc_140002B0D()
  br label %maybe_return

lock_release_check:
  ; If not reentrant, release the lock: xchg [lock], 0
  %not_reentrant = xor i1 %r14_flag, true
  br i1 %not_reentrant, label %release_lock, label %post_release

release_lock:
  %_ = atomicrmw xchg i8** %lock_slot_pp, i8* null monotonic
  br label %post_release

post_release:
  ; Optional callback around 0x14000108D
  ; rax = [ [off_1400043D0] ]
  %iat_slot = load i8**, i8*** @off_1400043D0, align 8
  %cb_ptr = load i8*, i8** %iat_slot, align 8
  %cb_is_null = icmp eq i8* %cb_ptr, null
  br i1 %cb_is_null, label %skip_cb, label %do_cb

do_cb:
  ; Call as void cb(0, 2, 0)
  %cb_typed = bitcast i8* %cb_ptr to void (i32, i32, i32)*
  call void %cb_typed(i32 0, i32 2, i32 0)
  br label %skip_cb

skip_cb:
  ; sub_140002A20(); [rax] = qword_140007010; sub_14000171D(...)
  %tmp_a20 = call i8* @sub_140002A20()
  %p7010 = load i8*, i8** @qword_140007010, align 8
  %slot_p = bitcast i8* %tmp_a20 to i8**
  store i8* %p7010, i8** %slot_p, align 8
  %arr7018 = load i8**, i8*** @qword_140007018, align 8
  %cnt7020 = load i32, i32* @dword_140007020, align 4
  call void @sub_14000171D(i8** %arr7018, i32 %cnt7020, i8* %tmp_a20)

  ; if dword_140007008 == 0 -> sub_140002B60(eax) path
  %flag_7008 = load i32, i32* @dword_140007008, align 4
  %flag_is_zero = icmp eq i32 %flag_7008, 0
  br i1 %flag_is_zero, label %call_b60_exit, label %check_7004

call_b60_exit:
  call void @sub_140002B60(i32 0)
  br label %maybe_return

check_7004:
  %flag_7004 = load i32, i32* @dword_140007004, align 4
  %flag_7004_zero = icmp eq i32 %flag_7004, 0
  br i1 %flag_7004_zero, label %post_cleanup, label %maybe_return

post_cleanup:
  ; loc_140002B0D, then return
  call void @loc_140002B0D()
  br label %maybe_return

cleanup_ret_ff:
  ; release lock if needed then return 0xFF
  %nr2 = xor i1 %r14_flag, true
  br i1 %nr2, label %rel2, label %ret_ff_now

rel2:
  %__ = atomicrmw xchg i8** %lock_slot_pp, i8* null monotonic
  br label %ret_ff_now

ret_ff_now:
  ret i32 255

maybe_return:
  ; Default return 0
  ret i32 0
}