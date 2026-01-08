; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140001E80()
declare void @sub_1400027F0(i8*)
declare void @sub_140002120()

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8
@qword_140008250 = external global void (i8*)*
@qword_140008268 = external global void (i8*)*

define i32 @sub_140002010(i32 %arg1, i32 %arg2) {
entry:
  %var10 = alloca i8*, align 8
  %cmp_eq2 = icmp eq i32 %arg2, 2
  br i1 %cmp_eq2, label %case2, label %not2

not2:                                             ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %arg2, 2
  br i1 %cmp_gt2, label %gt2, label %le2_non2

gt2:                                              ; preds = %not2
  %cmp_eq3 = icmp eq i32 %arg2, 3
  br i1 %cmp_eq3, label %eq3, label %ret1

eq3:                                              ; preds = %gt2
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %iszero = icmp eq i32 %g0, 0
  br i1 %iszero, label %ret1, label %eq3_call

eq3_call:                                         ; preds = %eq3
  call void @sub_140001E80()
  br label %ret1

le2_non2:                                         ; preds = %not2
  %iszero_edx = icmp eq i32 %arg2, 0
  br i1 %iszero_edx, label %edx0, label %edx1

edx1:                                             ; preds = %le2_non2
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1zero = icmp eq i32 %g1, 0
  br i1 %g1zero, label %loc_140002100, label %setflag_and_ret

loc_140002100:                                    ; preds = %edx1
  %fp268 = load void (i8*)*, void (i8*)** @qword_140008268, align 8
  %p_unk = getelementptr i8, i8* @unk_140007100, i64 0
  call void %fp268(i8* %p_unk)
  br label %setflag_and_ret

setflag_and_ret:                                  ; preds = %loc_140002100, %edx1
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case2:                                            ; preds = %entry
  call void @sub_140002120()
  br label %ret1

edx0:                                             ; preds = %le2_non2
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2nz = icmp ne i32 %g2, 0
  br i1 %g2nz, label %loc_1400020F0, label %loc_14000206E

loc_1400020F0:                                    ; preds = %edx0
  call void @sub_140001E80()
  br label %loc_14000206E

loc_14000206E:                                    ; preds = %loc_1400020F0, %edx0
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %cmp1 = icmp eq i32 %g3, 1
  br i1 %cmp1, label %after_cmp1_true, label %ret1

after_cmp1_true:                                  ; preds = %loc_14000206E
  %p0 = load i8*, i8** @qword_1400070E0, align 8
  %p0_isnull = icmp eq i8* %p0, null
  br i1 %p0_isnull, label %after_loop, label %loop_header

loop_header:                                      ; preds = %loop_back, %after_cmp1_true
  %cur = phi i8* [ %p0, %after_cmp1_true ], [ %next_loaded, %loop_back ]
  %cur_i8ptr = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %cur_i8ptr to i8**
  %next = load i8*, i8** %nextptr, align 8
  store i8* %next, i8** %var10, align 8
  call void @sub_1400027F0(i8* %cur)
  %next_loaded = load i8*, i8** %var10, align 8
  %next_nonnull = icmp ne i8* %next_loaded, null
  br i1 %next_nonnull, label %loop_back, label %after_loop

loop_back:                                        ; preds = %loop_header
  br label %loop_header

after_loop:                                       ; preds = %loop_header, %after_cmp1_true
  %p_unk2 = getelementptr i8, i8* @unk_140007100, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %fp250 = load void (i8*)*, void (i8*)** @qword_140008250, align 8
  call void %fp250(i8* %p_unk2)
  br label %ret1

ret1:                                             ; preds = %after_loop, %loc_14000206E, %case2, %setflag_and_ret, %eq3_call, %eq3, %gt2
  ret i32 1
}