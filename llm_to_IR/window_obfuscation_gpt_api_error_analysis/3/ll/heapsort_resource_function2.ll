; ModuleID = 'sub_140001010'
target triple = "x86_64-pc-windows-msvc"

@off_140004450 = external global i64*
@off_140004460 = external global i32*
@dword_140007004 = external global i32
@off_1400043D0 = external global i8*
@qword_140007010 = external global i8*
@qword_140007018 = external global i8**
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@off_140004440 = external global i8**
@off_140004410 = external global i32*
@off_140004420 = external global i32*
@off_140004430 = external global i32*
@off_1400043A0 = external global i8*
@off_140004400 = external global i32*
@off_1400044D0 = external global i32*
@off_1400044B0 = external global i32*
@off_140004380 = external global i32*
@off_1400043E0 = external global i32*
@First = external global i8*
@Last = external global i8*
@off_140004470 = external global i8*
@off_140004480 = external global i8*
@off_140004500 = external global i32*
@off_1400044C0 = external global i32*

declare dso_local i32 @GetCurrentThreadId()
declare dso_local void @Sleep(i32)
declare dso_local i32 @sub_140002A30(i32)
declare dso_local i8** @sub_140002A20()
declare dso_local void @sub_14000171D(i8**, i8**, i8*)
declare dso_local void @sub_140001CA0()
declare dso_local i8* @SetUnhandledExceptionFilter(i8*)
declare dso_local i8* @_set_invalid_parameter_handler(i8*)
declare dso_local void @sub_1400024E0()
declare dso_local i32* @__p__fmode()
declare dso_local i32* @__p__commode()
declare dso_local i32 @_set_app_type(i32)
declare dso_local i32 @_configthreadlocale(i32)
declare dso_local i32 @sub_140001910()
declare dso_local void @sub_140002070(i8*)
declare dso_local i32 @_initterm_e(i8*, i8*)
declare dso_local void @_initterm(i8*, i8*)
declare dso_local i32 @sub_140002A60(i32*, i8***, i8**, i32, i32*)
declare dso_local i8* @malloc(i64)
declare dso_local i64 @strlen(i8*)
declare dso_local i8* @memcpy(i8*, i8*, i64)
declare dso_local void @_cexit()
declare dso_local void @sub_1400018F0()
declare dso_local void @exit(i32) noreturn

declare dso_local i32 @TopLevelExceptionFilter(i8*)
declare dso_local void @Handler()

