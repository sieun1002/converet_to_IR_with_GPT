; ModuleID = 'tls_callback_module'
source_filename = "tls_callback_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@g_state = internal global i32 0, align 4
@off_140004370 = internal global i32* @g_state, align 8
@unk_140004BE0 = internal global [1 x void ()*] zeroinitializer, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_1(i8* %hModule, i32 %reason, i8* %reserved) local_unnamed_addr {
entry:
  %p_ptr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p_ptr, align 4
  %is2 = icmp eq i32 %val, 2
  br i1 %is2, label %after_set, label %setit

setit:
  store i32 2, i32* %p_ptr, align 4
  br label %after_set

after_set:
  %is_reason_2 = icmp eq i32 %reason, 2
  br i1 %is_reason_2, label %thread_attach, label %check_reason_1

check_reason_1:
  %is_reason_1 = icmp eq i32 %reason, 1
  br i1 %is_reason_1, label %tailcall_sub, label %ret

ret:
  ret void

tailcall_sub:
  tail call void @sub_1400023D0(i8* %hModule, i32 %reason, i8* %reserved)
  ret void

thread_attach:
  %start = getelementptr inbounds [1 x void ()*], [1 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [1 x void ()*], [1 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %empty = icmp eq void ()** %start, %end
  br i1 %empty, label %ret, label %loop

loop:
  %cur = phi void ()** [ %start, %thread_attach ], [ %next, %loop_continue ]
  %fnptr = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fnptr, null
  br i1 %isnull, label %skipcall, label %docall

docall:
  call void %fnptr()
  br label %skipcall

skipcall:
  br label %loop_continue

loop_continue:
  %next = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %cont = icmp ne void ()** %next, %end
  br i1 %cont, label %loop, label %ret
}