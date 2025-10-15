; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i8*

declare void @sub_140001010()
declare void (i32)* @signal(i32, void (i32)*)
declare void @sub_1400024E0()

define void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %0) {
entry:
  %1 = load i8*, i8** %0, align 8
  %2 = bitcast i8* %1 to i32*
  %3 = load i32, i32* %2, align 4
  %4 = and i32 %3, 553648127
  %5 = icmp eq i32 %4, 541541187
  br i1 %5, label %ccg_check, label %range_check

ccg_check:                                           ; 0x140002130 path
  %6 = getelementptr i8, i8* %1, i64 4
  %7 = load i8, i8* %6, align 1
  %8 = and i8 %7, 1
  %9 = icmp ne i8 %8, 0
  br i1 %9, label %range_check, label %default_return

range_check:                                         ; corresponds to loc_1400020A1 region
  %10 = icmp ugt i32 %3, 3221225622
  br i1 %10, label %fallback_20EF, label %le_0096

le_0096:
  %11 = icmp ule i32 %3, 3221225611
  br i1 %11, label %case_2110, label %switch_prep

switch_prep:
  %12 = add i32 %3, 1073741683
  %13 = icmp ugt i32 %12, 9
  br i1 %13, label %default_return, label %switch_disp

switch_disp:
  switch i32 %12, label %default_return [
    i32 0, label %case_20D0
    i32 1, label %case_20D0
    i32 2, label %case_20D0
    i32 3, label %case_20D0
    i32 4, label %case_20D0
    i32 5, label %default_return
    i32 6, label %case_20D0
    i32 7, label %case_2190
    i32 8, label %default_return
    i32 9, label %default_return
  ]

case_20D0:
  %14 = call void (i32)* @signal(i32 8, void (i32)* null)
  %15 = ptrtoint void (i32)* %14 to i64
  %16 = icmp eq i64 %15, 1
  br i1 %16, label %case_2224, label %check_nonzero_20D0

check_nonzero_20D0:
  %17 = icmp ne i64 %15, 0
  br i1 %17, label %case_21F0, label %fallback_20EF

case_2190:
  %18 = call void (i32)* @signal(i32 8, void (i32)* null)
  %19 = ptrtoint void (i32)* %18 to i64
  %20 = icmp eq i64 %19, 1
  br i1 %20, label %case_2190_set_ign, label %case_2190_check

case_2190_set_ign:
  %21 = inttoptr i64 1 to void (i32)*
  %22 = call void (i32)* @signal(i32 8, void (i32)* %21)
  br label %default_return

case_2190_check:
  %23 = icmp ne i64 %19, 0
  br i1 %23, label %case_21F0_from2190, label %fallback_20EF

case_21F0:
  call void %14(i32 8)
  br label %default_return

case_21F0_from2190:
  call void %18(i32 8)
  br label %default_return

case_2224:
  %24 = inttoptr i64 1 to void (i32)*
  %25 = call void (i32)* @signal(i32 8, void (i32)* %24)
  call void @sub_1400024E0()
  br label %default_return

case_2110:
  %26 = icmp eq i32 %3, 3221225477
  br i1 %26, label %case_1C0, label %gt_0005

gt_0005:
  %27 = icmp ugt i32 %3, 3221225477
  br i1 %27, label %case_2150, label %lt_0005

lt_0005:
  %28 = icmp eq i32 %3, 2147483650
  br i1 %28, label %default_return, label %fallback_20EF

case_2150:
  %29 = icmp eq i32 %3, 3221225480
  br i1 %29, label %default_return, label %check_001D

check_001D:
  %30 = icmp eq i32 %3, 3221225501
  br i1 %30, label %case_15E, label %fallback_20EF

case_15E:
  %31 = call void (i32)* @signal(i32 4, void (i32)* null)
  %32 = ptrtoint void (i32)* %31 to i64
  %33 = icmp eq i64 %32, 1
  br i1 %33, label %case_2210, label %check_15E_nonzero

check_15E_nonzero:
  %34 = icmp ne i64 %32, 0
  br i1 %34, label %call_handler_15E, label %fallback_20EF

call_handler_15E:
  call void %31(i32 4)
  br label %default_return

case_2210:
  %35 = inttoptr i64 1 to void (i32)*
  %36 = call void (i32)* @signal(i32 4, void (i32)* %35)
  br label %default_return

case_1C0:
  %37 = call void (i32)* @signal(i32 11, void (i32)* null)
  %38 = ptrtoint void (i32)* %37 to i64
  %39 = icmp eq i64 %38, 1
  br i1 %39, label %case_1FC, label %check_1C0_nonzero

check_1C0_nonzero:
  %40 = icmp ne i64 %38, 0
  br i1 %40, label %call_handler_1C0, label %fallback_20EF

call_handler_1C0:
  call void %37(i32 11)
  br label %default_return

case_1FC:
  %41 = inttoptr i64 1 to void (i32)*
  %42 = call void (i32)* @signal(i32 11, void (i32)* %41)
  br label %default_return

fallback_20EF:
  %43 = load i8*, i8** @qword_1400070D0, align 8
  %44 = icmp eq i8* %43, null
  br i1 %44, label %ret_zero_140, label %tailcall

tailcall:
  %45 = bitcast i8* %43 to i32 (i8**)*
  %46 = call i32 %45(i8** %0)
  ret i32 %46

ret_zero_140:
  ret i32 0

default_return:
  ret i32 -1
}