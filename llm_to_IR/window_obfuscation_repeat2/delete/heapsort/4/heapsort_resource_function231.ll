; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external dso_local global i32
@Block = external dso_local global %struct.Node*
@CriticalSection = external dso_local global %struct._RTL_CRITICAL_SECTION

declare dso_local dllimport noalias i8* @calloc(i64, i64)
declare dso_local dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dso_local dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %arg0, i8* %arg1) local_unnamed_addr {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %cont, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

cont:                                             ; preds = %entry
  %praw = call noalias i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %praw, null
  br i1 %isnull, label %retm1, label %ok

retm1:                                            ; preds = %cont
  ret i32 -1

ok:                                               ; preds = %cont
  %p = bitcast i8* %praw to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %p, i32 0, i32 0
  store i32 %arg0, i32* %field0ptr, align 4
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %p, i32 0, i32 2
  store i8* %arg1, i8** %field2ptr, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %field3ptr = getelementptr inbounds %struct.Node, %struct.Node* %p, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %field3ptr, align 8
  store %struct.Node* %p, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}