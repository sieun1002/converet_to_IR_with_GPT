; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct.anon = type { i32 }

@lock_var = global i64 0, align 8
@off_140004450 = global i64* @lock_var, align 8

@state_var = global i32 0, align 4
@off_140004460 = global i32* @state_var, align 8

@dword_140007004 = global i32 0, align 4
@dword_140007008 = global i32 1, align 4
@dword_140007020 = global i32 0, align 4

@qword_140007018 = global i8** null, align 8
@qword_140007010 = global i8** null, align 8

@func_slot = global i8* null, align 8
@off_1400043D0 = global i8** @func_slot, align 8

@prev_uef = global i8* null, align 8
@off_140004440 = global i8** @prev_uef, align 8

@cfg1 = global i32 0, align 4
@cfg2 = global i32 0, align 4
@cfg3 = global i32 0, align 4
@off_140004410 = global i32* @cfg1, align 8
@off_140004420 = global i32* @cfg2, align 8
@off_140004430 = global i32* @cfg3, align 8

@apptype_flag = global i32 0, align 4
@off_140004400 = global i32* @apptype_flag, align 8

@fmode_default = global i32 0, align 4
@off_1400044D0 = global i32* @fmode_default, align 8
@commode_default = global i32 0, align 4
@off_1400044B0 = global i32* @commode_default, align 8

@flag_4380 = global i32 0, align 4
@off_140004380 = global i32* @flag_4380, align 8

@thrlocale_flag = global i32 0, align 4
@off_1400043E0 = global i32* @thrlocale_flag, align 8

@First = global i8* null, align 8
@Last = global i8* null, align 8

@cpp_first_slot = global i8* null, align 8
@cpp_last_slot = global i8* null, align 8
@off_140004470 = global i8** @cpp_first_slot, align 8
@off_140004480 = global i8** @cpp_last_slot, align 8

@val_4500 = global i32 0, align 4
@off_140004500 = global i32* @val_4500, align 8

@val_44C0 = global i32 0, align 4
@off_1400044C0 = global i32* @val_44C0, align 8

; Declarations for external C/WinAPI functions
declare void @Sleep(i32)
declare i8* @SetUnhandledExceptionFilter(i8*)
declare i8* @_set_invalid_parameter_handler(i8*)
declare void @_set_app_type(i32)
declare i32 @_initterm_e(i8**, i8**)
declare void @_initterm(i8**, i8**)
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @_configthreadlocale(i32)
declare void @_cexit()
declare void @exit(i32)
declare i8* @malloc(i64)
declare i64 @strlen(i8*)
declare i8* @memcpy(i8*, i8*, i64)

; Stubs for local helper functions referenced by the routine
define i8* @sub_140002A20() {
entry:
  %p = call i8* @malloc(i64 8)
  ret i8* %p
}

define void @sub_14000171D(i8* %p, i64 %rdx, i32 %ecx) {
entry:
  ret void
}

