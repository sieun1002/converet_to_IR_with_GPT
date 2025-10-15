; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @sub_140002240()
declare void @sub_140002BB0(i8*)
declare void @sub_1403DDA29(i8*)
declare void @sub_1400024E0()
declare i32 @sub_1400E06D5(i8*)

define dso_local i32 @sub_1400023D0(i8* %rcx, i32 %edx) local_unnamed_addr {
entry:
  %cmp_eq_2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq_2, label %case2, label %check_gt2

check_gt2:                                        ; edx != 2
  %cmp_gt_2 = icmp ugt i32 %edx, 2
  br i1 %cmp_gt_2, label %gt2block, label %le2block

gt2block:                                         ; edx > 2
  %cmp_eq_3 = icmp eq i32 %edx, 3
  br i1 %cmp_eq_3, label %edx3, label %ret1

edx3:                                             ; edx == 3
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %ret1, label %call_240_then_2420

call_240_then_2420:
  call void @sub_140002240()
  br label %loc_2420

le2block:                                         ; edx <= 2 and not 2 -> edx == 0 or 1
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %loc_2420, label %edx1path

edx1path:                                         ; edx == 1
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %loc_24C0, label %setglob1_ret1

setglob1_ret1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case2:                                            ; edx == 2
  call void @sub_1400024E0()
  br label %ret1

loc_2420:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %loc_24B0, label %loc_242E

loc_24B0:
  call void @sub_140002240()
  br label %loc_24C0

loc_242E:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %g4, 1
  br i1 %is_one, label %cleanup_path, label %ret1

cleanup_path:
  %head0 = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head0, null
  br i1 %head_is_null, label %after_loop, label %loop

loop:
  %curr = phi i8* [ %head0, %cleanup_path ], [ %next, %loop ]
  %nextloc = getelementptr i8, i8* %curr, i64 16
  %nextlocptr = bitcast i8* %nextloc to i8**
  %next = load i8*, i8** %nextlocptr, align 8
  call void @sub_140002BB0(i8* %curr)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %loop, label %after_loop

after_loop:
  %unkptr = getelementptr i8, i8* @unk_140007100, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1403DDA29(i8* %unkptr)
  br label %ret1

loc_24C0:
  %unkptr2 = getelementptr i8, i8* @unk_140007100, i64 0
  %t = call i32 @sub_1400E06D5(i8* %unkptr2)
  %sum = add i32 %t, 57367
  %rax64 = zext i32 %sum to i64
  %addr = sub i64 %rax64, 1879047760
  %ptr = inttoptr i64 %addr to i8**
  %fnraw = load i8*, i8** %ptr, align 8
  %fn = bitcast i8* %fnraw to void ()*
  call void %fn()
  unreachable

ret1:
  ret i32 1
}