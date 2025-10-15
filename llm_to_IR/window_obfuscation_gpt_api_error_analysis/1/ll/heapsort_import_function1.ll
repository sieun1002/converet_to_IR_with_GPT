; ModuleID = 'sub_140001010.ll'
target triple = "x86_64-pc-windows-msvc"

; External function declarations (prototypes inferred from call sites)
declare i8* @get_current_teb_plus8()

declare void @sub_140002B60(i32)
declare i32 @sub_140002A30(i32)
declare void @sub_140002B38(i32)
declare i32* @sub_140002AE0()
declare i32* @sub_140002AD8()
declare i32 @sub_140001910()
declare i32 @sub_140002B48(i8*, i8*)
declare i32 @sub_140002A60(i32* %pCount, i8*** %pArray, i8** %pItem, i32 %opt, i32* %outVal)
declare i8* @sub_140002BB8(i64)
declare i64 @sub_140002AC0(i8*)
declare void @sub_140002B78(i8*, i8*, i64)
declare void @sub_140002B40(i8*, i8*)
declare void @sub_1400018F0()
declare i8** @sub_140002A20()
declare void @sub_14000171D(i32, i8**, i8*)
declare i8* @loc_1403DADE6(void ()*)
declare void @sub_1400024E0()
declare i8* @sub_140001CA0()
declare void @loc_140002B4D_p3()
declare void @loc_140002B0D_p3()
declare void @loc_140002B90(i32)
declare void @sub_140002070(void ()*)

; Function pointer and callback stubs referenced by address
declare void @nullsub_1()
declare void @sub_140002080()
declare void @sub_1400019D0()

; External globals (as referenced through RIP-relative loads)
@off_140004450 = external global i8*          ; points to lock variable (i8* storage)
@qword_140008280 = external global void (i32)* ; Sleep-like function pointer

@off_140004460 = external global i32*          ; state variable address
@off_1400043D0 = external global void (i32, i32, i32)**

@qword_140007010 = external global i8*
@qword_140007018 = external global i8**        ; array of i8* (strings/pointers)
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@dword_140007004 = external global i32

@off_140004440 = external global i8*           ; address to store callback handle
@off_140004410 = external global i32*
@off_140004420 = external global i32*
@off_140004430 = external global i32*

@off_1400043A0 = external global i8*           ; module base address
@off_140004400 = external global i32*          ; configuration flag address

@off_1400044D0 = external global i32*
@off_1400044B0 = external global i32*

@off_140004380 = external global i32*
@off_1400043E0 = external global i32*

@off_1400044A0 = external global i8*
@off_140004490 = external global i8*

@off_140004500 = external global i32*
@off_1400044C0 = external global i32*

@off_140004470 = external global i8*
@off_140004480 = external global i8*


