; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @sub_1404EFA12(i8*)
declare void @loc_1405C002E(i8*)
declare void @loc_1400027ED(i8*)

define i32 @sub_140002010(i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp_edx_2 = icmp eq i32 %edx, 2
  br i1 %cmp_edx_2, label %case2, label %after_cmp2

after_cmp2:                                           ; preds = %entry
  %cmp_edx_gt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_edx_gt2, label %gt2_block, label %le2_block

gt2_block:                                            ; preds = %after_cmp2
  %cmp3 = icmp eq i32 %edx, 3
  br i1 %cmp3, label %eq3_block, label %ret1

eq3_block:                                            ; preds = %gt2_block
  %v1 = load i32, i32* @dword_1400070E8, align 4
  %is_zero_v1 = icmp eq i32 %v1, 0
  br i1 %is_zero_v1, label %ret1, label %call_e80_then_ret1

call_e80_then_ret1:                                   ; preds = %eq3_block
  call void @sub_140001E80()
  br label %ret1

le2_block:                                            ; preds = %after_cmp2
  %is_zero_edx = icmp eq i32 %edx, 0
  br i1 %is_zero_edx, label %case0, label %case1

case1:                                                ; preds = %le2_block
  %v2 = load i32, i32* @dword_1400070E8, align 4
  %v2_zero = icmp eq i32 %v2, 0
  br i1 %v2_zero, label %call_4EFA12_then_set, label %set_state1

call_4EFA12_then_set:                                 ; preds = %case1
  call void @sub_1404EFA12(i8* @unk_140007100)
  br label %set_state1

set_state1:                                           ; preds = %call_4EFA12_then_set, %case1
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case2:                                                ; preds = %entry
  call void @sub_140002120()
  br label %ret1

case0:                                                ; preds = %le2_block
  %v3 = load i32, i32* @dword_1400070E8, align 4
  %v3_is_nonzero = icmp ne i32 %v3, 0
  br i1 %v3_is_nonzero, label %loc_0F0, label %after_first_test_zero

after_first_test_zero:                                ; preds = %case0
  %v4 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %v4, 1
  br i1 %is_one, label %loc_06E_body, label %ret1

loc_0F0:                                              ; preds = %case0
  call void @sub_140001E80()
  br label %loc_06E

loc_06E:                                              ; preds = %loc_0F0
  %v5 = load i32, i32* @dword_1400070E8, align 4
  %is_one_now = icmp eq i32 %v5, 1
  br i1 %is_one_now, label %loc_06E_body, label %ret1

loc_06E_body:                                         ; preds = %after_first_test_zero, %loc_06E
  %head0 = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head0, null
  br i1 %head_is_null, label %after_loop, label %loop_header

loop_header:                                          ; preds = %loop_call_cont, %loc_06E_body
  %cur = phi i8* [ %head0, %loc_06E_body ], [ %next_after2, %loop_call_cont ]
  %nextaddr = getelementptr i8, i8* %cur, i64 16
  %nextptrptr = bitcast i8* %nextaddr to i8**
  %next_loaded = load i8*, i8** %nextptrptr, align 8
  store i8* %next_loaded, i8** %var10, align 8
  %basefn = ptrtoint void (i8*)* @loc_1400027ED to i64
  %adj = add i64 %basefn, 3
  %fnptr = inttoptr i64 %adj to void (i8*)*
  call void %fnptr(i8* %cur)
  %next_after = load i8*, i8** %var10, align 8
  %cond = icmp ne i8* %next_after, null
  br i1 %cond, label %loop_call_cont, label %after_loop

loop_call_cont:                                       ; preds = %loop_header
  %next_after2 = load i8*, i8** %var10, align 8
  br label %loop_header

after_loop:                                           ; preds = %loop_header, %loc_06E_body
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @loc_1405C002E(i8* @unk_140007100)
  br label %ret1

ret1:                                                 ; preds = %after_loop, %loc_06E, %after_first_test_zero, %case2, %set_state1, %eq3_block, %call_e80_then_ret1, %gt2_block
  ret i32 1
}