; ModuleID = 'tls_callback_module'
source_filename = "tls_callback_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@g_state = dso_local global i32 0, align 4
@off_140004370 = dso_local global i32* @g_state, align 8
@tls_funcs = internal global [0 x void ()*] zeroinitializer, align 8

declare dso_local void @sub_1400023D0(i8* %h, i32 %reason, i8* %reserved)

define dso_local void @TlsCallback_1(i8* %h, i32 %reason, i8* %reserved) {
entry:
  %p_state_ptr = load i32*, i32** @off_140004370, align 8
  %state = load i32, i32* %p_state_ptr, align 4
  %is2 = icmp eq i32 %state, 2
  br i1 %is2, label %after_set, label %set2

set2:
  store i32 2, i32* %p_state_ptr, align 4
  br label %after_set

after_set:
  %is_reason_2 = icmp eq i32 %reason, 2
  br i1 %is_reason_2, label %reason2, label %check_reason1

check_reason1:
  %is_reason_1 = icmp eq i32 %reason, 1
  br i1 %is_reason_1, label %do_jump, label %ret

ret:
  ret void

reason2:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @tls_funcs, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @tls_funcs, i64 0, i64 0
  %empty = icmp eq void ()** %start, %end
  br i1 %empty, label %ret2, label %loop

loop:
  %iter = phi void ()** [ %start, %reason2 ], [ %next, %inc ]
  %cur = load void ()*, void ()** %iter, align 8
  %isnull = icmp eq void ()* %cur, null
  br i1 %isnull, label %inc, label %do_call

do_call:
  call void %cur()
  br label %inc

inc:
  %next = getelementptr inbounds void ()*, void ()** %iter, i64 1
  %done = icmp eq void ()** %next, %end
  br i1 %done, label %ret2, label %loop

ret2:
  ret void

do_jump:
  tail call void @sub_1400023D0(i8* %h, i32 %reason, i8* %reserved)
  ret void
}