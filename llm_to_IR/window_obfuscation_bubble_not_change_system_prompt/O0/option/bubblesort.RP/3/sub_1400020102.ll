; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@Block = external global i8*, align 8
@CriticalSection = external global i8, align 1

@__imp_DeleteCriticalSection = external dllimport global void (i8*)*, align 8
@__imp_InitializeCriticalSection = external dllimport global void (i8*)*, align 8

declare void @sub_140001E80()
declare void @sub_140002120()
declare dllimport void @free(i8*)

define i32 @sub_140002010(i32 %edx) {
entry:
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %bb_20d8, label %bb_after_cmp2

bb_after_cmp2:
  %cmp_ugt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_ugt2, label %bb_2048, label %bb_201f

bb_201f:
  %iszero = icmp eq i32 %edx, 0
  br i1 %iszero, label %bb_2060, label %bb_2023

bb_2023:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %iszero2 = icmp eq i32 %g1, 0
  br i1 %iszero2, label %bb_2100, label %bb_2031

bb_2031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

bb_2048:
  %is_edx_3 = icmp eq i32 %edx, 3
  br i1 %is_edx_3, label %bb_204d, label %ret1

bb_204d:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %iszero3 = icmp eq i32 %g2, 0
  br i1 %iszero3, label %ret1, label %bb_2057

bb_2057:
  call void @sub_140001E80()
  br label %ret1

bb_2060:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %nonzero = icmp ne i32 %g3, 0
  br i1 %nonzero, label %bb_20f0, label %bb_206e

bb_20f0:
  call void @sub_140001E80()
  br label %bb_206e

bb_206e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g4, 1
  br i1 %is1, label %bb_2079, label %ret1

bb_2079:
  %p0 = load i8*, i8** @Block, align 8
  %isnull_p0 = icmp eq i8* %p0, null
  br i1 %isnull_p0, label %bb_20ab, label %bb_2090

bb_2090:
  %p = phi i8* [ %p0, %bb_2079 ], [ %next, %bb_2090 ]
  %next_ptr = getelementptr i8, i8* %p, i64 16
  %next_slot = bitcast i8* %next_ptr to i8**
  %next = load i8*, i8** %next_slot, align 8
  call void @free(i8* %p)
  %hasnext = icmp ne i8* %next, null
  br i1 %hasnext, label %bb_2090, label %bb_20ab

bb_20ab:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %del_fp = load void (i8*)*, void (i8*)** @__imp_DeleteCriticalSection, align 8
  call void %del_fp(i8* @CriticalSection)
  br label %ret1

bb_20d8:
  call void @sub_140002120()
  br label %ret1

bb_2100:
  %init_fp = load void (i8*)*, void (i8*)** @__imp_InitializeCriticalSection, align 8
  call void %init_fp(i8* @CriticalSection)
  br label %bb_2031

ret1:
  ret i32 1
}