; ModuleID = 'tls_callback'
source_filename = "tls_callback.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@tls_state = internal global i32 0, align 4
@off_140004370 = global i32* @tls_state, align 8
@tls_hooks = internal global [1 x void ()*] zeroinitializer, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p = load i32*, i32** @off_140004370, align 8
  %old = load i32, i32* %p, align 4
  %cmp = icmp eq i32 %old, 2
  br i1 %cmp, label %after_set, label %set_to_2

set_to_2:
  store i32 2, i32* %p, align 4
  br label %after_set

after_set:
  %is2 = icmp eq i32 %Reason, 2
  br i1 %is2, label %on2, label %chk1

chk1:
  %is1 = icmp eq i32 %Reason, 1
  br i1 %is1, label %on1, label %ret

on2:
  %start = getelementptr inbounds [1 x void ()*], [1 x void ()*]* @tls_hooks, i64 1, i64 0
  %end = getelementptr inbounds [1 x void ()*], [1 x void ()*]* @tls_hooks, i64 1, i64 0
  %empty = icmp eq void ()** %start, %end
  br i1 %empty, label %ret, label %loop

loop:
  %cur = phi void ()** [ %start, %on2 ], [ %next, %loop_update ]
  %fp = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %skip, label %do_call

do_call:
  call void %fp()
  br label %skip

skip:
  %next = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %more = icmp ne void ()** %next, %end
  br i1 %more, label %loop_update, label %ret

loop_update:
  br label %loop

on1:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}