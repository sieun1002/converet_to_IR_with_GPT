; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i8*, %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.Node* null, align 8
@CriticalSection = dso_local global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dso_local noalias i8* @calloc(i64, i64)
declare dso_local void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dso_local void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %flag, 0
  br i1 %cmp, label %if.nonzero, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

if.nonzero:                                       ; preds = %entry
  %mem = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %retm1, label %gotmem

gotmem:                                           ; preds = %if.nonzero
  %node = bitcast i8* %mem to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %arg0, i32* %field0ptr, align 4
  %field1ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 1
  store i8* %arg1, i8** %field1ptr, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %prev = load %struct.Node*, %struct.Node** @Block, align 8
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store %struct.Node* %prev, %struct.Node** %field2ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0

retm1:                                            ; preds = %if.nonzero
  ret i32 -1
}