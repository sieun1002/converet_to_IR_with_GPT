; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@lock_storage = internal global i64 0, align 8
@off_140004450 = global i64* @lock_storage, align 8

@state_storage = internal global i32 0, align 4
@off_140004460 = global i32* @state_storage, align 8

@dword_140007004 = global i32 0, align 4
@dword_140007008 = global i32 0, align 4

@fnptr_slot = internal global i8* null, align 8
@off_1400043D0 = global i8** @fnptr_slot, align 8

@qword_140007010 = global i8* null, align 8
@qword_140007018 = global i8** null, align 8
@dword_140007020 = global i32 0, align 4

@some_flag = internal global i32 0, align 4
@off_140004400 = global i32* @some_flag, align 8

@flagA = internal global i32 0, align 4
@off_140004410 = global i32* @flagA, align 8

@flagB = internal global i32 0, align 4
@off_140004420 = global i32* @flagB, align 8

@flagC = internal global i32 0, align 4
@off_140004430 = global i32* @flagC, align 8

@fmode_default = internal global i32 0, align 4
@off_1400044D0 = global i32* @fmode_default, align 8

@commode_default = internal global i32 0, align 4
@off_1400044B0 = global i32* @commode_default, align 8

declare dllimport void @Sleep(i32)
declare dllimport i8* @SetUnhandledExceptionFilter(i8*)
declare dllimport i8* @_set_invalid_parameter_handler(i8*)
declare dllimport i32* @__p__fmode()
declare dllimport i32* @__p__commode()
declare dllimport void @exit(i32)
declare dllimport void @_cexit()
declare dllimport i8* @malloc(i64)
declare dllimport i8* @memcpy(i8*, i8*, i64)
declare dllimport i64 @strlen(i8*)
declare dllimport i32 @_initterm_e(i8**, i8**)
declare dllimport void @_initterm(i8**, i8**)
declare i8* @sub_140002A20()
declare void @sub_14000171D(i8*, i8*, i32)
declare i32 @sub_140002A30(i32)
declare void @sub_1400018F0()
declare i32 @sub_140001910()
declare void @sub_1400024E0()
declare void @sub_140001CA0()
declare void @sub_140002070(i8*)

define i32 @sub_140001010() {
entry:
  %lockptrptr = load i64*, i64** @off_140004450, align 8
  br label %acquire

acquire:
  %cmpx = cmpxchg i64* %lockptrptr, i64 0, i64 1 seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpx, 0
  %success = extractvalue { i64, i1 } %cmpx, 1
  br i1 %success, label %locked, label %spin

spin:
  call void @Sleep(i32 1000)
  br label %acquire

locked:
  %stateptrptr = load i32*, i32** @off_140004460, align 8
  %state = load i32, i32* %stateptrptr, align 4
  %isone = icmp eq i32 %state, 1
  br i1 %isone, label %fastpath, label %initcheck

fastpath:
  %code_fast = call i32 @sub_140002A30(i32 31)
  br label %release_after_code

initcheck:
  %iszero = icmp eq i32 %state, 0
  br i1 %iszero, label %do_init, label %after_init

do_init:
  store i32 1, i32* %stateptrptr, align 4
  %prevseh = call i8* @SetUnhandledExceptionFilter(i8* null)
  %previnv = call i8* @_set_invalid_parameter_handler(i8* null)
  call void @sub_1400024E0()
  %pA = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %pA, align 4
  %pB = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %pB, align 4
  %pC = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %pC, align 4
  br label %after_init

after_init:
  store i32 1, i32* @dword_140007004, align 4
  %pfmode = call i32* @__p__fmode()
  %defFptrptr = load i32*, i32** @off_1400044D0, align 8
  %defF = load i32, i32* %defFptrptr, align 4
  store i32 %defF, i32* %pfmode, align 4
  %pcomm = call i32* @__p__commode()
  %defCptrptr = load i32*, i32** @off_1400044B0, align 8
  %defC = load i32, i32* %defCptrptr, align 4
  store i32 %defC, i32* %pcomm, align 4
  br label %release_zero

release_after_code:
  %code_phi1 = phi i32 [ %code_fast, %fastpath ]
  br label %release

release_zero:
  %code_phi2 = phi i32 [ 0, %after_init ]
  br label %release

release:
  %retcode = phi i32 [ %code_phi1, %release_after_code ], [ %code_phi2, %release_zero ]
  %lockptr2 = load i64*, i64** @off_140004450, align 8
  store atomic i64 0, i64* %lockptr2 seq_cst, align 8
  %flag = load i32, i32* @dword_140007008, align 4
  %need_exit = icmp ne i32 %flag, 0
  br i1 %need_exit, label %do_exit, label %ret

do_exit:
  call void @exit(i32 %retcode)
  br label %ret

ret:
  ret i32 %retcode
}