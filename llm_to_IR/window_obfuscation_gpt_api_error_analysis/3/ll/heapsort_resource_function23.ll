target triple = "x86_64-pc-windows-msvc"

%struct.RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external dso_local global i32, align 4
@Block = external dso_local global %struct.Node*, align 8
@CriticalSection = external dso_local global %struct.RTL_CRITICAL_SECTION, align 8

declare dso_local noalias i8* @calloc(i64, i64)
declare dso_local dllimport void @EnterCriticalSection(%struct.RTL_CRITICAL_SECTION*)
declare dso_local dllimport void @LeaveCriticalSection(%struct.RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %a1, i8* %a2) local_unnamed_addr {
entry:
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp ne i32 %g0, 0
  br i1 %cmp0, label %alloc, label %ret_zero

alloc:
  %call = call noalias i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %fail, label %have

have:
  %node = bitcast i8* %call to %struct.Node*
  %field0 = getelementptr inbounds %struct.Node, %struct.Node* %node, i64 0, i32 0
  store i32 %a1, i32* %field0, align 4
  %field2 = getelementptr inbounds %struct.Node, %struct.Node* %node, i64 0, i32 2
  store i8* %a2, i8** %field2, align 8
  call void @EnterCriticalSection(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %field3 = getelementptr inbounds %struct.Node, %struct.Node* %node, i64 0, i32 3
  store %struct.Node* %old, %struct.Node** %field3, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret_zero

fail:
  ret i32 -1

ret_zero:
  ret i32 0
}