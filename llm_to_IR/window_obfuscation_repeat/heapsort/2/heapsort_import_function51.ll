; ModuleID = 'tls_callback_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@g_tls_state = internal global i32 0, align 4
@off_140004370 = internal global i32* @g_tls_state, align 8
@unk_140004BE0 = external global [0 x void ()*]

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p_ptr = load i32*, i32** @off_140004370, align 8
  %curval = load i32, i32* %p_ptr, align 4
  %is2 = icmp eq i32 %curval, 2
  br i1 %is2, label %after_set, label %set2

set2:
  store i32 2, i32* %p_ptr, align 4
  br label %after_set

after_set:
  %is_thread_attach = icmp eq i32 %Reason, 2
  br i1 %is_thread_attach, label %on_thread_attach, label %check_process_attach

check_process_attach:
  %is_process_attach = icmp eq i32 %Reason, 1
  br i1 %is_process_attach, label %tailcall_sub, label %ret

on_thread_attach:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %empty = icmp eq void ()** %start, %end
  br i1 %empty, label %ret, label %loop

loop:
  %cur = phi void ()** [ %start, %on_thread_attach ], [ %next, %cont ]
  %fnptr = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fnptr, null
  br i1 %isnull, label %cont, label %invoke

invoke:
  call void %fnptr()
  br label %cont

cont:
  %next = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %done = icmp eq void ()** %next, %end
  br i1 %done, label %ret, label %loop

tailcall_sub:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}