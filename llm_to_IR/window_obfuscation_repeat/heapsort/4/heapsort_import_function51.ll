; ModuleID = 'tls_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@global_int_target = internal global i32 0, align 4
@off_140004370 = internal global i32* @global_int_target, align 8
@tls_callbacks = internal constant [0 x void ()*] zeroinitializer, align 8

declare void @sub_1400023D0()

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %p_ptrptr = load i32*, i32** @off_140004370, align 8
  %p_loaded = load i32, i32* %p_ptrptr, align 4
  %cmp2 = icmp eq i32 %p_loaded, 2
  br i1 %cmp2, label %check_reason, label %set_two

set_two:
  store i32 2, i32* %p_ptrptr, align 4
  br label %check_reason

check_reason:
  %is_thread_attach = icmp eq i32 %Reason, 2
  br i1 %is_thread_attach, label %thread_attach, label %check_process

check_process:
  %is_process_attach = icmp eq i32 %Reason, 1
  br i1 %is_process_attach, label %process_attach, label %ret

thread_attach:
  %start = getelementptr [0 x void ()*], [0 x void ()*]* @tls_callbacks, i64 0, i64 0
  %end = getelementptr [0 x void ()*], [0 x void ()*]* @tls_callbacks, i64 0, i64 0
  br label %loop

loop:
  %cur = phi void ()** [ %start, %thread_attach ], [ %next, %latch ]
  %cmpdone = icmp eq void ()** %cur, %end
  br i1 %cmpdone, label %ret, label %body

body:
  %fnptr = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fnptr, null
  br i1 %isnull, label %latch, label %call

call:
  call void %fnptr()
  br label %latch

latch:
  %next = getelementptr void ()*, void ()** %cur, i64 1
  br label %loop

process_attach:
  call void @sub_1400023D0()
  br label %ret

ret:
  ret void
}