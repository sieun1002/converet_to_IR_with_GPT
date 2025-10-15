; ModuleID = 'mod'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@Block = external dso_local global i8*
@CriticalSection = external dso_local global [40 x i8]
@"__imp_EnterCriticalSection" = external dso_local global void (i8*)*
@"__imp_LeaveCriticalSection" = external dso_local global void (i8*)*

declare dso_local noalias i8* @calloc(i64, i64)

define dso_local i32 @sub_140002250(i32 %ecx, i8* %rdx) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %alloc, label %ret_zero

ret_zero:                                         ; preds = %entry
  ret i32 0

alloc:                                            ; preds = %entry
  %c1 = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %c1, null
  br i1 %isnull, label %ret_minus1, label %have_mem

ret_minus1:                                       ; preds = %alloc
  ret i32 -1

have_mem:                                         ; preds = %alloc
  %p_i32 = bitcast i8* %c1 to i32*
  store i32 %ecx, i32* %p_i32, align 4
  %p_plus8 = getelementptr i8, i8* %c1, i64 8
  %p_ptr = bitcast i8* %p_plus8 to i8**
  store i8* %rdx, i8** %p_ptr, align 8
  %cs_ptr_i8 = bitcast [40 x i8]* @CriticalSection to i8*
  %ecs_fp_ptr = load void (i8*)*, void (i8*)** @"__imp_EnterCriticalSection", align 8
  call void %ecs_fp_ptr(i8* %cs_ptr_i8)
  %blk = load i8*, i8** @Block, align 8
  %p_plus16 = getelementptr i8, i8* %c1, i64 16
  %p_ptr16 = bitcast i8* %p_plus16 to i8**
  store i8* %blk, i8** %p_ptr16, align 8
  store i8* %c1, i8** @Block, align 8
  %lcs_fp_ptr = load void (i8*)*, void (i8*)** @"__imp_LeaveCriticalSection", align 8
  call void %lcs_fp_ptr(i8* %cs_ptr_i8)
  ret i32 0
}