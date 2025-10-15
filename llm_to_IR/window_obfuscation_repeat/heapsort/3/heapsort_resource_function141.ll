; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0()

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = global [0 x void ()*] zeroinitializer, align 8

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %pglob = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %pglob, align 4
  %cmp = icmp eq i32 %val, 2
  br i1 %cmp, label %check_reason, label %setval

setval:
  store i32 2, i32* %pglob, align 4
  br label %check_reason

check_reason:
  switch i32 %Reason, label %ret [
    i32 2, label %case2
    i32 1, label %case1
  ]

ret:
  ret void

case2:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %cmpstart = icmp eq void ()** %start, %end
  br i1 %cmpstart, label %ret2, label %loop

loop:
  %phi.p = phi void ()** [ %start, %case2 ], [ %next, %loop.body_end ]
  %f = load void ()*, void ()** %phi.p, align 8
  %isnull = icmp eq void ()* %f, null
  br i1 %isnull, label %skipcall, label %docall

docall:
  call void %f()
  br label %loop.body_end

skipcall:
  br label %loop.body_end

loop.body_end:
  %next = getelementptr inbounds void ()*, void ()** %phi.p, i64 1
  %cmpnext = icmp eq void ()** %next, %end
  br i1 %cmpnext, label %ret2, label %loop

ret2:
  ret void

case1:
  call void @sub_1400023D0()
  ret void
}