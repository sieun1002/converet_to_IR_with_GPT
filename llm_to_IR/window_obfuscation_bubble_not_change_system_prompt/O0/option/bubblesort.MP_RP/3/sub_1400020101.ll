target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8
@qword_140008250 = external dso_local global void (i8*)*
@qword_140008268 = external dso_local global void (i8*)*

declare dso_local void @sub_140001E80()
declare dso_local void @sub_140002120()
declare dso_local void @sub_1400027F0(i8*)

define dso_local i32 @sub_140002010(i8* %arg1, i32 %edx) {
entry:
  %varNext = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %checkgt2

checkgt2:                                         ; edx != 2
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %gt2, label %le2path

le2path:                                          ; edx <= 2 and != 2 -> 0 or 1
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %case0, label %case1

case1:                                            ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1z = icmp eq i32 %g1, 0
  br i1 %g1z, label %call_8268, label %set_and_ret

call_8268:
  %fp_8268 = load void (i8*)*, void (i8*)** @qword_140008268, align 8
  call void %fp_8268(i8* @unk_140007100)
  br label %set_and_ret

set_and_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

gt2:                                              ; edx > 2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; edx == 3
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3z = icmp eq i32 %g3, 0
  br i1 %g3z, label %ret1, label %call_e80_3

call_e80_3:
  call void @sub_140001E80()
  br label %ret1

case0:                                            ; edx == 0
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %g0nz = icmp ne i32 %g0, 0
  br i1 %g0nz, label %call_e80_then, label %check_eq1

call_e80_then:
  call void @sub_140001E80()
  br label %check_eq1

check_eq1:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g4, 1
  br i1 %is1, label %prep_loop, label %ret1

prep_loop:
  %start = load i8*, i8** @qword_1400070E0, align 8
  %start_null = icmp eq i8* %start, null
  br i1 %start_null, label %afterLoop, label %loop

loop:
  %cur = phi i8* [ %start, %prep_loop ], [ %next2, %loop ]
  %cur_plus_16 = getelementptr i8, i8* %cur, i64 16
  %cur_next_ptr = bitcast i8* %cur_plus_16 to i8**
  %next1 = load i8*, i8** %cur_next_ptr, align 8
  store i8* %next1, i8** %varNext, align 8
  call void @sub_1400027F0(i8* %cur)
  %next2 = load i8*, i8** %varNext, align 8
  %hasNext = icmp ne i8* %next2, null
  br i1 %hasNext, label %loop, label %afterLoop

afterLoop:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %fp_8250 = load void (i8*)*, void (i8*)** @qword_140008250, align 8
  call void %fp_8250(i8* @unk_140007100)
  br label %ret1

case2:                                            ; edx == 2
  call void @sub_140002120()
  br label %ret1

ret1:
  ret i32 1
}