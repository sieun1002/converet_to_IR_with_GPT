; ModuleID = 'sub_140001010'
target triple = "x86_64-pc-windows-msvc"

@off_140004470 = external global i64*
@qword_140008280 = external global i8*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8**
@qword_140007010 = external global i64
@dword_140007020 = external global i32
@qword_140007018 = external global i64
@dword_140007008 = external global i32
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@off_140004420 = external global i32*
@off_140004460 = external global i8**
@off_140004490 = external global i8*
@off_1400044A0 = external global i8*

declare void @sub_1400018D0()
declare i8* @sub_140504827(i8*)
declare void @sub_140002120()
declare void @sub_140002790(i8*)
declare i8* @sub_140002660()
declare void @sub_140002880(...)
declare i8* @sub_140002778(i32)
declare i8* @sub_140002700(i8*)
declare i8* @sub_1400027F8(i64)
declare i32 @sub_140002670(i32)
declare void @sub_140002780(i8*, i8*)
declare void @sub_140001520()
declare void @sub_1400027A0(i32)
declare void @"loc_14000274D+3"()
declare void @"loc_1400027B5+3"(...)

declare void @sub_140001CB0()
declare void @nullsub_1()

define void @sub_140001010() {
entry:
  %rsiVal = call i64 asm sideeffect "mov eax, 0x30; mov rax, qword ptr gs:[rax]; mov rax, qword ptr [rax+8]", "={rax},~{dirflag},~{fpsr},~{flags}"()
  %lockptr = load i64*, i64** @off_140004470, align 8
  %sleep_raw = load i8*, i8** @qword_140008280, align 8
  %sleep_fn = bitcast i8* %sleep_raw to void (i32)*
  br label %cmpxchg_try

cmpxchg_try:
  %cx = cmpxchg i64* %lockptr, i64 0, i64 %rsiVal seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cx, 0
  %ok = extractvalue { i64, i1 } %cx, 1
  br i1 %ok, label %acquired, label %retry

retry:
  %eq = icmp eq i64 %old, %rsiVal
  br i1 %eq, label %owned, label %sleep

sleep:
  call void %sleep_fn(i32 1000)
  br label %cmpxchg_try

acquired:
  br label %after_lock

owned:
  br label %after_lock

after_lock:
  %r14d = phi i32 [ 0, %acquired ], [ 1, %owned ]
  %rbp_ptr = load i32*, i32** @off_140004480, align 8
  %st0 = load i32, i32* %rbp_ptr, align 4
  %is1 = icmp eq i32 %st0, 1
  br i1 %is1, label %bb_13c8, label %bb_check0

bb_check0:
  %st1 = load i32, i32* %rbp_ptr, align 4
  %is0 = icmp eq i32 %st1, 0
  br i1 %is0, label %bb_1110, label %bb_setflag

bb_setflag:
  store i32 1, i32* @dword_140007004, align 4
  %r14_is_zero = icmp eq i32 %r14d, 0
  br i1 %r14_is_zero, label %bb_1328, label %bb_108d

bb_1328:
  %oldx = atomicrmw xchg i64* %lockptr, i64 0 seq_cst
  br label %bb_108d

bb_108d:
  %pfnptrptr = load i8**, i8*** @off_1400043F0, align 8
  %pfnptr = load i8*, i8** %pfnptrptr, align 8
  %isnull = icmp eq i8* %pfnptr, null
  br i1 %isnull, label %bb_after_pfn, label %bb_call_pfn

bb_call_pfn:
  %pfn_cast = bitcast i8* %pfnptr to void (i32, i32, i64)*
  call void %pfn_cast(i32 0, i32 2, i64 0)
  br label %bb_after_pfn

bb_after_pfn:
  %p = call i8* @sub_140002660()
  %qv = load i64, i64* @qword_140007010, align 8
  %p64 = bitcast i8* %p to i64*
  store i64 %qv, i64* %p64, align 8
  %rcxv = load i32, i32* @dword_140007020, align 4
  %rdxv = load i64, i64* @qword_140007018, align 8
  call void @sub_140002880(i32 %rcxv, i64 %rdxv)
  %ecxv = load i32, i32* @dword_140007008, align 4
  %ecx_is_zero = icmp eq i32 %ecxv, 0
  br i1 %ecx_is_zero, label %bb_13d2, label %bb_10d7

bb_10d7:
  %edxv = load i32, i32* @dword_140007004, align 4
  %edx_is_zero = icmp eq i32 %edxv, 0
  br i1 %edx_is_zero, label %bb_1310, label %epilogue

bb_1310:
  call void @"loc_14000274D+3"()
  br label %epilogue

bb_1110:
  store i32 1, i32* %rbp_ptr, align 4
  call void @sub_1400018D0()
  %cb = bitcast void ()* @sub_140001CB0 to i8*
  %h = call i8* @sub_140504827(i8* %cb)
  %pstore = load i8**, i8*** @off_140004460, align 8
  store i8* %h, i8** %pstore, align 8
  %nullcb = bitcast void ()* @nullsub_1 to i8*
  call void @sub_140002790(i8* %nullcb)
  call void @sub_140002120()
  %p1 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p1, align 4
  %p2 = load i32*, i32** @off_140004440, align 8
  store i32 1, i32* %p2, align 4
  %p3 = load i32*, i32** @off_140004450, align 8
  store i32 1, i32* %p3, align 4
  %img = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %img to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %bb_pechk, label %bb_zero

bb_pechk:
  %e_lfanew_ptr = getelementptr i8, i8* %img, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %img, i64 %e_lfanew_sext
  %sigptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %bb_optmagic, label %bb_zero

bb_optmagic:
  %optmag_ptr = getelementptr i8, i8* %pehdr, i64 24
  %optmag_u16ptr = bitcast i8* %optmag_ptr to i16*
  %optmag = load i16, i16* %optmag_u16ptr, align 2
  %is_pe32 = icmp eq i16 %optmag, 267
  br i1 %is_pe32, label %bb_13aa, label %bb_check_peplus

bb_check_peplus:
  %is_pe64 = icmp eq i16 %optmag, 523
  br i1 %is_pe64, label %bb_peplus_path, label %bb_zero

bb_peplus_path:
  %off84 = getelementptr i8, i8* %pehdr, i64 132
  %u32off84ptr = bitcast i8* %off84 to i32*
  %u32off84 = load i32, i32* %u32off84ptr, align 4
  %gt = icmp ugt i32 %u32off84, 14
  br i1 %gt, label %bb_peplus_flag, label %bb_zero

bb_peplus_flag:
  %offF8 = getelementptr i8, i8* %pehdr, i64 248
  %u32offF8ptr = bitcast i8* %offF8 to i32*
  %u32offF8 = load i32, i32* %u32offF8ptr, align 4
  %nz_peplus = icmp ne i32 %u32offF8, 0
  %ecx_from_pe = zext i1 %nz_peplus to i32
  br label %bb_1c0_store

bb_13aa:
  %off74 = getelementptr i8, i8* %pehdr, i64 116
  %u32off74ptr = bitcast i8* %off74 to i32*
  %u32off74 = load i32, i32* %u32off74ptr, align 4
  %gt2 = icmp ugt i32 %u32off74, 14
  br i1 %gt2, label %bb_pe32_flag, label %bb_zero

bb_pe32_flag:
  %offE8 = getelementptr i8, i8* %pehdr, i64 232
  %u32offE8ptr = bitcast i8* %offE8 to i32*
  %u32offE8 = load i32, i32* %u32offE8ptr, align 4
  %nz_pe32 = icmp ne i32 %u32offE8, 0
  %ecx_from_pe32 = zext i1 %nz_pe32 to i32
  br label %bb_1c0_store

bb_zero:
  br label %bb_1c0_store

bb_1c0_store:
  %ecx_final = phi i32 [ %ecx_from_pe, %bb_peplus_flag ], [ %ecx_from_pe32, %bb_pe32_flag ], [ 0, %bb_zero ]
  %pflags = load i32*, i32** @off_140004420, align 8
  store i32 %ecx_final, i32* @dword_140007008, align 4
  %r8d_val = load i32, i32* %pflags, align 4
  %r8d_nz = icmp ne i32 %r8d_val, 0
  br i1 %r8d_nz, label %bb_1338, label %bb_11d9

bb_11d9:
  %ctx1 = call i8* @sub_140002778(i32 1)
  br label %bb_unreach_tail

bb_1338:
  %ctx2 = call i8* @sub_140002778(i32 2)
  br label %bb_unreach_tail

bb_unreach_tail:
  unreachable

bb_13c8:
  %retcode = call i32 @sub_140002670(i32 31)
  br label %bb_13d2

bb_13d2:
  %retcode_phi = phi i32 [ %retcode, %bb_13c8 ], [ 0, %bb_after_pfn ]
  call void @sub_1400027A0(i32 %retcode_phi)
  br label %epilogue

epilogue:
  ret void
}