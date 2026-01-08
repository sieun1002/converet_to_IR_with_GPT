; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global i8
@__imp_DeleteCriticalSection = external dllimport global void (i8*)*
@__imp_InitializeCriticalSection = external dllimport global void (i8*)*

declare void @sub_140001E80()
declare void @sub_140002120()
declare dllimport void @free(i8*)

define i32 @sub_140002010(i32 %edx) {
entry:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %bb_d8, label %bb_after_cmp2

bb_after_cmp2:                                      ; edx != 2
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %bb_048, label %bb_test0

bb_test0:                                           ; edx <= 2
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %bb_060, label %bb_edx1

bb_edx1:                                            ; edx == 1
  %val1 = load i32, i32* @dword_1400070E8, align 4
  %val1_is_zero = icmp eq i32 %val1, 0
  br i1 %val1_is_zero, label %bb_0100, label %bb_031

bb_0100:                                            ; InitializeCriticalSection(&CriticalSection)
  %init_fnptr = load void (i8*)*, void (i8*)** @__imp_InitializeCriticalSection
  call void %init_fnptr(i8* @CriticalSection)
  br label %bb_031

bb_031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %bb_ret1

bb_048:                                             ; edx > 2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %bb_04d_true, label %bb_ret1

bb_04d_true:                                        ; edx == 3
  %val2 = load i32, i32* @dword_1400070E8, align 4
  %is_zero3 = icmp eq i32 %val2, 0
  br i1 %is_zero3, label %bb_ret1, label %bb_call_e80

bb_call_e80:
  call void @sub_140001E80()
  br label %bb_ret1

bb_d8:                                              ; edx == 2
  call void @sub_140002120()
  br label %bb_ret1

bb_060:                                             ; edx == 0
  %val3 = load i32, i32* @dword_1400070E8, align 4
  %nz = icmp ne i32 %val3, 0
  br i1 %nz, label %bb_0F0, label %bb_06E

bb_0F0:
  call void @sub_140001E80()
  br label %bb_06E

bb_06E:
  %val4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %val4, 1
  br i1 %is1, label %bb_079, label %bb_ret1

bb_079:
  %blk0 = load i8*, i8** @Block, align 8
  %is_null = icmp eq i8* %blk0, null
  br i1 %is_null, label %bb_0AB, label %bb_090

bb_090:
  %cur = phi i8* [ %blk0, %bb_079 ], [ %next, %bb_0A9 ]
  %gep = getelementptr i8, i8* %cur, i64 16
  %pnext = bitcast i8* %gep to i8**
  %next = load i8*, i8** %pnext, align 8
  call void @free(i8* %cur)
  %cond = icmp ne i8* %next, null
  br i1 %cond, label %bb_0A9, label %bb_0AB

bb_0A9:
  br label %bb_090

bb_0AB:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %del_fnptr = load void (i8*)*, void (i8*)** @__imp_DeleteCriticalSection
  call void %del_fnptr(i8* @CriticalSection)
  br label %bb_ret1

bb_ret1:
  ret i32 1
}