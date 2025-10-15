; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i64 @__readgsqword(i32)

declare void @sub_140001C40(...)
declare i8* @sub_1400F62A4(...)
declare void @sub_140002AE0(...)
declare void @sub_140002480(...)
declare void @sub_140002AC8(...)
declare i8* @sub_140002A80(...)
declare i8* @sub_140002A78(...)
declare i32 @sub_1400018B0(...)
declare void @sub_140002AD0(...)
declare void @sub_140001890(...)
declare i32 @sub_1400029D0(...)
declare i64 @sub_140002A60(...)
declare i8* @sub_140002B48(...)
declare void @sub_140002B08(...)
declare void @sub_140002B20(...)
declare void @sub_140002010(...)
declare i32 @sub_140002A00(...)
declare void @sub_140002AF0(...)
declare void @sub_140002AA0(...)
declare i32 @sub_140002AD8(...)
declare i8** @sub_1400029C0(...)
declare void @sub_14000171D(...)

declare void @nullsub_1()
declare void @sub_140002020()
declare void @sub_140001970()

@off_140004450 = external global i64****
@qword_140008278 = external global i8*
@off_140004460 = external global i32**
@dword_140007004 = external global i32
@off_1400043D0 = external global i8**
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8**
@dword_140007008 = external global i32
@off_140004440 = external global i8**
@off_140004410 = external global i32**
@off_140004420 = external global i32**
@off_140004430 = external global i32**
@off_1400043A0 = external global i8**
@off_140004400 = external global i32**
@off_1400044D0 = external global i32**
@off_1400044B0 = external global i32**
@off_140004380 = external global i32**
@off_1400043E0 = external global i32**
@off_1400044A0 = external global i8**
@off_140004490 = external global i8**
@off_140004500 = external global i32**
@off_1400044C0 = external global i32**
@off_140004480 = external global i8**
@off_140004470 = external global i8**

define i32 @sub_140001010() {
entry:
  %teb.q = call i64 @__readgsqword(i32 48)
  %teb.p = inttoptr i64 %teb.q to i8*
  %teb.p.plus8 = getelementptr inbounds i8, i8* %teb.p, i64 8
  %tid.ptr = bitcast i8* %teb.p.plus8 to i64*
  %tid = load i64, i64* %tid.ptr, align 8
  %lock.ppp = load i64***, i64**** @off_140004450, align 8
  %lock.pp = load i64**, i64*** %lock.ppp, align 8
  %lock.ptr.ptr = load i64*, i64** %lock.pp, align 8
  %fp.raw = load i8*, i8** @qword_140008278, align 8
  %fp = bitcast i8* %fp.raw to void (i32)*
  br label %lock_try

lock_try:                                         ; preds = %sleep, %entry
  %cmpx = cmpxchg i64* %lock.ptr.ptr, i64 0, i64 %tid monotonic monotonic
  %old = extractvalue { i64, i1 } %cmpx, 0
  %ok = extractvalue { i64, i1 } %cmpx, 1
  br i1 %ok, label %locked, label %lock_fail

lock_fail:                                        ; preds = %lock_try
  %eq = icmp eq i64 %old, %tid
  br i1 %eq, label %locked_reentrant, label %sleep

sleep:                                            ; preds = %lock_fail
  call void %fp(i32 1000)
  br label %lock_try

locked_reentrant:                                 ; preds = %lock_fail
  br label %after_lock

locked:                                           ; preds = %lock_try
  br label %after_lock

after_lock:                                       ; preds = %locked, %locked_reentrant
  %r14 = phi i32 [ 0, %locked ], [ 1, %locked_reentrant ]
  %state.ptr = load i32*, i32** @off_140004460, align 8
  %state = load i32, i32* %state.ptr, align 4
  %is1 = icmp eq i32 %state, 1
  br i1 %is1, label %case_state1, label %check_state0

check_state0:                                     ; preds = %after_lock
  %is0 = icmp eq i32 %state, 0
  br i1 %is0, label %init_state, label %cont

init_state:                                       ; preds = %check_state0
  store i32 1, i32* %state.ptr, align 4
  call void (...) @sub_140001C40()
  %fptr.as.i8 = bitcast void ()* @sub_140002020 to i8*
  %rax1 = call i8* (...) @sub_1400F62A4(i8* %fptr.as.i8)
  %p04440 = load i8*, i8** @off_140004440, align 8
  %p04440.pp = bitcast i8* %p04440 to i8**
  store i8* %rax1, i8** %p04440.pp, align 8
  call void (...) @sub_140002AE0()
  call void (...) @sub_140002480()
  %p0410 = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %p0410, align 4
  %p0420 = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %p0420, align 4
  %p0430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p0430, align 4
  br label %check_pe

check_pe:                                         ; preds = %init_state
  br label %after_pe

after_pe:                                         ; preds = %check_pe
  %p0400 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* @dword_140007008, align 4
  %r8d.val = load i32, i32* %p0400, align 4
  %nz = icmp ne i32 %r8d.val, 0
  br i1 %nz, label %L338, label %L1E3

L338:                                             ; preds = %after_pe
  call void (...) @sub_140002AC8(i32 2)
  br label %L1E3

L1E3:                                             ; preds = %L338, %after_pe
  %prax1 = call i8* (...) @sub_140002A80()
  %pDptr = load i32*, i32** @off_1400044D0, align 8
  %valD = load i32, i32* %pDptr, align 4
  %prax1.i32 = bitcast i8* %prax1 to i32*
  store i32 %valD, i32* %prax1.i32, align 4
  %prax2 = call i8* (...) @sub_140002A78()
  %pB0ptr = load i32*, i32** @off_1400044B0, align 8
  %valB0 = load i32, i32* %pB0ptr, align 4
  %prax2.i32 = bitcast i8* %prax2 to i32*
  store i32 %valB0, i32* %prax2.i32, align 4
  %eax.ib0 = call i32 (...) @sub_1400018B0()
  %isneg = icmp slt i32 %eax.ib0, 0
  br i1 %isneg, label %L301, label %L210

L210:                                             ; preds = %L1E3
  ret i32 0

L301:                                             ; preds = %L1E3
  %rv8 = call i32 (...) @sub_1400029D0(i32 8)
  br label %epilogue_return_value

case_state1:                                      ; preds = %after_lock
  %rv31 = call i32 (...) @sub_1400029D0(i32 31)
  call void (...) @sub_140002AF0(i32 %rv31)
  br label %epilogue_return_value

cont:                                             ; preds = %check_state0
  store i32 1, i32* @dword_140007004, align 4
  %is_reentrant = icmp ne i32 %r14, 0
  br i1 %is_reentrant, label %path_reentrant, label %epilogue_zero

path_reentrant:                                   ; preds = %cont
  %oldx = atomicrmw xchg i64* %lock.ptr.ptr, i64 0 monotonic
  br label %epilogue_zero

epilogue_zero:                                    ; preds = %path_reentrant, %cont
  ret i32 0

epilogue_return_value:                            ; preds = %case_state1, %L301
  %retv = phi i32 [ %rv8, %L301 ], [ %rv31, %case_state1 ]
  ret i32 %retv
}