; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = global i32 0, align 4
@Block = global i8* null, align 8
@CriticalSection = global %RTL_CRITICAL_SECTION zeroinitializer, align 8

declare void @sub_140002240()
declare void @sub_1400024E0()
declare dllimport void @InitializeCriticalSection(%RTL_CRITICAL_SECTION* nocapture)
declare dllimport void @DeleteCriticalSection(%RTL_CRITICAL_SECTION* nocapture)
declare dllimport void @free(i8* nocapture)

define dso_local i32 @sub_1400023D0(i32 %mode) local_unnamed_addr {
entry:
  %cmp_eq2 = icmp eq i32 %mode, 2
  br i1 %cmp_eq2, label %case2, label %not2

not2:
  %cmp_ugt2 = icmp ugt i32 %mode, 2
  br i1 %cmp_ugt2, label %gt2, label %le2

le2:
  %cmp_eq0 = icmp eq i32 %mode, 0
  br i1 %cmp_eq0, label %case0, label %case1

case1:
  %flag_load1 = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero1 = icmp eq i32 %flag_load1, 0
  br i1 %flag_is_zero1, label %init_cs, label %set_flag

init_cs:
  call void @InitializeCriticalSection(%RTL_CRITICAL_SECTION* nonnull @CriticalSection)
  br label %set_flag

set_flag:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case2:
  call void @sub_1400024E0()
  br label %ret1

gt2:
  %cmp_eq3 = icmp eq i32 %mode, 3
  br i1 %cmp_eq3, label %case3, label %ret1

case3:
  %flag_load3 = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero3 = icmp eq i32 %flag_load3, 0
  br i1 %flag_is_zero3, label %ret1, label %call240_then_ret

call240_then_ret:
  call void @sub_140002240()
  br label %ret1

case0:
  %flag_load0 = load i32, i32* @dword_1400070E8, align 4
  %flag_nonzero0 = icmp ne i32 %flag_load0, 0
  br i1 %flag_nonzero0, label %call240_then_42E, label %loc_42E

call240_then_42E:
  call void @sub_140002240()
  br label %loc_42E

loc_42E:
  %flag_after = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag_after, 1
  br i1 %is_one, label %cleanup, label %ret1

cleanup:
  %head0 = load i8*, i8** @Block, align 8
  %isnull_head0 = icmp eq i8* %head0, null
  br i1 %isnull_head0, label %after_free, label %loop

loop:
  %cur = phi i8* [ %head0, %cleanup ], [ %next, %loop_cont ]
  %nextptr_i8 = getelementptr inbounds i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextptr_i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  call void @free(i8* %cur)
  %next_isnull = icmp eq i8* %next, null
  br i1 %next_isnull, label %after_free, label %loop_cont

loop_cont:
  br label %loop

after_free:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%RTL_CRITICAL_SECTION* nonnull @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}