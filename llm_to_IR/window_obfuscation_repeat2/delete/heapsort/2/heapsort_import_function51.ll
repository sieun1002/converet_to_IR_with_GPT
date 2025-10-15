; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = global [0 x void ()*] zeroinitializer, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %h, i32 %reason, i8* %reserved) {
entry:
  %pstat.ptrptr = load i32*, i32** @off_140004370, align 8
  %pstat.val = load i32, i32* %pstat.ptrptr, align 4
  %is.two = icmp eq i32 %pstat.val, 2
  br i1 %is.two, label %after_set, label %set_two

set_two:
  store i32 2, i32* %pstat.ptrptr, align 4
  br label %after_set

after_set:
  switch i32 %reason, label %ret [
    i32 2, label %case2
    i32 1, label %case1
  ]

case2:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %empty = icmp eq void ()** %start, %end
  br i1 %empty, label %ret, label %loop

loop:
  %cur = phi void ()** [ %start, %case2 ], [ %next, %cont ]
  %fn = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fn, null
  br i1 %isnull, label %cont, label %call

call:
  call void %fn()
  br label %cont

cont:
  %next = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %done = icmp eq void ()** %next, %end
  br i1 %done, label %ret, label %loop

case1:
  tail call void @sub_1400023D0(i8* %h, i32 %reason, i8* %reserved)
  ret void

ret:
  ret void
}