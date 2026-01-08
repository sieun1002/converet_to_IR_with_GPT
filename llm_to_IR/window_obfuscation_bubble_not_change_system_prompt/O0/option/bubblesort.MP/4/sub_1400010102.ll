; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i64 @llvm.read_register.i64(metadata)

@off_140004470 = external global i8*
@qword_140008280 = external global i8*
@off_140004480 = external global i8*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140007010 = external global i8*
@qword_140007018 = external global i8*
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@qword_140008278 = external global i8*
@off_140004460 = external global i8*
@off_140004430 = external global i8*
@off_140004440 = external global i8*
@off_140004450 = external global i8*
@off_1400043C0 = external global i8*
@off_140004420 = external global i8*
@off_1400044F0 = external global i8*
@off_1400044D0 = external global i8*
@off_1400043A0 = external global i8*
@off_140004400 = external global i8*
@off_1400044C0 = external global i8*
@off_1400044B0 = external global i8*
@off_140004520 = external global i8*
@off_1400044E0 = external global i8*
@off_1400044A0 = external global i8*
@off_140004490 = external global i8*

declare void @sub_1400018D0()
declare void @sub_140002790(i8*)
declare void @sub_140002120()
declare i8* @sub_140002660()
declare i32 @sub_140002880(i32, i8*, i8*)
declare i32* @sub_140002778(i32)
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i32 @sub_140001540()
declare void @sub_140001CA0(i8*)
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i32*, i8**, i8**, i32, i32*)
declare i8* @sub_1400027F8(i64)
declare void @sub_1400027B8(i8*, i8*, i64)
declare i64 @sub_140002700(i8*)
declare i32 @sub_140002670(i32)
declare void @sub_140002750()
declare void @sub_1400027A0(i32)
declare void @sub_140002780(i8*, i8*)
declare void @sub_1400027D0(i32)

declare void @sub_140001600()
declare void @sub_140001CB0()
declare void @nullsub_1()
declare void @sub_140001520()

