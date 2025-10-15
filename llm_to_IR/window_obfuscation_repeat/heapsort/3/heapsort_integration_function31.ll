; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_140004370 = external dso_local global i32*, align 8
@tls_callbacks = internal dso_local global [0 x void ()*] zeroinitializer, align 8

declare dso_local void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %ptrptr = load i32*, i32** @off_140004370, align 8
  %old = load i32, i32* %ptrptr, align 4
  %is2 = icmp eq i32 %old, 2
  br i1 %is2, label %after_set, label %set

set:
  store i32 2, i32* %ptrptr, align 4
  br label %after_set

after_set:
  switch i32 %Reason, label %ret [
    i32 2, label %thread_attach
    i32 1, label %process_attach
  ]

thread_attach:
  %startptr = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @tls_callbacks, i64 0, i64 0
  %endptr = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @tls_callbacks, i64 0, i64 0
  %empty = icmp eq void ()** %startptr, %endptr
  br i1 %empty, label %ret, label %loop

loop:
  %p = phi void ()** [ %startptr, %thread_attach ], [ %next, %loop_end ]
  %fp = load void ()*, void ()** %p, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %loop_end, label %do_call

do_call:
  call void %fp()
  br label %loop_end

loop_end:
  %next = getelementptr inbounds void ()*, void ()** %p, i64 1
  %done = icmp eq void ()** %next, %endptr
  br i1 %done, label %ret, label %loop

process_attach:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}