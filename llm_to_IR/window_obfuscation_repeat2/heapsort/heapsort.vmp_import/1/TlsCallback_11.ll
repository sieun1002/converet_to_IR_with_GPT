; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global void ()*

declare void @sub_140002370(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %offptr = load i32*, i32** @off_140004370
  %old = load i32, i32* %offptr
  %cmp_old = icmp eq i32 %old, 2
  br i1 %cmp_old, label %after_set, label %set_val

set_val:
  store i32 2, i32* %offptr
  br label %after_set

after_set:
  %is_two = icmp eq i32 %Reason, 2
  br i1 %is_two, label %case2, label %check_one

check_one:
  %is_one = icmp eq i32 %Reason, 1
  br i1 %is_one, label %case1, label %ret

case2:
  %start = getelementptr void ()*, void ()** @unk_140004BE0, i64 0
  %end = getelementptr void ()*, void ()** @unk_140004BE0, i64 0
  %range_empty = icmp eq void ()** %start, %end
  br i1 %range_empty, label %ret, label %loop

loop:
  %p = phi void ()** [ %start, %case2 ], [ %next, %latch ]
  %fp = load void ()*, void ()** %p
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %cont, label %do_call

do_call:
  call void %fp()
  br label %cont

cont:
  br label %latch

latch:
  %next = getelementptr void ()*, void ()** %p, i64 1
  %more = icmp ne void ()** %next, %end
  br i1 %more, label %loop, label %ret

case1:
  tail call void @sub_140002370(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}