define dso_local i32 @sub_140001010() local_unnamed_addr {
entry:
  %retvar = alloca i32, align 4
  %local_var_4C = alloca i32, align 4

  %gsbase64 = call i64 @llvm.read_register.i64(metadata !"gsbase")
  %gsbase = inttoptr i64 %gsbase64 to i8*
  %teb_slot = getelementptr i8, i8* %gsbase, i64 48
  %teb_ptrptr = bitcast i8* %teb_slot to i8**
  %teb = load i8*, i8** %teb_ptrptr, align 8
  %owner_slot = getelementptr i8, i8* %teb, i64 8
  %owner_ptrptr = bitcast i8* %owner_slot to i8**
  %owner = load i8*, i8** %owner_ptrptr, align 8

  %off4470 = load i8*, i8** @off_140004470, align 8
  %lockptr = bitcast i8* %off4470 to i8**

  %q_8280 = load i8*, i8** @qword_140008280, align 8
  %sleep_fp = bitcast i8* %q_8280 to void (i32)*

  br label %lock_try

lock_try:
  %cmpx = cmpxchg i8** %lockptr, i8* null, i8* %owner monotonic monotonic
  %old = extractvalue { i8*, i1 } %cmpx, 0
  %succ = extractvalue { i8*, i1 } %cmpx, 1
  br i1 %succ, label %after_lock, label %lock_fail

lock_fail:
  %same = icmp eq i8* %old, %owner
  br i1 %same, label %after_lock_reentry, label %sleep_wait

sleep_wait:
  call void %sleep_fp(i32 1000)
  br label %lock_try

after_lock:
  br label %locked_join

after_lock_reentry:
  br label %locked_join

locked_join:
  %reentered = phi i1 [ false, %after_lock ], [ true, %after_lock_reentry ]

  %off4480 = load i8*, i8** @off_140004480, align 8
  %state_ptr = bitcast i8* %off4480 to i32*
  %state0 = load i32, i32* %state_ptr, align 4
  %is_one = icmp eq i32 %state0, 1
  br i1 %is_one, label %loc_3C8, label %check_zero

check_zero:
  %state1 = load i32, i32* %state_ptr, align 4
  %is_zero = icmp eq i32 %state1, 0
  br i1 %is_zero, label %loc_1110, label %loc_07A

loc_3C8:
  %t31 = call i32 @sub_140002670(i32 31)
  call void @sub_1400027A0(i32 %t31)
  br label %post_init_gate

loc_1110:
  store i32 1, i32* %state_ptr, align 4
  call void @sub_1400018D0()
  %fptr_cb = bitcast void ()* @sub_140001CB0 to i8*
  %q_8278 = load i8*, i8** @qword_140008278, align 8
  %fp_8278 = bitcast i8* %q_8278 to i8* (i8*)*
  %res_8278 = call i8* %fp_8278(i8* %fptr_cb)
  %off4460 = load i8*, i8** @off_140004460, align 8
  %dst4460 = bitcast i8* %off4460 to i8**
  store i8* %res_8278, i8** %dst4460, align 8
  %cb_nullsub = bitcast void ()* @nullsub_1 to i8*
  call void @sub_140002790(i8* %cb_nullsub)
  call void @sub_140002120()

  %off4430 = load i8*, i8** @off_140004430, align 8
  %d4430 = bitcast i8* %off4430 to i32*
  store i32 1, i32* %d4430, align 4

  %off4440 = load i8*, i8** @off_140004440, align 8
  %d4440 = bitcast i8* %off4440 to i32*
  store i32 1, i32* %d4440, align 4

  %off4450 = load i8*, i8** @off_140004450, align 8
  %d4450 = bitcast i8* %off4450 to i32*
  store i32 1, i32* %d4450, align 4

  %base = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_check, label %after_pe

pe_check:
  %pe_ofs_ptr = getelementptr i8, i8* %base, i64 60
  %pe_ofs_iptr = bitcast i8* %pe_ofs_ptr to i32*
  %pe_ofs = load i32, i32* %pe_ofs_iptr, align 4
  %pe_ofs64 = sext i32 %pe_ofs to i64
  %nthdr = getelementptr i8, i8* %base, i64 %pe_ofs64
  %pe_sig_ptr = bitcast i8* %nthdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %opt_magic, label %after_pe

opt_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nthdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %is_10b = icmp eq i16 %magic, 267
  br i1 %is_10b, label %pe32, label %check_pe32plus

check_pe32plus:
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %pe32plus, label %after_pe

pe32:
  %size_cfg_ptr32_i8 = getelementptr i8, i8* %nthdr, i64 116
  %size_cfg_ptr32 = bitcast i8* %size_cfg_ptr32_i8 to i32*
  %size_cfg32 = load i32, i32* %size_cfg_ptr32, align 4
  %gt32 = icmp ugt i32 %size_cfg32, 14
  br i1 %gt32, label %load_cfg32, label %after_pe

load_cfg32:
  %cfg_flag_ptr32_i8 = getelementptr i8, i8* %nthdr, i64 232
  %cfg_flag_ptr32 = bitcast i8* %cfg_flag_ptr32_i8 to i32*
  %cfg_flag32 = load i32, i32* %cfg_flag_ptr32, align 4
  %nz32 = icmp ne i32 %cfg_flag32, 0
  %ecx32 = zext i1 %nz32 to i32
  br label %set_cfg

pe32plus:
  %size_cfg_ptr64_i8 = getelementptr i8, i8* %nthdr, i64 132
  %size_cfg_ptr64 = bitcast i8* %size_cfg_ptr64_i8 to i32*
  %size_cfg64 = load i32, i32* %size_cfg_ptr64, align 4
  %gt64 = icmp ugt i32 %size_cfg64, 14
  br i1 %gt64, label %load_cfg64, label %after_pe

load_cfg64:
  %cfg_flag_ptr64_i8 = getelementptr i8, i8* %nthdr, i64 248
  %cfg_flag_ptr64 = bitcast i8* %cfg_flag_ptr64_i8 to i32*
  %cfg_flag64 = load i32, i32* %cfg_flag_ptr64, align 4
  %nz64 = icmp ne i32 %cfg_flag64, 0
  %ecx64 = zext i1 %nz64 to i32
  br label %set_cfg

after_pe:
  %ecx_pe = phi i32 [ 0, %loc_1110 ], [ 0, %pe_check ], [ 0, %check_pe32plus ], [ 0, %pe32 ], [ 0, %pe32plus ]
  br label %cfg_store

set_cfg:
  %ecx_cfg = phi i32 [ %ecx32, %load_cfg32 ], [ %ecx64, %load_cfg64 ]
  br label %cfg_store

cfg_store:
  %ecx_final = phi i32 [ %ecx_pe, %after_pe ], [ %ecx_cfg, %set_cfg ]
  %off4420 = load i8*, i8** @off_140004420, align 8
  store i32 %ecx_final, i32* @dword_140007008, align 4
  %d4420 = bitcast i8* %off4420 to i32*
  %val4420 = load i32, i32* %d4420, align 4
  %nz4420 = icmp ne i32 %val4420, 0
  br i1 %nz4420, label %loc_1338, label %loc_1D9

loc_1338:
  %p778_2 = call i32* @sub_140002778(i32 2)
  br label %loc_1E3

loc_1D9:
  %p778_1 = call i32* @sub_140002778(i32 1)
  br label %loc_1E3

loc_1E3:
  %p720 = call i32* @sub_140002720()
  %off44F0 = load i8*, i8** @off_1400044F0, align 8
  %d44F0 = bitcast i8* %off44F0 to i32*
  %val44F0 = load i32, i32* %d44F0, align 4
  store i32 %val44F0, i32* %p720, align 4
  %p718 = call i32* @sub_140002718()
  %off44D0 = load i8*, i8** @off_1400044D0, align 8
  %d44D0 = bitcast i8* %off44D0 to i32*
  %val44D0 = load i32, i32* %d44D0, align 4
  store i32 %val44D0, i32* %p718, align 4

  %st = call i32 @sub_140001540()
  %isneg = icmp slt i32 %st, 0
  br i1 %isneg, label %loc_1301, label %cont_after_1208

loc_1301:
  %t8 = call i32 @sub_140002670(i32 8)
  store i32 %t8, i32* %retvar, align 4
  call void @sub_140002750()
  %r_final = load i32, i32* %retvar, align 4
  ret i32 %r_final

cont_after_1208:
  %off43A0 = load i8*, i8** @off_1400043A0, align 8
  %d43A0 = bitcast i8* %off43A0 to i32*
  %v43A0 = load i32, i32* %d43A0, align 4
  %is1 = icmp eq i32 %v43A0, 1
  br i1 %is1, label %loc_1399, label %check_400

loc_1399:
  %fp600 = bitcast void ()* @sub_140001600 to i8*
  call void @sub_140001CA0(i8* %fp600)
  br label %check_400

check_400:
  %off4400 = load i8*, i8** @off_140004400, align 8
  %d4400 = bitcast i8* %off4400 to i32*
  %v4400 = load i32, i32* %d4400, align 4
  %isFFFF = icmp eq i32 %v4400, -1
  br i1 %isFFFF, label %loc_138A, label %loc_1230

loc_138A:
  call void @sub_1400027D0(i32 -1)
  br label %loc_1230

loc_1230:
  %c4B0 = load i8*, i8** @off_1400044B0, align 8
  %c4C0 = load i8*, i8** @off_1400044C0, align 8
  %r_2788 = call i32 @sub_140002788(i8* %c4B0, i8* %c4C0)
  %nz_2788 = icmp ne i32 %r_2788, 0
  br i1 %nz_2788, label %loc_1380, label %loc_124B

loc_1380:
  ret i32 255

loc_124B:
  %off4520 = load i8*, i8** @off_140004520, align 8
  %d4520 = bitcast i8* %off4520 to i32*
  %v4520 = load i32, i32* %d4520, align 4
  store i32 %v4520, i32* %local_var_4C, align 4
  %off44E0 = load i8*, i8** @off_1400044E0, align 8
  %d44E0 = bitcast i8* %off44E0 to i32*
  %v44E0 = load i32, i32* %d44E0, align 4
  %cnt_ptr = bitcast i32* @dword_140007020 to i32*
  %arr_ptrptr = bitcast i8** @qword_140007018 to i8**
  %item_ptrptr = bitcast i8** @qword_140007010 to i8**
  %r_26A0 = call i32 @sub_1400026A0(i32* %cnt_ptr, i8** %arr_ptrptr, i8** %item_ptrptr, i32 %v44E0, i32* %local_var_4C)
  %isneg_26A0 = icmp slt i32 %r_26A0, 0
  br i1 %isneg_26A0, label %loc_1301, label %after_26A0

after_26A0:
  %cnt = load i32, i32* @dword_140007020, align 4
  %cnt64 = sext i32 %cnt to i64
  %cntp1 = add i64 %cnt64, 1
  %bytes = shl i64 %cntp1, 3
  %newarr = call i8* @sub_1400027F8(i64 %bytes)
  %null_new = icmp eq i8* %newarr, null
  br i1 %null_new, label %loc_1301, label %maybe_loop

maybe_loop:
  %gt0 = icmp sgt i32 %cnt, 0
  br i1 %gt0, label %loop_init, label %after_loop

loop_init:
  %oldarr = load i8*, i8** @qword_140007018, align 8
  br label %loop_header

loop_header:
  %i = phi i64 [ 1, %loop_init ], [ %i.next, %loop_body ]
  %elem_off = add i64 %i, -1
  %scale_old = mul i64 %elem_off, 8
  %old_elem_ptr_i8 = getelementptr i8, i8* %oldarr, i64 %scale_old
  %old_elem_qpp = bitcast i8* %old_elem_ptr_i8 to i8**
  %old_elem = load i8*, i8** %old_elem_qpp, align 8
  %len = call i64 @sub_140002700(i8* %old_elem)
  %len1 = add i64 %len, 1
  %buf = call i8* @sub_1400027F8(i64 %len1)
  %scale_dst = mul i64 %elem_off, 8
  %dst_slot_i8 = getelementptr i8, i8* %newarr, i64 %scale_dst
  %dst_slot = bitcast i8* %dst_slot_i8 to i8**
  store i8* %buf, i8** %dst_slot, align 8
  %okbuf = icmp ne i8* %buf, null
  br i1 %okbuf, label %loop_body, label %loc_1301

loop_body:
  %old_elem2 = phi i8* [ %old_elem, %loop_header ]
  %buf2 = phi i8* [ %buf, %loop_header ]
  call void @sub_1400027B8(i8* %buf2, i8* %old_elem2, i64 %len1)
  %i64 = sext i32 %cnt to i64
  %is_last = icmp eq i64 %i, %i64
  br i1 %is_last, label %after_loop, label %incr

incr:
  %i.next = add i64 %i, 1
  br label %loop_header

after_loop:
  %scale_tail = mul i64 %cnt64, 8
  %tail_slot_i8 = getelementptr i8, i8* %newarr, i64 %scale_tail
  %tail_slot = bitcast i8* %tail_slot_i8 to i8**
  store i8* null, i8** %tail_slot, align 8
  %off44A0 = load i8*, i8** @off_1400044A0, align 8
  %off4490 = load i8*, i8** @off_140004490, align 8
  store i8* %newarr, i8** @qword_140007018, align 8
  call void @sub_140002780(i8* %off4490, i8* %off44A0)
  call void @sub_140001520()
  store i32 2, i32* %state_ptr, align 4
  br label %post_init_gate

loc_07A:
  store i32 1, i32* @dword_140007004, align 4
  br label %post_init_gate

post_init_gate:
  %r14flag = phi i1 [ %reentered, %loc_3C8 ], [ %reentered, %after_loop ], [ %reentered, %loc_07A ]
  %need_release = icmp eq i1 %r14flag, false
  br i1 %need_release, label %release_lock, label %after_release

release_lock:
  %xchg_old = atomicrmw xchg i8** %lockptr, i8* null monotonic
  br label %after_release

after_release:
  %off43F0 = load i8*, i8** @off_1400043F0, align 8
  %pFptr = bitcast i8* %off43F0 to i8**
  %faddr = load i8*, i8** %pFptr, align 8
  %hasf = icmp ne i8* %faddr, null
  br i1 %hasf, label %call_f_43F0, label %after_f_43F0

call_f_43F0:
  %fp_43F0 = bitcast i8* %faddr to void (i32, i32, i32)*
  call void %fp_43F0(i32 0, i32 2, i32 0)
  br label %after_f_43F0

after_f_43F0:
  %pbuf = call i8* @sub_140002660()
  %pbuf_q = bitcast i8* %pbuf to i8**
  %v7010 = load i8*, i8** @qword_140007010, align 8
  store i8* %v7010, i8** %pbuf_q, align 8
  %v7020 = load i32, i32* @dword_140007020, align 4
  %v7018 = load i8*, i8** @qword_140007018, align 8
  %r_2880 = call i32 @sub_140002880(i32 %v7020, i8* %v7018, i8* %v7010)
  %ecx_flag = load i32, i32* @dword_140007008, align 4
  %is_zero_ecx = icmp eq i32 %ecx_flag, 0
  br i1 %is_zero_ecx, label %loc_13D2, label %check_d7004

loc_13D2:
  call void @sub_1400027A0(i32 %r_2880)
  store i32 %r_2880, i32* %retvar, align 4
  br label %epilogue

check_d7004:
  %v7004 = load i32, i32* @dword_140007004, align 4
  %is_zero_d7004 = icmp eq i32 %v7004, 0
  br i1 %is_zero_d7004, label %loc_1310, label %epilogue_fast

loc_1310:
  store i32 %r_2880, i32* %retvar, align 4
  call void @sub_140002750()
  br label %epilogue

epilogue_fast:
  store i32 %r_2880, i32* %retvar, align 4
  br label %epilogue

epilogue:
  %rv = load i32, i32* %retvar, align 4
  ret i32 %rv
}