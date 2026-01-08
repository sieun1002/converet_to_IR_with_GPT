; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare void @sub_140001420(i8*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %0 = load i64*, i64** @off_1400043B0, align 8
  %1 = getelementptr inbounds i64, i64* %0, i64 0
  %2 = load i64, i64* %1, align 8
  %3 = trunc i64 %2 to i32
  %4 = icmp eq i32 %3, -1
  br i1 %4, label %scan, label %check_zero

check_zero:                                       ; preds = %entry
  %5 = icmp eq i32 %3, 0
  br i1 %5, label %after_calls, label %prep_loop

prep_loop:                                        ; preds = %check_zero
  %6 = sext i32 %3 to i64
  %7 = getelementptr inbounds i64, i64* %0, i64 %6
  br label %call_loop

call_loop:                                        ; preds = %call_loop, %prep_loop
  %8 = phi i64* [ %7, %prep_loop ], [ %11, %call_loop ]
  %9 = load i64, i64* %8, align 8
  %10 = inttoptr i64 %9 to void ()*
  call void %10()
  %11 = getelementptr inbounds i64, i64* %8, i64 -1
  %12 = icmp eq i64* %11, %0
  br i1 %12, label %after_calls, label %call_loop

after_calls:                                      ; preds = %call_loop, %check_zero, %call_loop2, %scan_exit
  %13 = bitcast void ()* @sub_140001450 to i8*
  tail call void @sub_140001420(i8* %13)
  ret void

scan:                                             ; preds = %entry
  br label %scan_loop

scan_loop:                                        ; preds = %scan_loop, %scan
  %14 = phi i64 [ 0, %scan ], [ %17, %scan_loop ]
  %15 = phi i32 [ 0, %scan ], [ %16, %scan_loop ]
  %16 = trunc i64 %14 to i32
  %17 = add i64 %14, 1
  %18 = getelementptr inbounds i64, i64* %0, i64 %17
  %19 = load i64, i64* %18, align 8
  %20 = icmp ne i64 %19, 0
  br i1 %20, label %scan_loop, label %scan_exit

scan_exit:                                        ; preds = %scan_loop
  %21 = icmp eq i32 %15, 0
  br i1 %21, label %after_calls, label %prep_loop2

prep_loop2:                                       ; preds = %scan_exit
  %22 = sext i32 %15 to i64
  %23 = getelementptr inbounds i64, i64* %0, i64 %22
  br label %call_loop2

call_loop2:                                       ; preds = %call_loop2, %prep_loop2
  %24 = phi i64* [ %23, %prep_loop2 ], [ %27, %call_loop2 ]
  %25 = load i64, i64* %24, align 8
  %26 = inttoptr i64 %25 to void ()*
  call void %26()
  %27 = getelementptr inbounds i64, i64* %24, i64 -1
  %28 = icmp eq i64* %27, %0
  br i1 %28, label %after_calls, label %call_loop2
}