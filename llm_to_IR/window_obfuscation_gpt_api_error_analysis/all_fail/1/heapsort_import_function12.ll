; ModuleID = 'translated'
source_filename = "translated.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

; External data (pointers to data or functions)
@off_140004450 = external global i8*            ; -> i8* lock slot
@qword_140008280 = external global void (i32)*  ; function pointer (e.g., Sleep)
@off_140004460 = external global i8*            ; -> i32* state
@dword_140007004 = external global i32          ; flag
@off_1400043D0 = external global i8*            ; -> i8* (function pointer slot)
@qword_140007010 = external global i8*          ; pointer value
@dword_140007020 = external global i32          ; count
@qword_140007018 = external global i8**         ; array pointer
@dword_140007008 = external global i32          ; flag
@off_140004440 = external global i8*            ; -> i8* slot
@off_140004410 = external global i8*            ; -> i32*
@off_140004420 = external global i8*            ; -> i32*
@off_140004430 = external global i8*            ; -> i32*
@off_1400043A0 = external global i8*            ; -> i8* PE base
@off_140004400 = external global i8*            ; -> i32*
@off_1400044D0 = external global i8*            ; -> i32*
@off_1400044B0 = external global i8*            ; -> i32*
@off_140004380 = external global i8*            ; -> i32*
@off_1400043E0 = external global i8*            ; -> i32*
@off_1400044A0 = external global i8*            ; -> i8*
@off_140004490 = external global i8*            ; -> i8*
@off_140004500 = external global i8*            ; -> i32*
@off_1400044C0 = external global i8*            ; -> i32*
@off_140004480 = external global i8*            ; -> i8*
@off_140004470 = external global i8*            ; -> i8*

; Internal stubs referenced by address
define dso_local void @nullsub_1() {
entry:
  ret void
}

define dso_local void @sub_140002080() {
entry:
  ret void
}

define dso_local void @sub_1400019D0() {
entry:
  ret void
}

; External functions with best-effort prototypes
declare i8* @sub_140001CA0()
declare i8* @loc_1403DADE6(i8*, i8*)
declare void @loc_140002B4D_plus_3(void ()*)
declare void @sub_1400024E0()
declare i8** @sub_140002A20()
declare void @sub_14000171D(i32, i8**, i8*)
declare void @sub_140002B38(i32)
declare i32* @sub_140002AE0()
declare i32* @sub_140002AD8()
declare i32 @sub_140001910()
declare void @sub_140002070(i8*)
declare i32 @sub_140002B48(i8*, i8*)
declare i32 @sub_140002A60(i32*, i8***, i8**, i32, i32*)
declare i8* @sub_140002BB8(i64)
declare i64 @sub_140002AC0(i8*)
declare void @sub_140002B78(i8*, i8*, i64)
declare i32 @sub_140002A30(i32)
declare void @loc_140002B0D_plus_3()
declare void @sub_140002B60(i32)
declare void @sub_140002B40(i8*, i8*)
declare void @sub_1400018F0()
declare void @loc_140002B90(i32)

