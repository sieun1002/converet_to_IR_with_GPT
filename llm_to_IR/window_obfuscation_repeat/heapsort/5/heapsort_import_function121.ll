; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = dso_local global i32 0, align 4
@qword_1400070E0 = dso_local global i8* null, align 8
@unk_140007100 = dso_local global [1 x i8] zeroinitializer, align 1

declare dso_local void @sub_140002BB0(i8* noundef)
declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()
declare dso_local void @sub_1403DDA29(i8* noundef)
declare dso_local i32 @sub_1400E06D5(i8* noundef)

define dso_local i32 @sub_1400023D0(i32 noundef %mode) {
entry:
  %cmp_eq2 = icmp eq i32 %mode, 2
  br i1 %cmp_eq2, label %bb_mode2, label %bb_check_gt2

bb_check_gt2:
  %cmp_gt2 = icmp ugt i32 %mode, 2
  br i1 %cmp_gt2, label %bb_gt2, label %bb_lt2

bb_mode2:
  call void @sub_1400024E0()
  br label %ret1

bb_gt2:
  %cmp_eq3 = icmp eq i32 %mode, 3
  br i1 %cmp_eq3, label %bb_eq3, label %ret1

bb_eq3:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %ret1, label %bb_call_2240_then_420

bb_call_2240_then_420:
  call void @sub_140002240()
  br label %bb_420

bb_lt2:
  %is_zero = icmp eq i32 %mode, 0
  br i1 %is_zero, label %bb_420, label %bb_mode1

bb_mode1:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %bb_24C0, label %bb_set1

bb_set1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

bb_420:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %bb_24B0, label %bb_check_eq1

bb_check_eq1:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_is1 = icmp eq i32 %g4, 1
  br i1 %g4_is1, label %bb_cleanup, label %ret1

bb_24B0:
  call void @sub_140002240()
  br label %bb_24C0

bb_24C0:
  %unk_ptr0 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  %t0 = call i32 @sub_1400E06D5(i8* noundef %unk_ptr0)
  br label %ret1

bb_cleanup:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %is_null = icmp eq i8* %head, null
  br i1 %is_null, label %bb_after_loop, label %bb_loop

bb_loop:
  %curr = phi i8* [ %head, %bb_cleanup ], [ %next, %bb_loop_iter ]
  %next_field_ptr_i8 = getelementptr inbounds i8, i8* %curr, i64 16
  %next_field_ptr = bitcast i8* %next_field_ptr_i8 to i8**
  %next = load i8*, i8** %next_field_ptr, align 8
  call void @sub_140002BB0(i8* noundef %curr)
  %not_end = icmp ne i8* %next, null
  br i1 %not_end, label %bb_loop_iter, label %bb_after_loop

bb_loop_iter:
  br label %bb_loop

bb_after_loop:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %unk_ptr1 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_1403DDA29(i8* noundef %unk_ptr1)
  br label %ret1

ret1:
  ret i32 1
}