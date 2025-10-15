; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i8*, %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type { i8 }

@dword_1400070E8 = external global i32, align 4
@Block = external global %struct.Node*
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION

declare dllimport i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %arg1, i8* %arg2) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp eq i32 %g, 0
  br i1 %cmp, label %ret_zero, label %alloc

ret_zero:
  ret i32 0

alloc:
  %call = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %ret_neg1, label %have

ret_neg1:
  ret i32 -1

have:
  %node = bitcast i8* %call to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %arg1, i32* %field0ptr, align 4
  %field1ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 1
  store i8* %arg2, i8** %field1ptr, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store %struct.Node* %old, %struct.Node** %field2ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}