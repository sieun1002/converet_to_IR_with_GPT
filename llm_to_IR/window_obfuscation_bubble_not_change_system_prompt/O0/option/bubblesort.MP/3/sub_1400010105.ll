; ModuleID = 'sub_140001010_module'
target triple = "x86_64-pc-windows-msvc"

declare i64 @llvm.read_register.i64(metadata)

declare void @sub_1400018D0()
declare void @sub_140002790(i8*)
declare void @sub_140002120()
declare i32 @sub_140001540()
declare void @sub_140001520()
declare void @sub_140001CA0(i8*)
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i8*, i8*, i8*, i32, i8*)
declare i8* @sub_1400027F8(i64)
declare i64 @sub_140002700(i8*)
declare void @sub_1400027B8(i8*, i8*, i64)
declare void @sub_140002780(i8*, i8*)
declare void @sub_1400027D0(i32)
declare i8* @sub_140002720()
declare i8* @sub_140002718()
declare void @sub_140002778(i32)
declare i32 @sub_140002670(i32)
declare void @sub_1400027A0(i32)
declare i8* @sub_140002660()
declare void @sub_140002880(i32, i8*, i8*)
declare void @sub_140002750()

declare void @sub_140001CB0()
declare void @nullsub_1()
declare void @sub_140001600()

@off_140004470 = external global i8****** 
@qword_140008280 = external global i8** 
@off_140004480 = external global i32** 
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*** 
@qword_140007010 = external global i8** 
@dword_140007020 = external global i32
@qword_140007018 = external global i8** 
@dword_140007008 = external global i32
@qword_140008278 = external global i8** 
@off_140004460 = external global i8*** 
@off_140004430 = external global i32** 
@off_140004440 = external global i32** 
@off_140004450 = external global i32** 
@off_1400043C0 = external global i8** 
@off_140004420 = external global i32** 
@off_1400044F0 = external global i32** 
@off_1400044D0 = external global i32** 
@off_1400043A0 = external global i32** 
@off_140004400 = external global i32** 
@off_1400044C0 = external global i8** 
@off_1400044B0 = external global i8** 
@off_140004520 = external global i32** 
@off_1400044E0 = external global i32** 
@off_1400044A0 = external global i8** 
@off_140004490 = external global i8** 

