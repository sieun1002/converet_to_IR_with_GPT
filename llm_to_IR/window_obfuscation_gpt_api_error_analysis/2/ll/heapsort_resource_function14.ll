; ModuleID = 'tls_callback.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@__tls_cb_start = external global void ()*
@__tls_cb_end = external global void ()*

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr nounwind {
entry:
  %p.addr = load i32*, i32** @off_140004370, align 8
  %loaded = load i32, i32* %p.addr, align 4
  %cmp2 = icmp eq i32 %loaded, 2
  br i1 %cmp2, label %check_reason, label %store_two

store_two:
  store i32 2, i32* %p.addr, align 4
  br label %check_reason

check_reason:
  %is_thread_attach = icmp eq i32 %Reason, 2
  br i1 %is_thread_attach, label %thread_attach, label %check_proc

check_proc:
  %is_proc_attach = icmp eq i32 %Reason, 1
  br i1 %is_proc_attach, label %proc_attach, label %ret

ret:
  ret void

proc_attach:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

thread_attach:
  %start.ptr = getelementptr inbounds void ()*, void ()** @__tls_cb_start, i64 0
  %end.ptr = getelementptr inbounds void ()*, void ()** @__tls_cb_end, i64 0
  %eqempty = icmp eq void ()** %start.ptr, %end.ptr
  br i1 %eqempty, label %ret, label %loop

loop:
  %it.ptr = phi void ()** [ %start.ptr, %thread_attach ], [ %next.ptr, %cont ]
  %fn = load void ()*, void ()** %it.ptr, align 8
  %isnull = icmp eq void ()* %fn, null
  br i1 %isnull, label %cont, label %do_call

do_call:
  call void %fn()
  br label %cont

cont:
  %next.ptr = getelementptr inbounds void ()*, void ()** %it.ptr, i64 1
  %done = icmp eq void ()** %next.ptr, %end.ptr
  br i1 %done, label %ret, label %loop
}