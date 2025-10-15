; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external dso_local global i32*, align 8
@unk_140004BE0 = external dso_local global [0 x void ()*], align 8

declare dso_local void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)

define dso_local void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %pflag.ptr.addr = load i32*, i32** @off_140004370, align 8
  %pflag.val = load i32, i32* %pflag.ptr.addr, align 4
  %is2_init = icmp eq i32 %pflag.val, 2
  br i1 %is2_init, label %after_init, label %set_init

set_init:
  store i32 2, i32* %pflag.ptr.addr, align 4
  br label %after_init

after_init:
  %is_reason_2 = icmp eq i32 %Reason, 2
  br i1 %is_reason_2, label %on_attach, label %check_detach

check_detach:
  %is_reason_1 = icmp eq i32 %Reason, 1
  br i1 %is_reason_1, label %on_detach, label %ret

on_attach:
  %begin0 = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end0 = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %empty = icmp eq void ()** %begin0, %end0
  br i1 %empty, label %ret, label %loop

loop:
  %cur = phi void ()** [ %begin0, %on_attach ], [ %next, %loop_cont ]
  %fp = load void ()*, void ()** %cur, align 8
  %nonnull = icmp ne void ()* %fp, null
  br i1 %nonnull, label %do_call, label %loop_cont

do_call:
  call void %fp()
  br label %loop_cont

loop_cont:
  %next = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %done = icmp eq void ()** %next, %end0
  br i1 %done, label %ret, label %loop

on_detach:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}