; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external dso_local global i32
@Block = external dso_local global %struct.Node*
@CriticalSection = external dso_local global [40 x i8]

declare dllimport i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(i8*)
declare dllimport void @LeaveCriticalSection(i8*)

define dso_local i32 @sub_1400022B0(i32 %a, i8* %p) {
entry:
  %flag = load i32, i32* @dword_1400070E8
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %ret_zero, label %alloc

ret_zero:
  ret i32 0

alloc:
  %mem = call dllimport i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %ret_minus1, label %init

ret_minus1:
  ret i32 -1

init:
  %node = bitcast i8* %mem to %struct.Node*
  %field0 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %a, i32* %field0
  %field2 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %p, i8** %field2
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i32 0, i32 0
  call dllimport void @EnterCriticalSection(i8* %cs_ptr)
  %head = load %struct.Node*, %struct.Node** @Block
  %field3 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %head, %struct.Node** %field3
  store %struct.Node* %node, %struct.Node** @Block
  call dllimport void @LeaveCriticalSection(i8* %cs_ptr)
  ret i32 0
}