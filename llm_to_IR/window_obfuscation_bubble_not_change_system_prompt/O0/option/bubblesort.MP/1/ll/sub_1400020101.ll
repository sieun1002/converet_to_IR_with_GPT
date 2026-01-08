; ModuleID = 'sub_140002010'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1
@qword_140008250 = external global void (i8*)*, align 8
@qword_140008268 = external global void (i8*)*, align 8

declare void @sub_140001E80()
declare void @sub_1400027F0(i8*)
declare void @sub_140002120()

define i32 @sub_140002010(i32 %edx) {
entry:
  %var_next = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %check_gt2

check_gt2:                                           ; edx > 2 ?
  %gt2 = icmp ugt i32 %edx, 2
  br i1 %gt2, label %case_ge3, label %check_zero

check_zero:                                          ; edx == 0 ?
  %iszero = icmp eq i32 %edx, 0
  br i1 %iszero, label %case0, label %case1

case1:                                               ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1z = icmp eq i32 %g1, 0
  br i1 %g1z, label %loc_2100, label %loc_2031

loc_2100:
  %fp268 = load void (i8*)*, void (i8*)** @qword_140008268, align 8
  call void %fp268(i8* @unk_140007100)
  br label %loc_2031

loc_2031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case_ge3:                                            ; edx >= 3
  %eq3 = icmp eq i32 %edx, 3
  br i1 %eq3, label %case3, label %ret1

case3:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2z = icmp eq i32 %g2, 0
  br i1 %g2z, label %ret1, label %callE80_then_ret

callE80_then_ret:
  call void @sub_140001E80()
  br label %ret1

case2:                                               ; edx == 2
  call void @sub_140002120()
  ret i32 1

case0:                                               ; edx == 0
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3nz = icmp ne i32 %g3, 0
  br i1 %g3nz, label %loc_20F0, label %loc_206E

loc_20F0:
  call void @sub_140001E80()
  br label %loc_206E

loc_206E:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g4, 1
  br i1 %is1, label %loc_2079, label %ret1

loc_2079:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %loc_20AB, label %loc_2090

loc_2090:
  %node = phi i8* [ %head, %loc_2079 ], [ %next2, %loop_cont ]
  %gep = getelementptr i8, i8* %node, i64 16
  %next_ptr = bitcast i8* %gep to i8**
  %next1 = load i8*, i8** %next_ptr, align 8
  store i8* %next1, i8** %var_next, align 8
  call void @sub_1400027F0(i8* %node)
  %next2 = load i8*, i8** %var_next, align 8
  %cond = icmp ne i8* %next2, null
  br i1 %cond, label %loop_cont, label %loc_20AB

loop_cont:
  br label %loc_2090

loc_20AB:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %fp250 = load void (i8*)*, void (i8*)** @qword_140008250, align 8
  call void %fp250(i8* @unk_140007100)
  br label %ret1

ret1:
  ret i32 1
}