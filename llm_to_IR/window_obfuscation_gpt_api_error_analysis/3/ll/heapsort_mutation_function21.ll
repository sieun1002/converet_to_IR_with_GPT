; ModuleID = 'sub_1400022B0.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.node = type { i32, i8*, i8* }

@dword_1400070E8 = external dso_local global i32
@Block = external dso_local global i8*
@CriticalSection = external dso_local global %struct._RTL_CRITICAL_SECTION

declare dso_local noalias i8* @calloc(i64, i64)
declare dso_local void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dso_local void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define dso_local i32 @sub_1400022B0(i32 %a, i8* %p) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %alloc, label %ret0

alloc:
  %mem = call noalias i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %retm1, label %in_cs

in_cs:
  %node = bitcast i8* %mem to %struct.node*
  %field0 = getelementptr inbounds %struct.node, %struct.node* %node, i32 0, i32 0
  store i32 %a, i32* %field0, align 4
  %field1 = getelementptr inbounds %struct.node, %struct.node* %node, i32 0, i32 1
  store i8* %p, i8** %field1, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load i8*, i8** @Block, align 8
  %field2 = getelementptr inbounds %struct.node, %struct.node* %node, i32 0, i32 2
  store i8* %old, i8** %field2, align 8
  %newi8 = bitcast %struct.node* %node to i8*
  store i8* %newi8, i8** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret0

retm1:
  ret i32 -1

ret0:
  ret i32 0
}