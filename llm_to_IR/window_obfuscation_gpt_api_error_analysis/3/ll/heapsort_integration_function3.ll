; target: Windows x64
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external dso_local global i32*, align 8
@__tls_cb_start = external dso_local global void (i8*, i32, i8*)*, align 8
@__tls_cb_end   = external dso_local global void (i8*, i32, i8*)*, align 8

declare dso_local void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p_ptr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p_ptr, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %check_reason, label %set_two

set_two:
  store i32 2, i32* %p_ptr, align 4
  br label %check_reason

check_reason:
  %is_thread_attach = icmp eq i32 %Reason, 2
  br i1 %is_thread_attach, label %tls_scan_init, label %check_process_attach

check_process_attach:
  %is_process_attach = icmp eq i32 %Reason, 1
  br i1 %is_process_attach, label %tail_jump, label %ret

tls_scan_init:
  %empty = icmp eq void (i8*, i32, i8*)** @__tls_cb_start, @__tls_cb_end
  br i1 %empty, label %ret, label %loop

loop:
  %it = phi void (i8*, i32, i8*)** [ @__tls_cb_start, %tls_scan_init ], [ %next, %loop_latch ]
  %fp = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %it, align 8
  %isnull = icmp eq void (i8*, i32, i8*)* %fp, null
  br i1 %isnull, label %loop_latch, label %do_call

do_call:
  call void %fp(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %loop_latch

loop_latch:
  %next = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %it, i64 1
  %done = icmp eq void (i8*, i32, i8*)** %next, @__tls_cb_end
  br i1 %done, label %ret, label %loop

tail_jump:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}