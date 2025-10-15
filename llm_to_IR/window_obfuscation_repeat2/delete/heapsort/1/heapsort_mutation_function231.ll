; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = global i32 0, align 4
@Block = global i8* null, align 8
@CriticalSection = global %struct.RTL_CRITICAL_SECTION zeroinitializer, align 8

declare void @sub_1400024E0()
declare void @sub_140002240()
declare void @free(i8* noundef)
declare void @InitializeCriticalSection(%struct.RTL_CRITICAL_SECTION* noundef)
declare void @DeleteCriticalSection(%struct.RTL_CRITICAL_SECTION* noundef)

define i32 @sub_1400023D0(i32 %a, i32 %mode) {
entry:
  %cmp2 = icmp eq i32 %mode, 2
  br i1 %cmp2, label %case2, label %not2

case2:                                            ; edx == 2
  call void @sub_1400024E0()
  ret i32 1

not2:
  %gt2 = icmp ugt i32 %mode, 2
  br i1 %gt2, label %gt2block, label %le2block

gt2block:                                         ; edx > 2
  %eq3 = icmp eq i32 %mode, 3
  br i1 %eq3, label %mode3, label %ret1

mode3:                                            ; edx == 3
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %iszero1 = icmp eq i32 %flag1, 0
  br i1 %iszero1, label %ret1, label %call_sub240_then_ret

call_sub240_then_ret:
  call void @sub_140002240()
  br label %ret1

le2block:                                         ; edx <= 2
  %iszeroMode = icmp eq i32 %mode, 0
  br i1 %iszeroMode, label %mode0, label %mode1

mode1:                                            ; edx == 1
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %iszero2 = icmp eq i32 %flag2, 0
  br i1 %iszero2, label %init_cs_then_set, label %set_flag

init_cs_then_set:
  call void @InitializeCriticalSection(%struct.RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %set_flag

set_flag:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

mode0:                                            ; edx == 0
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_is_not_zero = icmp ne i32 %flag3, 0
  br i1 %flag3_is_not_zero, label %call240_then_chk_flag, label %chk_flag

call240_then_chk_flag:
  call void @sub_140002240()
  br label %chk_flag

chk_flag:
  %flag4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %flag4, 1
  br i1 %is1, label %cleanup, label %ret1

cleanup:
  %cur0 = load i8*, i8** @Block, align 8
  br label %loop_header

loop_header:
  %cur = phi i8* [ %cur0, %cleanup ], [ %next, %loop_body ]
  %is_null = icmp eq i8* %cur, null
  br i1 %is_null, label %after_loop, label %loop_body

loop_body:
  %gep2 = getelementptr i8, i8* %cur, i64 16
  %nextpp = bitcast i8* %gep2 to i8**
  %next = load i8*, i8** %nextpp, align 8
  call void @free(i8* noundef %cur)
  br label %loop_header

after_loop:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct.RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}