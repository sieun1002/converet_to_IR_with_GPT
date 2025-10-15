; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = global i32 0, align 4
@Block = global i8* null, align 8
@CriticalSection = global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dllimport void @free(i8*)
declare dllimport void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION*)

declare void @sub_140002240()
declare void @sub_1400024E0()

define i32 @sub_1400023D0(i8* %arg1, i32 %edx) {
entry:
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %case2, label %not2

case2:                                            ; preds = %entry
  call void @sub_1400024E0()
  ret i32 1

not2:                                             ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_gt2, label %gt2, label %lt2or1

gt2:                                              ; preds = %not2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; preds = %gt2
  %val3 = load i32, i32* @dword_1400070E8, align 4
  %iszero3 = icmp eq i32 %val3, 0
  br i1 %iszero3, label %ret1, label %call_sub240_then_ret

call_sub240_then_ret:                             ; preds = %case3
  call void @sub_140002240()
  br label %ret1

lt2or1:                                           ; preds = %not2
  %iszero = icmp eq i32 %edx, 0
  br i1 %iszero, label %case0, label %case1

case1:                                            ; preds = %lt2or1
  %v1 = load i32, i32* @dword_1400070E8, align 4
  %iszero1 = icmp eq i32 %v1, 0
  br i1 %iszero1, label %initCrit, label %setFlag

initCrit:                                         ; preds = %case1
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %setFlag

setFlag:                                          ; preds = %initCrit, %case1
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case0:                                            ; preds = %lt2or1
  %v0 = load i32, i32* @dword_1400070E8, align 4
  %nonzero = icmp ne i32 %v0, 0
  br i1 %nonzero, label %call240_and_continue, label %after240

call240_and_continue:                             ; preds = %case0
  call void @sub_140002240()
  br label %after240

after240:                                         ; preds = %call240_and_continue, %case0
  %v_after = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %v_after, 1
  br i1 %is1, label %cleanup, label %ret1

cleanup:                                          ; preds = %after240
  %blk = load i8*, i8** @Block, align 8
  br label %loopCheck

loopCheck:                                        ; preds = %afterFree, %cleanup
  %cur = phi i8* [ %blk, %cleanup ], [ %nextptr, %afterFree ]
  %cond = icmp eq i8* %cur, null
  br i1 %cond, label %afterLoop, label %loopBody

loopBody:                                         ; preds = %loopCheck
  %nextptraddr_tmp = getelementptr i8, i8* %cur, i64 16
  %nextptraddr = bitcast i8* %nextptraddr_tmp to i8**
  %nextptr = load i8*, i8** %nextptraddr, align 8
  call void @free(i8* %cur)
  br label %afterFree

afterFree:                                        ; preds = %loopBody
  %isnullnext = icmp eq i8* %nextptr, null
  br i1 %isnullnext, label %afterLoop, label %loopCheck

afterLoop:                                        ; preds = %afterFree, %loopCheck
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret1

ret1:                                             ; preds = %afterLoop, %after240, %setFlag, %gt2, %call_sub240_then_ret, %case3
  ret i32 1
}