; Main translated function
define dso_local i32 @sub_140001010() {
entry:
  ; locals
  %retv = alloca i32, align 4
  %token = alloca i8, align 1
  %r14flag = alloca i32, align 4
  %tmp54 = alloca i32, align 4
  %sav = alloca i32, align 4
  store i32 0, i32* %retv, align 4
  store i32 0, i32* %r14flag, align 4

  ; get lock address
  %lock_gptr = load i8*, i8** @off_140004450, align 8
  %lock_ptr = bitcast i8* %lock_gptr to i8**

lock.loop:
  %cmpx = cmpxchg i8** %lock_ptr, i8* null, i8* %token monotonic monotonic
  %old = extractvalue { i8*, i1 } %cmpx, 0
  %success = extractvalue { i8*, i1 } %cmpx, 1
  br i1 %success, label %locked, label %cmpfail

cmpfail:
  %owned = icmp eq i8* %old, %token
  br i1 %owned, label %recurse, label %sleep

sleep:
  %sleep_fp = load void (i32)*, void (i32)** @qword_140008280, align 8
  call void %sleep_fp(i32 1000)
  br label %lock.loop

recurse:
  store i32 1, i32* %r14flag, align 4
  br label %locked

locked:
  ; proceed
  ; rbp = *off_140004460
  %rbp_addr = load i8*, i8** @off_140004460, align 8
  %rbp_i32p = bitcast i8* %rbp_addr to i32*
  %rbp_val = load i32, i32* %rbp_i32p, align 4
  %is_one = icmp eq i32 %rbp_val, 1
  br i1 %is_one, label %doA30_31, label %chk_zero

doA30_31:
  %a31 = call i32 @sub_140002A30(i32 31)
  call void @sub_140002B60(i32 %a31)
  br label %after_init

chk_zero:
  %is_zero = icmp eq i32 %rbp_val, 0
  br i1 %is_zero, label %init_path, label %set_flag1

set_flag1:
  store i32 1, i32* @dword_140007004, align 4
  br label %after_init

init_path:
  ; [rbp] = 1
  store i32 1, i32* %rbp_i32p, align 4
  ; rax = sub_140001CA0
  %initp = call i8* @sub_140001CA0()
  ; rax = loc_1403DADE6(&sub_140002080, rax)
  %fptr_2080 = bitcast void ()* @sub_140002080 to i8*
  %hdl = call i8* @loc_1403DADE6(i8* %fptr_2080, i8* %initp)
  ; *(*off_140004440) = hdl
  %dst_slot_addr = load i8*, i8** @off_140004440, align 8
  %dst_slot = bitcast i8* %dst_slot_addr to i8**
  store i8* %hdl, i8** %dst_slot, align 8
  ; call loc_140002B4D+3(nullsub_1)
  call void @loc_140002B4D_plus_3(void ()* @nullsub_1)
  ; sub_1400024E0()
  call void @sub_1400024E0()
  ; set a few flags via off_* pointers
  %p4110 = load i8*, i8** @off_140004410, align 8
  %p4110_i32p = bitcast i8* %p4110 to i32*
  store i32 1, i32* %p4110_i32p, align 4

  %p4420 = load i8*, i8** @off_140004420, align 8
  %p4420_i32p = bitcast i8* %p4420 to i32*
  store i32 1, i32* %p4420_i32p, align 4

  %p4430 = load i8*, i8** @off_140004430, align 8
  %p4430_i32p = bitcast i8* %p4430 to i32*
  store i32 1, i32* %p4430_i32p, align 4

  ; compute ecx based on PE headers at *off_1400043A0
  %pebase_addr = load i8*, i8** @off_1400043A0, align 8
  %ecx_init = alloca i32, align 4
  store i32 0, i32* %ecx_init, align 4
  %base_null = icmp eq i8* %pebase_addr, null
  br i1 %base_null, label %store_ecx, label %check_mz

check_mz:
  %mz_ptr = bitcast i8* %pebase_addr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_step, label %store_ecx

pe_step:
  %lfanew_ptr = getelementptr i8, i8* %pebase_addr, i64 60
  %lfanew_ip = bitcast i8* %lfanew_ptr to i32*
  %lfanew = load i32, i32* %lfanew_ip, align 1
  %pnt64 = zext i32 %lfanew to i64
  %pnt = getelementptr i8, i8* %pebase_addr, i64 %pnt64
  %sigp = bitcast i8* %pnt to i32*
  %sig = load i32, i32* %sigp, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %store_ecx

check_magic:
  %magp_i8 = getelementptr i8, i8* %pnt, i64 24
  %magp = bitcast i8* %magp_i8 to i16*
  %magic = load i16, i16* %magp, align 1
  %is_pe32 = icmp eq i16 %magic, 267
  br i1 %is_pe32, label %pe32_case, label %check_pe32plus

check_pe32plus:
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %pe32p_case, label %store_ecx

pe32_case:
  %ddsz32_p_i8 = getelementptr i8, i8* %pnt, i64 116
  %ddsz32_p = bitcast i8* %ddsz32_p_i8 to i32*
  %ddsz32 = load i32, i32* %ddsz32_p, align 1
  %ddsz32_ok = icmp ugt i32 %ddsz32, 14
  br i1 %ddsz32_ok, label %pe32_read, label %store_ecx

pe32_read:
  %valp32_i8 = getelementptr i8, i8* %pnt, i64 232
  %valp32 = bitcast i8* %valp32_i8 to i32*
  %val32 = load i32, i32* %valp32, align 1
  %nz32 = icmp ne i32 %val32, 0
  %nz32_i32 = zext i1 %nz32 to i32
  store i32 %nz32_i32, i32* %ecx_init, align 4
  br label %store_ecx

pe32p_case:
  %ddsz64_p_i8 = getelementptr i8, i8* %pnt, i64 132
  %ddsz64_p = bitcast i8* %ddsz64_p_i8 to i32*
  %ddsz64 = load i32, i32* %ddsz64_p, align 1
  %ddsz64_ok = icmp ugt i32 %ddsz64, 14
  br i1 %ddsz64_ok, label %pe32p_read, label %store_ecx

pe32p_read:
  %valp64_i8 = getelementptr i8, i8* %pnt, i64 248
  %valp64 = bitcast i8* %valp64_i8 to i32*
  %val64 = load i32, i32* %valp64, align 1
  %nz64 = icmp ne i32 %val64, 0
  %nz64_i32 = zext i1 %nz64 to i32
  store i32 %nz64_i32, i32* %ecx_init, align 4
  br label %store_ecx

store_ecx:
  %ecx_final = load i32, i32* %ecx_init, align 4
  store i32 %ecx_final, i32* @dword_140007008, align 4
  br label %after_init

after_init:
  ; off_140004400 -> config
  %caddr = load i8*, i8** @off_140004400, align 8
  %cptr = bitcast i8* %caddr to i32*
  %cfg = load i32, i32* %cptr, align 4
  %cfg_nz = icmp ne i32 %cfg, 0
  br i1 %cfg_nz, label %call_b38_2, label %call_b38_1

call_b38_2:
  call void @sub_140002B38(i32 2)
  br label %after_b38

call_b38_1:
  call void @sub_140002B38(i32 1)
  br label %after_b38

after_b38:
  ; *sub_140002AE0() = *(*off_1400044D0)
  %dst1 = call i32* @sub_140002AE0()
  %src1_addr = load i8*, i8** @off_1400044D0, align 8
  %src1 = bitcast i8* %src1_addr to i32*
  %val1 = load i32, i32* %src1, align 4
  store i32 %val1, i32* %dst1, align 4
  ; *sub_140002AD8() = *(*off_1400044B0)
  %dst2 = call i32* @sub_140002AD8()
  %src2_addr = load i8*, i8** @off_1400044B0, align 8
  %src2 = bitcast i8* %src2_addr to i32*
  %val2 = load i32, i32* %src2, align 4
  store i32 %val2, i32* %dst2, align 4

  ; call sub_140001910 and check
  %rv_1910 = call i32 @sub_140001910()
  %neg = icmp slt i32 %rv_1910, 0
  br i1 %neg, label %error_301, label %cont_ok

cont_ok:
  ; if (*(*off_140004380) == 1) call sub_140002070(&sub_1400019D0)
  %o4380_addr = load i8*, i8** @off_140004380, align 8
  %o4380_p = bitcast i8* %o4380_addr to i32*
  %o4380_v = load i32, i32* %o4380_p, align 4
  %is_one_4380 = icmp eq i32 %o4380_v, 1
  br i1 %is_one_4380, label %do_2070, label %chk_43E0

do_2070:
  %fp_19d0 = bitcast void ()* @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %fp_19d0)
  br label %chk_43E0

