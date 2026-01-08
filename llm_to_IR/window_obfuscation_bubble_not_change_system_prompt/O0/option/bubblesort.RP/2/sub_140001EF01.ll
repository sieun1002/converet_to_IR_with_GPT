target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@Block = external global i8*, align 8
@CriticalSection = external global i8, align 8
@__imp_EnterCriticalSection = external global void (i8*)*, align 8
@__imp_LeaveCriticalSection = external global void (i8*)*, align 8

declare i8* @calloc(i64, i64)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %alloc, label %ret_zero

ret_zero:
  ret i32 0

alloc:
  %call = call i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %calloc_fail, label %after_alloc

calloc_fail:
  ret i32 -1

after_alloc:
  %intptr = bitcast i8* %call to i32*
  store i32 %arg0, i32* %intptr, align 4
  %ptr8 = getelementptr i8, i8* %call, i64 8
  %ptr8_cast = bitcast i8* %ptr8 to i8**
  store i8* %arg1, i8** %ptr8_cast, align 8
  %pEnter = load void (i8*)*, void (i8*)** @__imp_EnterCriticalSection, align 8
  call void %pEnter(i8* @CriticalSection)
  %old = load i8*, i8** @Block, align 8
  %ptr16 = getelementptr i8, i8* %call, i64 16
  %ptr16cast = bitcast i8* %ptr16 to i8**
  store i8* %old, i8** %ptr16cast, align 8
  store i8* %call, i8** @Block, align 8
  %pLeave = load void (i8*)*, void (i8*)** @__imp_LeaveCriticalSection, align 8
  call void %pLeave(i8* @CriticalSection)
  br label %ret_zero
}