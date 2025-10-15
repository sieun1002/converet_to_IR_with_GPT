; ModuleID = 'sub_1400022B0.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32
@Block = external global %struct.Node*
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION

declare dllimport noalias i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define i32 @sub_1400022B0(i32 noundef %param1, i8* noundef %param2) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp eq i32 %flag, 0
  br i1 %cond, label %ret0, label %alloc

ret0:
  ret i32 0

alloc:
  %mem = call noalias i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %retneg, label %init

retneg:
  ret i32 -1

init:
  %node = bitcast i8* %mem to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %param1, i32* %field0ptr, align 4
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %param2, i8** %field2ptr, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %head, %struct.Node** %nextptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}