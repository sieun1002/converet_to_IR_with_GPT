; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @free(i8*)
declare void @sub_140002320()
declare void @sub_1400025C0()
declare void @DeleteCriticalSection(i8*)
declare void @InitializeCriticalSection(i8*)

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global i8

define i32 @sub_1400024B0(i8* %rcx, i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %not2

case2:                                            ; edx == 2
  call void @sub_1400025C0()
  ret i32 1

not2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %check3, label %le2

le2:                                              ; edx <= 2
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %case0, label %case1

check3:                                           ; edx > 2
  %eq3 = icmp eq i32 %edx, 3
  br i1 %eq3, label %case3, label %ret1

case3:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %isZero3 = icmp eq i32 %g3, 0
  br i1 %isZero3, label %ret1, label %case3_call

case3_call:
  call void @sub_140002320()
  br label %ret1

case1:                                            ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %isZero1 = icmp eq i32 %g1, 0
  br i1 %isZero1, label %initCrit, label %set1

initCrit:
  call void @InitializeCriticalSection(i8* @CriticalSection)
  br label %set1

set1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case0:                                            ; edx == 0
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %nonZero0 = icmp ne i32 %g0, 0
  br i1 %nonZero0, label %call_then, label %after_call

call_then:
  call void @sub_140002320()
  br label %after_call

after_call:
  %g0b = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g0b, 1
  br i1 %is1, label %free_loop_entry, label %ret1

free_loop_entry:
  %block = load i8*, i8** @Block, align 8
  %isNull = icmp eq i8* %block, null
  br i1 %isNull, label %after_loop, label %loop

loop:
  %p = phi i8* [ %block, %free_loop_entry ], [ %next2, %loop_cont ]
  %addr = getelementptr i8, i8* %p, i64 16
  %addrp = bitcast i8* %addr to i8**
  %next = load i8*, i8** %addrp, align 8
  store i8* %next, i8** %var10, align 8
  call void @free(i8* %p)
  %next2 = load i8*, i8** %var10, align 8
  %cond = icmp ne i8* %next2, null
  br i1 %cond, label %loop_cont, label %after_loop

loop_cont:
  br label %loop

after_loop:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(i8* @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}