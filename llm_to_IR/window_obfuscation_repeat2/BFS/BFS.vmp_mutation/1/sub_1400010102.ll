; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004470 = external global i8*
@__imp_Sleep = external global void (i32)*

define void @sub_140001010() {
entry:
  %lock_ptr_i8 = load i8*, i8** @off_140004470
  %lock_addr = bitcast i8* %lock_ptr_i8 to i8**
  br label %try_lock

try_lock:                                         ; preds = %sleep, %entry
  %cmpx = cmpxchg i8** %lock_addr, i8* null, i8* null seq_cst monotonic
  %old = extractvalue { i8*, i1 } %cmpx, 0
  %ok = extractvalue { i8*, i1 } %cmpx, 1
  br i1 %ok, label %acquired, label %failed

failed:                                           ; preds = %try_lock
  %owned = icmp eq i8* %old, null
  br i1 %owned, label %owned_path, label %sleep

sleep:                                            ; preds = %failed
  %sleep_fn = load void (i32)*, void (i32)** @__imp_Sleep
  call void %sleep_fn(i32 1000)
  br label %try_lock

owned_path:                                       ; preds = %failed
  br label %acquired

acquired:                                         ; preds = %owned_path, %try_lock
  ret void
}