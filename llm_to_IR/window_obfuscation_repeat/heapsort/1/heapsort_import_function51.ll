; ModuleID = 'tls_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-f80:128-n8:16:32:64-S128"

@g_tls_flag = dso_local global i32 0, align 4
@off_140004370 = dso_local global i32* @g_tls_flag, align 8
@unk_140004BE0 = dso_local global [0 x void ()*] zeroinitializer, align 8

declare dso_local void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %p = load i32*, i32** @off_140004370, align 8
  %v = load i32, i32* %p, align 4
  %cmpv = icmp eq i32 %v, 2
  br i1 %cmpv, label %check_reason, label %set2

set2:
  store i32 2, i32* %p, align 4
  br label %check_reason

check_reason:
  %is_thread = icmp eq i32 %Reason, 2
  br i1 %is_thread, label %thread_attach, label %check_proc

check_proc:
  %is_proc = icmp eq i32 %Reason, 1
  br i1 %is_proc, label %proc_attach, label %ret

thread_attach:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %empty = icmp eq void ()** %start, %end
  br i1 %empty, label %ret, label %loop

loop:
  %iter = phi void ()** [ %start, %thread_attach ], [ %next, %after_call ]
  %fnptr = load void ()*, void ()** %iter, align 8
  %isnull = icmp eq void ()* %fnptr, null
  br i1 %isnull, label %skip_call, label %do_call

do_call:
  call void %fnptr()
  br label %after_call

skip_call:
  br label %after_call

after_call:
  %next = getelementptr inbounds void ()*, void ()** %iter, i64 1
  %cont = icmp ne void ()** %next, %end
  br i1 %cont, label %loop, label %ret

proc_attach:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}