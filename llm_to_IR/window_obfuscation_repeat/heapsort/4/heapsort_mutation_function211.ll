; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32, align 4
@CriticalSection = global [40 x i8] zeroinitializer, align 8
@Block = global %struct.Node* null, align 8

declare dllimport i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %g, 0
  br i1 %cmp, label %alloc, label %ret_zero

ret_zero:
  ret i32 0

alloc:
  %mem = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %ret_neg1, label %init

ret_neg1:
  ret i32 -1

init:
  %node = bitcast i8* %mem to %struct.Node*
  %field0 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %arg0, i32* %field0, align 4
  %field2 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %arg1, i8** %field2, align 8
  %csraw = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i32 0, i32 0
  %csptr = bitcast i8* %csraw to %struct._RTL_CRITICAL_SECTION*
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* %csptr)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %field3 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %field3, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* %csptr)
  ret i32 0
}