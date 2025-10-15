; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }
%struct.RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.Node* null, align 8
@CriticalSection = dso_local global %struct.RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dllimport i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(%struct.RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct.RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %retzero, label %alloc

retzero:
  ret i32 0

alloc:
  %mem = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %oom, label %cont

oom:
  ret i32 -1

cont:
  %node = bitcast i8* %mem to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %arg0, i32* %field0ptr, align 4
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %arg1, i8** %field2ptr, align 8
  call void @EnterCriticalSection(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %field3ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %field3ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}