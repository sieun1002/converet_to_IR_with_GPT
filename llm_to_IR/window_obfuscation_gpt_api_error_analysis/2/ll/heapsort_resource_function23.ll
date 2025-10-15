; target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external dso_local global i32, align 4
@Block = external dso_local global %struct.Node*, align 8
@CriticalSection = external dso_local global %struct._RTL_CRITICAL_SECTION, align 8

declare dso_local noalias i8* @calloc(i64, i64)
declare dso_local void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dso_local void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag.nz = icmp ne i32 %flag, 0
  br i1 %flag.nz, label %alloc, label %ret0

alloc:
  %mem = call noalias i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %retneg1, label %init

init:
  %node = bitcast i8* %mem to %struct.Node*
  %field0.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %arg0, i32* %field0.ptr, align 4
  %field2.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %arg1, i8** %field2.ptr, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %field3.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %head, %struct.Node** %field3.ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret0

retneg1:
  ret i32 -1

ret0:
  ret i32 0
}