; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-windows-msvc"

@off_140004470 = external global i8**        ; holds address of i8* lock variable
@qword_140008280 = external global i8*       ; function pointer
@off_140004480 = external global i32*        ; holds address of i32 state
@dword_140007004 = external global i32
@off_1400043F0 = external global i8**        ; holds address of function pointer
@qword_140007010 = external global i8*
@qword_140007018 = external global i8**      ; array of i8* (value)
@dword_140007020 = external global i32
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
@off_140004460 = external global i8**        ; holds address of i8* (callback)

declare void @sub_140002670(i32)
declare i8** @sub_140002660()
declare void @sub_140002880(i32, i8*)
declare void @sub_1400018D0()
declare i8* @loc_140017DB5(...)
declare void @sub_140002790()
declare void @sub_140002120()
declare void @loc_140002778(i32)
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i32 @sub_140001540()
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i32*, i8***, i8**, i32, i32*)
declare i8* @sub_1400027F8(i64)
declare void @sub_1400027B8(i8*, i8*, i64)
declare i64 @sub_140002700(i8*)
declare void @sub_140001520()
declare void @sub_1400027D0(i32)
declare void @sub_140001CA0(void ()*)
declare void @sub_140001600()
declare void @sub_140001CB0()
declare void @nullsub_1()
declare void @sub_140002780(i8*, i8*)

