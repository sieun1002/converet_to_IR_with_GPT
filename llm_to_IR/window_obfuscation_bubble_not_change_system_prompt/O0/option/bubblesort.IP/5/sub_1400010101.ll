; ModuleID = 'sub_140001010'
target triple = "x86_64-pc-windows-msvc"

declare i8** @sub_140002660()
declare i32 @sub_140002880(i32, i8*, i8*)
declare void @sub_140002750()
declare i32 @sub_140002670(i32)
declare void @sub_1400027A0(i32) noreturn
declare void @sub_1400018D0()
declare void @sub_14000ED64(void ()*)
declare void @sub_140001CB0()

@off_140004470 = external global i64*
@qword_140008280 = external global void (i32)*
@off_140004480 = external global i32*
@off_1400043F0 = external global void (i32, i32, i32)**
@dword_140007004 = external global i32
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8*
@dword_140007008 = external global i32

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %rsi_ptr = call i8* asm sideeffect "movl $$0x30, %eax; movq %gs:(%rax), %rax; movq 8(%rax), %rax", "={rax},~{dirflag},~{fpsr},~{flags}"()
  %rsi_i64 = ptrtoint i8* %rsi_ptr to i64
  %lockaddr_ptr = load i64*, i64** @off_140004470, align 8
  %sleep_fp = load void (i32)*, void (i32)** @qword_140008280, align 8
  br label %cmpxchg_loop_try

cmpxchg_loop_try:                                  ; 0x140001050
  %cmpres = cmpxchg i64* %lockaddr_ptr, i64 0, i64 %rsi_i64 seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpres, 0
  %success = extractvalue { i64, i1 } %cmpres, 1
  br i1 %success, label %after_lock, label %cmpxchg_fail

cmpxchg_fail:                                      ; 0x140001040
  %eq = icmp eq i64 %old, %rsi_i64
  br i1 %eq, label %set_r14_and_after_lock, label %sleep_and_retry

sleep_and_retry:
  call void %sleep_fp(i32 1000)
  br label %cmpxchg_loop_try

set_r14_and_after_lock:                            ; 0x140001100
  br label %after_lock

after_lock:                                        ; 0x14000105C
  %r14_flag = phi i1 [ false, %cmpxchg_loop_try ], [ true, %set_r14_and_after_lock ]
  %pflag_ptr = load i32*, i32** @off_140004480, align 8
  %flag1 = load i32, i32* %pflag_ptr, align 4
  %is_one = icmp eq i32 %flag1, 1
  br i1 %is_one, label %call_2670, label %check_zero

check_zero:
  %flag2 = load i32, i32* %pflag_ptr, align 4
  %is_zero = icmp eq i32 %flag2, 0
  br i1 %is_zero, label %do_init, label %after_init

do_init:                                           ; 0x140001110
  store i32 1, i32* %pflag_ptr, align 4
  call void @sub_1400018D0()
  call void @sub_14000ED64(void ()* @sub_140001CB0)
  br label %after_init

after_init:                                        ; 0x14000107A
  store i32 1, i32* @dword_140007004, align 4
  br i1 %r14_flag, label %skip_release, label %release_and_continue

release_and_continue:                              ; 0x140001328
  %oldx = atomicrmw xchg i64* %lockaddr_ptr, i64 0 seq_cst
  br label %cont_after_release

skip_release:
  br label %cont_after_release

cont_after_release:                                ; 0x14000108D
  %fpptrptr = load void (i32, i32, i32)**, void (i32, i32, i32)*** @off_1400043F0, align 8
  %fpptr = load void (i32, i32, i32)*, void (i32, i32, i32)** %fpptrptr, align 8
  %has_fp = icmp ne void (i32, i32, i32)* %fpptr, null
  br i1 %has_fp, label %call_fp, label %after_fp

call_fp:
  call void %fpptr(i32 0, i32 2, i32 0)
  br label %after_fp

after_fp:                                          ; 0x1400010A8
  %storage = call i8** @sub_140002660()
  %r8val = load i8*, i8** @qword_140007010, align 8
  store i8* %r8val, i8** %storage, align 8
  %ecxval = load i32, i32* @dword_140007020, align 4
  %rdxval = load i8*, i8** @qword_140007018, align 8
  %ret = call i32 @sub_140002880(i32 %ecxval, i8* %rdxval, i8* %r8val)
  %ecx2 = load i32, i32* @dword_140007008, align 4
  %is_zero_ecx2 = icmp eq i32 %ecx2, 0
  br i1 %is_zero_ecx2, label %call_27A0, label %check_edxflag

check_edxflag:                                     ; 0x1400010DD
  %edxflag = load i32, i32* @dword_140007004, align 4
  %is_zero_edx = icmp eq i32 %edxflag, 0
  br i1 %is_zero_edx, label %call_2750_and_ret, label %ret_normal

ret_normal:                                        ; 0x1400010E5
  ret i32 %ret

call_2750_and_ret:                                 ; 0x140001310
  call void @sub_140002750()
  ret i32 %ret

call_2670:                                         ; 0x1400013C8
  %r = call i32 @sub_140002670(i32 31)
  br label %call_27A0

call_27A0:                                         ; 0x1400013D2
  %code = phi i32 [ %r, %call_2670 ], [ %ret, %after_fp ]
  call void @sub_1400027A0(i32 %code)
  unreachable
}