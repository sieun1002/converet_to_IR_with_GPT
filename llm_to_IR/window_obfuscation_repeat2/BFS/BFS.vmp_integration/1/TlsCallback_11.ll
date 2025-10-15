; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@off_140004390 = external global i32*
@unk_140004C00 = external global void ()*

declare void @sub_1400024B0(i8* %DllHandle, i32 %Reason, i8* %Reserved)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %paddr = load i32*, i32** @off_140004390, align 8
  %val = load i32, i32* %paddr, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %afterset, label %set

set:
  store i32 2, i32* %paddr, align 4
  br label %afterset

afterset:
  %is2 = icmp eq i32 %Reason, 2
  br i1 %is2, label %case2, label %chk1

chk1:
  %is1 = icmp eq i32 %Reason, 1
  br i1 %is1, label %case1, label %ret

case2:
  %startptr = getelementptr void ()*, void ()** @unk_140004C00, i64 0
  %endptr = getelementptr void ()*, void ()** @unk_140004C00, i64 0
  %eq = icmp eq void ()** %startptr, %endptr
  br i1 %eq, label %ret2, label %loop

loop:
  %iter = phi void ()** [ %startptr, %case2 ], [ %next, %cont ]
  %fp = load void ()*, void ()** %iter, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %cont, label %callfp

callfp:
  call void %fp()
  br label %cont

cont:
  %next = getelementptr void ()*, void ()** %iter, i64 1
  %continue = icmp ne void ()** %next, %endptr
  br i1 %continue, label %loop, label %ret2

ret2:
  ret void

case1:
  tail call void @sub_1400024B0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}