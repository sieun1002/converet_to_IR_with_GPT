; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.Node* null, align 8
@CriticalSection = global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dllimport noalias i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %a, i8* %p) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tobool = icmp ne i32 %flag, 0
  br i1 %tobool, label %if.alloc, label %ret.zero

ret.zero:
  ret i32 0

if.alloc:
  %mem = call noalias i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %ret.minus1, label %init

ret.minus1:
  ret i32 -1

init:
  %node = bitcast i8* %mem to %struct.Node*
  %a_ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %a, i32* %a_ptr, align 4
  %p_ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %p, i8** %p_ptr, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %next_ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}