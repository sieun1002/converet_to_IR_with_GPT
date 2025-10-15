; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = global [0 x void ()*] zeroinitializer, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %arg0, i32 %arg1, i8* %arg2) {
entry:
  %pstate.ptr = load i32*, i32** @off_140004370, align 8
  %cur = load i32, i32* %pstate.ptr, align 4
  %is2 = icmp eq i32 %cur, 2
  br i1 %is2, label %after_state, label %set2

set2:
  store i32 2, i32* %pstate.ptr, align 4
  br label %after_state

after_state:
  %r_is_2 = icmp eq i32 %arg1, 2
  br i1 %r_is_2, label %case_2, label %check_1

check_1:
  %r_is_1 = icmp eq i32 %arg1, 1
  br i1 %r_is_1, label %case_1, label %ret

case_2:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %empty = icmp eq void ()** %start, %end
  br i1 %empty, label %ret, label %loop

loop:
  %it = phi void ()** [ %start, %case_2 ], [ %next, %loop_cont ]
  %fp = load void ()*, void ()** %it, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %after_call, label %do_call

do_call:
  call void %fp()
  br label %after_call

after_call:
  %next = getelementptr inbounds void ()*, void ()** %it, i64 1
  %more = icmp ne void ()** %next, %end
  br i1 %more, label %loop_cont, label %ret

loop_cont:
  br label %loop

case_1:
  tail call void @sub_1400023D0(i8* %arg0, i32 %arg1, i8* %arg2)
  ret void

ret:
  ret void
}