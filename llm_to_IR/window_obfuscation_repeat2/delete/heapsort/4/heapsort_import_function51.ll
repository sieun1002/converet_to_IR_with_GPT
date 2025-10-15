; ModuleID: 'module'
source_filename = "module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global [0 x void ()*], align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %paddr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %paddr, align 4
  %cmp = icmp eq i32 %val, 2
  br i1 %cmp, label %after_init, label %set2

set2:
  store i32 2, i32* %paddr, align 4
  br label %after_init

after_init:
  %is2 = icmp eq i32 %Reason, 2
  br i1 %is2, label %case_attach, label %check_detach

check_detach:
  %is1 = icmp eq i32 %Reason, 1
  br i1 %is1, label %case_detach, label %ret

case_attach:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %cmpse = icmp eq void ()** %start, %end
  br i1 %cmpse, label %ret, label %loop

loop:
  %cur = phi void ()** [ %start, %case_attach ], [ %next, %loop.inc ]
  %fptr = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fptr, null
  br i1 %isnull, label %loop.inc, label %loop.call

loop.call:
  call void %fptr()
  br label %loop.inc

loop.inc:
  %next = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %done = icmp eq void ()** %next, %end
  br i1 %done, label %ret, label %loop

case_detach:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}