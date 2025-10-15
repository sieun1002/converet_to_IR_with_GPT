; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.block = type { i32, i32, i8*, i8* }

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global i8

declare i8* @calloc(i64, i64)
declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %ret_zero, label %alloc

ret_zero:
  ret i32 0

alloc:
  %mem = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %ret_neg1, label %init

ret_neg1:
  ret i32 -1

init:
  %blk = bitcast i8* %mem to %struct.block*
  %field0.ptr = getelementptr inbounds %struct.block, %struct.block* %blk, i32 0, i32 0
  store i32 %arg0, i32* %field0.ptr, align 4
  %field2.ptr = getelementptr inbounds %struct.block, %struct.block* %blk, i32 0, i32 2
  store i8* %arg1, i8** %field2.ptr, align 8
  call void @EnterCriticalSection(i8* @CriticalSection)
  %old = load i8*, i8** @Block, align 8
  %field3.ptr = getelementptr inbounds %struct.block, %struct.block* %blk, i32 0, i32 3
  store i8* %old, i8** %field3.ptr, align 8
  %newhead = bitcast %struct.block* %blk to i8*
  store i8* %newhead, i8** @Block, align 8
  call void @LeaveCriticalSection(i8* @CriticalSection)
  br label %ret_zero
}