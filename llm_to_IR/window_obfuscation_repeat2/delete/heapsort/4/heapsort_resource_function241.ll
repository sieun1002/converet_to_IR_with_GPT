; ModuleID = 'module'
source_filename = "module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, [12 x i8], %struct.Block* }

@dword_1400070E8 = external global i32
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @free(i8*)

define i32 @sub_140002340(i32 %0) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %have_flag, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

have_flag:                                        ; preds = %entry
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %headnull = icmp eq %struct.Block* %head, null
  br i1 %headnull, label %leave, label %loop

loop:                                             ; preds = %have_flag, %cont
  %prev = phi %struct.Block* [ null, %have_flag ], [ %cur, %cont ]
  %cur = phi %struct.Block* [ %head, %have_flag ], [ %next2, %cont ]
  %keyptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %next = load %struct.Block*, %struct.Block** %nptr, align 8
  %cmp = icmp eq i32 %key, %0
  br i1 %cmp, label %found, label %not_equal

not_equal:                                        ; preds = %loop
  %isnull = icmp eq %struct.Block* %next, null
  br i1 %isnull, label %leave, label %cont

cont:                                             ; preds = %not_equal
  %next2 = phi %struct.Block* [ %next, %not_equal ]
  br label %loop

found:                                            ; preds = %loop
  %hasprev = icmp ne %struct.Block* %prev, null
  br i1 %hasprev, label %has_prev, label %no_prev

has_prev:                                         ; preds = %found
  %pnextptr = getelementptr inbounds %struct.Block, %struct.Block* %prev, i32 0, i32 2
  store %struct.Block* %next, %struct.Block** %pnextptr, align 8
  br label %do_free

no_prev:                                          ; preds = %found
  store %struct.Block* %next, %struct.Block** @Block, align 8
  br label %do_free

do_free:                                          ; preds = %no_prev, %has_prev
  %cur_i8 = bitcast %struct.Block* %cur to i8*
  call void @free(i8* %cur_i8)
  br label %leave

leave:                                            ; preds = %not_equal, %have_flag, %do_free
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}