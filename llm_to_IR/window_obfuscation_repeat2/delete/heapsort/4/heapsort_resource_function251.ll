; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = global i32 0, align 4
@Block = global i8* null, align 8
@CriticalSection = global [40 x i8] zeroinitializer, align 8

@__imp_InitializeCriticalSection = external global void (i8*)*, align 8
@__imp_DeleteCriticalSection = external global void (i8*)*, align 8

declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()
declare dso_local void @free(i8*)

define dso_local i32 @sub_1400023D0(i32 %a1, i32 %a2) {
entry:
  %cmp2 = icmp eq i32 %a2, 2
  br i1 %cmp2, label %case2, label %not2

case2:                                            ; edx == 2
  call void @sub_1400024E0()
  ret i32 1

not2:
  %cmpgt = icmp ugt i32 %a2, 2
  br i1 %cmpgt, label %gt2, label %le2

le2:
  %iszero = icmp eq i32 %a2, 0
  br i1 %iszero, label %case0, label %case1

case1:                                            ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_iszero = icmp eq i32 %g1, 0
  br i1 %g1_iszero, label %initCrit, label %set1

initCrit:
  %fnptr1 = load void (i8*)*, void (i8*)** @__imp_InitializeCriticalSection, align 8
  %csaddr = bitcast [40 x i8]* @CriticalSection to i8*
  call void %fnptr1(i8* %csaddr)
  br label %set1

set1:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

gt2:
  %is3 = icmp eq i32 %a2, 3
  br i1 %is3, label %eq3, label %ret1

eq3:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3nz = icmp ne i32 %g3, 0
  br i1 %g3nz, label %call_sub, label %ret1

call_sub:
  call void @sub_140002240()
  br label %ret1

ret1:
  ret i32 1

case0:                                            ; edx == 0
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %g0nz = icmp ne i32 %g0, 0
  br i1 %g0nz, label %call_sub_then_42E, label %l42E

call_sub_then_42E:
  call void @sub_140002240()
  br label %l42E

l42E:
  %g_after = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g_after, 1
  br i1 %is1, label %cleanup, label %ret1

cleanup:
  %blk = load i8*, i8** @Block, align 8
  %blk_isnull = icmp eq i8* %blk, null
  br i1 %blk_isnull, label %after_loop, label %loop

loop:
  %cur = phi i8* [ %blk, %cleanup ], [ %next, %loop ]
  %ptr_offset = getelementptr i8, i8* %cur, i64 16
  %ptr_as_pp = bitcast i8* %ptr_offset to i8**
  %next = load i8*, i8** %ptr_as_pp, align 8
  call void @free(i8* %cur)
  %next_isnull = icmp eq i8* %next, null
  br i1 %next_isnull, label %after_loop, label %loop

after_loop:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %fnptr2 = load void (i8*)*, void (i8*)** @__imp_DeleteCriticalSection, align 8
  %csaddr2 = bitcast [40 x i8]* @CriticalSection to i8*
  call void %fnptr2(i8* %csaddr2)
  br label %ret1
}