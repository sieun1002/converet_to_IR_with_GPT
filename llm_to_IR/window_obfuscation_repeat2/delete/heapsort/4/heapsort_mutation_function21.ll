; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @Sleep(i32)
declare ptr @SetUnhandledExceptionFilter(ptr)
declare ptr @_set_invalid_parameter_handler(ptr)
declare void @sub_140001CA0()
declare void @sub_1400024E0()
declare i32 @_set_app_type(i32)
declare ptr @__p__fmode()
declare ptr @__p__commode()
declare i32 @sub_140001910()
declare i32 @sub_140002A60(ptr, ptr, ptr, i32, ptr)
declare ptr @malloc(i64)
declare ptr @memcpy(ptr, ptr, i64)
declare i64 @strlen(ptr)
declare i32 @sub_140002A30(i32)
declare i32 @_initterm_e(ptr, ptr)
declare void @_initterm(ptr, ptr)
declare void @sub_1400018F0()
declare i32 @_configthreadlocale(i32)
declare void @sub_140002070(ptr)
declare void @_cexit()
declare void @exit(i32) noreturn
declare ptr @sub_140002A20()
declare void @sub_14000171D(i32, ptr, ptr)
declare i32 @TopLevelExceptionFilter(ptr)
declare void @Handler()
declare i32 @sub_1400019D0()

@off_140004450 = external global ptr
@off_140004460 = external global ptr
@dword_140007004 = external global i32
@off_1400043D0 = external global ptr
@qword_140007010 = external global ptr
@dword_140007020 = external global i32
@qword_140007018 = external global ptr
@dword_140007008 = external global i32
@off_140004440 = external global ptr
@off_140004410 = external global ptr
@off_140004420 = external global ptr
@off_140004430 = external global ptr
@off_1400043A0 = external global ptr
@off_140004400 = external global ptr
@off_1400044D0 = external global ptr
@off_1400044B0 = external global ptr
@off_140004380 = external global ptr
@off_1400043E0 = external global ptr
@First = external global ptr
@Last = external global ptr
@off_140004500 = external global ptr
@off_1400044C0 = external global ptr
@off_140004470 = external global ptr
@off_140004480 = external global ptr

