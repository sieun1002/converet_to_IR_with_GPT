; ModuleID = 'sub_140001010_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002670(i32)
declare i8** @sub_140002660()
declare void @sub_1400018D0()
declare i8* @sub_14000AA1D(i8*)
declare void @sub_140002790(i8*)
declare void @sub_140002120()
declare void @sub_140002880(i32, i8*, i8*)
declare void @sub_140002720()
declare void @"loc_140002775+3"(i32)
declare void @nullsub_1()
declare void @sub_140001CB0()

@off_140004470 = external global i8*
@qword_140008280 = external global void (i32)*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8*
@off_140004460 = external global i8*
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@off_140004420 = external global i32*
@dword_140007008 = external global i32

define void @sub_140001010() {
entry:
  ; rsi := qword ptr gs:[0x38]
  %owner_i64 = call i64 asm sideeffect inteldialect "mov $0, qword ptr gs:[0x38]", "=r"()
  %owner = inttoptr i64 %owner_i64 to i8*
  ; rbx := [off_140004470] (address of lock), rdi := [qword_140008280] (function ptr)
  %lock_addr_ptr = load i8*, i8** @off_140004470
  %lock_ptr = bitcast i8* %lock_addr_ptr to i8**
  %sleep_ptr = load void (i32)*, void (i32)** @qword_140008280
  br label %try_cmpxchg

try_cmpxchg:                                      ; 0x140001050
  %cmpres = cmpxchg i8** %lock_ptr, i8* null, i8* %owner seq_cst seq_cst
  %old = extractvalue { i8*, i1 } %cmpres, 0
  %success = extractvalue { i8*, i1 } %cmpres, 1
  br i1 %success, label %got_lock_init, label %cmp_fail

cmp_fail:                                         ; 0x140001040
  %is_owner = icmp eq i8* %old, %owner
  br i1 %is_owner, label %set_r14_one, label %sleep_then_retry

set_r14_one:                                      ; 0x140001100
  br label %got_lock

sleep_then_retry:
  call void %sleep_ptr(i32 1000)
  br label %try_cmpxchg

got_lock_init:
  br label %got_lock

got_lock:                                         ; 0x14000105C
  %r14_flag = phi i1 [ false, %got_lock_init ], [ true, %set_r14_one ]
  %status_addr = load i32*, i32** @off_140004480
  %status = load i32, i32* %status_addr, align 4
  %is_one = icmp eq i32 %status, 1
  br i1 %is_one, label %call_2670_1F, label %check_zero

call_2670_1F:                                     ; 0x1400013C8 path target
  call void @sub_140002670(i32 31)
  ret void

check_zero:
  %status2 = load i32, i32* %status_addr, align 4
  %is_zero = icmp eq i32 %status2, 0
  br i1 %is_zero, label %block_110, label %after_07a

block_110:                                        ; 0x140001110
  store i32 1, i32* %status_addr, align 4
  call void @sub_1400018D0()
  %cb_ptr = bitcast void ()* @sub_140001CB0 to i8*
  %ret_aa1d = call i8* @sub_14000AA1D(i8* %cb_ptr)
  %rdx_addr_ptr = load i8*, i8** @off_140004460
  %rdx_addr_pptr = bitcast i8* %rdx_addr_ptr to i8**
  store i8* %ret_aa1d, i8** %rdx_addr_pptr, align 8
  %null_ptr = bitcast void ()* @nullsub_1 to i8*
  call void @sub_140002790(i8* %null_ptr)
  call void @sub_140002120()
  %p430 = load i32*, i32** @off_140004430
  store i32 1, i32* %p430, align 4
  %p440 = load i32*, i32** @off_140004440
  store i32 1, i32* %p440, align 4
  %p450 = load i32*, i32** @off_140004450
  store i32 1, i32* %p450, align 4
  br label %pe_check

after_07a:                                        ; 0x14000107A onward
  store i32 1, i32* @dword_140007004, align 4
  %r14_is_zero = icmp eq i1 %r14_flag, false
  br i1 %r14_is_zero, label %release_then_continue, label %cont_08D

release_then_continue:                            ; 0x140001328
  %unused = atomicrmw xchg i8** %lock_ptr, i8* null seq_cst
  br label %cont_08D

cont_08D:                                         ; 0x14000108D
  %p1 = load i8*, i8** @off_1400043F0
  %fpaddrptr = bitcast i8* %p1 to i8**
  %fpptr = load i8*, i8** %fpaddrptr
  %has_fp = icmp ne i8* %fpptr, null
  br i1 %has_fp, label %call_fp, label %after_call_fp

call_fp:
  %fp_typed = bitcast i8* %fpptr to void (i32, i32, i32)*
  call void %fp_typed(i32 0, i32 2, i32 0)
  br label %after_call_fp

after_call_fp:
  %pout = call i8** @sub_140002660()
  %r8val = load i8*, i8** @qword_140007010
  %ecxval = load i32, i32* @dword_140007020
  store i8* %r8val, i8** %pout, align 8
  %rdxval = load i8*, i8** @qword_140007018
  call void @sub_140002880(i32 %ecxval, i8* %rdxval, i8* %r8val)
  br label %pe_check

pe_check:
  %image_base = load i8*, i8** @off_1400043C0
  %mzptr = bitcast i8* %image_base to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %have_mz, label %after_pe_flag

have_mz:
  %ptr_3c = getelementptr i8, i8* %image_base, i32 60
  %nt_off32_ptr = bitcast i8* %ptr_3c to i32*
  %nt_off32 = load i32, i32* %nt_off32_ptr, align 4
  %nt_off64 = sext i32 %nt_off32 to i64
  %nt_hdr_ptr = getelementptr i8, i8* %image_base, i64 %nt_off64
  %pe_sig_ptr = bitcast i8* %nt_hdr_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %opt_magic, label %after_pe_flag

opt_magic:
  %opt_magic_ptr = getelementptr i8, i8* %nt_hdr_ptr, i32 24
  %opt_magic_p16 = bitcast i8* %opt_magic_ptr to i16*
  %dx = load i16, i16* %opt_magic_p16, align 2
  %is_10b = icmp eq i16 %dx, 267
  br i1 %is_10b, label %path_3aa, label %check_20b

check_20b:
  %is_20b = icmp eq i16 %dx, 523
  br i1 %is_20b, label %pe32plus, label %after_pe_flag

pe32plus:
  %off84 = getelementptr i8, i8* %nt_hdr_ptr, i32 132
  %p84 = bitcast i8* %off84 to i32*
  %val84 = load i32, i32* %p84, align 4
  %cond = icmp ugt i32 %val84, 14
  br i1 %cond, label %r9d_path, label %after_pe_flag

r9d_path:
  %offF8 = getelementptr i8, i8* %nt_hdr_ptr, i32 248
  %pF8 = bitcast i8* %offF8 to i32*
  %r9d = load i32, i32* %pF8, align 4
  %ecx_bool = icmp ne i32 %r9d, 0
  br label %after_pe_calc

path_3aa:                                         ; 0x1400013AA
  %off74 = getelementptr i8, i8* %nt_hdr_ptr, i32 116
  %p74 = bitcast i8* %off74 to i32*
  %v74 = load i32, i32* %p74, align 4
  %cond2 = icmp ugt i32 %v74, 14
  br i1 %cond2, label %r10d_path, label %after_pe_flag

r10d_path:
  %offE8 = getelementptr i8, i8* %nt_hdr_ptr, i32 232
  %pE8 = bitcast i8* %offE8 to i32*
  %r10d = load i32, i32* %pE8, align 4
  %ecx_bool2 = icmp ne i32 %r10d, 0
  br label %after_pe_calc

after_pe_flag:
  br label %store_ecx

after_pe_calc:
  %ecx_final = phi i1 [ %ecx_bool, %r9d_path ], [ %ecx_bool2, %r10d_path ]
  br label %store_ecx

store_ecx:
  %ecx_flag = phi i1 [ false, %after_pe_flag ], [ %ecx_final, %after_pe_calc ]
  %val_i32 = zext i1 %ecx_flag to i32
  store i32 %val_i32, i32* @dword_140007008, align 4
  %conf_ptr = load i32*, i32** @off_140004420
  %r8d = load i32, i32* %conf_ptr, align 4
  %has_conf = icmp ne i32 %r8d, 0
  br i1 %has_conf, label %L_1338, label %L_1DE

L_1DE:                                            ; 0x1400011D9/1DE path
  call void @"loc_140002775+3"(i32 1)
  call void @sub_140002720()
  ret void

L_1338:                                           ; 0x140001338
  call void @"loc_140002775+3"(i32 2)
  call void @sub_140002720()
  ret void
}