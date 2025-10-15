; ModuleID: fixed
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = external dso_local global i32
@CriticalSection = external dso_local global i8
@Block = external dso_local global i8*

declare dso_local i8* @calloc(i64, i64)
declare dso_local void @EnterCriticalSection(i8*)
declare dso_local void @LeaveCriticalSection(i8*)

define dso_local i32 @sub_140002390(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %alloc, label %ret_zero

ret_zero:
  ret i32 0

alloc:
  %p = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %fail, label %cont

fail:
  ret i32 -1

cont:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %p_plus8_ptr = bitcast i8* %p_plus8 to i8**
  store i8* %arg1, i8** %p_plus8_ptr, align 8
  call void @EnterCriticalSection(i8* @CriticalSection)
  %old = load i8*, i8** @Block, align 8
  %p_plus16 = getelementptr inbounds i8, i8* %p, i64 16
  %p_plus16_ptr = bitcast i8* %p_plus16 to i8**
  store i8* %old, i8** %p_plus16_ptr, align 8
  store i8* %p, i8** @Block, align 8
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret i32 0
}