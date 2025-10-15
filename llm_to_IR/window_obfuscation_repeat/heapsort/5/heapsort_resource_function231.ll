; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type { i8* }

@dword_1400070E8 = external dso_local global i32
@Block = dso_local global %struct.Node* null, align 8
@CriticalSection = dso_local global [40 x i8] zeroinitializer, align 8

declare dso_local dllimport i8* @calloc(i64, i64)
declare dso_local dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dso_local dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %a, i8* %b) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp eq i32 %g, 0
  br i1 %cmp, label %ret0, label %alloc

ret0:
  ret i32 0

alloc:
  %mem = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %retm1, label %ok

retm1:
  ret i32 -1

ok:
  %node = bitcast i8* %mem to %struct.Node*
  %a_ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %a, i32* %a_ptr, align 8
  %b_ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %b, i8** %b_ptr, align 8
  %cs_raw = bitcast [40 x i8]* @CriticalSection to %struct._RTL_CRITICAL_SECTION*
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* %cs_raw)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %next_ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* %cs_raw)
  ret i32 0
}