define i32 @sub_140002A30(i32 %code) {
entry:
  ret i32 0
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

define i32 @sub_140002A60(i32* %argcPtr, i8*** %argvOut, i8*** %envOut, i32* %opt, i32 %flag) {
entry:
  ret i32 0
}

define void @sub_1400018F0() {
entry:
  ret void
}

define void @sub_140002070(i8* %fn) {
entry:
  ret void
}

define void @sub_1400019D0() {
entry:
  ret void
}

; Exception and invalid parameter handlers
define i32 @TopLevelExceptionFilter(i8* %ExceptionPointers) {
entry:
  ret i32 0
}

define void @Handler(i16* %expr, i16* %func, i16* %file, i32 %line, i64 %reserved) {
entry:
  ret void
}

; Main function reconstructed/stubbed to be compilable
define void @sub_140001010() {
entry:
  %lockpp = load i64*, i64** @off_140004450, align 8
  br label %lockloop

lockloop:                                         ; preds = %sleep, %entry
  %cmpx = cmpxchg i64* %lockpp, i64 0, i64 1 monotonic monotonic
  %old = extractvalue { i64, i1 } %cmpx, 0
  %got = extractvalue { i64, i1 } %cmpx, 1
  br i1 %got, label %afterlock, label %sleep

sleep:                                            ; preds = %lockloop
  call void @Sleep(i32 1000)
  br label %lockloop

afterlock:                                        ; preds = %lockloop
  %statepp = load i32*, i32** @off_140004460, align 8
  %state = load i32, i32* %statepp, align 4
  %is1 = icmp eq i32 %state, 1
  br i1 %is1, label %state_one, label %state_check0

state_one:                                        ; preds = %afterlock
  %t0 = call i32 @sub_140002A30(i32 31)
  br label %cont

state_check0:                                     ; preds = %afterlock
  %is0 = icmp eq i32 %state, 0
  br i1 %is0, label %do_init, label %cont

do_init:                                          ; preds = %state_check0
  store i32 1, i32* %statepp, align 4
  call void @sub_140001CA0()
  %uef_ptr = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prev = call i8* @SetUnhandledExceptionFilter(i8* %uef_ptr)
  %prevslotpp = load i8**, i8*** @off_140004440, align 8
  store i8* %prev, i8** %prevslotpp, align 8
  %iph_ptr = bitcast void (i16*, i16*, i16*, i32, i64)* @Handler to i8*
  %oldiph = call i8* @_set_invalid_parameter_handler(i8* %iph_ptr)
  call void @sub_1400024E0()
  %cfg1p = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %cfg1p, align 4
  %cfg2p = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %cfg2p, align 4
  %cfg3p = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %cfg3p, align 4
  br label %cont

cont:                                             ; preds = %do_init, %state_check0, %state_one
  store i32 1, i32* @dword_140007008, align 4
  %appflagp = load i32*, i32** @off_140004400, align 8
  %appflag = load i32, i32* %appflagp, align 4
  %nz = icmp ne i32 %appflag, 0
  br i1 %nz, label %set_gui, label %set_console

set_console:                                      ; preds = %cont
  call void @_set_app_type(i32 1)
  br label %after_set_app

set_gui:                                          ; preds = %cont
  call void @_set_app_type(i32 2)
  br label %after_set_app

after_set_app:                                    ; preds = %set_gui, %set_console
  %pfmode = call i32* @__p__fmode()
  %fmp = load i32*, i32** @off_1400044D0, align 8
  %fm = load i32, i32* %fmp, align 4
  store i32 %fm, i32* %pfmode, align 4
  %pcomm = call i32* @__p__commode()
  %cmp = load i32*, i32** @off_1400044B0, align 8
  %cm = load i32, i32* %cmp, align 4
  store i32 %cm, i32* %pcomm, align 4
  %r910 = call i32 @sub_140001910()
  %neg = icmp slt i32 %r910, 0
  br i1 %neg, label %error, label %ok1

ok1:                                              ; preds = %after_set_app
  %thrpp = load i32*, i32** @off_1400043E0, align 8
  %thrflag = load i32, i32* %thrpp, align 4
  %isMinusOne = icmp eq i32 %thrflag, -1
  br i1 %isMinusOne, label %set_thrloc, label %after_thrloc

set_thrloc:                                       ; preds = %ok1
  %cfgret = call i32 @_configthreadlocale(i32 -1)
  br label %after_thrloc

after_thrloc:                                     ; preds = %set_thrloc, %ok1
  %firstp = getelementptr i8*, i8** @First, i64 0
  %lastp = getelementptr i8*, i8** @Last, i64 0
  %rc = call i32 @_initterm_e(i8** %firstp, i8** %lastp)
  %rcnz = icmp ne i32 %rc, 0
  br i1 %rcnz, label %error, label %after_initterm_e

after_initterm_e:                                 ; preds = %after_thrloc
  %r9srcp = load i32*, i32** @off_1400044C0, align 8
  %r9val = load i32, i32* %r9srcp, align 4
  %var = alloca i32, align 4
  %v4500p = load i32*, i32** @off_140004500, align 8
  %v4500 = load i32, i32* %v4500p, align 4
  store i32 %v4500, i32* %var, align 4
  %retA60 = call i32 @sub_140002A60(i32* @dword_140007020, i8*** @qword_140007018, i8*** @qword_140007010, i32* %var, i32 %r9val)
  %retneg = icmp slt i32 %retA60, 0
  br i1 %retneg, label %error, label %argv_done

argv_done:                                        ; preds = %after_initterm_e
  call void @sub_1400018F0()
  %statepp2 = load i32*, i32** @off_140004460, align 8
  store i32 2, i32* %statepp2, align 4
  br label %release

error:                                            ; preds = %after_initterm_e, %after_set_app
  %ec = call i32 @sub_140002A30(i32 8)
  call void @_cexit()
  br label %release

release:                                          ; preds = %error, %argv_done
  %lockpp2 = load i64*, i64** @off_140004450, align 8
  %oldx = atomicrmw xchg i64* %lockpp2, i64 0 monotonic
  ret void
}