define dso_local i32 @sub_140001010() {
entry:
  %status = alloca i32, align 4
  %has_seh = alloca i32, align 4
  %var_4C = alloca i32, align 4
  store i32 0, ptr %status
  store i32 0, ptr %has_seh
  %self = bitcast i32 ()* @sub_140001010 to ptr
  %lockaddrptr = load ptr, ptr @off_140004450
  br label %spin

spin:                                             ; preds = %sleep, %entry
  %oldpair = cmpxchg ptr %lockaddrptr, ptr null, ptr %self monotonic monotonic
  %oldval = extractvalue { ptr, i1 } %oldpair, 0
  %acqsuccess = extractvalue { ptr, i1 } %oldpair, 1
  br i1 %acqsuccess, label %locked, label %cmpfail

cmpfail:                                          ; preds = %spin
  %isSelf = icmp eq ptr %oldval, %self
  br i1 %isSelf, label %self_owner, label %sleep

sleep:                                            ; preds = %cmpfail
  call void @Sleep(i32 1000)
  br label %spin

self_owner:                                       ; preds = %cmpfail
  br label %loc_14000105C

locked:                                           ; preds = %spin
  br label %loc_14000105C

loc_14000105C:                                    ; preds = %self_owner, %locked
  %cont = phi i1 [ true, %self_owner ], [ false, %locked ]
  %stateptrptr = load ptr, ptr @off_140004460
  %state = load i32, ptr %stateptrptr
  %is1 = icmp eq i32 %state, 1
  br i1 %is1, label %loc_13C8, label %check_state_zero

check_state_zero:                                 ; preds = %loc_14000105C
  %is0 = icmp eq i32 %state, 0
  br i1 %is0, label %loc_140001110, label %set_dword_7004

set_dword_7004:                                   ; preds = %check_state_zero
  store i32 1, ptr @dword_140007004
  br label %loc_140001084

loc_140001110:                                    ; preds = %check_state_zero
  store i32 1, ptr %stateptrptr
  call void @sub_140001CA0()
  %prev = call ptr @SetUnhandledExceptionFilter(ptr @TopLevelExceptionFilter)
  %seh_prev_store_ptr = load ptr, ptr @off_140004440
  store ptr %prev, ptr %seh_prev_store_ptr
  %oldh = call ptr @_set_invalid_parameter_handler(ptr @Handler)
  call void @sub_1400024E0()
  %p1 = load ptr, ptr @off_140004410
  store i32 1, ptr %p1
  %p2 = load ptr, ptr @off_140004420
  store i32 1, ptr %p2
  %p3 = load ptr, ptr @off_140004430
  store i32 1, ptr %p3
  %base = load ptr, ptr @off_1400043A0
  %base_null = icmp eq ptr %base, null
  br i1 %base_null, label %after_pe_check, label %pe_check_mz

pe_check_mz:                                      ; preds = %loc_140001110
  %mzptr = bitcast ptr %base to ptr
  %mz = load i16, ptr %mzptr
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_fetch_nt, label %after_pe_check

pe_fetch_nt:                                      ; preds = %pe_check_mz
  %e_lfanew_ptr = getelementptr i8, ptr %base, i64 60
  %e_lfanew_i32 = load i32, ptr %e_lfanew_ptr
  %e_lfanew64 = sext i32 %e_lfanew_i32 to i64
  %nt = getelementptr i8, ptr %base, i64 %e_lfanew64
  %sig = load i32, ptr %nt
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %opt_hdr, label %after_pe_check

opt_hdr:                                          ; preds = %pe_fetch_nt
  %opt_magic_ptr = getelementptr i8, ptr %nt, i64 24
  %opt_magic = load i16, ptr %opt_magic_ptr
  %is_10B = icmp eq i16 %opt_magic, 267
  %is_20B = icmp eq i16 %opt_magic, 523
  br i1 %is_10B, label %pe_10B, label %check_20B

check_20B:                                        ; preds = %opt_hdr
  br i1 %is_20B, label %pe_20B, label %after_pe_check

pe_20B:                                           ; preds = %check_20B
  %size_ptr_20 = getelementptr i8, ptr %nt, i64 132
  %sz_20 = load i32, ptr %size_ptr_20
  %gt = icmp ugt i32 %sz_20, 14
  br i1 %gt, label %read_seh_20, label %after_pe_check

read_seh_20:                                      ; preds = %pe_20B
  %seh_ptr_20 = getelementptr i8, ptr %nt, i64 248
  %seh_val_20 = load i32, ptr %seh_ptr_20
  %nonzero_20 = icmp ne i32 %seh_val_20, 0
  %flag20 = select i1 %nonzero_20, i32 1, i32 0
  store i32 %flag20, ptr %has_seh
  br label %after_pe_check

pe_10B:                                           ; preds = %opt_hdr
  %size_ptr_10 = getelementptr i8, ptr %nt, i64 116
  %sz_10 = load i32, ptr %size_ptr_10
  %gt10 = icmp ugt i32 %sz_10, 14
  br i1 %gt10, label %read_seh_10, label %after_pe_check

read_seh_10:                                      ; preds = %pe_10B
  %seh_ptr_10 = getelementptr i8, ptr %nt, i64 232
  %seh_val_10 = load i32, ptr %seh_ptr_10
  %nonzero_10 = icmp ne i32 %seh_val_10, 0
  %flag10 = select i1 %nonzero_10, i32 1, i32 0
  store i32 %flag10, ptr %has_seh
  br label %after_pe_check

after_pe_check:                                   ; preds = %read_seh_10, %pe_10B, %read_seh_20, %pe_20B, %check_20B, %pe_fetch_nt, %pe_check_mz, %loc_140001110
  %ecx_val = load i32, ptr %has_seh
  store i32 %ecx_val, ptr @dword_140007008
  %app_ptr_ptr = load ptr, ptr @off_140004400
  %app = load i32, ptr %app_ptr_ptr
  %app_nonzero = icmp ne i32 %app, 0
  br i1 %app_nonzero, label %set_app_type2, label %set_app_type1

set_app_type1:                                    ; preds = %after_pe_check
  %ret_apptype1 = call i32 @_set_app_type(i32 1)
  br label %p_fmode

set_app_type2:                                    ; preds = %after_pe_check
  %ret_apptype2 = call i32 @_set_app_type(i32 2)
  br label %p_fmode

p_fmode:                                          ; preds = %set_app_type2, %set_app_type1
  %pf = call ptr @__p__fmode()
  %src_fmode_ptrptr = load ptr, ptr @off_1400044D0
  %src_fmode = load i32, ptr %src_fmode_ptrptr
  store i32 %src_fmode, ptr %pf
  %pc = call ptr @__p__commode()
  %src_commode_ptrptr = load ptr, ptr @off_1400044B0
  %src_commode = load i32, ptr %src_commode_ptrptr
  store i32 %src_commode, ptr %pc
  %ret_1910 = call i32 @sub_140001910()
  %neg = icmp slt i32 %ret_1910, 0
  br i1 %neg, label %error_path_1301, label %check_4380

check_4380:                                       ; preds = %p_fmode
  %p4380 = load ptr, ptr @off_140004380
  %v4380 = load i32, ptr %p4380
  %is1_4380 = icmp eq i32 %v4380, 1
  br i1 %is1_4380, label %call_2070, label %after_220

call_2070:                                        ; preds = %check_4380
  call void @sub_140002070(ptr @sub_1400019D0)
  br label %after_220

after_220:                                        ; preds = %call_2070, %check_4380
  %p3E0 = load ptr, ptr @off_1400043E0
  %v3E0 = load i32, ptr %p3E0
  %is_m1 = icmp eq i32 %v3E0, -1
  br i1 %is_m1, label %call_config, label %after_config

call_config:                                      ; preds = %after_220
  %retcfg = call i32 @_configthreadlocale(i32 -1)
  br label %after_config

after_config:                                     ; preds = %call_config, %after_220
  %Last_ptr = load ptr, ptr @Last
  %First_ptr = load ptr, ptr @First
  %ret_init_e = call i32 @_initterm_e(ptr %First_ptr, ptr %Last_ptr)
  %nonzero_init_e = icmp ne i32 %ret_init_e, 0
  br i1 %nonzero_init_e, label %loc_1380, label %cont1

loc_1380:                                         ; preds = %after_config
  store i32 255, ptr %status
  br label %epilogue

cont1:                                            ; preds = %after_config
  %p4500 = load ptr, ptr @off_140004500
  %v4500 = load i32, ptr %p4500
  store i32 %v4500, ptr %var_4C
  %p4C0 = load ptr, ptr @off_1400044C0
  %v4C0 = load i32, ptr %p4C0
  %ret_A60 = call i32 @sub_140002A60(ptr @dword_140007020, ptr @qword_140007018, ptr @qword_140007010, i32 %v4C0, ptr %var_4C)
  %retnegA60 = icmp slt i32 %ret_A60, 0
  br i1 %retnegA60, label %error_path_1301, label %alloc_for_args

alloc_for_args:                                   ; preds = %cont1
  %count = load i32, ptr @dword_140007020
  %count64 = sext i32 %count to i64
  %plus1 = add i64 %count64, 1
  %sizebytes = shl i64 %plus1, 3
  %r13 = call ptr @malloc(i64 %sizebytes)
  %isnullr13 = icmp eq ptr %r13, null
  br i1 %isnullr13, label %error_path_1301, label %copy_check

copy_check:                                       ; preds = %alloc_for_args
  %cntle = icmp sle i32 %count, 0
  br i1 %cntle, label %finalize_copy, label %copy_loop_init

copy_loop_init:                                   ; preds = %copy_check
  %r15 = load ptr, ptr @qword_140007018
  br label %copy_loop_head

copy_loop_head:                                   ; preds = %inc_i, %copy_loop_init
  %i = phi i64 [ 1, %copy_loop_init ], [ %i_next, %inc_i ]
  %idx0 = sub i64 %i, 1
  %elem_ptr_src_ptr = getelementptr ptr, ptr %r15, i64 %idx0
  %src = load ptr, ptr %elem_ptr_src_ptr
  %len = call i64 @strlen(ptr %src)
  %n = add i64 %len, 1
  %dst = call ptr @malloc(i64 %n)
  %elem_ptr_dst_ptr = getelementptr ptr, ptr %r13, i64 %idx0
  store ptr %dst, ptr %elem_ptr_dst_ptr
  %dst_isnull = icmp eq ptr %dst, null
  br i1 %dst_isnull, label %error_path_1301, label %do_memcpy

do_memcpy:                                        ; preds = %copy_loop_head
  %cpy = call ptr @memcpy(ptr %dst, ptr %src, i64 %n)
  %r12_curr = sext i32 %count to i64
  %cmp_end = icmp eq i64 %r12_curr, %i
  br i1 %cmp_end, label %loc_1347, label %inc_i

inc_i:                                            ; preds = %do_memcpy
  %i_next = add i64 %i, 1
  br label %copy_loop_head

loc_1347:                                         ; preds = %do_memcpy
  %endptr = getelementptr ptr, ptr %r13, i64 %r12_curr
  br label %finalize_copy

finalize_copy:                                    ; preds = %copy_check, %loc_1347
  %endptr_phi = phi ptr [ %endptr, %loc_1347 ], [ %r13, %copy_check ]
  store ptr null, ptr %endptr_phi
  store ptr %r13, ptr @qword_140007018
  %first2 = load ptr, ptr @off_140004470
  %last2 = load ptr, ptr @off_140004480
  call void @_initterm(ptr %first2, ptr %last2)
  call void @sub_1400018F0()
  %stateptrptr2 = load ptr, ptr @off_140004460
  store i32 2, ptr %stateptrptr2
  br label %loc_140001084

error_path_1301:                                  ; preds = %copy_loop_head, %alloc_for_args, %cont1, %p_fmode
  %retA30_8 = call i32 @sub_140002A30(i32 8)
  store i32 %retA30_8, ptr %status
  call void @_cexit()
  %st = load i32, ptr %status
  ret i32 %st

loc_13C8:                                         ; preds = %loc_14000105C
  %retA30_31 = call i32 @sub_140002A30(i32 31)
  store i32 %retA30_31, ptr %status
  br label %loc_14000108D

loc_140001084:                                    ; preds = %finalize_copy, %set_dword_7004
  br i1 %cont, label %loc_14000108D, label %loc_140001328

loc_140001328:                                    ; preds = %loc_140001084
  %lockaddrptr2 = load ptr, ptr @off_140004450
  %oldx = atomicrmw xchg ptr %lockaddrptr2, ptr null monotonic
  br label %loc_14000108D

loc_14000108D:                                    ; preds = %loc_13C8, %loc_140001328, %loc_140001084
  %p_off = load ptr, ptr @off_1400043D0
  %pp = load ptr, ptr %p_off
  %isnullpp = icmp eq ptr %pp, null
  br i1 %isnullpp, label %after_hook, label %call_hook

call_hook:                                        ; preds = %loc_14000108D
  %fn = bitcast ptr %pp to void (i32, i32, i32)*
  call void %fn(i32 0, i32 2, i32 0)
  br label %after_hook

after_hook:                                       ; preds = %call_hook, %loc_14000108D
  %pbuf = call ptr @sub_140002A20()
  %val7010 = load ptr, ptr @qword_140007010
  store ptr %val7010, ptr %pbuf
  %arg_rdx = load ptr, ptr @qword_140007018
  %arg_ecx = load i32, ptr @dword_140007020
  %arg_r8 = load ptr, ptr @qword_140007010
  call void @sub_14000171D(i32 %arg_ecx, ptr %arg_rdx, ptr %arg_r8)
  %flag = load i32, ptr @dword_140007008
  %iszeroFlag = icmp eq i32 %flag, 0
  br i1 %iszeroFlag, label %loc_13D2, label %check_7004

check_7004:                                       ; preds = %after_hook
  %v7004 = load i32, ptr @dword_140007004
  %iszero7004 = icmp eq i32 %v7004, 0
  br i1 %iszero7004, label %loc_1310, label %epilogue

loc_1310:                                         ; preds = %check_7004
  call void @_cexit()
  %st2 = load i32, ptr %status
  ret i32 %st2

loc_13D2:                                         ; preds = %after_hook
  %st3 = load i32, ptr %status
  call void @exit(i32 %st3)
  unreachable

epilogue:                                         ; preds = %loc_1380, %check_7004
  %st4 = load i32, ptr %status
  ret i32 %st4
}