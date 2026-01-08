; ModuleID = 'sub_140002010'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@__imp_DeleteCriticalSection = external global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_InitializeCriticalSection = external global void (%struct._RTL_CRITICAL_SECTION*)*

declare dllimport void @free(i8* noundef)
declare void @sub_140001E80()
declare void @sub_140002120()

define i32 @sub_140002010(i8* %arg1, i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp_eq_2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq_2, label %bb_0d8, label %bb_after_cmp2

bb_0d8:                                            ; loc_1400020D8
  call void @sub_140002120()
  br label %ret1

bb_after_cmp2:
  %cmp_ugt_2 = icmp ugt i32 %edx, 2
  br i1 %cmp_ugt_2, label %bb_048, label %bb_01f

bb_01f:
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %bb_060, label %bb_023

bb_023:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %bb_100, label %bb_031

bb_100:                                            ; loc_140002100
  %impInit = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_InitializeCriticalSection, align 8
  call void %impInit(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %bb_031

bb_031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

bb_048:
  %cmp_eq_3 = icmp eq i32 %edx, 3
  br i1 %cmp_eq_3, label %bb_04d_true, label %ret1

bb_04d_true:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %ret1, label %bb_057

bb_057:
  call void @sub_140001E80()
  br label %ret1

bb_060:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nz = icmp ne i32 %g3, 0
  br i1 %g3_nz, label %bb_0f0, label %bb_06e

bb_0f0:                                            ; loc_1400020F0
  call void @sub_140001E80()
  br label %bb_06e

bb_06e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_eq_1 = icmp eq i32 %g4, 1
  br i1 %g4_eq_1, label %bb_079, label %ret1

bb_079:
  %blk = load i8*, i8** @Block, align 8
  %blk_is_null = icmp eq i8* %blk, null
  br i1 %blk_is_null, label %bb_0ab, label %bb_090

bb_090:
  br label %loop

loop:
  %curr = phi i8* [ %blk, %bb_090 ], [ %next_loaded, %after_free ]
  %gep_next = getelementptr i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %gep_next to i8**
  %next_loaded = load i8*, i8** %nextptr, align 8
  store i8* %next_loaded, i8** %var10, align 8
  call void @free(i8* %curr)
  %nl = load i8*, i8** %var10, align 8
  %has_next = icmp ne i8* %nl, null
  br i1 %has_next, label %after_free, label %bb_0ab

after_free:
  br label %loop

bb_0ab:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %impDel = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_DeleteCriticalSection, align 8
  call void %impDel(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}