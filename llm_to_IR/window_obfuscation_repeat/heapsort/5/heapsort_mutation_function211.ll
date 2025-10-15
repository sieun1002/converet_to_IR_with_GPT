; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.Node* null, align 8
@CriticalSection = global [40 x i8] zeroinitializer, align 8

declare dllimport i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(i8*)
declare dllimport void @LeaveCriticalSection(i8*)

define dso_local i32 @sub_1400022B0(i32 %param0, i8* %param1) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %do, label %ret0

ret0:
  ret i32 0

do:
  %call = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %fail, label %succ

fail:
  ret i32 -1

succ:
  %node = bitcast i8* %call to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %param0, i32* %field0ptr, align 4
  %field1ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %param1, i8** %field1ptr, align 8
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @EnterCriticalSection(i8* %cs_ptr)
  %blk = load %struct.Node*, %struct.Node** @Block, align 8
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %blk, %struct.Node** %nextptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(i8* %cs_ptr)
  ret i32 0
}