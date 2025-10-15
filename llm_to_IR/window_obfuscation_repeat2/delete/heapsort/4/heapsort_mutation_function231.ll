; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { [16 x i8], %struct.Node* }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.Node* null, align 8
@CriticalSection = dso_local global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dso_local void @free(i8* noundef)
declare dso_local void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dso_local void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i32 %arg) {
entry:
  %cmp2 = icmp eq i32 %arg, 2
  br i1 %cmp2, label %case2, label %check_gt2

case2:
  call void @sub_1400024E0()
  ret i32 1

check_gt2:
  %gt2 = icmp ugt i32 %arg, 2
  br i1 %gt2, label %gt2block, label %test_zero

gt2block:
  %is3 = icmp eq i32 %arg, 3
  br i1 %is3, label %edx3path, label %ret1

edx3path:
  %val3 = load i32, i32* @dword_1400070E8, align 4
  %isZero3 = icmp eq i32 %val3, 0
  br i1 %isZero3, label %ret1, label %call_2240_then_ret

call_2240_then_ret:
  call void @sub_140002240()
  br label %ret1

test_zero:
  %isZero = icmp eq i32 %arg, 0
  br i1 %isZero, label %edx0, label %edxNonZero

edxNonZero:
  %val1 = load i32, i32* @dword_1400070E8, align 4
  %isZero1 = icmp eq i32 %val1, 0
  br i1 %isZero1, label %init_cs_then_set1, label %set1

init_cs_then_set1:
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %set1

set1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

edx0:
  %val0a = load i32, i32* @dword_1400070E8, align 4
  %isNZ0a = icmp ne i32 %val0a, 0
  br i1 %isNZ0a, label %call_2240_then_42E, label %L42E

call_2240_then_42E:
  call void @sub_140002240()
  br label %L42E

L42E:
  %val0b = load i32, i32* @dword_1400070E8, align 4
  %isOne = icmp eq i32 %val0b, 1
  br i1 %isOne, label %cleanupBlock, label %ret1

cleanupBlock:
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  br label %loop_head

loop_head:
  %curr = phi %struct.Node* [ %head, %cleanupBlock ], [ %next, %loop_body ]
  %isnull = icmp eq %struct.Node* %curr, null
  br i1 %isnull, label %after_loop, label %loop_body

loop_body:
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 1
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %curr_i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* %curr_i8)
  br label %loop_head

after_loop:
  store %struct.Node* null, %struct.Node** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}