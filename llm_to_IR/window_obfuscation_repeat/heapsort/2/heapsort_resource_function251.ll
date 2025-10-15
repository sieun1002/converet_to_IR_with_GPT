; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { [16 x i8], %struct.Block* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.Block* null, align 8
@CriticalSection = global [40 x i8] zeroinitializer, align 8

declare dllimport void @free(i8* noundef)
declare dllimport void @InitializeCriticalSection(i8* noundef)
declare dllimport void @DeleteCriticalSection(i8* noundef)

declare void @sub_140002240()
declare void @sub_1400024E0()

define i32 @sub_1400023D0(i32 %arg1, i32 %arg2) local_unnamed_addr {
entry:
  %cmp2 = icmp eq i32 %arg2, 2
  br i1 %cmp2, label %case2, label %after_cmp2

after_cmp2:
  %gt2 = icmp ugt i32 %arg2, 2
  br i1 %gt2, label %loc_2408, label %test_edx_zero

test_edx_zero:
  %iszero = icmp eq i32 %arg2, 0
  br i1 %iszero, label %loc_2420, label %loc_read_flag

loc_read_flag:
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1iszero = icmp eq i32 %flag1, 0
  br i1 %flag1iszero, label %loc_24C0, label %loc_23F1

loc_23F1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

loc_2408:
  %is3 = icmp eq i32 %arg2, 3
  br i1 %is3, label %loc_240D_eq3, label %ret1

loc_240D_eq3:
  %f = load i32, i32* @dword_1400070E8, align 4
  %iszero2 = icmp eq i32 %f, 0
  br i1 %iszero2, label %ret1, label %call_sub_2240_then_return

call_sub_2240_then_return:
  call void @sub_140002240()
  br label %ret1

loc_2420:
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %isnonzero = icmp ne i32 %flag2, 0
  br i1 %isnonzero, label %loc_24B0, label %loc_242E

loc_24B0:
  call void @sub_140002240()
  br label %loc_242E

loc_242E:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %flag3, 1
  br i1 %is1, label %proceed_free, label %ret1

proceed_free:
  %blk0 = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %blk0, null
  br i1 %isnull, label %free_done, label %free_loop

free_loop:
  %cur = phi %struct.Block* [ %blk0, %proceed_free ], [ %next, %free_loop ]
  %nextptrptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 1
  %next = load %struct.Block*, %struct.Block** %nextptrptr, align 8
  %cur_i8 = bitcast %struct.Block* %cur to i8*
  call dllimport void @free(i8* %cur_i8)
  %hasnext = icmp ne %struct.Block* %next, null
  br i1 %hasnext, label %free_loop, label %free_done

free_done:
  store %struct.Block* null, %struct.Block** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i32 0, i32 0
  call dllimport void @DeleteCriticalSection(i8* %cs_ptr)
  br label %ret1

case2:
  call void @sub_1400024E0()
  ret i32 1

loc_24C0:
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i32 0, i32 0
  call dllimport void @InitializeCriticalSection(i8* %cs_ptr2)
  br label %loc_23F1

ret1:
  ret i32 1
}