chk_43E0:
  %o43E0_addr = load i8*, i8** @off_1400043E0, align 8
  %o43E0_p = bitcast i8* %o43E0_addr to i32*
  %o43E0_v = load i32, i32* %o43E0_p, align 4
  %is_m1 = icmp eq i32 %o43E0_v, -1
  br i1 %is_m1, label %call_b90_m1, label %cont_after_b90

call_b90_m1:
  call void @loc_140002B90(i32 -1)
  br label %cont_after_b90

cont_after_b90:
  ; call sub_140002B48((*off_140004490), (*off_1400044A0))
  %a0490 = load i8*, i8** @off_140004490, align 8
  %p0490 = bitcast i8* %a0490 to i8*
  %a04A0 = load i8*, i8** @off_1400044A0, align 8
  %p04A0 = bitcast i8* %a04A0 to i8*
  %b48rv = call i32 @sub_140002B48(i8* %p0490, i8* %p04A0)
  %b48nz = icmp ne i32 %b48rv, 0
  br i1 %b48nz, label %ret_ff, label %prep_a60

ret_ff:
  store i32 255, i32* %retv, align 4
  br label %maybe_release_and_ret

prep_a60:
  ; load [*off_140004500] into tmp54, and r9 from *off_1400044C0
  %a0500 = load i8*, i8** @off_140004500, align 8
  %p0500 = bitcast i8* %a0500 to i32*
  %v0500 = load i32, i32* %p0500, align 4
  store i32 %v0500, i32* %tmp54, align 4

  %a04C0 = load i8*, i8** @off_1400044C0, align 8
  %p04C0 = bitcast i8* %a04C0 to i32*
  %v04C0 = load i32, i32* %p04C0, align 4

  ; prepare args for sub_140002A60
  %rcx_arg = bitcast i32* @dword_140007020 to i32*
  %rdx_arg = bitcast i8*** @qword_140007018 to i8***
  %r8_arg = bitcast i8** @qword_140007010 to i8**
  %a60rv = call i32 @sub_140002A60(i32* %rcx_arg, i8*** %rdx_arg, i8** %r8_arg, i32 %v04C0, i32* %tmp54)
  %a60neg = icmp slt i32 %a60rv, 0
  br i1 %a60neg, label %error_301, label %alloc_list

