; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global void ()*, align 8

declare void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p = load i32*, i32** @off_140004370, align 8
  %v = load i32, i32* %p, align 4
  %cmp = icmp eq i32 %v, 2
  br i1 %cmp, label %after_set, label %do_set

do_set:
  store i32 2, i32* %p, align 4
  br label %after_set

after_set:
  %is2 = icmp eq i32 %Reason, 2
  br i1 %is2, label %case2, label %check1

check1:
  %is1 = icmp eq i32 %Reason, 1
  br i1 %is1, label %case1, label %ret

case2:
  %rbx0 = getelementptr inbounds void ()*, void ()** @unk_140004BE0, i64 0
  %rsi = getelementptr inbounds void ()*, void ()** @unk_140004BE0, i64 0
  %empty = icmp eq void ()** %rbx0, %rsi
  br i1 %empty, label %ret, label %loop

loop:
  %rbx = phi void ()** [ %rbx0, %case2 ], [ %rbx.next, %aftercall ]
  %fn = load void ()*, void ()** %rbx, align 8
  %isnull = icmp eq void ()* %fn, null
  br i1 %isnull, label %aftercall, label %docall

docall:
  call void %fn()
  br label %aftercall

aftercall:
  %rbx.next = getelementptr inbounds void ()*, void ()** %rbx, i64 1
  %cont = icmp ne void ()** %rbx.next, %rsi
  br i1 %cont, label %loop, label %ret

case1:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}