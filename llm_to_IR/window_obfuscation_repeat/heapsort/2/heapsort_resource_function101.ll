; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i64*, align 8

declare i32 @j__crt_atexit(void ()*)

define void @sub_140001820() {
entry:
  ret void
}

define i32 @sub_140001870() {
entry:
  %0 = load i64*, i64** @off_140004390, align 8
  %1 = load i64, i64* %0, align 8
  %2 = trunc i64 %1 to i32
  %3 = icmp eq i32 %2, -1
  br i1 %3, label %scan_init, label %have_count

have_count:                                        ; preds = %entry
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %register, label %call_loop_prep

scan_init:                                         ; preds = %entry
  br label %scan_loop

scan_loop:                                         ; preds = %scan_loop, %scan_init
  %5 = phi i64 [ 0, %scan_init ], [ %8, %scan_loop ]
  %6 = add i64 %5, 1
  %7 = getelementptr inbounds i64, i64* %0, i64 %6
  %8 = add i64 %5, 1
  %9 = load i64, i64* %7, align 8
  %10 = icmp ne i64 %9, 0
  br i1 %10, label %scan_loop, label %scan_exit

scan_exit:                                         ; preds = %scan_loop
  %11 = trunc i64 %5 to i32
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %register, label %call_loop_from_scan_prep

call_loop_from_scan_prep:                          ; preds = %scan_exit
  %13 = zext i32 %11 to i64
  br label %call_loop

call_loop_prep:                                    ; preds = %have_count
  %14 = zext i32 %2 to i64
  br label %call_loop

call_loop:                                         ; preds = %call_loop_iter, %call_loop_prep, %call_loop_from_scan_prep
  %15 = phi i64 [ %14, %call_loop_prep ], [ %16, %call_loop_iter ], [ %13, %call_loop_from_scan_prep ]
  %16 = add i64 %15, -1
  %17 = getelementptr inbounds i64, i64* %0, i64 %15
  %18 = load i64, i64* %17, align 8
  %19 = inttoptr i64 %18 to void ()*
  call void %19()
  %20 = icmp ne i64 %16, 0
  br i1 %20, label %call_loop_iter, label %register

call_loop_iter:                                    ; preds = %call_loop
  br label %call_loop

register:                                          ; preds = %call_loop, %scan_exit, %have_count
  %21 = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %21
}