alloc_list:
  ; r12 = (i64) dword_140007020
  %cnt = load i32, i32* @dword_140007020, align 4
  %cnt64 = sext i32 %cnt to i64
  ; size = (cnt + 1) * 8
  %cntp1 = add i64 %cnt64, 1
  %bytes = shl i64 %cntp1, 3
  %mem = call i8* @sub_140002BB8(i64 %bytes)
  %r13 = bitcast i8* %mem to i8**
  %r13null = icmp eq i8** %r13, null
  br i1 %r13null, label %error_301, label %maybe_loop

maybe_loop:
  %need_loop = icmp sgt i64 %cnt64, 0
  br i1 %need_loop, label %copy_loop_init, label %finalize_list

copy_loop_init:
  %r15 = load i8**, i8*** @qword_140007018, align 8
  br label %copy_loop_hdr

copy_loop_hdr:
  %i = phi i64 [ 1, %copy_loop_init ], [ %i_next, %copy_loop_body_done ]
  ; src = r15[i-1]
  %idxm1 = sub i64 %i, 1
  %src_slot = getelementptr i8*, i8** %r15, i64 %idxm1
  %src_val = load i8*, i8** %src_slot, align 8
  ; len = sub_140002AC0(src)
  %len = call i64 @sub_140002AC0(i8* %src_val)
  %size = add i64 %len, 1
  ; dest buffer
  %dest = call i8* @sub_140002BB8(i64 %size)
  ; store dest into r13[i-1]
  %dst_slot = getelementptr i8*, i8** %r13, i64 %idxm1
  store i8* %dest, i8** %dst_slot, align 8
  ; if dest == null -> error
  %dest_null = icmp eq i8* %dest, null
  br i1 %dest_null, label %error_301, label %do_copy

do_copy:
  ; sub_140002B78(dest, src, size)
  call void @sub_140002B78(i8* %dest, i8* %src_val, i64 %size)
  ; if i == cnt -> exit loop
  %at_end = icmp eq i64 %i, %cnt64
  br i1 %at_end, label %copy_loop_end, label %copy_loop_body_done

copy_loop_body_done:
  %i_next = add i64 %i, 1
  br label %copy_loop_hdr

copy_loop_end:
  ; rax = &r13[cnt]
  %end_slot = getelementptr i8*, i8** %r13, i64 %cnt64
  br label %finalize_list

