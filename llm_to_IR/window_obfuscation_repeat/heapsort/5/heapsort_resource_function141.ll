; ModuleID: tls_callback_module
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@init_state = internal global i32 0, align 4
@off_140004370 = global i32* @init_state, align 8
@tls_callbacks = internal constant [0 x void ()*] zeroinitializer, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p_state_ptr = load i32*, i32** @off_140004370, align 8
  %state_val = load i32, i32* %p_state_ptr, align 4
  %cmp_state = icmp eq i32 %state_val, 2
  br i1 %cmp_state, label %after_state, label %set_state

set_state:
  store i32 2, i32* %p_state_ptr, align 4
  br label %after_state

after_state:
  %is_reason_2 = icmp eq i32 %Reason, 2
  br i1 %is_reason_2, label %reason2, label %check_reason1

check_reason1:
  %is_reason_1 = icmp eq i32 %Reason, 1
  br i1 %is_reason_1, label %tailcall, label %ret

tailcall:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void

reason2:
  %begin = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @tls_callbacks, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @tls_callbacks, i64 0, i64 0
  %empty = icmp eq void ()** %begin, %end
  br i1 %empty, label %ret2, label %loop

loop:
  %cur = phi void ()** [ %begin, %reason2 ], [ %next, %loop_cont ]
  %fp = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %loop_skip_call, label %loop_do_call

loop_do_call:
  call void %fp()
  br label %loop_cont

loop_skip_call:
  br label %loop_cont

loop_cont:
  %next = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %done = icmp eq void ()** %next, %end
  br i1 %done, label %ret2, label %loop

ret2:
  ret void
}