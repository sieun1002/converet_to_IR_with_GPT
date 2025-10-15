; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.Node = type { [16 x i8], %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.Node* null, align 8
@CriticalSection = global [48 x i8] zeroinitializer, align 8

declare dllimport void @free(i8*)
declare dllimport void @InitializeCriticalSection(i8*)
declare dllimport void @DeleteCriticalSection(i8*)
declare void @sub_140002240()
declare void @sub_1400024E0()

define i32 @sub_1400023D0(i8* %a1, i32 %a2) {
entry:
  %cmp_eq2 = icmp eq i32 %a2, 2
  br i1 %cmp_eq2, label %case2, label %not2

case2:                                            ; preds = %entry
  call void @sub_1400024E0()
  ret i32 1

not2:                                             ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %a2, 2
  br i1 %cmp_gt2, label %gt2, label %lt2eq

gt2:                                              ; preds = %not2
  %cmp_eq3 = icmp eq i32 %a2, 3
  br i1 %cmp_eq3, label %eq3, label %ret1

eq3:                                              ; preds = %gt2
  %state1 = load i32, i32* @dword_1400070E8, align 4
  %state1nz = icmp ne i32 %state1, 0
  br i1 %state1nz, label %callSub, label %ret1

callSub:                                          ; preds = %eq3
  call void @sub_140002240()
  br label %ret1

ret1:                                             ; preds = %callSub, %eq3, %gt2
  ret i32 1

lt2eq:                                            ; preds = %not2
  %iszero = icmp eq i32 %a2, 0
  br i1 %iszero, label %case0, label %case1

case1:                                            ; preds = %lt2eq
  %state2 = load i32, i32* @dword_1400070E8, align 4
  %state2z = icmp eq i32 %state2, 0
  br i1 %state2z, label %initcs, label %set1

initcs:                                           ; preds = %case1
  %cs_ptr0 = getelementptr inbounds [48 x i8], [48 x i8]* @CriticalSection, i64 0, i64 0
  call void @InitializeCriticalSection(i8* %cs_ptr0)
  br label %set1

set1:                                             ; preds = %initcs, %case1
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

case0:                                            ; preds = %lt2eq
  %state3 = load i32, i32* @dword_1400070E8, align 4
  %state3nz = icmp ne i32 %state3, 0
  br i1 %state3nz, label %callSub2, label %afterSub

callSub2:                                         ; preds = %case0
  call void @sub_140002240()
  br label %afterSub

afterSub:                                         ; preds = %callSub2, %case0
  %state4 = load i32, i32* @dword_1400070E8, align 4
  %isOne = icmp eq i32 %state4, 1
  br i1 %isOne, label %cleanup, label %ret1b

ret1b:                                            ; preds = %afterSub
  ret i32 1

cleanup:                                          ; preds = %afterSub
  %p0 = load %struct.Node*, %struct.Node** @Block, align 8
  br label %loop

loop:                                             ; preds = %loopbody, %cleanup
  %p = phi %struct.Node* [ %p0, %cleanup ], [ %p_next, %loopbody ]
  %ptest = icmp eq %struct.Node* %p, null
  br i1 %ptest, label %afterLoop, label %loopbody

loopbody:                                         ; preds = %loop
  %nextptrptr = getelementptr inbounds %struct.Node, %struct.Node* %p, i32 0, i32 1
  %p_next = load %struct.Node*, %struct.Node** %nextptrptr, align 8
  %p_i8 = bitcast %struct.Node* %p to i8*
  call void @free(i8* %p_i8)
  br label %loop

afterLoop:                                        ; preds = %loop
  %cs_ptr1 = getelementptr inbounds [48 x i8], [48 x i8]* @CriticalSection, i64 0, i64 0
  store %struct.Node* null, %struct.Node** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(i8* %cs_ptr1)
  ret i32 1
}