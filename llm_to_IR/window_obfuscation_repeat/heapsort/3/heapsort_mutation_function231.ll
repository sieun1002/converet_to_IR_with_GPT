; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { %struct._RTL_CRITICAL_SECTION_DEBUG*, i32, i32, i8*, i8*, i64 }
%struct._RTL_CRITICAL_SECTION_DEBUG = type opaque

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global i8* null, align 8
@CriticalSection = dso_local global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare void @sub_140002240()
declare void @sub_1400024E0()
declare dllimport void @free(i8* noundef)
declare dllimport void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dllimport void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)

define dso_local i32 @sub_1400023D0(i32 noundef %edx) {
entry:
  switch i32 %edx, label %ret1 [
    i32 2, label %case2
    i32 3, label %case3
    i32 0, label %case0
    i32 1, label %case1
  ]

case2:
  call void @sub_1400024E0()
  br label %ret1

case3:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %iszero3 = icmp eq i32 %g3, 0
  br i1 %iszero3, label %ret1, label %call240_case3

call240_case3:
  call void @sub_140002240()
  br label %ret1

case1:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %iszero1 = icmp eq i32 %g1, 0
  br i1 %iszero1, label %init_cs, label %set_state1

init_cs:
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %set_state1

set_state1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case0:
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %iszero0 = icmp eq i32 %g0, 0
  br i1 %iszero0, label %after_maybe_call, label %call240_case0

call240_case0:
  call void @sub_140002240()
  br label %after_maybe_call

after_maybe_call:
  %g_after = load i32, i32* @dword_1400070E8, align 4
  %isone = icmp eq i32 %g_after, 1
  br i1 %isone, label %do_cleanup, label %ret1

do_cleanup:
  %head = load i8*, i8** @Block, align 8
  %head_isnull = icmp eq i8* %head, null
  br i1 %head_isnull, label %after_free, label %loop

loop:
  %cur = phi i8* [ %head, %do_cleanup ], [ %next, %loop ]
  %nextaddr = getelementptr i8, i8* %cur, i64 16
  %nextpp = bitcast i8* %nextaddr to i8**
  %next = load i8*, i8** %nextpp, align 8
  call void @free(i8* noundef %cur)
  %next_isnull = icmp eq i8* %next, null
  br i1 %next_isnull, label %after_free, label %loop

after_free:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}