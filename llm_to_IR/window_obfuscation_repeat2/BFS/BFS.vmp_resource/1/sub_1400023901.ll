; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [4 x i8], i8*, %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type opaque

@Block = global %struct.Node* null, align 8
@dword_1400070E8 = external global i32
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION

declare dllimport i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_140002390(i32 %a, i8* %b) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp eq i32 %g, 0
  br i1 %cmp, label %ret0, label %cont

ret0:
  ret i32 0

cont:
  %call = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %fail, label %allocok

fail:
  ret i32 -1

allocok:
  %node = bitcast i8* %call to %struct.Node*
  %field0 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %a, i32* %field0, align 4
  %field1 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %b, i8** %field1, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %field2 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %field2, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}