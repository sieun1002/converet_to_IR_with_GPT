; ModuleID = 'sub_140002010.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140001E80()
declare void @loc_1400027F0(i8*)
declare i32 @sub_1400FEC71(i8*)
declare void @sub_140002120()
declare void @loc_1400E441D(i8*)

define dso_local i32 @sub_140002010(i8* %arg1, i32 %arg2) {
entry:
  %var10 = alloca i8*, align 8
  %cur = alloca i8*, align 8
  %cmp_eq2 = icmp eq i32 %arg2, 2
  br i1 %cmp_eq2, label %bb_d8, label %bb_cmpgt2

bb_cmpgt2:                                        ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %arg2, 2
  br i1 %cmp_gt2, label %bb_048, label %bb_checkzero

bb_checkzero:                                     ; preds = %bb_cmpgt2
  %is_zero = icmp eq i32 %arg2, 0
  br i1 %is_zero, label %bb_060, label %bb_edx1

bb_edx1:                                          ; preds = %bb_checkzero
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %g0_is_zero = icmp eq i32 %g0, 0
  br i1 %g0_is_zero, label %bb_100, label %bb_031

bb_048:                                           ; preds = %bb_cmpgt2
  %cmp_eq3 = icmp eq i32 %arg2, 3
  br i1 %cmp_eq3, label %bb_04d, label %bb_03b

bb_04d:                                           ; preds = %bb_048
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %bb_03b, label %bb_call_e80_then_060

bb_call_e80_then_060:                             ; preds = %bb_04d
  call void @sub_140001E80()
  br label %bb_060

bb_060:                                           ; preds = %bb_call_e80_then_060, %bb_checkzero
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_nonzero = icmp ne i32 %g2, 0
  br i1 %g2_nonzero, label %bb_0f0, label %bb_06e

bb_06e:                                           ; preds = %bb_060
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %cmp_eq1 = icmp eq i32 %g3, 1
  br i1 %cmp_eq1, label %bb_079, label %bb_03b

bb_079:                                           ; preds = %bb_06e
  %p = load i8*, i8** @qword_1400070E0, align 8
  %p_is_null = icmp eq i8* %p, null
  br i1 %p_is_null, label %bb_0ab, label %bb_loop

bb_loop:                                          ; preds = %bb_aftercall, %bb_079
  %cur_in = phi i8* [ %p, %bb_079 ], [ %next_loaded2, %bb_aftercall ]
  store i8* %cur_in, i8** %cur, align 8
  %cur_loaded = load i8*, i8** %cur, align 8
  %gepn = getelementptr i8, i8* %cur_loaded, i64 16
  %pp = bitcast i8* %gepn to i8**
  %next_val = load i8*, i8** %pp, align 8
  store i8* %next_val, i8** %var10, align 8
  call void @loc_1400027F0(i8* %cur_loaded)
  %next_loaded = load i8*, i8** %var10, align 8
  %hasnext = icmp ne i8* %next_loaded, null
  br i1 %hasnext, label %bb_aftercall, label %bb_0ab

bb_aftercall:                                     ; preds = %bb_loop
  %next_loaded2 = load i8*, i8** %var10, align 8
  br label %bb_loop

bb_0f0:                                           ; preds = %bb_060
  call void @sub_140001E80()
  br label %bb_100

bb_100:                                           ; preds = %bb_0f0, %bb_edx1
  call void @loc_1400E441D(i8* @unk_140007100)
  br label %bb_031

bb_0ab:                                           ; preds = %bb_loop, %bb_079
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %call_fec71 = call i32 @sub_1400FEC71(i8* @unk_140007100)
  br label %bb_d8

bb_d8:                                            ; preds = %bb_0ab, %entry
  call void @sub_140002120()
  ret i32 1

bb_031:                                           ; preds = %bb_100, %bb_edx1
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

bb_03b:                                           ; preds = %bb_06e, %bb_04d, %bb_048
  ret i32 1
}