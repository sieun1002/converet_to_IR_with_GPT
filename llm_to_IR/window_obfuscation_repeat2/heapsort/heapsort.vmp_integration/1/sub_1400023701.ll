; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = dso_local global i32 0
@qword_1400070E0 = dso_local global i8* null
@unk_140007100 = dso_local global [1 x i8] zeroinitializer

declare void @sub_1400021E0()
declare void @sub_140002B40(i8*)
declare void @sub_140002480()
declare void @sub_140034A58(i8*)
declare void @loc_1400205CD(i8*)

define dso_local i32 @sub_140002370(i8* %arg1, i32 %arg2) {
entry:
  %cmp2 = icmp eq i32 %arg2, 2
  br i1 %cmp2, label %case2, label %not2

case2:                                            ; edx == 2
  call void @sub_140002480()
  ret i32 1

not2:
  %ugt2 = icmp ugt i32 %arg2, 2
  br i1 %ugt2, label %gt2_block, label %lt2_block

gt2_block:                                        ; edx > 2
  %is3 = icmp eq i32 %arg2, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; edx == 3
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_nz = icmp ne i32 %flag3, 0
  br i1 %flag3_nz, label %call_1E0_from3, label %ret1

call_1E0_from3:
  call void @sub_1400021E0()
  br label %ret1

lt2_block:                                        ; edx < 2
  %isZero = icmp eq i32 %arg2, 0
  br i1 %isZero, label %edx0, label %edx1

edx1:                                             ; edx == 1
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_nz = icmp ne i32 %flag1, 0
  br i1 %flag1_nz, label %setflag_and_ret1, label %call_34A58

setflag_and_ret1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

call_34A58:
  %ptr_unk = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_140034A58(i8* %ptr_unk)
  br label %ret1

edx0:                                             ; edx == 0
  %flag0 = load i32, i32* @dword_1400070E8, align 4
  %flag0_nz = icmp ne i32 %flag0, 0
  br i1 %flag0_nz, label %call_1E0_then_3CE, label %at_3CE

call_1E0_then_3CE:
  call void @sub_1400021E0()
  br label %at_3CE

at_3CE:
  %flag_after = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %flag_after, 1
  br i1 %is1, label %cleanup_loop_entry, label %ret1

cleanup_loop_entry:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %after_cleanuplist, label %loop

loop:
  %node = phi i8* [ %head, %cleanup_loop_entry ], [ %next, %loop_cont ]
  %node_plus_16 = getelementptr i8, i8* %node, i64 16
  %nextptrptr = bitcast i8* %node_plus_16 to i8**
  %next = load i8*, i8** %nextptrptr, align 8
  call void @sub_140002B40(i8* %node)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %loop_cont, label %after_cleanuplist

loop_cont:
  br label %loop

after_cleanuplist:
  %ptr_unk2 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @loc_1400205CD(i8* %ptr_unk2)
  br label %ret1

ret1:
  ret i32 1
}