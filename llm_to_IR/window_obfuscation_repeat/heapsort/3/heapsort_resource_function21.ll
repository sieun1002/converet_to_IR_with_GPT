; ModuleID: fixed_module
source_filename = "fixed_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@lockVar = internal global i64 0, align 8
@off_140004450 = internal global i64* @lockVar, align 8

@stateVar = internal global i32 0, align 4
@off_140004460 = internal global i32* @stateVar, align 8

@dword_140007004 = internal global i32 0, align 4
@off_1400043D0 = internal global i8* null, align 8

@qword_140007010 = internal global i8* null, align 8
@qword_140007018 = internal global i8** null, align 8
@dword_140007020 = internal global i32 0, align 4
@dword_140007008 = internal global i32 0, align 4

@appFlag = internal global i32 0, align 4
@off_140004400 = internal global i32* @appFlag, align 8

@fmode_init = internal global i32 0, align 4
@off_1400044D0 = internal global i32* @fmode_init, align 8

@commode_init = internal global i32 0, align 4
@off_1400044B0 = internal global i32* @commode_init, align 8

@flag_4380 = internal global i32 0, align 4
@off_140004380 = internal global i32* @flag_4380, align 8

@threadloc_flag = internal global i32 -1, align 4
@off_1400043E0 = internal global i32* @threadloc_flag, align 8

@First = internal global i8** null, align 8
@Last  = internal global i8** null, align 8

@off_140004470 = internal global i8** null, align 8
@off_140004480 = internal global i8** null, align 8

@int_0 = internal global i32 0, align 4
@off_140004500 = internal global i32* @int_0, align 8
@off_1400044C0 = internal global i32* @int_0, align 8

@prevUEF = internal global i8* null, align 8
@off_140004440 = internal global i8** @prevUEF, align 8

@int_flag1 = internal global i32 0, align 4
@off_140004410 = internal global i32* @int_flag1, align 8

@int_flag2 = internal global i32 0, align 4
@off_140004420 = internal global i32* @int_flag2, align 8

@int_flag3 = internal global i32 0, align 4
@off_140004430 = internal global i32* @int_flag3, align 8

@off_1400043A0 = internal global i8* null, align 8

declare void @Sleep(i32)
declare i8* @SetUnhandledExceptionFilter(i8*)
declare i8* @_set_invalid_parameter_handler(i8*)
declare void @_set_app_type(i32)
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @_initterm_e(i8**, i8**)
declare void @_initterm(i8**, i8**)
declare i8* @malloc(i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i64 @strlen(i8*)
declare void @exit(i32) noreturn
declare void @_cexit()
declare i32 @_configthreadlocale(i32)

define i32 @TopLevelExceptionFilter(i8* %ep) {
entry:
  ret i32 0
}

define void @Handler(i8* %a, i8* %b, i8* %c, i32 %d, i64 %e) {
entry:
  ret void
}

define void @sub_140001CA0() {
entry:
  ret void
}

define void @sub_1400024E0() {
entry:
  ret void
}

define i32 @sub_140001910() {
entry:
  ret i32 0
}

define void @sub_1400018F0() {
entry:
  ret void
}

define void @sub_140002070(i8* %f) {
entry:
  ret void
}

define i32 @sub_140001010() {
entry:
  br label %acquire

acquire:                                          ; preds = %sleep, %entry
  %p.lock.ptrptr = load i64*, i64** @off_140004450, align 8
  %cmp = cmpxchg i64* %p.lock.ptrptr, i64 0, i64 1 seq_cst seq_cst
  %oldval = extractvalue { i64, i1 } %cmp, 0
  %success = extractvalue { i64, i1 } %cmp, 1
  br i1 %success, label %acquired, label %sleep

sleep:                                            ; preds = %acquire
  call void @Sleep(i32 1000)
  br label %acquire

acquired:                                         ; preds = %acquire
  %state.ptrptr = load i32*, i32** @off_140004460, align 8
  %state.cur = load i32, i32* %state.ptrptr, align 4
  %isZero = icmp eq i32 %state.cur, 0
  br i1 %isZero, label %do_init, label %post

do_init:                                          ; preds = %acquired
  store i32 1, i32* %state.ptrptr, align 4
  call void @sub_140001CA0()
  %filter.fn = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prev = call i8* @SetUnhandledExceptionFilter(i8* %filter.fn)
  %prev.slot.ptrptr = load i8**, i8*** @off_140004440, align 8
  store i8* %prev, i8** %prev.slot.ptrptr, align 8
  %iph.fn = bitcast void (i8*, i8*, i8*, i32, i64)* @Handler to i8*
  %oldiph = call i8* @_set_invalid_parameter_handler(i8* %iph.fn)
  call void @sub_1400024E0()
  %p1 = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %p1, align 4
  %p2 = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %p2, align 4
  %p3 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p3, align 4
  %apptype.ptr = load i32*, i32** @off_140004400, align 8
  %appval = load i32, i32* %apptype.ptr, align 4
  %appnz = icmp ne i32 %appval, 0
  %type = select i1 %appnz, i32 2, i32 1
  call void @_set_app_type(i32 %type)
  %pfmode = call i32* @__p__fmode()
  %fmptr = load i32*, i32** @off_1400044D0, align 8
  %fm = load i32, i32* %fmptr, align 4
  store i32 %fm, i32* %pfmode, align 4
  %pcommode = call i32* @__p__commode()
  %cmptr = load i32*, i32** @off_1400044B0, align 8
  %cm = load i32, i32* %cmptr, align 4
  store i32 %cm, i32* %pcommode, align 4
  %r = call i32 @sub_140001910()
  %tlpp = load i32*, i32** @off_1400043E0, align 8
  %tl = load i32, i32* %tlpp, align 4
  %need = icmp eq i32 %tl, -1
  br i1 %need, label %do_cfg, label %cfg_done

do_cfg:                                           ; preds = %do_init
  %cfgret = call i32 @_configthreadlocale(i32 -1)
  br label %cfg_done

cfg_done:                                         ; preds = %do_cfg, %do_init
  %first.ptr = load i8**, i8*** @First, align 8
  %last.ptr  = load i8**, i8*** @Last, align 8
  %ie = call i32 @_initterm_e(i8** %first.ptr, i8** %last.ptr)
  store i32 0, i32* @dword_140007020, align 4
  %mem = call i8* @malloc(i64 8)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %skip_argv_store, label %argv_store

argv_store:                                       ; preds = %cfg_done
  %mem.cast = bitcast i8* %mem to i8**
  store i8* null, i8** %mem.cast, align 8
  br label %skip_argv_store

skip_argv_store:                                  ; preds = %argv_store, %cfg_done
  %mem.cast2 = bitcast i8* %mem to i8**
  store i8** %mem.cast2, i8*** @qword_140007018, align 8
  store i8* null, i8** @qword_140007010, align 8
  %f2 = load i8**, i8*** @off_140004470, align 8
  %l2 = load i8**, i8*** @off_140004480, align 8
  call void @_initterm(i8** %f2, i8** %l2)
  call void @sub_1400018F0()
  store i32 2, i32* %state.ptrptr, align 4
  br label %post

post:                                             ; preds = %skip_argv_store, %acquired
  %p.lock.ptrptr.1 = load i64*, i64** @off_140004450, align 8
  %oldx = atomicrmw xchg i64* %p.lock.ptrptr.1, i64 0 seq_cst
  ret i32 0
}