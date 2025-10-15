; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare i8* @signal(i32, i8*)
declare void @sub_140001010()
declare void @sub_1400024E0()

define void @start() local_unnamed_addr {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %recPtr) local_unnamed_addr {
entry:
  %0 = bitcast i8* %recPtr to i8**
  %1 = load i8*, i8** %0, align 8
  %2 = bitcast i8* %1 to i32*
  %3 = load i32, i32* %2, align 4
  %4 = and i32 %3, 553648127
  %5 = icmp eq i32 %4, 541541187
  br i1 %5, label %check_flags, label %main_dispatch

check_flags:                                       ; preds = %entry
  %6 = getelementptr inbounds i8, i8* %1, i64 4
  %7 = load i8, i8* %6, align 1
  %8 = and i8 %7, 1
  %9 = icmp ne i8 %8, 0
  br i1 %9, label %main_dispatch, label %ret_minus1

main_dispatch:                                     ; preds = %check_flags, %entry
  %10 = icmp ugt i32 %3, 3221225622
  br i1 %10, label %fallback_0EF, label %le_96

le_96:                                             ; preds = %main_dispatch
  %11 = icmp ule i32 %3, 3221225611
  br i1 %11, label %loc_110, label %switch_calc

loc_110:                                           ; preds = %le_96
  %12 = icmp eq i32 %3, 3221225477
  br i1 %12, label %loc_1C0, label %loc_110_part2

loc_110_part2:                                     ; preds = %loc_110
  %13 = icmp ugt i32 %3, 3221225477
  br i1 %13, label %loc_150, label %loc_110_part3

loc_110_part3:                                     ; preds = %loc_110_part2
  %14 = icmp eq i32 %3, 2147483650
  br i1 %14, label %ret_minus1, label %fallback_0EF

loc_150:                                           ; preds = %loc_110_part2
  %15 = icmp eq i32 %3, 3221225480
  br i1 %15, label %ret_minus1, label %loc_150_part2

loc_150_part2:                                     ; preds = %loc_150
  %16 = icmp eq i32 %3, 3221225501
  br i1 %16, label %loc_15E, label %fallback_0EF

switch_calc:                                       ; preds = %le_96
  %17 = add i32 %3, 1073741683
  %18 = icmp ule i32 %17, 9
  br i1 %18, label %switch_dispatch, label %ret_minus1

switch_dispatch:                                   ; preds = %switch_calc
  switch i32 %17, label %ret_minus1 [
    i32 0, label %loc_0D0
    i32 1, label %loc_0D0
    i32 2, label %loc_0D0
    i32 3, label %loc_0D0
    i32 4, label %loc_0D0
    i32 5, label %ret_minus1
    i32 6, label %loc_0D0
    i32 7, label %loc_190
    i32 8, label %ret_minus1
    i32 9, label %loc_15E
  ]

loc_0D0:                                           ; preds = %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch, %switch_dispatch
  %19 = call i8* @signal(i32 8, i8* null)
  %20 = inttoptr i64 1 to i8*
  %21 = icmp eq i8* %19, %20
  br i1 %21, label %loc_2224, label %after_check0

after_check0:                                      ; preds = %loc_0D0
  %22 = icmp ne i8* %19, null
  br i1 %22, label %loc_1F0_from_0D0, label %fallback_0EF

loc_1F0_from_0D0:                                  ; preds = %after_check0
  %23 = bitcast i8* %19 to void (i32)*
  call void %23(i32 8)
  br label %ret_minus1

loc_190:                                           ; preds = %switch_dispatch
  %24 = call i8* @signal(i32 8, i8* null)
  %25 = inttoptr i64 1 to i8*
  %26 = icmp eq i8* %24, %25
  br i1 %26, label %loc_190_set, label %loc_190_after

loc_190_set:                                       ; preds = %loc_190
  %27 = call i8* @signal(i32 8, i8* %25)
  br label %ret_minus1

loc_190_after:                                     ; preds = %loc_190
  %28 = icmp ne i8* %24, null
  br i1 %28, label %loc_1F0_from_190, label %fallback_0EF

loc_1F0_from_190:                                  ; preds = %loc_190_after
  %29 = bitcast i8* %24 to void (i32)*
  call void %29(i32 8)
  br label %ret_minus1

loc_15E:                                           ; preds = %loc_150_part2, %switch_dispatch
  %30 = call i8* @signal(i32 4, i8* null)
  %31 = inttoptr i64 1 to i8*
  %32 = icmp eq i8* %30, %31
  br i1 %32, label %loc_210, label %after15e

after15e:                                          ; preds = %loc_15E
  %33 = icmp eq i8* %30, null
  br i1 %33, label %fallback_0EF, label %call15e

call15e:                                           ; preds = %after15e
  %34 = bitcast i8* %30 to void (i32)*
  call void %34(i32 4)
  br label %ret_minus1

loc_1C0:                                           ; preds = %loc_110
  %35 = call i8* @signal(i32 11, i8* null)
  %36 = inttoptr i64 1 to i8*
  %37 = icmp eq i8* %35, %36
  br i1 %37, label %loc_1FC, label %after1c0

after1c0:                                          ; preds = %loc_1C0
  %38 = icmp eq i8* %35, null
  br i1 %38, label %fallback_0EF, label %call1c0

call1c0:                                           ; preds = %after1c0
  %39 = bitcast i8* %35 to void (i32)*
  call void %39(i32 11)
  br label %ret_minus1

loc_1FC:                                           ; preds = %loc_1C0
  %40 = call i8* @signal(i32 11, i8* %36)
  br label %ret_minus1

loc_210:                                           ; preds = %loc_15E
  %41 = call i8* @signal(i32 4, i8* %31)
  br label %ret_minus1

loc_2224:                                          ; preds = %loc_0D0
  %42 = inttoptr i64 1 to i8*
  %43 = call i8* @signal(i32 8, i8* %42)
  call void @sub_1400024E0()
  br label %ret_minus1

fallback_0EF:                                      ; preds = %after1c0, %after15e, %loc_190_after, %after_check0, %loc_150_part2, %loc_110_part3, %main_dispatch
  %44 = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %45 = icmp eq i32 (i8*)* %44, null
  br i1 %45, label %ret0, label %tailcall

ret0:                                              ; preds = %fallback_0EF
  ret i32 0

tailcall:                                          ; preds = %fallback_0EF
  %46 = call i32 %44(i8* %recPtr)
  ret i32 %46

ret_minus1:                                        ; preds = %loc_2224, %loc_210, %call1c0, %loc_1FC, %call15e, %loc_1F0_from_190, %loc_190_set, %loc_1F0_from_0D0, %switch_dispatch, %switch_calc, %loc_150, %loc_110_part3, %check_flags
  ret i32 -1
}