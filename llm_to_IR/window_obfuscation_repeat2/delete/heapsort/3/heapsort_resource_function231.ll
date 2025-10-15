; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, i8* }

@dword_1400070E8 = external dso_local global i32
@CriticalSection = external dso_local global i8
@Block = external dso_local global i8*

declare dso_local noalias i8* @calloc(i64, i64)
declare dso_local void @EnterCriticalSection(i8*)
declare dso_local void @LeaveCriticalSection(i8*)

define dso_local i32 @sub_1400022B0(i32 %ecx, i8* %rdx) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %alloc, label %ret_zero

ret_zero:                                          ; preds = %entry
  ret i32 0

alloc:                                             ; preds = %entry
  %call = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %ret_minus1, label %init

ret_minus1:                                        ; preds = %alloc
  ret i32 -1

init:                                              ; preds = %alloc
  %node = bitcast i8* %call to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %ecx, i32* %field0ptr, align 4
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %rdx, i8** %field2ptr, align 8
  call void @EnterCriticalSection(i8* @CriticalSection)
  %old = load i8*, i8** @Block, align 8
  %field3ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store i8* %old, i8** %field3ptr, align 8
  store i8* %call, i8** @Block, align 8
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret i32 0
}