; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.Node* null, align 8
@CriticalSection = global [40 x i8] zeroinitializer, align 8

declare dllimport i8* @calloc(i64, i64)
declare dllimport void @EnterCriticalSection(i8*)
declare dllimport void @LeaveCriticalSection(i8*)

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %alloc, label %ret_zero

ret_zero:                                         ; preds = %entry
  ret i32 0

alloc:                                            ; preds = %entry
  %2 = call i8* @calloc(i64 1, i64 24)
  %3 = icmp eq i8* %2, null
  br i1 %3, label %fail, label %init

fail:                                             ; preds = %alloc
  ret i32 -1

init:                                             ; preds = %alloc
  %4 = bitcast i8* %2 to %struct.Node*
  %5 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 0
  store i32 %arg0, i32* %5, align 4
  %6 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 2
  store i8* %arg1, i8** %6, align 8
  %7 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i32 0, i32 0
  call void @EnterCriticalSection(i8* %7)
  %8 = load %struct.Node*, %struct.Node** @Block, align 8
  %9 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 3
  store %struct.Node* %8, %struct.Node** %9, align 8
  store %struct.Node* %4, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(i8* %7)
  ret i32 0
}