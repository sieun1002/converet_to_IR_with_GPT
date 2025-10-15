; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { i64, i64, %struct.Block* }

@dword_1400070E8 = internal global i32 0, align 4
@Block = internal global %struct.Block* null, align 8
@CriticalSection = internal global [40 x i8] zeroinitializer, align 8

declare void @sub_140002240()
declare void @sub_1400024E0()
declare void @free(i8* noundef)
declare void @DeleteCriticalSection(i8* noundef)
declare void @InitializeCriticalSection(i8* noundef)

define i32 @sub_1400023D0(i8* noundef %hinstDLL, i32 noundef %fdwReason, i8* noundef %lpReserved) local_unnamed_addr {
entry:
  %cmp2 = icmp eq i32 %fdwReason, 2
  br i1 %cmp2, label %case2, label %not2

case2:
  call void @sub_1400024E0()
  br label %ret1

not2:
  %gt2 = icmp ugt i32 %fdwReason, 2
  br i1 %gt2, label %gt2blk, label %le2blk

gt2blk:
  %is3 = icmp eq i32 %fdwReason, 3
  br i1 %is3, label %case3, label %ret1

case3:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_zero = icmp eq i32 %flag3, 0
  br i1 %flag3_zero, label %ret1, label %call240_case3

call240_case3:
  call void @sub_140002240()
  br label %ret1

le2blk:
  %is0 = icmp eq i32 %fdwReason, 0
  br i1 %is0, label %case0, label %case1

case1:
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_zero = icmp eq i32 %flag1, 0
  br i1 %flag1_zero, label %initCS, label %setFlag1

initCS:
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i32 0, i32 0
  call void @InitializeCriticalSection(i8* %cs_ptr)
  br label %setFlag1

setFlag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case0:
  %flag0 = load i32, i32* @dword_1400070E8, align 4
  %flag0_nz = icmp ne i32 %flag0, 0
  br i1 %flag0_nz, label %call240_then, label %after240

call240_then:
  call void @sub_140002240()
  br label %after240

after240:
  %flag_after = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag_after, 1
  br i1 %is_one, label %cleanup, label %ret1

cleanup:
  %blk0 = load %struct.Block*, %struct.Block** @Block, align 8
  br label %loop

loop:
  %cur = phi %struct.Block* [ %blk0, %cleanup ], [ %next, %loop_body ]
  %isnull = icmp eq %struct.Block* %cur, null
  br i1 %isnull, label %after_free, label %loop_body

loop_body:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %cur_i8 = bitcast %struct.Block* %cur to i8*
  call void @free(i8* %cur_i8)
  br label %loop

after_free:
  store %struct.Block* null, %struct.Block** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i32 0, i32 0
  call void @DeleteCriticalSection(i8* %cs_ptr2)
  br label %ret1

ret1:
  ret i32 1
}