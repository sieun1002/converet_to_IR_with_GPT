; ModuleID = 'sub_1400022B0.ll'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external dso_local global i32
@CriticalSection = external dso_local global %struct._RTL_CRITICAL_SECTION
@Block = external dso_local global %struct.Node*

declare dso_local dllimport i8* @calloc(i64, i64)
declare dso_local dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dso_local dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %arg0, i8* %arg1) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %ret0, label %alloc

alloc:
  %mem = call i8* @calloc(i64 1, i64 24)
  %null = icmp eq i8* %mem, null
  br i1 %null, label %retneg1, label %init

init:
  %node = bitcast i8* %mem to %struct.Node*
  %f0p = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %arg0, i32* %f0p
  %f2p = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %arg1, i8** %f2p
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %f3p = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %f3p
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret0

ret0:
  ret i32 0

retneg1:
  ret i32 -1
}