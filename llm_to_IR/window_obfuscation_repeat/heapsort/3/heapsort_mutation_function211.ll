; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@Block = global %struct.Node* null, align 8
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION

declare dllimport i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define i32 @sub_1400022B0(i32 %ecx, i8* %rdx) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %do, label %ret0

do:
  %mem = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %ret_neg1, label %ok

ok:
  %node = bitcast i8* %mem to %struct.Node*
  %field0 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %ecx, i32* %field0, align 4
  %field2 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %rdx, i8** %field2, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %next = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %head, %struct.Node** %next, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret0

ret0:
  ret i32 0

ret_neg1:
  ret i32 -1
}