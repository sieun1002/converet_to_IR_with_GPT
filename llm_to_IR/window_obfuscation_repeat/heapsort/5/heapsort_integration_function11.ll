; ModuleID = 'fixed'
source_filename = "fixed"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_140007004 = global i32 0, align 4
@g_lock_storage = global i64 0, align 8
@off_140004450 = global i64* @g_lock_storage, align 8
@qword_140008280 = global void (i32)* null, align 8

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %lock.addr = load i64*, i64** @off_140004450, align 8
  br label %try_lock

try_lock:                                         ; preds = %again, %entry
  %cmpx = cmpxchg i64* %lock.addr, i64 0, i64 1 seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpx, 0
  %ok = extractvalue { i64, i1 } %cmpx, 1
  br i1 %ok, label %locked, label %fail

fail:                                             ; preds = %try_lock
  %fn = load void (i32)*, void (i32)** @qword_140008280, align 8
  %isnull = icmp eq void (i32)* %fn, null
  br i1 %isnull, label %again, label %do_call

do_call:                                          ; preds = %fail
  call void %fn(i32 1000)
  br label %again

again:                                            ; preds = %do_call, %fail
  br label %try_lock

locked:                                           ; preds = %try_lock
  store i32 1, i32* @dword_140007004, align 4
  store i64 0, i64* %lock.addr, align 8
  ret i32 0
}