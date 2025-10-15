; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, i32, i8*, %struct.Node* }

declare i8* @calloc(i64, i64)
declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

@dword_1400070E8 = external global i32
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Node*

define i32 @sub_1400022B0(i32 %a, i8* %p) {
entry:
  %guard = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %guard, 0
  br i1 %tst, label %alloc, label %ret0

alloc:
  %mem = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %retneg1, label %have

have:
  %node = bitcast i8* %mem to %struct.Node*
  %f0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %a, i32* %f0ptr, align 4
  %f2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %p, i8** %f2ptr, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %f3ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %f3ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret0

retneg1:
  ret i32 -1

ret0:
  ret i32 0
}