define dso_local i32 @sub_140001010() {
entry:
  %ret.slot = alloca i32, align 4
  %var_4C = alloca i32, align 4
  %tid32 = call i32 @GetCurrentThreadId()
  %owner = zext i32 %tid32 to i64
  %lock.ptr.ptr = load i64*, i64** @off_140004450
  br label %try_lock

try_lock:                                           ; attempt to acquire spinlock
  %cmpx = cmpxchg i64* %lock.ptr.ptr, i64 0, i64 %owner monotonic monotonic
  %oldval = extractvalue { i64, i1 } %cmpx, 0
  %acq = extractvalue { i64, i1 } %cmpx, 1
  br i1 %acq, label %got_lock, label %lock_fail

lock_fail:
  %reent = icmp eq i64 %oldval, %owner
  br i1 %reent, label %reentered, label %sleep

sleep:
  call void @Sleep(i32 1000)
  br label %try_lock

reentered:
  br label %locked

got_lock:
  br label %locked

locked:
  %reentered.flag = phi i1 [ false, %got_lock ], [ true, %reentered ]
  %state.ptr = load i32*, i32** @off_140004460
  %state.val = load i32, i32* %state.ptr
  %is_one = icmp eq i32 %state.val, 1
  br i1 %is_one, label %state_is_one, label %state_not_one

state_is_one:
  %rc1 = call i32 @sub_140002A30(i32 31)
  call void @exit(i32 %rc1)
  unreachable

state_not_one:
  %is_zero = icmp eq i32 %state.val, 0
  br i1 %is_zero, label %do_init, label %set_flag_and_continue

set_flag_and_continue:
  store i32 1, i32* @dword_140007004
  br label %after_init_common

do_init:
  store i32 1, i32* %state.ptr
  call void @sub_140001CA0()
  %seh.fn.i8 = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prev.seh = call i8* @SetUnhandledExceptionFilter(i8* %seh.fn.i8)
  %prev.store.ptr.ptr = load i8**, i8*** @off_140004440
  store i8* %prev.seh, i8** %prev.store.ptr.ptr
  %iph = bitcast void ()* @Handler to i8*
  %old.iph = call i8* @_set_invalid_parameter_handler(i8* %iph)
  call void @sub_1400024E0()
  %p410 = load i32*, i32** @off_140004410
  store i32 1, i32* %p410
  %p420 = load i32*, i32** @off_140004420
  store i32 1, i32* %p420
  %p430 = load i32*, i32** @off_140004430
  store i32 1, i32* %p430
  %imgbase = load i8*, i8** @off_1400043A0
  %mz.ptr = bitcast i8* %imgbase to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_check, label %pe_done

pe_check:
  %lfanew.ptr = getelementptr i8, i8* %imgbase, i64 60
  %lfanew.p32 = bitcast i8* %lfanew.ptr to i32*
  %lfanew = load i32, i32* %lfanew.p32, align 1
  %lfanew.z = zext i32 %lfanew to i64
  %pehdr = getelementptr i8, i8* %imgbase, i64 %lfanew.z
  %sig.p = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig.p, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %optmagic, label %pe_done

optmagic:
  %optmag.ptr = getelementptr i8, i8* %pehdr, i64 24
  %optmag.p16 = bitcast i8* %optmag.ptr to i16*
  %optmag = load i16, i16* %optmag.p16, align 1
  %is_pe32 = icmp eq i16 %optmag, 267
  %is_pe64 = icmp eq i16 %optmag, 523
  br i1 %is_pe32, label %pe32_secdir, label %check_pe64

check_pe64:
  br i1 %is_pe64, label %pe64_secdir, label %pe_done

pe32_secdir:
  %dd.count32.ptr = getelementptr i8, i8* %pehdr, i64 116
  %dd.count32.p = bitcast i8* %dd.count32.ptr to i32*
  %dd.count32 = load i32, i32* %dd.count32.p, align 1
  %enough32 = icmp ugt i32 %dd.count32, 14
  br i1 %enough32, label %pe32_hassec, label %pe_done

pe32_hassec:
  %sec32.ptr = getelementptr i8, i8* %pehdr, i64 232
  %sec32.p = bitcast i8* %sec32.ptr to i32*
  %sec32 = load i32, i32* %sec32.p, align 1
  %nz32 = icmp ne i32 %sec32, 0
  %cl32 = zext i1 %nz32 to i32
  store i32 %cl32, i32* @dword_140007008
  br label %after_peflag

pe64_secdir:
  %dd.count64.ptr = getelementptr i8, i8* %pehdr, i64 132
  %dd.count64.p = bitcast i8* %dd.count64.ptr to i32*
  %dd.count64 = load i32, i32* %dd.count64.p, align 1
  %enough64 = icmp ugt i32 %dd.count64, 14
  br i1 %enough64, label %pe64_hassec, label %pe_done

pe64_hassec:
  %sec64.ptr = getelementptr i8, i8* %pehdr, i64 248
  %sec64.p = bitcast i8* %sec64.ptr to i32*
  %sec64 = load i32, i32* %sec64.p, align 1
  %nz64 = icmp ne i32 %sec64, 0
  %cl64 = zext i1 %nz64 to i32
  store i32 %cl64, i32* @dword_140007008
  br label %after_peflag

pe_done:
  store i32 0, i32* @dword_140007008
  br label %after_peflag

after_peflag:
  %p400.ptr = load i32*, i32** @off_140004400
  %appflag = load i32, i32* %p400.ptr
  %isgui = icmp ne i32 %appflag, 0
  %app.type = select i1 %isgui, i32 2, i32 1
  %oldtype = call i32 @_set_app_type(i32 %app.type)
  %pfmode = call i32* @__p__fmode()
  %pfmode.src.ptr = load i32*, i32** @off_1400044D0
  %pfmode.src = load i32, i32* %pfmode.src.ptr
  store i32 %pfmode.src, i32* %pfmode
  %pcommode = call i32* @__p__commode()
  %pcommode.src.ptr = load i32*, i32** @off_1400044B0
  %pcommode.src = load i32, i32* %pcommode.src.ptr
  store i32 %pcommode.src, i32* %pcommode
  %init910 = call i32 @sub_140001910()
  %neg910 = icmp slt i32 %init910, 0
  br i1 %neg910, label %error_exit_cexit, label %after_1910

after_1910:
  %p380.ptr = load i32*, i32** @off_140004380
  %v380 = load i32, i32* %p380.ptr
  %is1_380 = icmp eq i32 %v380, 1
  br i1 %is1_380, label %call_2070, label %after_2070

call_2070:
  %fn190.ptr = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  call void @sub_140002070(i8* %fn190.ptr)
  br label %after_2070

after_2070:
  %p3E0.ptr = load i32*, i32** @off_1400043E0
  %v3E0 = load i32, i32* %p3E0.ptr
  %is_m1 = icmp eq i32 %v3E0, -1
  br i1 %is_m1, label %set_locale, label %after_locale

set_locale:
  %cfg = call i32 @_configthreadlocale(i32 -1)
  br label %after_locale

after_locale:
  %first.ptr = load i8*, i8** @First
  %last.ptr = load i8*, i8** @Last
  %initE = call i32 @_initterm_e(i8* %first.ptr, i8* %last.ptr)
  %nonzero = icmp ne i32 %initE, 0
  br i1 %nonzero, label %ret_ff, label %cont_after_initterm_e

ret_ff:
  ret i32 255

cont_after_initterm_e:
  %p500 = load i32*, i32** @off_140004500
  %v500 = load i32, i32* %p500
  store i32 %v500, i32* %var_4C
  %p4C0 = load i32*, i32** @off_1400044C0
  %v4C0 = load i32, i32* %p4C0
  %argvc.ptr = bitcast i32* @dword_140007020 to i32*
  %argv.ptrptr = bitcast i8** @qword_140007018 to i8***
  %argv0.ptr = bitcast i8* @qword_140007010 to i8**
  %rc2 = call i32 @sub_140002A60(i32* %argvc.ptr, i8*** %argv.ptrptr, i8** %argv0.ptr, i32 %v4C0, i32* %var_4C)
  %neg2 = icmp slt i32 %rc2, 0
  br i1 %neg2, label %error_exit_cexit, label %alloc_argv

alloc_argv:
  %argc32 = load i32, i32* @dword_140007020
  %argc64 = sext i32 %argc32 to i64
  %argc1 = add nsw i64 %argc64, 1
  %size.ptrs = shl i64 %argc1, 3
  %newargv.raw = call i8* @malloc(i64 %size.ptrs)
  %newargv = bitcast i8* %newargv.raw to i8**
  %isnull_new = icmp eq i8** %newargv, null
  br i1 %isnull_new, label %error_exit_cexit, label %maybe_loop

maybe_loop:
  %need_loop = icmp sgt i64 %argc64, 0
  br i1 %need_loop, label %loop_start, label %finalize_argv

loop_start:
  %i.init = phi i64 [ 1, %maybe_loop ], [ %i.next, %loop_body_done ]
  %oldargv = load i8**, i8*** @qword_140007018
  %idx0 = add i64 %i.init, -1
  %src.slot.ptr = getelementptr inbounds i8*, i8** %oldargv, i64 %idx0
  %src.str = load i8*, i8** %src.slot.ptr
  %len = call i64 @strlen(i8* %src.str)
  %copiesz = add i64 %len, 1
  %dst.raw = call i8* @malloc(i64 %copiesz)
  %dst.slot.ptr = getelementptr inbounds i8*, i8** %newargv, i64 %idx0
  store i8* %dst.raw, i8** %dst.slot.ptr
  %dst.null = icmp eq i8* %dst.raw, null
  br i1 %dst.null, label %error_exit_cexit, label %do_copy

do_copy:
  %copied = call i8* @memcpy(i8* %dst.raw, i8* %src.str, i64 %copiesz)
  %is_last = icmp eq i64 %i.init, %argc64
  br i1 %is_last, label %finalize_argv, label %loop_body_done

loop_body_done:
  %i.next = add i64 %i.init, 1
  br label %loop_start

finalize_argv:
  %end.slot.ptr = getelementptr inbounds i8*, i8** %newargv, i64 %argc64
  store i8* null, i8** %end.slot.ptr
  store i8** %newargv, i8*** @qword_140007018
  %first2 = load i8*, i8** @off_140004470
  %last2 = load i8*, i8** @off_140004480
  call void @_initterm(i8* %first2, i8* %last2)
  call void @sub_1400018F0()
  store i32 2, i32* %state.ptr
  br label %after_init_common

error_exit_cexit:
  %rc3 = call i32 @sub_140002A30(i32 8)
  store i32 %rc3, i32* %ret.slot
  call void @_cexit()
  %retv = load i32, i32* %ret.slot
  ret i32 %retv

after_init_common:
  %need_release = icmp eq i1 %reentered.flag, false
  br i1 %need_release, label %release_lock, label %post_release

release_lock:
  %oldx = atomicrmw xchg i64* %lock.ptr.ptr, i64 0 monotonic
  br label %post_release

post_release:
  %pfnptr.addr = load i8*, i8** @off_1400043D0
  %pfnptr.ptr = bitcast i8* %pfnptr.addr to i8**
  %pfn = load i8*, i8** %pfnptr.ptr
  %has_cb = icmp ne i8* %pfn, null
  br i1 %has_cb, label %call_cb, label %after_cb

call_cb:
  %cb = bitcast i8* %pfn to void (i64, i64, i64)*
  call void %cb(i64 0, i64 2, i64 0)
  br label %after_cb

after_cb:
  %dstslot = call i8** @sub_140002A20()
  %argv0val = load i8*, i8** @qword_140007010
  store i8* %argv0val, i8** %dstslot
  %argv.table = load i8**, i8*** @qword_140007018
  call void @sub_14000171D(i8** %dstslot, i8** %argv.table, i8* %argv0val)
  %flag008 = load i32, i32* @dword_140007008
  %zero008 = icmp eq i32 %flag008, 0
  br i1 %zero008, label %must_exit, label %check004

must_exit:
  call void @exit(i32 0)
  unreachable

check004:
  %flag004 = load i32, i32* @dword_140007004
  %zero004 = icmp eq i32 %flag004, 0
  br i1 %zero004, label %error_exit_cexit, label %ret0

ret0:
  ret i32 0
}