define i32 @sub_140001010() {
entry:
  %var_4C = alloca i32, align 4
  %var_78 = alloca i8*, align 8
  %var_5C = alloca i32, align 4
  %retv = alloca i32, align 4
  store i32 0, i32* %retv, align 4
  %gsbase = call i64 @llvm.read_register.i64(metadata !"gsbase")
  %gsbase_ptr = inttoptr i64 %gsbase to i8*
  %tib_slot = getelementptr i8, i8* %gsbase_ptr, i64 48
  %tib_slot_ptr = bitcast i8* %tib_slot to i8**
  %teb = load i8*, i8** %tib_slot_ptr, align 8
  %owner_ptraddr = getelementptr i8, i8* %teb, i64 8
  %owner_ptraddr_cast = bitcast i8* %owner_ptraddr to i8**
  %owner = load i8*, i8** %owner_ptraddr_cast, align 8
  %rbx_base_ptr_ptr_ptr_ptr = load i8*****, i8****** @off_140004470
  %rbx_base_ptr_ptr_ptr = load i8****, i8***** %rbx_base_ptr_ptr_ptr_ptr
  %rbx_base_ptr_ptr = load i8***, i8**** %rbx_base_ptr_ptr_ptr
  %rbx_base_ptr = load i8**, i8*** %rbx_base_ptr_ptr
  %sleep_func = load i8*, i8** @qword_140008280
  br label %try_lock

try_lock:                                        ; preds = %sleep_then_retry, %entry
  %cmpx = cmpxchg i8** %rbx_base_ptr, i8* null, i8* %owner monotonic monotonic
  %oldval = extractvalue { i8*, i1 } %cmpx, 0
  %success = extractvalue { i8*, i1 } %cmpx, 1
  br i1 %success, label %lock_acquired, label %cmp_fail

cmp_fail:                                        ; preds = %try_lock
  %eq_ours = icmp eq i8* %oldval, %owner
  br i1 %eq_ours, label %already_owned, label %sleep_then_retry

sleep_then_retry:                                ; preds = %cmp_fail
  %sleep_cast = bitcast i8* %sleep_func to void (i32)*
  call void %sleep_cast(i32 1000)
  br label %try_lock

already_owned:                                   ; preds = %cmp_fail
  br label %post_lock_owned

lock_acquired:                                   ; preds = %try_lock
  br label %post_lock_owned

post_lock_owned:                                 ; preds = %lock_acquired, %already_owned
  %r14 = phi i32 [ 1, %already_owned ], [ 0, %lock_acquired ]
  %rbp_ptrptr = load i32*, i32** @off_140004480
  %rbp_val = load i32, i32* %rbp_ptrptr, align 4
  %is_one = icmp eq i32 %rbp_val, 1
  br i1 %is_one, label %state_one, label %check_zero

state_one:                                       ; preds = %post_lock_owned
  %tmp31 = call i32 @sub_140002670(i32 31)
  call void @sub_1400027A0(i32 %tmp31)
  unreachable

check_zero:                                      ; preds = %post_lock_owned
  %is_zero = icmp eq i32 %rbp_val, 0
  br i1 %is_zero, label %init_path, label %set_flag_and_continue

set_flag_and_continue:                           ; preds = %check_zero
  store i32 1, i32* @dword_140007004, align 4
  br label %after_set

init_path:                                       ; preds = %check_zero
  store i32 1, i32* %rbp_ptrptr, align 4
  call void @sub_1400018D0()
  %fptr_loader = load i8*, i8** @qword_140008278
  %fptr_cast = bitcast i8* %fptr_loader to i8* (i8*)*
  %cb = bitcast void ()* @sub_140001CB0 to i8*
  %ret_from_cbreg = call i8* %fptr_cast(i8* %cb)
  %off_4460 = load i8**, i8*** @off_140004460
  store i8* %ret_from_cbreg, i8** %off_4460, align 8
  %ns = bitcast void ()* @nullsub_1 to i8*
  call void @sub_140002790(i8* %ns)
  call void @sub_140002120()
  %p_4430 = load i32*, i32** @off_140004430
  store i32 1, i32* %p_4430, align 4
  %p_4440 = load i32*, i32** @off_140004440
  store i32 1, i32* %p_4440, align 4
  %p_4450 = load i32*, i32** @off_140004450
  store i32 1, i32* %p_4450, align 4
  %p_43C0 = load i8*, i8** @off_1400043C0
  %mz_ptr = bitcast i8* %p_43C0 to i16*
  %mzw = load i16, i16* %mz_ptr, align 2
  %is_MZ = icmp eq i16 %mzw, 23117
  br i1 %is_MZ, label %check_PE_hdr, label %set_ecx0

check_PE_hdr:                                    ; preds = %init_path
  %e_lfanew_ptr = getelementptr i8, i8* %p_43C0, i64 60
  %e_lfanew_ptr_i32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr_i32, align 4
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %p_43C0, i64 %e_lfanew
  %nt_hdr_i32p = bitcast i8* %nt_hdr to i32*
  %pe_sig = load i32, i32* %nt_hdr_i32p, align 4
  %is_PE = icmp eq i32 %pe_sig, 17744
  br i1 %is_PE, label %check_opt_magic, label %set_ecx0

check_opt_magic:                                 ; preds = %check_PE_hdr
  %opt_magic_ptr = getelementptr i8, i8* %nt_hdr, i64 24
  %opt_magic_ptr_i16 = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic16 = load i16, i16* %opt_magic_ptr_i16, align 2
  %is_PE32 = icmp eq i16 %opt_magic16, 267
  br i1 %is_PE32, label %pe32_magic, label %check_pe32plus

check_pe32plus:                                  ; preds = %check_opt_magic
  %is_PE32plus = icmp eq i16 %opt_magic16, 523
  br i1 %is_PE32plus, label %pe32plus_path, label %set_ecx0

pe32plus_path:                                   ; preds = %check_pe32plus
  %soh_ptr = getelementptr i8, i8* %nt_hdr, i64 132
  %soh_ptr_i32 = bitcast i8* %soh_ptr to i32*
  %soh = load i32, i32* %soh_ptr_i32, align 4
  %soh_cond = icmp ugt i32 %soh, 14
  br i1 %soh_cond, label %pe32plus_check_flag, label %set_ecx0

pe32plus_check_flag:                             ; preds = %pe32plus_path
  %flag_ptr = getelementptr i8, i8* %nt_hdr, i64 248
  %flag_ptr_i32 = bitcast i8* %flag_ptr to i32*
  %flag = load i32, i32* %flag_ptr_i32, align 4
  %flag_nz = icmp ne i32 %flag, 0
  %ecx_from_flag = select i1 %flag_nz, i32 1, i32 0
  br label %after_pe_check

pe32_magic:                                      ; preds = %check_opt_magic
  %soh32_ptr = getelementptr i8, i8* %nt_hdr, i64 116
  %soh32_ptr_i32 = bitcast i8* %soh32_ptr to i32*
  %soh32 = load i32, i32* %soh32_ptr_i32, align 4
  %soh32_cond = icmp ugt i32 %soh32, 14
  br i1 %soh32_cond, label %pe32_check_flag, label %set_ecx0

pe32_check_flag:                                 ; preds = %pe32_magic
  %flag32_ptr = getelementptr i8, i8* %nt_hdr, i64 232
  %flag32_ptr_i32 = bitcast i8* %flag32_ptr to i32*
  %flag32 = load i32, i32* %flag32_ptr_i32, align 4
  %flag32_nz = icmp ne i32 %flag32, 0
  %ecx_from_flag32 = select i1 %flag32_nz, i32 1, i32 0
  br label %after_pe_check

set_ecx0:                                        ; preds = %pe32plus_path, %check_pe32plus, %check_PE_hdr, %init_path, %pe32_magic
  br label %after_pe_check

after_pe_check:                                  ; preds = %pe32_check_flag, %pe32plus_check_flag, %set_ecx0
  %ecx_phi = phi i32 [ %ecx_from_flag32, %pe32_check_flag ], [ %ecx_from_flag, %pe32plus_check_flag ], [ 0, %set_ecx0 ]
  %p_4420 = load i32*, i32** @off_140004420
  store i32 %ecx_phi, i32* @dword_140007008, align 4
  %r8d_val = load i32, i32* %p_4420, align 4
  %r8d_nz = icmp ne i32 %r8d_val, 0
  br i1 %r8d_nz, label %path_1338, label %cont_1

path_1338:                                       ; preds = %after_pe_check
  call void @sub_140002778(i32 2)
  br label %after_1DE

cont_1:                                          ; preds = %after_pe_check
  call void @sub_140002778(i32 1)
  br label %after_1DE

after_1DE:                                       ; preds = %cont_1, %path_1338
  %p_4F0 = load i32*, i32** @off_1400044F0
  %retptr1 = call i8* @sub_140002720()
  %retptr1_i32 = bitcast i8* %retptr1 to i32*
  %val4f0 = load i32, i32* %p_4F0, align 4
  store i32 %val4f0, i32* %retptr1_i32, align 4
  %p_4D0 = load i32*, i32** @off_1400044D0
  %retptr2 = call i8* @sub_140002718()
  %retptr2_i32 = bitcast i8* %retptr2 to i32*
  %val4d0 = load i32, i32* %p_4D0, align 4
  store i32 %val4d0, i32* %retptr2_i32, align 4
  %st = call i32 @sub_140001540()
  %neg = icmp slt i32 %st, 0
  br i1 %neg, label %error_1301, label %check_3a0

check_3a0:                                       ; preds = %after_1DE
  %p_3a0 = load i32*, i32** @off_1400043A0
  %val3a0 = load i32, i32* %p_3a0, align 4
  %is1_3a0 = icmp eq i32 %val3a0, 1
  br i1 %is1_3a0, label %call_1399, label %check_400

call_1399:                                       ; preds = %check_3a0
  %p_fun1600 = bitcast void ()* @sub_140001600 to i8*
  call void @sub_140001CA0(i8* %p_fun1600)
  br label %after_1399

after_1399:                                      ; preds = %call_1399
  br label %check_400

check_400:                                       ; preds = %after_1399, %check_3a0
  %p_400 = load i32*, i32** @off_140004400
  %val400 = load i32, i32* %p_400, align 4
  %is_m1 = icmp eq i32 %val400, -1
  br i1 %is_m1, label %call_138a, label %call_1230

call_138a:                                       ; preds = %check_400
  call void @sub_1400027D0(i32 -1)
  br label %call_1230

call_1230:                                       ; preds = %call_138a, %check_400
  %p_4C0 = load i8*, i8** @off_1400044C0
  %p_4B0 = load i8*, i8** @off_1400044B0
  %res788 = call i32 @sub_140002788(i8* %p_4B0, i8* %p_4C0)
  %nz = icmp ne i32 %res788, 0
  br i1 %nz, label %ret_ff, label %call_124b

ret_ff:                                          ; preds = %call_1230
  store i32 255, i32* %retv, align 4
  br label %early_return

call_124b:                                       ; preds = %call_1230
  %p_520 = load i32*, i32** @off_140004520
  %v520 = load i32, i32* %p_520, align 4
  store i32 %v520, i32* %var_4C, align 4
  %p_4E0 = load i32*, i32** @off_1400044E0
  %r9val = load i32, i32* %p_4E0, align 4
  %var_4C_as_i8 = bitcast i32* %var_4C to i8*
  store i8* %var_4C_as_i8, i8** %var_78, align 8
  %rcx_arg = bitcast i32* @dword_140007020 to i8*
  %rdx_arg = bitcast i8** @qword_140007018 to i8*
  %r8_arg = bitcast i8** @qword_140007010 to i8*
  %arg5 = load i8*, i8** %var_78, align 8
  %res6A0 = call i32 @sub_1400026A0(i8* %rcx_arg, i8* %rdx_arg, i8* %r8_arg, i32 %r9val, i8* %arg5)
  %res6A0_neg = icmp slt i32 %res6A0, 0
  br i1 %res6A0_neg, label %error_1301, label %continue_after_6A0

continue_after_6A0:                              ; preds = %call_124b
  %count = load i32, i32* @dword_140007020, align 4
  %count64 = sext i32 %count to i64
  %plus1 = add i64 %count64, 1
  %bytes = shl i64 %plus1, 3
  %newarr = call i8* @sub_1400027F8(i64 %bytes)
  %isnull_newarr = icmp eq i8* %newarr, null
  br i1 %isnull_newarr, label %error_1301, label %maybe_loop

maybe_loop:                                      ; preds = %continue_after_6A0
  %le0 = icmp sle i32 %count, 0
  br i1 %le0, label %build_terminator, label %loop_prep

loop_prep:                                       ; preds = %maybe_loop
  %oldarr = load i8*, i8** @qword_140007018, align 8
  %i_init = add i64 0, 1
  br label %loop_cond

loop_cond:                                       ; preds = %after_copy, %loop_prep
  %i = phi i64 [ %i_init, %loop_prep ], [ %i_next, %after_copy ]
  %idx0 = add i64 %i, -1
  %src_off = mul i64 %idx0, 8
  %srcptr_addr = getelementptr i8, i8* %oldarr, i64 %src_off
  %srcptr_addr_cast = bitcast i8* %srcptr_addr to i8**
  %srcptr = load i8*, i8** %srcptr_addr_cast, align 8
  %len = call i64 @sub_140002700(i8* %srcptr)
  %len1 = add i64 %len, 1
  %buf = call i8* @sub_1400027F8(i64 %len1)
  %dst_off = mul i64 %idx0, 8
  %dst_addr = getelementptr i8, i8* %newarr, i64 %dst_off
  %dst_addr_cast = bitcast i8* %dst_addr to i8**
  store i8* %buf, i8** %dst_addr_cast, align 8
  %isnull_buf = icmp eq i8* %buf, null
  br i1 %isnull_buf, label %error_1301, label %do_copy

do_copy:                                         ; preds = %loop_cond
  call void @sub_1400027B8(i8* %buf, i8* %srcptr, i64 %len1)
  %i64_count = sext i32 %count to i64
  %eq_last = icmp eq i64 %i64_count, %i
  br i1 %eq_last, label %last_elem, label %after_copy

after_copy:                                      ; preds = %do_copy
  %i_next = add i64 %i, 1
  br label %loop_cond

last_elem:                                       ; preds = %do_copy
  %endoff = mul i64 %i64_count, 8
  %endptr = getelementptr i8, i8* %newarr, i64 %endoff
  br label %build_terminator_from_rax

build_terminator:                                ; preds = %maybe_loop
  %i64_count2 = sext i32 %count to i64
  %endoff2 = mul i64 %i64_count2, 8
  %endptr2 = getelementptr i8, i8* %newarr, i64 %endoff2
  br label %build_terminator_from_rax

build_terminator_from_rax:                       ; preds = %build_terminator, %last_elem
  %endphi = phi i8* [ %endptr, %last_elem ], [ %endptr2, %build_terminator ]
  %endphi_cast = bitcast i8* %endphi to i8**
  store i8* null, i8** %endphi_cast, align 8
  %p_4A0 = load i8*, i8** @off_1400044A0
  %p_490 = load i8*, i8** @off_140004490
  store i8* %newarr, i8** @qword_140007018, align 8
  call void @sub_140002780(i8* %p_490, i8* %p_4A0)
  call void @sub_140001520()
  store i32 2, i32* %rbp_ptrptr, align 4
  br label %after_set

after_set:                                       ; preds = %build_terminator_from_rax, %set_flag_and_continue
  %r14_is_zero = icmp eq i32 %r14, 0
  br i1 %r14_is_zero, label %release_lock, label %continue_no_release

release_lock:                                    ; preds = %after_set
  %old_release = atomicrmw xchg i8** %rbx_base_ptr, i8* null monotonic
  br label %cont_108d

continue_no_release:                             ; preds = %after_set
  br label %cont_108d

cont_108d:                                       ; preds = %continue_no_release, %release_lock
  %p_43F0 = load i8**, i8*** @off_1400043F0
  %f_slot = load i8*, i8** %p_43F0, align 8
  %has_func = icmp ne i8* %f_slot, null
  br i1 %has_func, label %call_slot, label %after_slot

call_slot:                                       ; preds = %cont_108d
  %slot_cast = bitcast i8* %f_slot to void (i32, i32, i32)*
  call void %slot_cast(i32 0, i32 2, i32 0)
  br label %after_slot

after_slot:                                      ; preds = %call_slot, %cont_108d
  %p_ret = call i8* @sub_140002660()
  %p_ret_cast = bitcast i8* %p_ret to i8**
  %val_q7010 = load i8*, i8** @qword_140007010, align 8
  store i8* %val_q7010, i8** %p_ret_cast, align 8
  %ecx_val2 = load i32, i32* @dword_140007020, align 4
  %rdx_val2 = load i8*, i8** @qword_140007018, align 8
  %r8_val2 = load i8*, i8** @qword_140007010, align 8
  call void @sub_140002880(i32 %ecx_val2, i8* %rdx_val2, i8* %r8_val2)
  %ecx_g = load i32, i32* @dword_140007008, align 4
  %ecx_zero = icmp eq i32 %ecx_g, 0
  br i1 %ecx_zero, label %call_3d2, label %check_7004

check_7004:                                      ; preds = %after_slot
  %edx_g = load i32, i32* @dword_140007004, align 4
  %edx_zero = icmp eq i32 %edx_g, 0
  br i1 %edx_zero, label %path_1310, label %epilogue_return

error_1301:                                      ; preds = %continue_after_6A0, %loop_cond, %after_1DE
  %errcode = call i32 @sub_140002670(i32 8)
  store i32 %errcode, i32* %var_5C, align 4
  call void @sub_140002750()
  %eax_from_stack = load i32, i32* %var_5C, align 4
  store i32 %eax_from_stack, i32* %retv, align 4
  br label %early_return

path_1310:                                       ; preds = %check_7004
  %cur_rv = load i32, i32* %retv, align 4
  store i32 %cur_rv, i32* %var_5C, align 4
  call void @sub_140002750()
  %rv2 = load i32, i32* %var_5C, align 4
  store i32 %rv2, i32* %retv, align 4
  br label %early_return

call_3d2:                                        ; preds = %after_slot
  %rv3 = load i32, i32* %retv, align 4
  call void @sub_1400027A0(i32 %rv3)
  unreachable

epilogue_return:                                 ; preds = %check_7004
  %final = load i32, i32* %retv, align 4
  ret i32 %final

early_return:                                    ; preds = %path_1310, %error_1301, %ret_ff
  %final2 = load i32, i32* %retv, align 4
  ret i32 %final2
}