; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global i8* null, align 8
@CriticalSection = dso_local global [40 x i8] zeroinitializer, align 8

declare void @free(i8*)
declare void @DeleteCriticalSection(i8*)
declare void @InitializeCriticalSection(i8*)
declare void @sub_140002240()
declare void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i8* %arg1, i32 %edx) {
entry:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %not2

case2:                                            ; edx == 2
  call void @sub_1400024E0()
  ret i32 1

not2:
  %gt2 = icmp ugt i32 %edx, 2
  br i1 %gt2, label %ge3, label %lt2

lt2:
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %case0, label %case1

case1:                                            ; edx == 1
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_zero = icmp eq i32 %flag1, 0
  br i1 %flag1_zero, label %initcrit, label %setflag1

initcrit:
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @InitializeCriticalSection(i8* %cs_ptr)
  br label %setflag1

setflag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

ge3:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; edx == 3
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_zero = icmp eq i32 %flag3, 0
  br i1 %flag3_zero, label %ret1, label %call_sub240

call_sub240:
  call void @sub_140002240()
  br label %ret1

case0:                                            ; edx == 0
  %flag0 = load i32, i32* @dword_1400070E8, align 4
  %flag0_zero = icmp eq i32 %flag0, 0
  br i1 %flag0_zero, label %L42E, label %call240_then_L42E

call240_then_L42E:
  call void @sub_140002240()
  br label %L42E

L42E:
  %flag42E = load i32, i32* @dword_1400070E8, align 4
  %flag_is1 = icmp eq i32 %flag42E, 1
  br i1 %flag_is1, label %cleanup, label %ret1

cleanup:
  %head = load i8*, i8** @Block, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %after_free, label %free_loop

free_loop:
  br label %loop_body

loop_body:
  %cur = phi i8* [ %head, %free_loop ], [ %next, %after_free_one ]
  %cur_plus16 = getelementptr i8, i8* %cur, i64 16
  %next_ptrptr = bitcast i8* %cur_plus16 to i8**
  %next = load i8*, i8** %next_ptrptr, align 8
  call void @free(i8* %cur)
  %hasnext = icmp ne i8* %next, null
  br i1 %hasnext, label %after_free_one, label %after_free

after_free_one:
  br label %loop_body

after_free:
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(i8* %cs_ptr2)
  br label %ret1

ret1:
  ret i32 1
}