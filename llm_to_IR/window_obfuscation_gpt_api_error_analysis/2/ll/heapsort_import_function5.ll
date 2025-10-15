; ModuleID = 'TlsCallback_1.ll'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0()

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global void ()*, align 8

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p_global_ptr = load i32*, i32** @off_140004370, align 8
  %current = load i32, i32* %p_global_ptr, align 4
  %is2 = icmp eq i32 %current, 2
  br i1 %is2, label %after_set, label %do_set

do_set:
  store i32 2, i32* %p_global_ptr, align 4
  br label %after_set

after_set:
  %isReason2 = icmp eq i32 %Reason, 2
  br i1 %isReason2, label %case2, label %check1

check1:
  %isReason1 = icmp eq i32 %Reason, 1
  br i1 %isReason1, label %case1, label %ret

case2:
  %start = getelementptr inbounds void ()*, void ()** @unk_140004BE0, i64 0
  %end = getelementptr inbounds void ()*, void ()** @unk_140004BE0, i64 0
  %empty = icmp eq void ()** %start, %end
  br i1 %empty, label %ret2, label %loop_check

loop_check:
  %it = phi void ()** [ %start, %case2 ], [ %nextptr, %inc ]
  %cond = icmp ne void ()** %it, %end
  br i1 %cond, label %loop_body, label %ret2

loop_body:
  %fptr = load void ()*, void ()** %it, align 8
  %isnull = icmp eq void ()* %fptr, null
  br i1 %isnull, label %inc, label %call

call:
  call void %fptr()
  br label %inc

inc:
  %nextptr = getelementptr inbounds void ()*, void ()** %it, i64 1
  br label %loop_check

case1:
  tail call void @sub_1400023D0()
  ret void

ret2:
  ret void

ret:
  ret void
}