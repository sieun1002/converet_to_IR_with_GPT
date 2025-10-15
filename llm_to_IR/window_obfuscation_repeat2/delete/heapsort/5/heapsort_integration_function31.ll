; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = global [0 x void ()*] zeroinitializer, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %rcx, i32 %edx, i8* %r8) {
entry:
  %gptr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %gptr, align 4
  %cmp = icmp eq i32 %val, 2
  br i1 %cmp, label %check_reason, label %store_two

store_two:
  store i32 2, i32* %gptr, align 4
  br label %check_reason

check_reason:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %reason2, label %check1

check1:
  %cmp1 = icmp eq i32 %edx, 1
  br i1 %cmp1, label %reason1, label %ret

reason2:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %cmpse = icmp eq void ()** %start, %end
  br i1 %cmpse, label %ret, label %loop

loop:
  %rbx0 = phi void ()** [ %start, %reason2 ], [ %rbx.next, %loop.cont ]
  %fptr = load void ()*, void ()** %rbx0, align 8
  %isnull = icmp eq void ()* %fptr, null
  br i1 %isnull, label %inc, label %call

call:
  call void %fptr()
  br label %inc

inc:
  %rbx.next = getelementptr inbounds void ()*, void ()** %rbx0, i64 1
  %done = icmp eq void ()** %rbx.next, %end
  br i1 %done, label %ret, label %loop.cont

loop.cont:
  br label %loop

reason1:
  call void @sub_1400023D0(i8* %rcx, i32 %edx, i8* %r8)
  br label %ret

ret:
  ret void
}