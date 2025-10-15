; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.RTL_CRITICAL_SECTION_DEBUG = type opaque
%struct.RTL_CRITICAL_SECTION = type { %struct.RTL_CRITICAL_SECTION_DEBUG*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { [16 x i8], %struct.Node* }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.Node* null, align 8
@CriticalSection = dso_local global %struct.RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dso_local void @free(i8* noundef)
declare dso_local void @DeleteCriticalSection(%struct.RTL_CRITICAL_SECTION* noundef)
declare dso_local void @InitializeCriticalSection(%struct.RTL_CRITICAL_SECTION* noundef)
declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i32 noundef %edx) {
entry:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %not2

case2:
  call void @sub_1400024E0()
  ret i32 1

not2:
  %gt2 = icmp ugt i32 %edx, 2
  br i1 %gt2, label %greater2, label %le2

greater2:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %eq3, label %ret1

eq3:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3zero = icmp eq i32 %flag3, 0
  br i1 %flag3zero, label %ret1, label %do_call_2240_3

do_call_2240_3:
  call void @sub_140002240()
  br label %ret1

le2:
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %case0, label %case1

case1:
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1zero = icmp eq i32 %flag1, 0
  br i1 %flag1zero, label %init_cs, label %setflag1

init_cs:
  call void @InitializeCriticalSection(%struct.RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %setflag1

setflag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case0:
  %flag0 = load i32, i32* @dword_1400070E8, align 4
  %flag0nonzero = icmp ne i32 %flag0, 0
  br i1 %flag0nonzero, label %call_2240_then_check, label %check_then_cleanup

call_2240_then_check:
  call void @sub_140002240()
  br label %check_then_cleanup

check_then_cleanup:
  %flagA = load i32, i32* @dword_1400070E8, align 4
  %isOne = icmp eq i32 %flagA, 1
  br i1 %isOne, label %do_cleanup, label %ret1

do_cleanup:
  %cur0 = load %struct.Node*, %struct.Node** @Block, align 8
  br label %loop_head

loop_head:
  %cur = phi %struct.Node* [ %cur0, %do_cleanup ], [ %next2, %loop_body ]
  %cond = icmp ne %struct.Node* %cur, null
  br i1 %cond, label %loop_body, label %after_free

loop_body:
  %nextptr2 = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 1
  %next2 = load %struct.Node*, %struct.Node** %nextptr2, align 8
  %cur_i82 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* noundef %cur_i82)
  br label %loop_head

after_free:
  store %struct.Node* null, %struct.Node** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct.RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}