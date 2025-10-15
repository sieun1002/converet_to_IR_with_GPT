; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = global i32 0, align 4
@qword_1400070E0 = global i8* null, align 8
@unk_140007100 = global [1 x i8] zeroinitializer, align 1

declare void @sub_140002320()
declare void @sub_140002C90(i8*)
declare void @sub_1402FF71B(i8*)
declare void @sub_1400025C0()
declare void @loc_1403EC37A(i8*)

define i32 @sub_1400024B0(i8* %rcx.arg, i32 %edx.arg) {
entry:
  %next = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx.arg, 2
  br i1 %cmp2, label %case2, label %check_gt2

case2:                                            ; preds = %entry
  call void @sub_1400025C0()
  ret i32 1

check_gt2:                                        ; preds = %entry
  %ugt2 = icmp ugt i32 %edx.arg, 2
  br i1 %ugt2, label %gt2, label %check_zero

check_zero:                                       ; preds = %check_gt2
  %iszero = icmp eq i32 %edx.arg, 0
  br i1 %iszero, label %case0, label %case1

case1:                                            ; preds = %check_zero
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %label5a0, label %label4d1

label5a0:                                         ; preds = %case1
  %punk = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @loc_1403EC37A(i8* %punk)
  ret i32 1

label4d1:                                         ; preds = %case1
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

gt2:                                              ; preds = %check_gt2
  %is3 = icmp eq i32 %edx.arg, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; preds = %gt2
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_zero = icmp eq i32 %g2, 0
  br i1 %g2_zero, label %ret1, label %call_2320

call_2320:                                        ; preds = %case3
  call void @sub_140002320()
  br label %ret1

ret1:                                             ; preds = %case3, %gt2, %call_2320
  ret i32 1

case0:                                            ; preds = %check_zero
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %g0_nonzero = icmp ne i32 %g0, 0
  br i1 %g0_nonzero, label %label2590, label %label250e

label2590:                                        ; preds = %case0
  call void @sub_140002320()
  br label %label250e

label250e:                                        ; preds = %label2590, %case0
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_is1 = icmp eq i32 %g3, 1
  br i1 %g3_is1, label %label2519, label %ret1_2

ret1_2:                                           ; preds = %label250e
  ret i32 1

label2519:                                        ; preds = %label250e
  %cur0 = load i8*, i8** @qword_1400070E0, align 8
  br label %loop_hdr

loop_hdr:                                         ; preds = %loop_body_end, %label2519
  %cur = phi i8* [ %cur0, %label2519 ], [ %cur_next_after, %loop_body_end ]
  %isnullhdr = icmp eq i8* %cur, null
  br i1 %isnullhdr, label %label254b, label %loop_body

loop_body:                                        ; preds = %loop_hdr
  %gep = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %gep to i8**
  %nx = load i8*, i8** %nextptr, align 8
  store i8* %nx, i8** %next, align 8
  call void @sub_140002C90(i8* %cur)
  br label %loop_body_end

loop_body_end:                                    ; preds = %loop_body
  %cur_next_after = load i8*, i8** %next, align 8
  br label %loop_hdr

label254b:                                        ; preds = %loop_hdr
  %punk2 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1402FF71B(i8* %punk2)
  ret i32 1
}