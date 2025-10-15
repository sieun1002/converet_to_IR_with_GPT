; ModuleID = 'tls_callback_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global i8*
@unk_140004BE0_end = external global i8*

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %p_addr = load i32*, i32** @off_140004370, align 8
  %old_val = load i32, i32* %p_addr, align 4
  %is_two = icmp eq i32 %old_val, 2
  br i1 %is_two, label %after_set, label %do_set

do_set:
  store i32 2, i32* %p_addr, align 4
  br label %after_set

after_set:
  switch i32 %Reason, label %ret [
    i32 2, label %case_thread_attach
    i32 1, label %case_process_attach
  ]

case_thread_attach:
  %start_ptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %end_ptr = getelementptr i8*, i8** @unk_140004BE0_end, i64 0
  %is_empty = icmp eq i8** %start_ptr, %end_ptr
  br i1 %is_empty, label %ret, label %loop

loop:
  %curr = phi i8** [ %start_ptr, %case_thread_attach ], [ %next, %loop_latch ]
  %entry_ptr = load i8*, i8** %curr, align 8
  %is_null = icmp eq i8* %entry_ptr, null
  br i1 %is_null, label %loop_latch, label %do_call

do_call:
  %fn = bitcast i8* %entry_ptr to void ()*
  call void %fn()
  br label %loop_latch

loop_latch:
  %next = getelementptr i8*, i8** %curr, i64 1
  %done = icmp eq i8** %next, %end_ptr
  br i1 %done, label %ret, label %loop

case_process_attach:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}