finalize_list:
  ; if no loop, end_slot = &r13[0]
  %end_ptr = phi i8** [ %end_slot, %copy_loop_end ], [ %r13, %maybe_loop ]
  ; *end_ptr = null
  store i8* null, i8** %end_ptr, align 8
  ; qword_140007018 = r13
  store i8** %r13, i8*** @qword_140007018, align 8
  ; call sub_140002B40(*off_140004470, *off_140004480)
  %a0470 = load i8*, i8** @off_140004470, align 8
  %a0480 = load i8*, i8** @off_140004480, align 8
  call void @sub_140002B40(i8* %a0470, i8* %a0480)
  ; call sub_1400018F0
  call void @sub_1400018F0()
  ; [rbp] = 2
  store i32 2, i32* %rbp_i32p, align 4
  br label %post_build

error_301:
  %e8 = call i32 @sub_140002A30(i32 8)
  store i32 %e8, i32* %sav, align 4
  call void @loc_140002B0D_plus_3()
  %er = load i32, i32* %sav, align 4
  store i32 %er, i32* %retv, align 4
  br label %maybe_release_and_ret

post_build:
  ; continue common tail
  br label %test_r14

test_r14:
  %r14v = load i32, i32* %r14flag, align 4
  %r14_is_zero = icmp eq i32 %r14v, 0
  br i1 %r14_is_zero, label %release_lock_then_continue, label %continue_no_release

release_lock_then_continue:
  ; release lock: store null atomically
  store atomic i8* null, i8** %lock_ptr monotonic, align 8
  br label %continue_common

continue_no_release:
  br label %continue_common

continue_common:
  ; optional callback through **off_1400043D0
  %cb_slot_addr = load i8*, i8** @off_1400043D0, align 8
  %cb_ptr = bitcast i8* %cb_slot_addr to i8**
  %cb_val_i8 = load i8*, i8** %cb_ptr, align 8
  %cb_is_null = icmp eq i8* %cb_val_i8, null
  br i1 %cb_is_null, label %after_cb, label %do_cb

do_cb:
  %cb = bitcast i8* %cb_val_i8 to void (i32, i32, i32)*
  call void %cb(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  ; sub_140002A20 -> store qword_140007010 into *ret
  %pstore = call i8** @sub_140002A20()
  %val_q7010 = load i8*, i8** @qword_140007010, align 8
  store i8* %val_q7010, i8** %pstore, align 8
  ; call sub_14000171D(dword_140007020, qword_140007018, qword_140007010)
  %c_val = load i32, i32* @dword_140007020, align 4
  %rdx_val = load i8**, i8*** @qword_140007018, align 8
  %r8_val = load i8*, i8** @qword_140007010, align 8
  call void @sub_14000171D(i32 %c_val, i8** %rdx_val, i8* %r8_val)

  ; tail checks similar to assembly
  %flag8 = load i32, i32* @dword_140007008, align 4
  %flag8_zero = icmp eq i32 %flag8, 0
  br i1 %flag8_zero, label %call_b60_then_maybe, label %check_d7004

call_b60_then_maybe:
  %curret = load i32, i32* %retv, align 4
  call void @sub_140002B60(i32 %curret)
  br label %check_d7004

check_d7004:
  %f7004 = load i32, i32* @dword_140007004, align 4
  %f7004_zero = icmp eq i32 %f7004, 0
  br i1 %f7004_zero, label %save_call_b0d_ret, label %maybe_release_and_ret

save_call_b0d_ret:
  %curret2 = load i32, i32* %retv, align 4
  store i32 %curret2, i32* %sav, align 4
  call void @loc_140002B0D_plus_3()
  %rest = load i32, i32* %sav, align 4
  store i32 %rest, i32* %retv, align 4
  br label %maybe_release_and_ret

maybe_release_and_ret:
  ; ensure lock released if not recursion
  %r14v2 = load i32, i32* %r14flag, align 4
  %r14z2 = icmp eq i32 %r14v2, 0
  br i1 %r14z2, label %release_and_ret, label %just_ret

release_and_ret:
  store atomic i8* null, i8** %lock_ptr monotonic, align 8
  %rvf = load i32, i32* %retv, align 4
  ret i32 %rvf

just_ret:
  %rvf2 = load i32, i32* %retv, align 4
  ret i32 %rvf2
}