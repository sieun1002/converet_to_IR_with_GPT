; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external global i32
@CriticalSection = external global i8
@Block = external global %struct.Node*

declare noalias i8* @calloc(i64, i64)
declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %t0 = load i32, i32* @dword_1400070E8, align 4
  %t1 = icmp eq i32 %t0, 0
  br i1 %t1, label %ret_zero, label %do_alloc

ret_zero:
  ret i32 0

do_alloc:
  %t2 = call i8* @calloc(i64 1, i64 24)
  %t3 = icmp eq i8* %t2, null
  br i1 %t3, label %ret_fail, label %after_alloc

ret_fail:
  ret i32 -1

after_alloc:
  %t4 = bitcast i8* %t2 to %struct.Node*
  %t5 = getelementptr inbounds %struct.Node, %struct.Node* %t4, i64 0, i32 0
  store i32 %arg0, i32* %t5, align 4
  %t6 = getelementptr inbounds %struct.Node, %struct.Node* %t4, i64 0, i32 2
  store i8* %arg1, i8** %t6, align 8
  call void @EnterCriticalSection(i8* @CriticalSection)
  %t7 = load %struct.Node*, %struct.Node** @Block, align 8
  %t8 = getelementptr inbounds %struct.Node, %struct.Node* %t4, i64 0, i32 3
  store %struct.Node* %t7, %struct.Node** %t8, align 8
  store %struct.Node* %t4, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret i32 0
}