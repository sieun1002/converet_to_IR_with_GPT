; ModuleID = 'sub_140002010'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1
@qword_140008250 = external global void (i8*)*, align 8
@qword_140008268 = external global void (i8*)*, align 8

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @sub_1400027F0(i8*)

define dso_local i32 @sub_140002010(i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %case2, label %cmp_above

cmp_above:
  %cmp_ugt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_ugt2, label %caseAbove, label %zero_check

zero_check:
  %cmp_zero = icmp eq i32 %edx, 0
  br i1 %cmp_zero, label %case0, label %case1

case1:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %iszero_g1 = icmp eq i32 %g1, 0
  br i1 %iszero_g1, label %call268, label %setE8to1

call268:
  %fp268 = load void (i8*)*, void (i8*)** @qword_140008268, align 8
  call void %fp268(i8* @unk_140007100)
  br label %setE8to1

setE8to1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret

caseAbove:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %case3, label %ret

case3:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %nz_g3 = icmp ne i32 %g3, 0
  br i1 %nz_g3, label %callE80_case3, label %ret

callE80_case3:
  call void @sub_140001E80()
  br label %ret

case0:
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %nz_g0 = icmp ne i32 %g0, 0
  br i1 %nz_g0, label %callE80_then, label %afterCheck

callE80_then:
  call void @sub_140001E80()
  br label %afterCheck

afterCheck:
  %g0b = load i32, i32* @dword_1400070E8, align 4
  %is1_g0b = icmp eq i32 %g0b, 1
  br i1 %is1_g0b, label %process_list, label %ret

process_list:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_isnull = icmp eq i8* %head, null
  br i1 %head_isnull, label %after_list, label %loop

loop:
  %node = phi i8* [ %head, %process_list ], [ %next2, %loop ]
  %next_ptr_i8 = getelementptr i8, i8* %node, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  store i8* %next, i8** %var10, align 8
  call void @sub_1400027F0(i8* %node)
  %next2 = load i8*, i8** %var10, align 8
  %has_next = icmp ne i8* %next2, null
  br i1 %has_next, label %loop, label %after_list

after_list:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %fp250 = load void (i8*)*, void (i8*)** @qword_140008250, align 8
  call void %fp250(i8* @unk_140007100)
  br label %ret

case2:
  call void @sub_140002120()
  br label %ret

ret:
  ret i32 1
}