; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = global i32 0, align 4
@qword_1400070E0 = global i8* null, align 8
@unk_140007100 = global [1 x i8] zeroinitializer, align 1

declare void @sub_140002320()
declare void @sub_140002C90(i8*)
declare void @sub_1400025C0()
declare i8 @loc_1400F2976(i8*)
declare void @loc_1403F15F8(i8*)

define i32 @sub_1400024B0(i8* %a1, i32 %a2) {
entry:
  %cmp2 = icmp eq i32 %a2, 2
  br i1 %cmp2, label %L2578, label %after_cmp2

after_cmp2:                                       ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %a2, 2
  br i1 %cmp_gt2, label %L24E8, label %L24BF

L24BF:                                            ; preds = %after_cmp2
  %iszero = icmp eq i32 %a2, 0
  br i1 %iszero, label %L2500, label %L24C3

L24C3:                                            ; preds = %L24BF
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %L25A0, label %L24D1

L24D1:                                            ; preds = %L24C3
  store i32 1, i32* @dword_1400070E8, align 4
  br label %return1

L24E8:                                            ; preds = %after_cmp2
  %cmp_eq3 = icmp eq i32 %a2, 3
  br i1 %cmp_eq3, label %L24ED, label %return1

L24ED:                                            ; preds = %L24E8
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %return1, label %call_2320_path

call_2320_path:                                   ; preds = %L24ED
  call void @sub_140002320()
  br label %return1

L2500:                                            ; preds = %L24BF
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %L2590, label %L250E

L2590:                                            ; preds = %L2500
  call void @sub_140002320()
  br label %L250E

L250E:                                            ; preds = %L2590, %L2500
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_is_one = icmp eq i32 %g4, 1
  br i1 %g4_is_one, label %L2519, label %return1

L2519:                                            ; preds = %L250E
  %p = load i8*, i8** @qword_1400070E0, align 8
  %p_is_null = icmp eq i8* %p, null
  br i1 %p_is_null, label %L254B, label %L2530

L2530:                                            ; preds = %L2519, %L2539
  %cur = phi i8* [ %p, %L2519 ], [ %next, %L2539 ]
  %addr = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %addr to i8**
  %next = load i8*, i8** %nextptr, align 8
  call void @sub_140002C90(i8* %cur)
  br label %L2539

L2539:                                            ; preds = %L2530
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %L254B, label %L2530

L254B:                                            ; preds = %L2539, %L2519
  %unkptr = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %callres = call i8 @loc_1400F2976(i8* %unkptr)
  br label %L2578

L2578:                                            ; preds = %L254B, %entry
  call void @sub_1400025C0()
  br label %return1

L25A0:                                            ; preds = %L24C3
  %unkptr2 = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @loc_1403F15F8(i8* %unkptr2)
  br label %return1

return1:                                          ; preds = %L25A0, %L2578, %L250E, %call_2320_path, %L24ED, %L24E8, %L24D1
  ret i32 1
}