; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external dso_local global i32, align 4
@Block = external dso_local global %struct.Node*, align 8
@CriticalSection = external dso_local global %struct._RTL_CRITICAL_SECTION, align 8

declare dso_local i8* @calloc(i64, i64)
declare dso_local void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dso_local void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %param0, i8* %param1) local_unnamed_addr {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp eq i32 %g, 0
  br i1 %cmp, label %ret_zero, label %cont

ret_zero:
  ret i32 0

cont:
  %call = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %ret_neg1, label %have

ret_neg1:
  ret i32 -1

have:
  %node = bitcast i8* %call to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %param0, i32* %field0ptr, align 4
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %param1, i8** %field2ptr, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %field3ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %field3ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}