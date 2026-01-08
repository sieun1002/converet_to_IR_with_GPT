; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @"loc_1400027ED+3"(i8*)
declare void @"loc_1405C002E"(i8*)
declare void @sub_1404EFA12(i8*)

define i32 @sub_140002010(i32 %edx) {
entry:
  %next.slot = alloca i8*, align 8
  %cmp.eq.2 = icmp eq i32 %edx, 2
  br i1 %cmp.eq.2, label %bb.d8, label %bb.cmp2.cont

bb.cmp2.cont:                                     ; preds = %entry
  %cmp.ugt.2 = icmp ugt i32 %edx, 2
  br i1 %cmp.ugt.2, label %bb.048, label %bb.01f

bb.01f:                                           ; preds = %bb.cmp2.cont
  %is.zero = icmp eq i32 %edx, 0
  br i1 %is.zero, label %bb.060, label %bb.023

bb.023:                                           ; preds = %bb.01f
  %v023 = load i32, i32* @dword_1400070E8, align 4
  %t023 = icmp eq i32 %v023, 0
  br i1 %t023, label %bb.0100, label %bb.031

bb.031:                                           ; preds = %bb.023, %bb.0100
  store i32 1, i32* @dword_1400070E8, align 4
  br label %bb.ret1

bb.048:                                           ; preds = %bb.cmp2.cont
  %eq3 = icmp eq i32 %edx, 3
  br i1 %eq3, label %bb.04d, label %bb.ret1

bb.04d:                                           ; preds = %bb.048
  %v04d = load i32, i32* @dword_1400070E8, align 4
  %t04d = icmp eq i32 %v04d, 0
  br i1 %t04d, label %bb.ret1, label %bb.057

bb.057:                                           ; preds = %bb.04d
  call void @sub_140001E80()
  br label %bb.ret1

bb.060:                                           ; preds = %bb.01f
  %v060 = load i32, i32* @dword_1400070E8, align 4
  %t060 = icmp ne i32 %v060, 0
  br i1 %t060, label %bb.0f0, label %bb.06e

bb.0f0:                                           ; preds = %bb.060
  call void @sub_140001E80()
  br label %bb.06e

bb.06e:                                           ; preds = %bb.0f0, %bb.060
  %v06e = load i32, i32* @dword_1400070E8, align 4
  %cmp.eq.1 = icmp eq i32 %v06e, 1
  br i1 %cmp.eq.1, label %bb.079, label %bb.ret1

bb.079:                                           ; preds = %bb.06e
  %p079 = load i8*, i8** @qword_1400070E0, align 8
  %is.null.p079 = icmp eq i8* %p079, null
  br i1 %is.null.p079, label %bb.0ab, label %bb.090

bb.090:                                           ; preds = %bb.079
  br label %loop

loop:                                             ; preds = %loop, %bb.090
  %node = phi i8* [ %p079, %bb.090 ], [ %next.after, %loop ]
  %gep.next = getelementptr i8, i8* %node, i64 16
  %next.pp = bitcast i8* %gep.next to i8**
  %next = load i8*, i8** %next.pp, align 8
  store i8* %next, i8** %next.slot, align 8
  call void @"loc_1400027ED+3"(i8* %node)
  %next.after = load i8*, i8** %next.slot, align 8
  %has.next = icmp ne i8* %next.after, null
  br i1 %has.next, label %loop, label %bb.0ab

bb.0ab:                                           ; preds = %loop, %bb.079
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @"loc_1405C002E"(i8* @unk_140007100)
  br label %bb.ret1

bb.d8:                                            ; preds = %entry
  call void @sub_140002120()
  br label %bb.ret1

bb.0100:                                          ; preds = %bb.023
  call void @sub_1404EFA12(i8* @unk_140007100)
  br label %bb.031

bb.ret1:                                          ; preds = %bb.0ab, %bb.06e, %bb.057, %bb.04d, %bb.048, %bb.031, %bb.d8
  ret i32 1
}