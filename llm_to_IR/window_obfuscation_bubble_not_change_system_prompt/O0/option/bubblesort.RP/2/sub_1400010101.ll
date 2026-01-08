; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002660()
declare i32 @sub_140002880(i32, i8**, i8*)
declare i32 @sub_140002670(i32)
declare void @sub_1400018D0()
declare i32 @TopLevelExceptionFilter(i8*)
declare i8* @_set_invalid_parameter_handler(i8*)
declare void @sub_140002120()
declare void @_set_app_type(i32)
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @sub_140001540()
declare void @sub_140001CA0(i8*)
declare void @sub_140001600()
declare i32 @_configthreadlocale(i32)
declare i32 @_initterm_e(i8**, i8**)
declare void @_initterm(i8**, i8**)
declare i8* @malloc(i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i64 @strlen(i8*)
declare void @sub_140001520()
declare void @_cexit()
declare void @exit(i32)

@off_140004470 = external global i64*
@__imp_Sleep = external global void (i32)*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8**
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8**
@dword_140007008 = external global i32
@__imp_SetUnhandledExceptionFilter = external global i8* (i8*)*
@off_140004460 = external global i8**
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@off_140004420 = external global i32*
@off_1400044F0 = external global i32*
@off_1400044D0 = external global i32*
@off_1400043A0 = external global i32*
@off_140004400 = external global i32*
@Last = external global i8**
@First = external global i8**
@off_140004520 = external global i32*
@off_1400044E0 = external global i32*
@off_1400044A0 = external global i8**
@off_140004490 = external global i8**

define i32 @sub_140001010() {
entry:
  ; allocate locals corresponding to stack temps
  %var_4C = alloca i32, align 4
  %var_5C = alloca i32, align 4

  ; emulate "rsi" thread token with a stable, nonzero value derived from an existing symbol
  %token = ptrtoint (i64** @off_140004470 to i64)

  ; load lock address and Sleep IAT
  %lock.ptr.ptr = load i64*, i64** @off_140004470
  %sleep.fp = load void (i32)*, void (i32)** @__imp_Sleep

  br label %acquire

acquire:
  ; cmpxchg [lock], 0 -> token
  %cmpxchg = cmpxchg i64* %lock.ptr.ptr, i64 0, i64 %token seq_cst
  %old.owner = extractvalue { i64, i1 } %cmpxchg, 0
  %success = extractvalue { i64, i1 } %cmpxchg, 1
  br i1 %success, label %locked, label %cmp_failed

cmp_failed:
  ; if same owner (recursive), set r14d=1 and continue; else Sleep(1000) and retry
  %is_same = icmp eq i64 %old.owner, %token
  br i1 %is_same, label %recursive_owner, label %sleep_and_retry

sleep_and_retry:
  call void %sleep.fp(i32 noundef 1000)
  br label %acquire

recursive_owner:
  ; r14d = 1
  br label %post_lock

locked:
  ; r14d = 0
  br label %post_lock

post_lock:
  ; r14 flag phi: true if recursive owner path, false if freshly acquired
  %r14_flag = phi i1 [ true, %recursive_owner ], [ false, %locked ]

  ; rbp = *off_140004480 (state pointer)
  %state.ptr = load i32*, i32** @off_140004480
  ; if (*state == 1) -> call sub_140002670(0x1F) then exit with its result
  %state.val0 = load i32, i32* %state.ptr
  %is_one = icmp eq i32 %state.val0, 1
  br i1 %is_one, label %blk_13c8, label %check_state_zero

blk_13c8:
  %ret_1f = call i32 @sub_140002670(i32 noundef 31)
  br label %blk_13d2

check_state_zero:
  ; if (*state == 0) -> initialization path
  %state.val1 = load i32, i32* %state.ptr
  %is_zero = icmp eq i32 %state.val1, 0
  br i1 %is_zero, label %blk_1110, label %after_state_init

blk_1110:
  ; *state = 1
  store i32 1, i32* %state.ptr
  call void @sub_1400018D0()
  ; SetUnhandledExceptionFilter(TopLevelExceptionFilter)
  %pSetUEF = load i8* (i8*)*, i8* (i8*)** @__imp_SetUnhandledExceptionFilter
  %filter.ptr = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prev.filter = call i8* %pSetUEF(i8* noundef %filter.ptr)
  ; *off_140004460 = prev.filter
  %prev.store.ptr = load i8**, i8*** @off_140004460
  store i8* %prev.filter, i8** %prev.store.ptr
  ; _set_invalid_parameter_handler(Handler)
  %handler.ptr = bitcast void (...)* @sub_140001600 to i8*
  ; The actual invalid parameter handler is 'Handler'; use its address
  %handler.addr = bitcast void (...)* @sub_140001600 to i8*
  call i8* @_set_invalid_parameter_handler(i8* noundef %handler.addr)
  call void @sub_140002120()

  ; *(*off_140004430) = 1
  %pA = load i32*, i32** @off_140004430
  store i32 1, i32* %pA
  ; *(*off_140004440) = 1
  %pB = load i32*, i32** @off_140004440
  store i32 1, i32* %pB
  ; *(*off_140004450) = 1
  %pC = load i32*, i32** @off_140004450
  store i32 1, i32* %pC

  ; PE header checks, initialize ecx = 0
  %ecx_init = add i32 0, 0
  ; base = *off_1400043C0
  %base = load i8*, i8** @off_1400043C0
  ; if (*(u16*)base != 0x5A4D) goto set_flag_and_after
  %mz.ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz.ptr
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %after_pe_checks

check_pe:
  ; nt = base + *(i32*)(base+0x3C)
  %e_lfanew.ptr = getelementptr i8, i8* %base, i64 60
  %e_lfanew.p32 = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.p32
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew.sext
  ; if (*(u32*)nt != 0x00004550) goto after_pe_checks
  %pe.sig.ptr = bitcast i8* %nt to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %opt_hdr, label %after_pe_checks

opt_hdr:
  ; magic = *(u16*)(nt+0x18)
  %magic.ptr = getelementptr i8, i8* %nt, i64 24
  %magic.p16 = bitcast i8* %magic.ptr to i16*
  %magic = load i16, i16* %magic.p16
  %is_pe32 = icmp eq i16 %magic, 267
  br i1 %is_pe32, label %pe32_path, label %check_pe32plus

check_pe32plus:
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %pe32plus_path, label %after_pe_checks

pe32_path:
  ; if (*(u32*)(nt+0x74) <= 0x0E) goto after_pe_checks
  %size.opt.pe32.ptr = getelementptr i8, i8* %nt, i64 116
  %size.opt.pe32.p32 = bitcast i8* %size.opt.pe32.ptr to i32*
  %size.opt.pe32 = load i32, i32* %size.opt.pe32.p32
  %jbe = icmp ule i32 %size.opt.pe32, 14
  br i1 %jbe, label %after_pe_checks, label %pe32_has_flag

pe32_has_flag:
  ; r10d = *(u32*)(nt+0xE8)
  %nx.ptr.pe32 = getelementptr i8, i8* %nt, i64 232
  %nx.p32.pe32 = bitcast i8* %nx.ptr.pe32 to i32*
  %nx.val.pe32 = load i32, i32* %nx.p32.pe32
  %nz.pe32 = icmp ne i32 %nx.val.pe32, 0
  %ecx_from_pe32 = zext i1 %nz.pe32 to i32
  br label %after_pe_checks

pe32plus_path:
  ; if (*(u32*)(nt+0x84) <= 0x0E) goto after_pe_checks
  %size.opt.pe32p.ptr = getelementptr i8, i8* %nt, i64 132
  %size.opt.pe32p.p32 = bitcast i8* %size.opt.pe32p.ptr to i32*
  %size.opt.pe32p = load i32, i32* %size.opt.pe32p.p32
  %jbe2 = icmp ule i32 %size.opt.pe32p, 14
  br i1 %jbe2, label %after_pe_checks, label %pe32p_has_flag

pe32p_has_flag:
  ; r9d = *(u32*)(nt+0xF8)
  %nx.ptr.pe32p = getelementptr i8, i8* %nt, i64 248
  %nx.p32.pe32p = bitcast i8* %nx.ptr.pe32p to i32*
  %nx.val.pe32p = load i32, i32* %nx.p32.pe32p
  %nz.pe32p = icmp ne i32 %nx.val.pe32p, 0
  %ecx_from_pe32p = zext i1 %nz.pe32p to i32
  br label %after_pe_checks

after_pe_checks:
  ; select ecx based on which path reached here
  %ecx_final = phi i32 [ %ecx_init, %blk_1110 ], [ %ecx_init, %check_pe ], [ %ecx_init, %check_pe32plus ], [ %ecx_from_pe32, %pe32_has_flag ], [ %ecx_from_pe32p, %pe32p_has_flag ], [ %ecx_init, %pe32_path ], [ %ecx_init, %pe32plus_path ]

  ; cs:dword_140007008 = ecx_final
  store i32 %ecx_final, i32* @dword_140007008

  ; r8d = *(*off_140004420)
  %pApp = load i32*, i32** @off_140004420
  %app.val = load i32, i32* %pApp
  %app.nz = icmp ne i32 %app.val, 0
  br i1 %app.nz, label %blk_1338, label %blk_11e3

blk_1338:
  call void @_set_app_type(i32 noundef 2)
  br label %blk_11e3

blk_11e3:
  ; *__p__fmode() = *(*off_1400044F0)
  %pfmode = call i32* @__p__fmode()
  %pF = load i32*, i32** @off_1400044F0
  %fval = load i32, i32* %pF
  store i32 %fval, i32* %pfmode
  ; *__p__commode() = *(*off_1400044D0)
  %pcomm = call i32* @__p__commode()
  %pCm = load i32*, i32** @off_1400044D0
  %cmval = load i32, i32* %pCm
  store i32 %cmval, i32* %pcomm

  ; sub_140001540
  %initres = call i32 @sub_140001540()
  %neg = icmp slt i32 %initres, 0
  br i1 %neg, label %blk_1301, label %check_3a0

check_3a0:
  ; if (*(*off_1400043A0) == 1) { sub_140001CA0(&sub_140001600) }
  %p3a0 = load i32*, i32** @off_1400043A0
  %v3a0 = load i32, i32* %p3a0
  %is1 = icmp eq i32 %v3a0, 1
  br i1 %is1, label %blk_1399, label %after_1399

blk_1399:
  %fnptr = bitcast void ()* @sub_140001600 to i8*
  call void @sub_140001CA0(i8* noundef %fnptr)
  br label %after_1399

after_1399:
  ; if (*(*off_140004400) == -1) _configthreadlocale(-1)
  %p400 = load i32*, i32** @off_140004400
  %v400 = load i32, i32* %p400
  %is_m1 = icmp eq i32 %v400, -1
  br i1 %is_m1, label %blk_138a, label %blk_1230

blk_138a:
  %tmpCtl = call i32 @_configthreadlocale(i32 noundef -1)
  br label %blk_1230

blk_1230:
  ; _initterm_e(First, Last)
  %first.ptr = load i8**, i8*** @First
  %last.ptr = load i8**, i8*** @Last
  %e = call i32 @_initterm_e(i8** noundef %first.ptr, i8** noundef %last.ptr)
  %e_nz = icmp ne i32 %e, 0
  br i1 %e_nz, label %blk_1380, label %blk_124b

blk_1380:
  br label %epilogue_ff

blk_124b:
  ; setup for sub_1400026A0
  %p520 = load i32*, i32** @off_140004520
  %val520 = load i32, i32* %p520
  store i32 %val520, i32* %var_4C
  %p4E0 = load i32*, i32** @off_1400044E0
  %val4E0 = load i32, i32* %p4E0
  ; rcx=&dword_140007020, rdx=&qword_140007018, r8=&qword_140007010, r9d=val4E0, 5th=&var_4C
  %r = call i32 @sub_1400026A0(i32* noundef @dword_140007020, i8*** noundef @qword_140007018, i8** noundef @qword_140007010, i32 noundef %val4E0, i32* noundef %var_4C)
  %r_neg = icmp slt i32 %r, 0
  br i1 %r_neg, label %blk_1301, label %after_26a0

after_26a0:
  ; r12 = dword_140007020
  %argc = load i32, i32* @dword_140007020
  ; bytes = (argc+1)*8
  %argc1 = add i32 %argc, 1
  %argc1.z = zext i32 %argc1 to i64
  %bytes = shl i64 %argc1.z, 3
  %argv.new.buf = call i8* @malloc(i64 noundef %bytes)
  %r13 = bitcast i8* %argv.new.buf to i8**
  %r13.isnull = icmp eq i8* %argv.new.buf, null
  br i1 %r13.isnull, label %blk_1301, label %check_copy_loop

check_copy_loop:
  ; if argc <= 0 -> write terminator and proceed
  %argc.le0 = icmp sle i32 %argc, 0
  br i1 %argc.le0, label %write_term, label %loop_prep

loop_prep:
  ; r15 = qword_140007018, esi = 1
  %r15 = load i8**, i8*** @qword_140007018
  %i.start = add i32 0, 1
  br label %loop

loop:
  ; src = r15 + (i-1)
  %i.phi = phi i32 [ %i.start, %loop_prep ], [ %i.next, %loop_next ]
  %i.idx = add i32 %i.phi, -1
  %i.idx.z = zext i32 %i.idx to i64
  %src.ptr.addr = getelementptr i8*, i8** %r15, i64 %i.idx.z
  %src.ptr = load i8*, i8** %src.ptr.addr
  ; len = strlen(src)
  %len = call i64 @strlen(i8* noundef %src.ptr)
  %size.copy = add i64 %len, 1
  ; dest = malloc(size.copy)
  %dest = call i8* @malloc(i64 noundef %size.copy)
  ; store dest into new argv
  %dest.slot.addr = getelementptr i8*, i8** %r13, i64 %i.idx.z
  store i8* %dest, i8** %dest.slot.addr
  ; if dest == null -> error
  %dest.null = icmp eq i8* %dest, null
  br i1 %dest.null, label %blk_1301, label %do_copy

do_copy:
  ; memcpy(dest, src, size.copy)
  %copyres = call i8* @memcpy(i8* noundef %dest, i8* noundef %src.ptr, i64 noundef %size.copy)
  ; if i == argc -> finish
  %i.eq.argc = icmp eq i32 %i.phi, %argc
  br i1 %i.eq.argc, label %write_term, label %loop_next

loop_next:
  %i.next = add i32 %i.phi, 1
  br label %loop

write_term:
  ; place terminating null pointer at argv_new[argc]
  %argc.z = sext i32 %argc to i64
  %term.slot = getelementptr i8*, i8** %r13, i64 %argc.z
  store i8* null, i8** %term.slot

  ; qword_140007018 = r13
  store i8** %r13, i8*** @qword_140007018

  ; _initterm(*off_140004490, *off_1400044A0)
  %first2 = load i8**, i8*** @off_140004490
  %last2 = load i8**, i8*** @off_1400044A0
  call void @_initterm(i8** noundef %first2, i8** noundef %last2)

  call void @sub_140001520()
  ; *state = 2
  store i32 2, i32* %state.ptr
  br label %after_state_init

after_state_init:
  ; dword_140007004 = 1
  store i32 1, i32* @dword_140007004

  ; if not recursive owner, release lock: xchg [lock], 0
  %not_rec = xor i1 %r14_flag, true
  br i1 %not_rec, label %unlock, label %no_unlock

unlock:
  atomicrmw xchg i64* %lock.ptr.ptr, i64 0 seq_cst
  br label %after_unlock

no_unlock:
  br label %after_unlock

after_unlock:
  ; if (*(*off_1400043F0)) call it with (0,2,0)
  %pfn.storage.ptr = load i8**, i8*** @off_1400043F0
  %pfn.raw = load i8*, i8** %pfn.storage.ptr
  %has_cb = icmp ne i8* %pfn.raw, null
  br i1 %has_cb, label %call_cb, label %after_cb

call_cb:
  %cb = bitcast i8* %pfn.raw to void (i32, i32, i32)*
  call void %cb(i32 noundef 0, i32 noundef 2, i32 noundef 0)
  br label %after_cb

after_cb:
  ; p = sub_140002660(); *p = qword_140007010
  %pbuf = call i8* @sub_140002660()
  %pbuf.q = bitcast i8* %pbuf to i8**
  %progname = load i8*, i8** @qword_140007010
  store i8* %progname, i8** %pbuf.q

  ; call sub_140002880(dword_140007020, qword_140007018, qword_140007010)
  %argc_val = load i32, i32* @dword_140007020
  %argv_ptr = load i8**, i8*** @qword_140007018
  %env_ptr = load i8*, i8** @qword_140007010
  %res_2880 = call i32 @sub_140002880(i32 noundef %argc_val, i8** noundef %argv_ptr, i8* noundef %env_ptr)

  ; if (dword_140007008 == 0) exit(res_2880)
  %flag = load i32, i32* @dword_140007008
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %blk_13d2_from_main, label %chk_cexit

blk_13d2_from_main:
  br label %blk_13d2

chk_cexit:
  ; if (dword_140007004 == 0) { var_5C = res_2880; _cexit(); return var_5C; } else return res_2880
  %need_cexit = load i32, i32* @dword_140007004
  %is_zero2 = icmp eq i32 %need_cexit, 0
  br i1 %is_zero2, label %do_cexit, label %ret_direct

do_cexit:
  store i32 %res_2880, i32* %var_5C
  call void @_cexit()
  %ret_after_cexit = load i32, i32* %var_5C
  br label %ret_block

ret_direct:
  ; return res_2880
  br label %ret_block

blk_1301:
  ; error path: sub_140002670(8); then go to cexit/return path
  %errcode = call i32 @sub_140002670(i32 noundef 8)
  store i32 %errcode, i32* %var_5C
  call void @_cexit()
  %ret_err = load i32, i32* %var_5C
  br label %ret_block

epilogue_ff:
  ; set eax=0xFF and return
  br label %ret_ff

ret_ff:
  br label %ret_block

blk_13d2:
  ; exit with code in eax (from either 13c8 or main path)
  %exit_code = phi i32 [ %ret_1f, %blk_13c8 ], [ %res_2880, %blk_13d2_from_main ]
  call void @exit(i32 noundef %exit_code)
  unreachable

ret_block:
  ; unified return
  %ret_sel = phi i32 [ %ret_after_cexit, %do_cexit ], [ %res_2880, %ret_direct ], [ %ret_err, %blk_1301 ], [ 255, %ret_ff ]
  ret i32 %ret_sel
}