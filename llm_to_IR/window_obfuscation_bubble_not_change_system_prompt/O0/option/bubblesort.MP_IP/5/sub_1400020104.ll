; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external dso_local global i8*
@dword_1400070E8 = external dso_local global i32
@unk_140007100 = external dso_local global i8

declare dso_local void @sub_140001E80()
declare dso_local void @sub_140002120()
declare dso_local void @sub_1404EFA12(i8*)
declare dso_local void @loc_1405C002E(i8*)

define dso_local i32 @sub_140002010(i32 %arg) local_unnamed_addr {
entry:
  %var10 = alloca i8*, align 8
  %cmp_eq2 = icmp eq i32 %arg, 2
  br i1 %cmp_eq2, label %case2, label %after_cmp2

after_cmp2:                                        ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %arg, 2
  br i1 %cmp_gt2, label %gt2, label %le1_or1

gt2:                                              ; preds = %after_cmp2
  %cmp_eq3 = icmp eq i32 %arg, 3
  br i1 %cmp_eq3, label %eq3, label %ret1

eq3:                                              ; preds = %gt2
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %iszero1 = icmp eq i32 %g1, 0
  br i1 %iszero1, label %ret1, label %callE80_after

callE80_after:                                    ; preds = %eq3
  call void @sub_140001E80()
  br label %ret1

le1_or1:                                          ; preds = %after_cmp2
  %iszero = icmp eq i32 %arg, 0
  br i1 %iszero, label %edx_zero, label %edx_one_path

edx_one_path:                                     ; preds = %le1_or1
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %iszero2 = icmp eq i32 %g2, 0
  br i1 %iszero2, label %loc_100, label %set_state1

loc_100:                                          ; preds = %edx_one_path
  call void @sub_1404EFA12(i8* @unk_140007100)
  br label %set_state1

set_state1:                                       ; preds = %loc_100, %edx_one_path
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case2:                                            ; preds = %entry
  call void @sub_140002120()
  ret i32 1

edx_zero:                                         ; preds = %le1_or1
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %isnotzero3 = icmp ne i32 %g3, 0
  br i1 %isnotzero3, label %callE80_then, label %at_06e

callE80_then:                                     ; preds = %edx_zero
  call void @sub_140001E80()
  br label %at_06e

at_06e:                                           ; preds = %callE80_then, %edx_zero
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g4, 1
  br i1 %is1, label %list_cleanup, label %ret1

list_cleanup:                                     ; preds = %at_06e
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_isnull = icmp eq i8* %head, null
  br i1 %head_isnull, label %after_loop, label %loop

loop:                                             ; preds = %after_call, %list_cleanup
  %node_cur = phi i8* [ %head, %list_cleanup ], [ %next_loaded, %after_call ]
  %ptr16 = getelementptr i8, i8* %node_cur, i64 16
  %ptr16pp = bitcast i8* %ptr16 to i8**
  %next_val = load i8*, i8** %ptr16pp, align 8
  store i8* %next_val, i8** %var10, align 8
  %fptr = inttoptr i64 5368719344 to void (i8*)*
  call void %fptr(i8* %node_cur)
  %next_loaded = load i8*, i8** %var10, align 8
  %notnull = icmp ne i8* %next_loaded, null
  br i1 %notnull, label %after_call, label %after_loop

after_call:                                       ; preds = %loop
  br label %loop

after_loop:                                       ; preds = %loop, %list_cleanup
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @loc_1405C002E(i8* @unk_140007100)
  br label %ret1

ret1:                                             ; preds = %after_loop, %at_06e, %set_state1, %eq3, %callE80_after, %gt2
  ret i32 1
}