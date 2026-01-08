; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

; External globals
@off_140004470 = external global i64*          ; pointer to 64-bit lock storage
@off_140004480 = external global i32*          ; pointer to 32-bit state
@off_1400043F0 = external global i8**          ; pointer to a pointer to func
@qword_140008280 = external global void (i32)* ; Sleep-like function pointer
@qword_140007010 = external global i8*
@qword_140007018 = external global i8*
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@dword_140007004 = external global i32

; External/undefined functions
declare i8* @sub_140002660()
declare i32 @sub_140002880(i32, i8*, i8*)
declare i32 @sub_140002750()
declare i32 @sub_140002670(i32)
declare i32 @sub_1400027A0(i32)
declare i32 @sub_1400018D0()
declare void @sub_14000ED64(i8*)
declare void @sub_140001CB0()

define i32 @sub_140001010() {
entry:
  ; rax = gs:[0x30]
  %teb = call i8* asm sideeffect "mov $0, qword ptr gs:[0x30]", "=r,~{dirflag},~{fpsr},~{flags}"()
  ; rsi = [rax+8]
  %tid.ptr = getelementptr inbounds i8, i8* %teb, i64 8
  %tid.q = bitcast i8* %tid.ptr to i64*
  %self = load i64, i64* %tid.q, align 8

  ; rbx = cs:off_140004470
  %lock.addr = load i64*, i64** @off_140004470, align 8

  ; rdi = cs:qword_140008280
  %sleep.fn = load void (i32)*, void (i32)** @qword_140008280, align 8
  br label %try_lock

try_lock:                                           ; loc_140001050
  %cmpx = cmpxchg i64* %lock.addr, i64 0, i64 %self seq_cst seq_cst
  %oldval = extractvalue { i64, i1 } %cmpx, 0
  %success = extractvalue { i64, i1 } %cmpx, 1
  br i1 %success, label %acquired, label %check_owned

check_owned:                                        ; loc_140001040
  %owned = icmp eq i64 %oldval, %self
  br i1 %owned, label %already_held, label %do_sleep

do_sleep:
  call void %sleep.fn(i32 1000)
  br label %try_lock

already_held:                                       ; loc_140001100
  br label %after_lock

acquired:
  br label %after_lock

after_lock:                                         ; loc_14000105C
  %held_before = phi i1 [ true, %already_held ], [ false, %acquired ]
  ; rbp = cs:off_140004480
  %state.ptr = load i32*, i32** @off_140004480, align 8
  %state = load i32, i32* %state.ptr, align 4

  ; cmp [rbp], 1
  %is_one = icmp eq i32 %state, 1
  br i1 %is_one, label %state_one, label %check_zero

state_one:                                          ; loc_1400013C8 -> loc_1400013D2
  %r0 = call i32 @sub_140002670(i32 31)
  %r1 = call i32 @sub_1400027A0(i32 %r0)
  ret i32 %r1

check_zero:                                         ; 0x14000106F..0x140001074
  %is_zero = icmp eq i32 %state, 0
  br i1 %is_zero, label %state_zero, label %state_other

state_zero:                                         ; loc_140001110
  store i32 1, i32* %state.ptr, align 4
  %initr = call i32 @sub_1400018D0()
  %cb = bitcast void ()* @sub_140001CB0 to i8*
  call void @sub_14000ED64(i8* %cb)
  unreachable

state_other:
  ; cs:dword_140007004 = 1
  store i32 1, i32* @dword_140007004, align 4

  ; test r14d ; if zero, unlock
  br i1 %held_before, label %after_unlock, label %do_unlock

do_unlock:                                          ; loc_140001328
  %xchg.prev = atomicrmw xchg i64* %lock.addr, i64 0 seq_cst
  br label %after_unlock

after_unlock:                                       ; loc_14000108D
  ; optional callback via off_1400043F0
  %ppfn = load i8**, i8*** @off_1400043F0, align 8
  %pfn = load i8*, i8** %ppfn, align 8
  %has_cb = icmp ne i8* %pfn, null
  br i1 %has_cb, label %call_cb, label %after_cb

call_cb:
  %cb.fn = bitcast i8* %pfn to void (i32, i32, i32)*
  call void %cb.fn(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  ; rax = sub_140002660()
  %res.ptr = call i8* @sub_140002660()
  ; r8 = cs:qword_140007010 ; [rax] = r8
  %r8val = load i8*, i8** @qword_140007010, align 8
  %rax.as.p = bitcast i8* %res.ptr to i8**
  store i8* %r8val, i8** %rax.as.p, align 8

  ; ecx = dword_140007020 ; rdx = qword_140007018 ; call sub_140002880
  %ecxv = load i32, i32* @dword_140007020, align 4
  %rdxv = load i8*, i8** @qword_140007018, align 8
  %ret1 = call i32 @sub_140002880(i32 %ecxv, i8* %rdxv, i8* %r8val)

  ; ecx = dword_140007008 ; test/jz loc_1400013D2
  %cfg = load i32, i32* @dword_140007008, align 4
  %cfg_is_zero = icmp eq i32 %cfg, 0
  br i1 %cfg_is_zero, label %call_27A0, label %check_flag_7004

call_27A0:                                          ; loc_1400013D2
  %r2 = call i32 @sub_1400027A0(i32 %ret1)
  ret i32 %r2

check_flag_7004:
  %f = load i32, i32* @dword_140007004, align 4
  %f_is_zero = icmp eq i32 %f, 0
  br i1 %f_is_zero, label %call_2750, label %ret_direct

call_2750:                                          ; loc_140001310
  %spill = alloca i32, align 4
  store i32 %ret1, i32* %spill, align 4
  %tmpcall = call i32 @sub_140002750()
  %ret.saved = load i32, i32* %spill, align 4
  ret i32 %ret.saved

ret_direct:                                         ; falls to epilogue
  ret i32 %ret1
}