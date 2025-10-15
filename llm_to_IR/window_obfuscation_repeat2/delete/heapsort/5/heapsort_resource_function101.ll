; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_140004390 = external dso_local global i64*, align 8

declare dso_local i32 @j__crt_atexit(void ()*)
declare dso_local void @sub_140001820()

define dso_local i32 @sub_140001870() local_unnamed_addr {
entry:
  %0 = load i64*, i64** @off_140004390, align 8
  %1 = load i64, i64* %0, align 8
  %2 = trunc i64 %1 to i32
  %3 = icmp eq i32 %2, -1
  br i1 %3, label %scan_init, label %count_from_header

scan_init:                                         ; preds = %entry
  %4 = bitcast i64* %0 to i8**
  br label %scan_loop

scan_loop:                                         ; preds = %scan_loop_cont, %scan_init
  %5 = phi i64 [ 0, %scan_init ], [ %8, %scan_loop_cont ]
  %6 = add i64 %5, 1
  %7 = getelementptr inbounds i8*, i8** %4, i64 %6
  %8 = add i64 %5, 1
  %9 = load i8*, i8** %7, align 8
  %10 = icmp ne i8* %9, null
  br i1 %10, label %scan_loop_cont, label %count_from_scan

scan_loop_cont:                                    ; preds = %scan_loop
  br label %scan_loop

count_from_scan:                                   ; preds = %scan_loop
  br label %dispatch_count

count_from_header:                                 ; preds = %entry
  %11 = zext i32 %2 to i64
  br label %dispatch_count

dispatch_count:                                    ; preds = %count_from_header, %count_from_scan
  %12 = phi i64 [ %5, %count_from_scan ], [ %11, %count_from_header ]
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %after_calls, label %call_setup

call_setup:                                        ; preds = %dispatch_count
  %14 = bitcast i64* %0 to void ()**
  %15 = getelementptr inbounds void ()*, void ()** %14, i64 %12
  br label %call_loop

call_loop:                                         ; preds = %call_loop, %call_setup
  %16 = phi void ()** [ %15, %call_setup ], [ %19, %call_loop ]
  %17 = load void ()*, void ()** %16, align 8
  call void %17()
  %18 = getelementptr inbounds void ()*, void ()** %16, i64 -1
  %19 = getelementptr inbounds void ()*, void ()** %16, i64 -1
  %20 = icmp eq void ()** %18, %14
  br i1 %20, label %after_calls, label %call_loop

after_calls:                                       ; preds = %call_loop, %dispatch_count
  %21 = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %21
}