define i32 @sub_140001010() {
entry:
  %ret = alloca i32, align 4
  %var_54 = alloca i32, align 4
  %var_5C = alloca i32, align 4
  %reentrant = alloca i1, align 1
  store i32 0, i32* %ret, align 4
  store i1 false, i1* %reentrant, align 1

  ; rsi <- gs:[0x30], then [rax+8] (thread/owner token)
  %owner.ptr = call i8* @get_current_teb_plus8()

  ; rbx <- [off_140004450] (address of lock variable), CAS [rbx]: 0 -> owner
  %lock.addr.val = load i8*, i8** @off_140004450, align 8
  %lock.mem = bitcast i8* %lock.addr.val to i8**

  br label %spin_try

spin_try:
  %cmpx = cmpxchg i8** %lock.mem, i8* null, i8* %owner.ptr seq_cst seq_cst
  %oldval = extractvalue { i8*, i1 } %cmpx, 0
  %success = extractvalue { i8*, i1 } %cmpx, 1
  br i1 %success, label %lock_acquired, label %spin_fail

spin_fail:
  %self_owned = icmp eq i8* %oldval, %owner.ptr
  br i1 %self_owned, label %already_owned, label %sleep_retry

sleep_retry:
  %sleep.fn.ptr.ptr = load void (i32)*, void (i32)** @qword_140008280, align 8
  call void %sleep.fn.ptr.ptr(i32 1000)
  br label %spin_try

already_owned:
  store i1 true, i1* %reentrant, align 1
  br label %state_check

lock_acquired:
  store i1 false, i1* %reentrant, align 1
  br label %state_check

state_check:
  %state.addr = load i32*, i32** @off_140004460, align 8
  %state.val = load i32, i32* %state.addr, align 4
  %is_one = icmp eq i32 %state.val, 1
  br i1 %is_one, label %state_one, label %state_not_one

state_one:
  %rv31 = call i32 @sub_140002A30(i32 31)
  call void @sub_140002B60(i32 %rv31)
  unreachable

state_not_one:
  %is_zero = icmp eq i32 %state.val, 0
  br i1 %is_zero, label %init_path, label %set_flag_and_continue

; state == 0 initialization
init_path:
  store i32 1, i32* %state.addr, align 4
  %t_init = call i8* @sub_140001CA0()

  %nullsub.ptr = bitcast void ()* @nullsub_1 to void ()*
  %vehh = call i8* @loc_1403DADE6(void ()* %nullsub.ptr)
  %veh.slot.addr = load i8*, i8** @off_140004440, align 8
  %veh.slot = bitcast i8* %veh.slot.addr to i8**
  store i8* %vehh, i8** %veh.slot, align 8

  call void @loc_140002B4D_p3()
  call void @sub_1400024E0()

  ; set three flags to 1
  %p410 = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %p410, align 4
  %p420 = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %p420, align 4
  %p430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p430, align 4

  ; Examine PE headers to compute ecx flag -> dword_140007008
  %ecx_tmp = alloca i32, align 4
  store i32 0, i32* %ecx_tmp, align 4

  %base = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117         ; 0x5A4D
  br i1 %is_mz, label %check_pe, label %after_pe_checks

check_pe:
  %pfan.ptr = getelementptr inbounds i8, i8* %base, i64 60
  %pfan = bitcast i8* %pfan.ptr to i32*
  %e_lfanew = load i32, i32* %pfan, align 4
  %nt.ptr = getelementptr inbounds i8, i8* %base, i32 %e_lfanew
  %sig.ptr = bitcast i8* %nt.ptr to i32*
  %sig = load i32, i32* %sig.ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744        ; 0x00004550
  br i1 %is_pe, label %opt_hdr, label %after_pe_checks

opt_hdr:
  %magic.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %magic.p = bitcast i8* %magic.ptr to i16*
  %magic = load i16, i16* %magic.p, align 2
  %is_pe32 = icmp eq i16 %magic, 267      ; 0x10B
  br i1 %is_pe32, label %pe32_case, label %check_pe64

check_pe64:
  %is_pe64 = icmp eq i16 %magic, 523      ; 0x20B
  br i1 %is_pe64, label %pe64_case, label %after_pe_checks

pe64_case:
  %sizeoptoff64 = getelementptr inbounds i8, i8* %nt.ptr, i64 132 ; 0x84
  %sizeopt64.p = bitcast i8* %sizeoptoff64 to i32*
  %sizeopt64 = load i32, i32* %sizeopt64.p, align 4
  %has_data_dir64 = icmp ugt i32 %sizeopt64, 14
  br i1 %has_data_dir64, label %read_cfguard64, label %after_pe_checks

read_cfguard64:
  %cfguardoff64 = getelementptr inbounds i8, i8* %nt.ptr, i64 248 ; 0xF8
  %cfguard64.p = bitcast i8* %cfguardoff64 to i32*
  %cfguard64 = load i32, i32* %cfguard64.p, align 4
  %nz64 = icmp ne i32 %cfguard64, 0
  %nz64.zext = zext i1 %nz64 to i32
  store i32 %nz64.zext, i32* %ecx_tmp, align 4
  br label %after_pe_checks

pe32_case:
  %sizeoptoff32 = getelementptr inbounds i8, i8* %nt.ptr, i64 116 ; 0x74
  %sizeopt32.p = bitcast i8* %sizeoptoff32 to i32*
  %sizeopt32 = load i32, i32* %sizeopt32.p, align 4
  %has_data_dir32 = icmp ugt i32 %sizeopt32, 14
  br i1 %has_data_dir32, label %read_cfguard32, label %after_pe_checks

read_cfguard32:
  %cfguardoff32 = getelementptr inbounds i8, i8* %nt.ptr, i64 232 ; 0xE8
  %cfguard32.p = bitcast i8* %cfguardoff32 to i32*
  %cfguard32 = load i32, i32* %cfguard32.p, align 4
  %nz32 = icmp ne i32 %cfguard32, 0
  %nz32.zext = zext i1 %nz32 to i32
  store i32 %nz32.zext, i32* %ecx_tmp, align 4
  br label %after_pe_checks

after_pe_checks:
  %ecx.flag = load i32, i32* %ecx_tmp, align 4
  store i32 %ecx.flag, i32* @dword_140007008, align 4

  ; r8d <- [off_140004400]
  %conf.addr = load i32*, i32** @off_140004400, align 8
  %conf.val = load i32, i32* %conf.addr, align 4
  %conf.nzero = icmp ne i32 %conf.val, 0
  br i1 %conf.nzero, label %call_b38_2, label %call_b38_1

call_b38_2:
  call void @sub_140002B38(i32 2)
  br label %init_cont

call_b38_1:
  call void @sub_140002B38(i32 1)
  br label %init_cont

init_cont:
  ; propagate config values
  %pA = call i32* @sub_140002AE0()
  %srcA.addr = load i32*, i32** @off_1400044D0, align 8
  %srcA = load i32, i32* %srcA.addr, align 4
  store i32 %srcA, i32* %pA, align 4

  %pB = call i32* @sub_140002AD8()
  %srcB.addr = load i32*, i32** @off_1400044B0, align 8
  %srcB = load i32, i32* %srcB.addr, align 4
  store i32 %srcB, i32* %pB, align 4

  %rv_1910 = call i32 @sub_140001910()
  %neg_rv_1910 = icmp slt i32 %rv_1910, 0
  br i1 %neg_rv_1910, label %error_1301, label %post_1910

post_1910:
  %p380 = load i32*, i32** @off_140004380, align 8
  %v380 = load i32, i32* %p380, align 4
  %is_one_380 = icmp eq i32 %v380, 1
  br i1 %is_one_380, label %call_2070, label %check_3E0

call_2070:
  %cb.ptr = bitcast void ()* @sub_1400019D0 to void ()*
  call void @sub_140002070(void ()* %cb.ptr)
  br label %check_3E0

check_3E0:
  %p3E0 = load i32*, i32** @off_1400043E0, align 8
  %v3E0 = load i32, i32* %p3E0, align 4
  %is_m1_3E0 = icmp eq i32 %v3E0, -1
  br i1 %is_m1_3E0, label %call_B90, label %b48_call

call_B90:
  call void @loc_140002B90(i32 -1)
  br label %b48_call

b48_call:
  %p4A0 = load i8*, i8** @off_1400044A0, align 8
  %p490 = load i8*, i8** @off_140004490, align 8
  %rv_b48 = call i32 @sub_140002B48(i8* %p490, i8* %p4A0)
  %nz_b48 = icmp ne i32 %rv_b48, 0
  br i1 %nz_b48, label %ret_ff, label %call_A60

ret_ff:
  store i32 255, i32* %ret, align 4
  br label %epilogue_check

call_A60:
  %p500 = load i32*, i32** @off_140004500, align 8
  %v500 = load i32, i32* %p500, align 4
  store i32 %v500, i32* %var_54, align 4

  %optC.addr = load i32*, i32** @off_1400044C0, align 8
  %optC = load i32, i32* %optC.addr, align 4

  %count.ptr = bitcast i32* @dword_140007020 to i32*
  %arr.ptr.ptr = bitcast i8*** @qword_140007018 to i8***
  %item.ptr = bitcast i8** @qword_140007010 to i8**
  %rv_a60 = call i32 @sub_140002A60(i32* %count.ptr, i8*** %arr.ptr.ptr, i8** %item.ptr, i32 %optC, i32* %var_54)
  %neg_a60 = icmp slt i32 %rv_a60, 0
  br i1 %neg_a60, label %error_1301, label %post_a60

post_a60:
  %count = load i32, i32* @dword_140007020, align 4
  %count.sext = sext i32 %count to i64
  %count.plus1 = add i64 %count.sext, 1
  %bytes = shl i64 %count.plus1, 3
  %new.arr.raw = call i8* @sub_140002BB8(i64 %bytes)
  %new.arr = bitcast i8* %new.arr.raw to i8**
  %is_null_new = icmp eq i8** %new.arr, null
  br i1 %is_null_new, label %error_1301, label %copy_loop_check

copy_loop_check:
  %has_elems = icmp sgt i64 %count.sext, 0
  br i1 %has_elems, label %copy_loop_body_entry, label %write_sentinel

; r15 = old array, r13 = new array
copy_loop_body_entry:
  br label %copy_loop_body

; i from 1 to count
copy_loop_body:
  %i = phi i64 [ 1, %copy_loop_body_entry ], [ %i.next, %copy_after_copy ]
  %old.arr = load i8**, i8*** @qword_140007018, align 8

  %src.idx = add i64 %i, -1
  %src.ptr.slot = getelementptr inbounds i8*, i8** %old.arr, i64 %src.idx
  %src.ptr = load i8*, i8** %src.ptr.slot, align 8

  %len.noNul = call i64 @sub_140002AC0(i8* %src.ptr)
  %len.withNul = add i64 %len.noNul, 1

  %dest.buf.raw = call i8* @sub_140002BB8(i64 %len.withNul)
  %dest.buf = bitcast i8* %dest.buf.raw to i8*
  %dest.slot = getelementptr inbounds i8*, i8** %new.arr, i64 %src.idx
  store i8* %dest.buf, i8** %dest.slot, align 8

  %dest.isnull = icmp eq i8* %dest.buf, null
  br i1 %dest.isnull, label %error_1301, label %do_copy

do_copy:
  call void @sub_140002B78(i8* %dest.buf, i8* %src.ptr, i64 %len.withNul)

  %is_last = icmp eq i64 %count.sext, %i
  br i1 %is_last, label %last_elem_ptr, label %copy_after_copy

copy_after_copy:
  %i.next = add i64 %i, 1
  br label %copy_loop_body

last_elem_ptr:
  %last.slot = getelementptr inbounds i8*, i8** %new.arr, i64 %count.sext
  br label %write_sentinel

write_sentinel:
  ; if came from no-elements, synthesize last.slot = new.arr + count
  %cond_lastptr = phi i8** [ %last.slot, %last_elem_ptr ], [ getelementptr (i8*, i8** %new.arr, i64 %count.sext), %copy_loop_check ]
  store i8* null, i8** %cond_lastptr, align 8

  ; publish new array and do follow-up calls
  store i8** %new.arr, i8*** @qword_140007018, align 8

  %p470 = load i8*, i8** @off_140004470, align 8
  %p480 = load i8*, i8** @off_140004480, align 8
  call void @sub_140002B40(i8* %p470, i8* %p480)

  call void @sub_1400018F0()
  store i32 2, i32* %state.addr, align 4
  br label %post_init_release

error_1301:
  %rv8 = call i32 @sub_140002A30(i32 8)
  store i32 %rv8, i32* %ret, align 4
  store i32 %rv8, i32* %var_5C, align 4
  call void @loc_140002B0D_p3()
  %rv_after = load i32, i32* %var_5C, align 4
  store i32 %rv_after, i32* %ret, align 4
  br label %epilogue_check

; state != 0 and != 1
set_flag_and_continue:
  store i32 1, i32* @dword_140007004, align 4
  br label %post_init_release

; Common path after init or flag set: optionally release lock if not reentrant, then continue
post_init_release:
  %reent = load i1, i1* %reentrant, align 1
  %not_reent = icmp eq i1 %reent, false
  br i1 %not_reent, label %unlock_then_cont, label %cont_body

unlock_then_cont:
  store atomic i8* null, i8** %lock.mem seq_cst, align 8
  br label %cont_body

cont_body:
  ; optional callback
  %cb.addr = load void (i32, i32, i32)**, void (i32, i32, i32)*** @off_1400043D0, align 8
  %cb.fun = load void (i32, i32, i32)*, void (i32, i32, i32)** %cb.addr, align 8
  %have_cb = icmp ne void (i32, i32, i32)* %cb.fun, null
  br i1 %have_cb, label %call_cb, label %skip_cb

call_cb:
  call void %cb.fun(i32 0, i32 2, i32 0)
  br label %skip_cb

skip_cb:
  %cell = call i8** @sub_140002A20()
  %item = load i8*, i8** @qword_140007010, align 8
  store i8* %item, i8** %cell, align 8

  %arr2 = load i8**, i8*** @qword_140007018, align 8
  %cnt2 = load i32, i32* @dword_140007020, align 4
  call void @sub_14000171D(i32 %cnt2, i8** %arr2, i8* %item)

  %gflag = load i32, i32* @dword_140007008, align 4
  %gflag_zero = icmp eq i32 %gflag, 0
  br i1 %gflag_zero, label %fatal_exit, label %chk_flag_7004

fatal_exit:
  %cur = load i32, i32* %ret, align 4
  call void @sub_140002B60(i32 %cur)
  unreachable

chk_flag_7004:
  %f7004 = load i32, i32* @dword_140007004, align 4
  %f7004_zero = icmp eq i32 %f7004, 0
  br i1 %f7004_zero, label %do_loc_B0D, label %epilogue

do_loc_B0D:
  %cur2 = load i32, i32* %ret, align 4
  store i32 %cur2, i32* %var_5C, align 4
  call void @loc_140002B0D_p3()
  %final = load i32, i32* %var_5C, align 4
  store i32 %final, i32* %ret, align 4
  br label %epilogue

epilogue_check:
  %rtnow = load i32, i32* %ret, align 4
  br label %epilogue

epilogue:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}