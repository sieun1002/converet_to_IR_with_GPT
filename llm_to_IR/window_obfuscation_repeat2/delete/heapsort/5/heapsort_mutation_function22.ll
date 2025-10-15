; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004450 = external global i64*
@__imp_Sleep = external global void (i32)*
@off_140004460 = external global i32*
@off_1400043D0 = external global i8*
@off_140004440 = external global i8**
@__imp_SetUnhandledExceptionFilter = external global i8* (i8*)*
@off_140004410 = external global i32*
@off_140004420 = external global i32*
@off_140004430 = external global i32*
@off_1400043A0 = external global i8*
@off_140004400 = external global i32*
@First = external global i8*
@Last = external global i8*
@off_140004500 = external global i32*
@off_1400044C0 = external global i32*
@off_1400044D0 = external global i32*
@off_1400044B0 = external global i32*
@off_140004380 = external global i32*
@off_1400043E0 = external global i32*
@off_140004470 = external global i8*
@off_140004480 = external global i8*

@qword_140007010 = global i8* null
@qword_140007018 = global i8** null
@dword_140007020 = global i32 0
@dword_140007008 = global i32 0
@dword_140007004 = global i32 0

declare i32 @sub_140002A30(i32)
declare void @sub_140001CA0()
declare i8* @_set_invalid_parameter_handler(i8*)
declare void @sub_1400024E0()
declare void @_set_app_type(i32)
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @sub_140001910()
declare void @sub_140002070(i8*)
declare i32 @_configthreadlocale(i32)
declare i32 @_initterm_e(i8*, i8*)
declare i32 @sub_140002A60(i8*, i8*, i8*, i32, i8*)
declare i8** @sub_140002A20()
declare i8* @malloc(i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i64 @strlen(i8*)
declare void @_initterm(i8*, i8*)
declare void @sub_1400018F0()
declare i32 @sub_14000171D(i32, i8**, i8*)
declare void @_cexit()
declare void @exit(i32) noreturn

declare i32 @TopLevelExceptionFilter(i8*)
declare void @sub_1400019D0()
declare void @Handler(...)

define i32 @sub_140001010() {
entry:
  %var_5C = alloca i32, align 4
  %var_4C = alloca i32, align 4
  %var_78 = alloca i8*, align 8

  %lockptr.addr = load i64*, i64** @off_140004450, align 8
  %owner = ptrtoint i8* null to i64
  br label %acquire

acquire:
  %cmp = cmpxchg i64* %lockptr.addr, i64 0, i64 %owner seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmp, 0
  %succ = extractvalue { i64, i1 } %cmp, 1
  br i1 %succ, label %acquired, label %cmpfail

cmpfail:
  %is_owner = icmp eq i64 %old, %owner
  br i1 %is_owner, label %reentrant, label %sleepblk

sleepblk:
  %Sleep_fp_ptr = load void (i32)*, void (i32)** @__imp_Sleep, align 8
  call void %Sleep_fp_ptr(i32 1000)
  br label %acquire

reentrant:
  br label %after_lock

acquired:
  br label %after_lock

after_lock:
  %r14d = phi i32 [ 0, %acquired ], [ 1, %reentrant ]
  %rbp_ptr = load i32*, i32** @off_140004460, align 8
  %rbp_val1 = load i32, i32* %rbp_ptr, align 4
  %cmp_state1 = icmp eq i32 %rbp_val1, 1
  br i1 %cmp_state1, label %loc_13C8, label %after_state1

after_state1:
  %rbp_val2 = load i32, i32* %rbp_ptr, align 4
  %is_zero_state = icmp eq i32 %rbp_val2, 0
  br i1 %is_zero_state, label %loc_1110, label %set_dword_7004

set_dword_7004:
  store i32 1, i32* @dword_140007004, align 4
  br label %loc_1084

loc_1084:
  %r14_is_zero = icmp eq i32 %r14d, 0
  br i1 %r14_is_zero, label %loc_1328, label %loc_108D

loc_1328:
  %xchg_old = atomicrmw xchg i64* %lockptr.addr, i64 0 seq_cst
  br label %loc_108D

loc_108D:
  %cb_slot = load i8*, i8** @off_1400043D0, align 8
  %cb_nonnull = icmp ne i8* %cb_slot, null
  br i1 %cb_nonnull, label %call_cb, label %after_cb

call_cb:
  %cb_typed = bitcast i8* %cb_slot to void (i32, i32, i32)*
  call void %cb_typed(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  %ret_ptr = call i8** @sub_140002A20()
  %progname = load i8*, i8** @qword_140007010, align 8
  %argc_val = load i32, i32* @dword_140007020, align 4
  store i8* %progname, i8** %ret_ptr, align 8
  %argv_ptr = load i8**, i8*** @qword_140007018, align 8
  %ret_171D = call i32 @sub_14000171D(i32 %argc_val, i8** %argv_ptr, i8* %progname)
  %flag_7008 = load i32, i32* @dword_140007008, align 4
  %flag_7008_is_zero = icmp eq i32 %flag_7008, 0
  br i1 %flag_7008_is_zero, label %loc_13D2, label %check_7004

check_7004:
  %flag_7004 = load i32, i32* @dword_140007004, align 4
  %flag_7004_is_zero = icmp eq i32 %flag_7004, 0
  br i1 %flag_7004_is_zero, label %loc_1310, label %epilogue

epilogue:
  ret i32 %ret_171D

loc_1110:
  store i32 1, i32* %rbp_ptr, align 4
  call void @sub_140001CA0()
  %seh_set = load i8* (i8*)*, i8* (i8*)** @__imp_SetUnhandledExceptionFilter, align 8
  %toplevel_ptr = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prev_filter = call i8* %seh_set(i8* %toplevel_ptr)
  %prev_slot_ptr = load i8**, i8*** @off_140004440, align 8
  store i8* %prev_filter, i8** %prev_slot_ptr, align 8
  %ip_handler = bitcast void (...)* @Handler to i8*
  %prev_iph = call i8* @_set_invalid_parameter_handler(i8* %ip_handler)
  call void @sub_1400024E0()
  %p410 = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %p410, align 4
  %p420 = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %p420, align 4
  %p430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p430, align 4
  %image_base = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %image_base to i16*
  %mz = load i16, i16* %mz_ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_check, label %loc_11C0

pe_check:
  %lfanew_ptr = getelementptr i8, i8* %image_base, i64 60
  %lfanew_p = bitcast i8* %lfanew_ptr to i32*
  %lfanew = load i32, i32* %lfanew_p, align 4
  %lfanew64 = sext i32 %lfanew to i64
  %nthdr = getelementptr i8, i8* %image_base, i64 %lfanew64
  %sig_p = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig_p, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %opt_hdr_check, label %loc_11C0

opt_hdr_check:
  %magic_ptr = getelementptr i8, i8* %nthdr, i64 24
  %magic_p = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_p, align 2
  %is_10B = icmp eq i16 %magic, 267
  br i1 %is_10B, label %loc_13AA, label %check_20B

check_20B:
  %is_20B = icmp eq i16 %magic, 523
  br i1 %is_20B, label %opt64_dir, label %loc_11C0

opt64_dir:
  %opt64_size_ptr = getelementptr i8, i8* %nthdr, i64 132
  %opt64_size_p = bitcast i8* %opt64_size_ptr to i32*
  %opt64_size = load i32, i32* %opt64_size_p, align 4
  %cond = icmp ugt i32 %opt64_size, 14
  br i1 %cond, label %read_dir64, label %loc_11C0

read_dir64:
  %dir_entry_ptr = getelementptr i8, i8* %nthdr, i64 248
  %dir_entry_p = bitcast i8* %dir_entry_ptr to i32*
  %r9d_val = load i32, i32* %dir_entry_p, align 4
  %has_dir64 = icmp ne i32 %r9d_val, 0
  %ecx_val64 = zext i1 %has_dir64 to i32
  br label %loc_11C0

loc_13AA:
  %opt32_size_ptr = getelementptr i8, i8* %nthdr, i64 116
  %opt32_size_p = bitcast i8* %opt32_size_ptr to i32*
  %opt32_size = load i32, i32* %opt32_size_p, align 4
  %cond32 = icmp ugt i32 %opt32_size, 14
  br i1 %cond32, label %read_dir32, label %loc_11C0

read_dir32:
  %dir_entry32_ptr = getelementptr i8, i8* %nthdr, i64 232
  %dir_entry32_p = bitcast i8* %dir_entry32_ptr to i32*
  %r10d_val = load i32, i32* %dir_entry32_p, align 4
  %has_dir32 = icmp ne i32 %r10d_val, 0
  %ecx_val32 = zext i1 %has_dir32 to i32
  br label %loc_11C0

loc_11C0:
  %phi_ecx = phi i32 [ 0, %loc_1110 ], [ 0, %pe_check ], [ 0, %check_20B ], [ 0, %opt_hdr_check ], [ %ecx_val64, %read_dir64 ], [ %ecx_val32, %read_dir32 ]
  store i32 %phi_ecx, i32* @dword_140007008, align 4
  %app_type_ptr = load i32*, i32** @off_140004400, align 8
  %app_type_val = load i32, i32* %app_type_ptr, align 4
  %nonzero_app = icmp ne i32 %app_type_val, 0
  br i1 %nonzero_app, label %loc_1338, label %loc_11E3

loc_1338:
  call void @_set_app_type(i32 2)
  br label %loc_11E3

loc_11E3:
  %pfmode = call i32* @__p__fmode()
  %fmode_src_ptr_g = load i32*, i32** @off_1400044D0, align 8
  %fmode_src = load i32, i32* %fmode_src_ptr_g, align 4
  store i32 %fmode_src, i32* %pfmode, align 4

  %pcommode = call i32* @__p__commode()
  %comm_src_ptr_g = load i32*, i32** @off_1400044B0, align 8
  %comm_src = load i32, i32* %comm_src_ptr_g, align 4
  store i32 %comm_src, i32* %pcommode, align 4

  %ret_1910 = call i32 @sub_140001910()
  %neg = icmp slt i32 %ret_1910, 0
  br i1 %neg, label %loc_1301, label %after_1910

after_1910:
  %p4380 = load i32*, i32** @off_140004380, align 8
  %v4380 = load i32, i32* %p4380, align 4
  %is_one_4380 = icmp eq i32 %v4380, 1
  br i1 %is_one_4380, label %loc_1399, label %loc_1220

loc_1399:
  %fn_ptr = bitcast void ()* @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %fn_ptr)
  br label %loc_1220

loc_1220:
  %p43E0 = load i32*, i32** @off_1400043E0, align 8
  %v43E0 = load i32, i32* %p43E0, align 4
  %is_m1 = icmp eq i32 %v43E0, -1
  br i1 %is_m1, label %loc_138A, label %loc_1230

loc_138A:
  %tmp_cfg = call i32 @_configthreadlocale(i32 -1)
  br label %loc_1230

loc_1230:
  %last_val = load i8*, i8** @Last, align 8
  %first_val = load i8*, i8** @First, align 8
  %init_e_ret = call i32 @_initterm_e(i8* %first_val, i8* %last_val)
  %init_e_nonzero = icmp ne i32 %init_e_ret, 0
  br i1 %init_e_nonzero, label %loc_1380, label %loc_124B

loc_1380:
  ret i32 255

loc_124B:
  %p4500 = load i32*, i32** @off_140004500, align 8
  %v4500 = load i32, i32* %p4500, align 4
  store i32 %v4500, i32* %var_4C, align 4

  %p44C0 = load i32*, i32** @off_1400044C0, align 8
  %v44C0 = load i32, i32* %p44C0, align 4

  %var_4C_ptr = bitcast i32* %var_4C to i8*
  store i8* %var_4C_ptr, i8** %var_78, align 8

  %rcx_arg = bitcast i32* @dword_140007020 to i8*
  %rdx_arg = bitcast i8*** @qword_140007018 to i8*
  %r8_arg  = bitcast i8** @qword_140007010 to i8*
  %fifth   = load i8*, i8** %var_78, align 8
  %ret_2A60 = call i32 @sub_140002A60(i8* %rcx_arg, i8* %rdx_arg, i8* %r8_arg, i32 %v44C0, i8* %fifth)
  %ret_2A60_neg = icmp slt i32 %ret_2A60, 0
  br i1 %ret_2A60_neg, label %loc_1301, label %after_2A60

after_2A60:
  %argc_now = load i32, i32* @dword_140007020, align 4
  %argc_sext = sext i32 %argc_now to i64
  %argc_plus1 = add nsw i64 %argc_sext, 1
  %size_bytes = shl i64 %argc_plus1, 3
  %new_argv_mem = call i8* @malloc(i64 %size_bytes)
  %r13 = bitcast i8* %new_argv_mem to i8**
  %r13_is_null = icmp eq i8* %new_argv_mem, null
  br i1 %r13_is_null, label %loc_1301, label %loop_prep

loop_prep:
  %cond_no_args = icmp sle i32 %argc_now, 0
  br i1 %cond_no_args, label %finalize_array, label %loop_init

loop_init:
  %r15 = load i8**, i8*** @qword_140007018, align 8
  br label %loop_cond

loop_cond:
  %i = phi i64 [ 1, %loop_init ], [ %i_next, %loop_body_end ]
  %prev_index = sub i64 %i, 1
  %src_ptr_i = getelementptr i8*, i8** %r15, i64 %prev_index
  %src_i = load i8*, i8** %src_ptr_i, align 8
  %len = call i64 @strlen(i8* %src_i)
  %len1 = add i64 %len, 1
  %dstbuf = call i8* @malloc(i64 %len1)
  %dst_slot = getelementptr i8*, i8** %r13, i64 %prev_index
  store i8* %dstbuf, i8** %dst_slot, align 8
  %dstbuf_null = icmp eq i8* %dstbuf, null
  br i1 %dstbuf_null, label %loc_1301, label %loop_copy

loop_copy:
  %ignore = call i8* @memcpy(i8* %dstbuf, i8* %src_i, i64 %len1)
  %i32 = trunc i64 %i to i32
  %is_last = icmp eq i32 %argc_now, %i32
  br i1 %is_last, label %loc_1347, label %loop_body_end

loop_body_end:
  %i_next = add i64 %i, 1
  br label %loop_cond

loc_1347:
  %endptr_calc = getelementptr i8*, i8** %r13, i64 %argc_sext
  br label %finalize_array

finalize_array:
  %endptr_phi = phi i8** [ %endptr_calc, %loc_1347 ], [ %r13, %loop_prep ]
  store i8* null, i8** %endptr_phi, align 8
  %first_init = load i8*, i8** @off_140004470, align 8
  %last_init  = load i8*, i8** @off_140004480, align 8
  store i8** %r13, i8*** @qword_140007018, align 8
  call void @_initterm(i8* %first_init, i8* %last_init)
  call void @sub_1400018F0()
  store i32 2, i32* %rbp_ptr, align 4
  br label %loc_1084

loc_1301:
  %code8 = call i32 @sub_140002A30(i32 8)
  br label %loc_1310

loc_1310:
  %code_sel = phi i32 [ %code8, %loc_1301 ], [ %ret_171D, %check_7004 ]
  store i32 %code_sel, i32* %var_5C, align 4
  call void @_cexit()
  %retcode = load i32, i32* %var_5C, align 4
  ret i32 %retcode

loc_13C8:
  %code31 = call i32 @sub_140002A30(i32 31)
  call void @exit(i32 %code31)
  unreachable

loc_13D2:
  call void @exit(i32 %ret_171D)
  unreachable
}