; ModuleID = 'tls_module'
target triple = "x86_64-pc-windows-msvc"

@g_tls_state = internal global i32 0, align 4
@off_140004370 = dso_local global i32* @g_tls_state, align 8
@tls_array = internal global [0 x void (i8*, i32, i8*)*] zeroinitializer, align 8

declare dso_local void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %pstate.ptrptr = load i32*, i32** @off_140004370, align 8
  %old = load i32, i32* %pstate.ptrptr, align 4
  %cmpold = icmp eq i32 %old, 2
  br i1 %cmpold, label %after_state, label %set_state

set_state:
  store i32 2, i32* %pstate.ptrptr, align 4
  br label %after_state

after_state:
  %isReason2 = icmp eq i32 %Reason, 2
  br i1 %isReason2, label %on_reason2, label %check_reason1

check_reason1:
  %isReason1 = icmp eq i32 %Reason, 1
  br i1 %isReason1, label %call_sub, label %ret

ret:
  ret void

call_sub:
  call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

on_reason2:
  %start = getelementptr inbounds [0 x void (i8*, i32, i8*)*], [0 x void (i8*, i32, i8*)*]* @tls_array, i64 0, i64 0
  %end = getelementptr inbounds [0 x void (i8*, i32, i8*)*], [0 x void (i8*, i32, i8*)*]* @tls_array, i64 0, i64 0
  %empty = icmp eq void (i8*, i32, i8*)** %start, %end
  br i1 %empty, label %ret2, label %loop

ret2:
  ret void

loop:
  %it = phi void (i8*, i32, i8*)** [ %start, %on_reason2 ], [ %next, %cont ]
  %fn = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %it, align 8
  %isnull = icmp eq void (i8*, i32, i8*)* %fn, null
  br i1 %isnull, label %cont, label %docall

docall:
  call void %fn(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %cont

cont:
  %next = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %it, i64 1
  %done = icmp eq void (i8*, i32, i8*)** %next, %end
  br i1 %done, label %ret3, label %loop

ret3:
  ret void
}