define void @sub_140001010() {
entry:
  ; rsi <- [gs:0x30]+8
  %teb = call i8* asm "movq %gs:0x30, $0", "=r"()
  %teb_plus8 = getelementptr i8, i8* %teb, i64 8
  %teb_plus8_ptr = bitcast i8* %teb_plus8 to i8**
  %rsi_val = load i8*, i8** %teb_plus8_ptr, align 8

  ; rbx <- *off_140004470 (address of the lock variable)
  %lock_ptrptr = load i8**, i8*** @off_140004470, align 8

  ; rdi <- qword_140008280 (function pointer, e.g., Sleep)
  %sleep_fp_g = load i8*, i8** @qword_140008280, align 8

  br label %spin_try

spin_try:
  ; attempt lock: cmpxchg [rbx], 0 -> rsi
  %cmpx = cmpxchg i8** %lock_ptrptr, i8* null, i8* %rsi_val seq_cst seq_cst
  %prev = extractvalue { i8*, i1 } %cmpx, 0
  %acq = extractvalue { i8*, i1 } %cmpx, 1
  br i1 %acq, label %after_lock, label %cmpfail

cmpfail:
  ; if previous value == rsi, recursive acquisition
  %owned = icmp eq i8* %prev, %rsi_val
  br i1 %owned, label %owned_path, label %sleep_path

sleep_path:
  ; call rdi(1000)
  %sleep_fp = bitcast i8* %sleep_fp_g to void (i32)*
  call void %sleep_fp(i32 1000)
  br label %spin_try

owned_path:
  br label %after_lock

after_lock:
  ; r14d flag: 0 for freshly acquired, 1 for recursive
  %r14_phi = phi i32 [ 0, %spin_try ], [ 1, %owned_path ]

  ; rbp <- *off_140004480
  %rbp_ptr = load i32*, i32** @off_140004480, align 8
  ; eax <- [rbp]
  %rbp_val0 = load i32, i32* %rbp_ptr, align 4
  ; if ([rbp]==1) call sub_140002670(31)
  %is_one = icmp eq i32 %rbp_val0, 1
  br i1 %is_one, label %call_31_then_cont, label %check_zero

call_31_then_cont:
  call void @sub_140002670(i32 31)
  br label %check_zero

check_zero:
  %rbp_val1 = load i32, i32* %rbp_ptr, align 4
  %is_zero = icmp eq i32 %rbp_val1, 0
  br i1 %is_zero, label %init_path, label %set_dword_7004

init_path:
  store i32 1, i32* %rbp_ptr, align 4
  call void @sub_1400018D0()
  ; rcx <- &sub_140001CB0
  %cb_ptr_cast = bitcast void ()* @sub_140001CB0 to i8*
  %ret_init = call i8* @loc_140017DB5(i8* %cb_ptr_cast)
  ; [off_140004460] <- rax
  %off_4460 = load i8**, i8*** @off_140004460, align 8
  store i8* %ret_init, i8** %off_4460, align 8
  call void @sub_140002790()
  call void @sub_140002120()
  ; *off_140004430 = 1
  %p430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p430, align 4
  ; *off_140004440 = 1
  %p440 = load i32*, i32** @off_140004440, align 8
  store i32 1, i32* %p440, align 4
  ; *off_140004450 = 1
  %p450 = load i32*, i32** @off_140004450, align 8
  store i32 1, i32* %p450, align 4

  ; PE header checks to set ecx flag -> dword_140007008
  %imgptr = load i8*, i8** @off_1400043C0, align 8
  %mz_ptr = bitcast i8* %imgptr to i16*
  %mz = load i16, i16* %mz_ptr, align 2
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %nt_check, label %pe_flag_store

nt_check:
  ; NT headers pointer
  %pe_off_ptr_i8 = getelementptr i8, i8* %imgptr, i64 60
  %pe_off_ptr = bitcast i8* %pe_off_ptr_i8 to i32*
  %pe_off32 = load i32, i32* %pe_off_ptr, align 4
  %pe_off64 = sext i32 %pe_off32 to i64
  %nthdr = getelementptr i8, i8* %imgptr, i64 %pe_off64
  %sig_ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %opt_magic, label %pe_flag_store

opt_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nthdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic16 = load i16, i16* %opt_magic_ptr, align 2
  %is_pe32 = icmp eq i16 %opt_magic16, 267
  br i1 %is_pe32, label %pe32_path, label %check_pe64

check_pe64:
  %is_pe64 = icmp eq i16 %opt_magic16, 523
  br i1 %is_pe64, label %pe64_path, label %pe_flag_store

pe64_path:
  %sz64_ptr_i8 = getelementptr i8, i8* %nthdr, i64 132
  %sz64_ptr = bitcast i8* %sz64_ptr_i8 to i32*
  %sz64 = load i32, i32* %sz64_ptr, align 4
  %sz64_gt = icmp ugt i32 %sz64, 14
  br i1 %sz64_gt, label %pe64_field, label %pe_flag_store

pe64_field:
  %f64_ptr_i8 = getelementptr i8, i8* %nthdr, i64 248
  %f64_ptr = bitcast i8* %f64_ptr_i8 to i32*
  %f64 = load i32, i32* %f64_ptr, align 4
  %f64_nz = icmp ne i32 %f64, 0
  %cl_pe64 = zext i1 %f64_nz to i32
  br label %pe_flag_store

pe32_path:
  %sz32_ptr_i8 = getelementptr i8, i8* %nthdr, i64 116
  %sz32_ptr = bitcast i8* %sz32_ptr_i8 to i32*
  %sz32 = load i32, i32* %sz32_ptr, align 4
  %sz32_gt = icmp ugt i32 %sz32, 14
  br i1 %sz32_gt, label %pe32_field, label %pe_flag_store

pe32_field:
  %f32_ptr_i8 = getelementptr i8, i8* %nthdr, i64 232
  %f32_ptr = bitcast i8* %f32_ptr_i8 to i32*
  %f32 = load i32, i32* %f32_ptr, align 4
  %f32_nz = icmp ne i32 %f32, 0
  %cl_pe32 = zext i1 %f32_nz to i32
  br label %pe_flag_store

pe_flag_store:
  ; select cl from the two paths or default 0
  %cl_merge = phi i32 [ 0, %init_path ], [ 0, %nt_check ], [ 0, %check_pe64 ], [ 0, %pe64_path ], [ 0, %pe32_path ], [ %cl_pe64, %pe64_field ], [ %cl_pe32, %pe32_field ]
  store i32 %cl_merge, i32* @dword_140007008, align 4

  ; r8d <- *off_140004420
  %p4420 = load i32*, i32** @off_140004420, align 8
  %r8d_val = load i32, i32* %p4420, align 4
  %r8d_nz = icmp ne i32 %r8d_val, 0
  br i1 %r8d_nz, label %call_2778_two, label %call_2778_one

call_2778_one:
  call void @loc_140002778(i32 1)
  br label %cont_after_2778

call_2778_two:
  call void @loc_140002778(i32 2)
  br label %cont_after_2778

cont_after_2778:
  ; rax <- sub_140002720(); *rax = *(*off_1400044F0)
  %pA = call i32* @sub_140002720()
  %p4F0 = load i32*, i32** @off_1400044F0, align 8
  %v4F0 = load i32, i32* %p4F0, align 4
  store i32 %v4F0, i32* %pA, align 4
  ; rax <- sub_140002718(); *rax = *(*off_1400044D0)
  %pB = call i32* @sub_140002718()
  %p4D0 = load i32*, i32** @off_1400044D0, align 8
  %v4D0 = load i32, i32* %p4D0, align 4
  store i32 %v4D0, i32* %pB, align 4
  ; eax <- sub_140001540()
  %ret1540 = call i32 @sub_140001540()
  %neg1540 = icmp slt i32 %ret1540, 0
  br i1 %neg1540, label %error_gs8, label %chk_43A0

chk_43A0:
  %p43A0 = load i32*, i32** @off_1400043A0, align 8
  %v43A0 = load i32, i32* %p43A0, align 4
  %is1_43A0 = icmp eq i32 %v43A0, 1
  br i1 %is1_43A0, label %call_1CA0, label %chk_4400

call_1CA0:
  call void @sub_140001CA0(void ()* @sub_140001600)
  br label %after_1CA0

chk_4400:
  %p4400 = load i32*, i32** @off_140004400, align 8
  %v4400 = load i32, i32* %p4400, align 4
  %is_m1_4400 = icmp eq i32 %v4400, -1
  br i1 %is_m1_4400, label %call_27D0, label %cont_main

call_27D0:
  call void @sub_1400027D0(i32 -1)
  br label %cont_main

after_1CA0:
  br label %cont_main

cont_main:
  ; eax <- sub_140002788(off_4B0, off_4C0)
  %p4B0 = load i8*, i8** @off_1400044B0, align 8
  %p4C0 = load i8*, i8** @off_1400044C0, align 8
  %ret2788 = call i32 @sub_140002788(i8* %p4B0, i8* %p4C0)
  %nz2788 = icmp ne i32 %ret2788, 0
  br i1 %nz2788, label %early_ret_ff, label %prep_26A0

early_ret_ff:
  br label %epilogue

prep_26A0:
  ; prepare args for sub_1400026A0
  %p4520 = load i32*, i32** @off_140004520, align 8
  %v4520 = load i32, i32* %p4520, align 4
  ; local copy
  %var54 = alloca i32, align 4
  store i32 %v4520, i32* %var54, align 4
  %p44E0 = load i32*, i32** @off_1400044E0, align 8
  %v44E0 = load i32, i32* %p44E0, align 4
  ; rcx=&dword_140007020, rdx=&qword_140007018, r8=&qword_140007010, r9d=v44E0, 5th=&var54
  %r = call i32 @sub_1400026A0(i32* @dword_140007020, i8*** @qword_140007018, i8** @qword_140007010, i32 %v44E0, i32* %var54)
  %neg26A0 = icmp slt i32 %r, 0
  br i1 %neg26A0, label %error_gs8, label %alloc_vec

alloc_vec:
  ; r12 <- dword_140007020
  %cnt32 = load i32, i32* @dword_140007020, align 4
  %cnt64 = sext i32 %cnt32 to i64
  ; allocate (cnt+1)*8 bytes
  %cntp1 = add i64 %cnt64, 1
  %bytes = shl i64 %cntp1, 3
  %vec = call i8* @sub_1400027F8(i64 %bytes)
  %vec_is_null = icmp eq i8* %vec, null
  br i1 %vec_is_null, label %error_gs8, label %check_cnt

check_cnt:
  %cnt_pos = icmp sgt i32 %cnt32, 0
  br i1 %cnt_pos, label %loop_prep, label %write_term_and_commit

loop_prep:
  %src_arr = load i8**, i8*** @qword_140007018, align 8
  br label %loop_head

loop_head:
  ; i from 0 to cnt32-1
  %i = phi i32 [ 0, %loop_prep ], [ %i.next, %do_copy ]
  %i_done = icmp sge i32 %i, %cnt32
  br i1 %i_done, label %write_term_and_commit, label %loop_body

loop_body:
  ; src = src_arr[i]
  %i64 = sext i32 %i to i64
  %src_e_ptr = getelementptr i8*, i8** %src_arr, i64 %i64
  %src_e = load i8*, i8** %src_e_ptr, align 8
  ; len = sub_140002700(src)
  %len = call i64 @sub_140002700(i8* %src_e)
  ; rdi = len + 1
  %lenp1 = add i64 %len, 1
  ; dst = sub_1400027F8(len+1)
  %dst = call i8* @sub_1400027F8(i64 %lenp1)
  ; store into array
  %r13_arr = bitcast i8* %vec to i8**
  %dst_e_ptr = getelementptr i8*, i8** %r13_arr, i64 %i64
  store i8* %dst, i8** %dst_e_ptr, align 8
  ; if dst == NULL -> error
  %dst_is_null = icmp eq i8* %dst, null
  br i1 %dst_is_null, label %error_gs8, label %do_copy

do_copy:
  ; sub_1400027B8(dst, src, len+1)
  call void @sub_1400027B8(i8* %dst, i8* %src_e, i64 %lenp1)
  ; i++
  %i.next = add i32 %i, 1
  br label %loop_head

write_term_and_commit:
  ; r13[cnt] = NULL
  %cnt64_for_term = sext i32 %cnt32 to i64
  %r13_arr2 = bitcast i8* %vec to i8**
  %term_ptr = getelementptr i8*, i8** %r13_arr2, i64 %cnt64_for_term
  store i8* null, i8** %term_ptr, align 8
  ; cs:qword_140007018 = r13
  store i8** %r13_arr2, i8*** @qword_140007018, align 8
  ; call sub_140002780(off_140004490, off_1400044A0)
  %p4490 = load i8*, i8** @off_140004490, align 8
  %p44A0 = load i8*, i8** @off_1400044A0, align 8
  call void @sub_140002780(i8* %p4490, i8* %p44A0)
  call void @sub_140001520()
  ; [rbp] = 2
  store i32 2, i32* %rbp_ptr, align 4
  br label %set_dword_7004_cont

error_gs8:
  call void @sub_140002670(i32 8)
  ; release lock if we acquired it (r14==0)
  %r14_is0_a = icmp eq i32 %r14_phi, 0
  br i1 %r14_is0_a, label %release_then_tail, label %tail

set_dword_7004:
  store i32 1, i32* @dword_140007004, align 4
  br label %set_dword_7004_cont

set_dword_7004_cont:
  ; if r14==0 -> release lock before tail
  %r14_is0 = icmp eq i32 %r14_phi, 0
  br i1 %r14_is0, label %release_then_tail, label %tail

release_then_tail:
  ; atomic xchg [rbx] <- 0
  %_old = atomicrmw xchg i8** %lock_ptrptr, i8* null seq_cst
  br label %tail

tail:
  ; rax <- *off_1400043F0; rax <- [rax]; if rax != 0 call rax(0,2,0)
  %pfpp = load i8**, i8*** @off_1400043F0, align 8
  %pf = load i8*, i8** %pfpp, align 8
  %pf_nz = icmp ne i8* %pf, null
  br i1 %pf_nz, label %call_pf, label %after_pf

call_pf:
  %pf_typed = bitcast i8* %pf to void (i32, i32, i64)*
  call void %pf_typed(i32 0, i32 2, i64 0)
  br label %after_pf

after_pf:
  ; rax <- sub_140002660(); [rax] = qword_140007010
  %ret2660 = call i8** @sub_140002660()
  %val7010 = load i8*, i8** @qword_140007010, align 8
  store i8* %val7010, i8** %ret2660, align 8
  ; ecx <- dword_140007020, rdx <- qword_140007018 ; call sub_140002880(ecx, rdx)
  %cnt_final = load i32, i32* @dword_140007020, align 4
  %arr_final = load i8**, i8*** @qword_140007018, align 8
  %arr_final_i8 = bitcast i8** %arr_final to i8*
  call void @sub_140002880(i32 %cnt_final, i8* %arr_final_i8)
  br label %epilogue

epilogue:
  ret void
}