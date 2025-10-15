; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@CriticalSection = external global i8
@Block = external global i8*

declare i8* @calloc(i64, i64)
declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)

define i32 @sub_1400022B0(i32 %a, i8* %b) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %zero = icmp eq i32 %g, 0
  br i1 %zero, label %ret0, label %alloc

alloc:
  %p = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %retneg1, label %init

init:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %a, i32* %p_i32, align 4
  %p_plus8 = getelementptr i8, i8* %p, i64 8
  %p8_ptr = bitcast i8* %p_plus8 to i8**
  store i8* %b, i8** %p8_ptr, align 8
  call void @EnterCriticalSection(i8* @CriticalSection)
  %old = load i8*, i8** @Block, align 8
  %p_plus16 = getelementptr i8, i8* %p, i64 16
  %p16_ptr = bitcast i8* %p_plus16 to i8**
  store i8* %old, i8** %p16_ptr, align 8
  store i8* %p, i8** @Block, align 8
  call void @LeaveCriticalSection(i8* @CriticalSection)
  br label %ret0

retneg1:
  ret i32 -1

ret0:
  ret i32 0
}