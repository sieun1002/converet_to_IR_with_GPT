; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004450 = external global i8**
@qword_140008280 = external global i8*

define i32 @sub_140001010() {
entry:
  %r14 = alloca i1, align 1
  store i1 false, i1* %r14, align 1
  %lockaddr_ptr = load i8**, i8*** @off_140004450
  br label %spin

spin:
  %rsi = inttoptr i64 1 to i8*
  %oldpair = cmpxchg i8** %lockaddr_ptr, i8* null, i8* %rsi monotonic monotonic
  %old = extractvalue { i8*, i1 } %oldpair, 0
  %ok = extractvalue { i8*, i1 } %oldpair, 1
  br i1 %ok, label %got_lock, label %check_old

check_old:
  %is_reentrant = icmp eq i8* %old, %rsi
  br i1 %is_reentrant, label %set_reentrant, label %sleep_then_retry

set_reentrant:
  store i1 true, i1* %r14, align 1
  br label %continue_after_lock

sleep_then_retry:
  %sleep_fp_addr = load i8*, i8** @qword_140008280
  %sleep_fp_isnull = icmp eq i8* %sleep_fp_addr, null
  br i1 %sleep_fp_isnull, label %spin, label %do_sleep

do_sleep:
  %sleep = bitcast i8* %sleep_fp_addr to void (i32)*
  call void %sleep(i32 1000)
  br label %spin

got_lock:
  store i1 false, i1* %r14, align 1
  br label %continue_after_lock

continue_after_lock:
  %flag = load i1, i1* %r14, align 1
  %not_re = icmp eq i1 %flag, false
  br i1 %not_re, label %release, label %ret

release:
  %lockaddr_i64ptr = bitcast i8** %lockaddr_ptr to i64*
  %oldv64 = atomicrmw xchg i64* %lockaddr_i64ptr, i64 0 monotonic
  br label %ret

ret:
  ret i32 0
}