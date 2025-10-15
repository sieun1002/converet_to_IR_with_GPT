; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global void ()*, align 8

declare void @sub_1400023D0()

define void @TlsCallback_1(i8* %rcx, i32 %edx, i8* %r8) {
entry:
  %paddr = load i32*, i32** @off_140004370
  %cur = load i32, i32* %paddr
  %is2 = icmp eq i32 %cur, 2
  br i1 %is2, label %afterSet, label %doSet

doSet:
  store i32 2, i32* %paddr
  br label %afterSet

afterSet:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %on2, label %check1

check1:
  %cmp1 = icmp eq i32 %edx, 1
  br i1 %cmp1, label %on1, label %ret

ret:
  ret void

on2:
  %start = getelementptr inbounds void ()*, void ()** @unk_140004BE0, i64 0
  %end = getelementptr inbounds void ()*, void ()** @unk_140004BE0, i64 0
  %eq = icmp eq void ()** %start, %end
  br i1 %eq, label %ret2, label %loop

loop:
  %i = phi void ()** [ %start, %on2 ], [ %next, %skip ]
  %fptr = load void ()*, void ()** %i
  %isnull = icmp eq void ()* %fptr, null
  br i1 %isnull, label %skip, label %call

call:
  call void %fptr()
  br label %skip

skip:
  %next = getelementptr inbounds void ()*, void ()** %i, i64 1
  %cond = icmp ne void ()** %next, %end
  br i1 %cond, label %loop, label %ret2

ret2:
  ret void

on1:
  call void @sub_1400023D0()
  ret void
}