; target: Windows x64 (MSVC)
; NOTE:
; - This is a faithful, type-safe LLVM IR skeleton for sub_140001010 that captures
;   the locking/reentrancy and several dominant control-flow decisions visible in the
;   provided disassembly. Many deep OS/PE-initialization details and mid-function
;   calls into other routines have been conservatively abstracted as externs or elided.
; - The spinlock owner uses a per-thread token read via an external helper. Provide a
;   suitable implementation for get_current_thread_token() that returns a unique
;   pointer-sized token per thread (e.g., derived from the TEB or similar).
; - The function returns i32, using 0 as the default success path as a conservative
;   approximation when exact EAX propagation is unclear from the disassembly snippet.
; - All external symbols referenced must be provided at link time.
; - Build with -fno-stack-protector/-GS- style options if you add stack locals that
;   would otherwise introduce stack protection.

target triple = "x86_64-pc-windows-msvc"

; ===== Extern globals referenced by this function =====
; Lock owner cell (the code performs cmpxchg/xchg directly on this cell).
@off_140004450 = external global i8*

; Sleep-like callback location (function pointer). Called with ECX=1000 when spinning.
@qword_140008280 = external global void (i32)*

; State variable accessed directly (rbp points here in the disassembly).
@off_140004460 = external global i32

; Global configuration flags referenced/modified on init paths.
@dword_140007004 = external global i32
@dword_140007008 = external global i32

; ===== Extern functions that are directly called here (subset) =====
; Provide a thread-unique token (e.g., from TEB/GS).
declare i8* @get_current_thread_token()

; Observed calls with ECX=31 or 8, returning EAX. Modeled as i32(i32).
declare i32 @sub_140002A30(i32)

; Observed tail where ECX := EAX from previous, then call.
declare void @sub_140002B60(i32)


; ===== Function: sub_140001010 =====
define i32 @sub_140001010() {
entry:
  ; Acquire thread-unique token to own the lock (models rsi = [gs:0x30]+0x8 in asm).
  %token = call i8* @get_current_thread_token()

  br label %acquire

; lock acquisition: try to set @off_140004450 from null to %token
acquire:
  %cmpxchg.pair = cmpxchg i8* @off_140004450, i8* null, i8* %token seq_cst seq_cst
  %old.owner    = extractvalue { i8*, i1 } %cmpxchg.pair, 0
  %acq.success  = extractvalue { i8*, i1 } %cmpxchg.pair, 1
  br i1 %acq.success, label %acquired_noreent, label %acquire_failed

acquire_failed:
  ; Reentrant if the current owner equals our token.
  %reent = icmp eq i8* %old.owner, %token
  br i1 %reent, label %acquired_reent, label %sleep_then_retry

sleep_then_retry:
  ; Call through the indirect sleep-like callback with 1000 ms, then retry.
  %sleep.fp = load void (i32)*, void (i32)** @qword_140008280
  call void %sleep.fp(i32 1000)
  br label %acquire

acquired_noreent:
  ; r14d := 0 (not reentrant)
  br label %after_lock

acquired_reent:
  ; r14d := 1 (reentrant acquisition)
  br label %after_lock

after_lock:
  ; r14flag models the r14d flag in the disassembly (0 = first-time, 1 = reentrant).
  %r14flag = phi i1 [ false, %acquired_noreent ], [ true, %acquired_reent ]

  ; Load and inspect the state value (*off_140004460).
  %state.val = load i32, i32* @off_140004460, align 4
  %state.eq1 = icmp eq i32 %state.val, 1
  br i1 %state.eq1, label %state_is_1, label %check_state_zero

; Matches loc_1400013C8 then loc_1400013D2 tail when state==1.
state_is_1:
  %a30.ret = call i32 @sub_140002A30(i32 31)
  ; If dword_140007008 == 0, then ECX := EAX and call sub_140002B60.
  %flag.7008   = load i32, i32* @dword_140007008, align 4
  %flag.is.zero = icmp eq i32 %flag.7008, 0
  br i1 %flag.is.zero, label %call_b60, label %epilogue

call_b60:
  call void @sub_140002B60(i32 %a30.ret)
  br label %return_zero

check_state_zero:
  ; If state == 0, set it to 1 and proceed through the init-like path.
  %state.is.zero = icmp eq i32 %state.val, 0
  br i1 %state.is.zero, label %init_path, label %set_dword_7004

; Corresponds to loc_140001110 (set state to 1) then elided heavy init.
init_path:
  store i32 1, i32* @off_140004460, align 4
  ; Conservatively mirror visible side-effects: set dword_140007004 := 1.
  store i32 1, i32* @dword_140007004, align 4
  br label %post_init

; Corresponds to loc_14000107A/loc_140001084 path setting dword_140007004 := 1.
set_dword_7004:
  store i32 1, i32* @dword_140007004, align 4
  br label %post_init

; After init/flag updates: if r14flag == 0 (non-reentrant), release the lock.
post_init:
  %need.release = xor i1 %r14flag, true
  br i1 %need.release, label %release_lock, label %no_release

; Matches loc_140001328: xor eax,eax ; xchg rax, [rbx] — effectively clear owner.
release_lock:
  %prev.owner = atomicrmw xchg i8* @off_140004450, i8* null seq_cst
  br label %proceed_after_release

no_release:
  br label %proceed_after_release

; Proceeds similarly to loc_14000108D and beyond; details elided.
proceed_after_release:
  br label %epilogue

epilogue:
  ; Default conservative return.
  br label %return_zero

return_zero:
  ret i32 0
}