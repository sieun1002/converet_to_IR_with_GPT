; ModuleID = 'module.ll'
source_filename = "module.ll"
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { i32, i8*, %struct.Block* }
%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32, align 4
@Block = external global %struct.Block*, align 8
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8

declare noalias i8* @calloc(i64, i64)
declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define i32 @sub_1400022B0(i32 %ecx, i8* %rdx) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %if.then, label %ret.zero

ret.zero:
  ret i32 0

if.then:
  %call = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %calloc.fail, label %alloc.ok

calloc.fail:
  ret i32 -1

alloc.ok:
  %blk = bitcast i8* %call to %struct.Block*
  %field0 = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 0
  store i32 %ecx, i32* %field0, align 4
  %field1 = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 1
  store i8* %rdx, i8** %field1, align 8
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %old = load %struct.Block*, %struct.Block** @Block, align 8
  %field2 = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 2
  store %struct.Block* %old, %struct.Block** %field2, align 8
  store %struct.Block* %blk, %struct.Block** @Block, align 8
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}