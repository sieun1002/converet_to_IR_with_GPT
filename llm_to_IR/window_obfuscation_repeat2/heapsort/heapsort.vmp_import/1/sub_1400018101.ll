; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8*

declare void @loc_140001420(void ()*)
declare void @sub_1400017C0()

define void @sub_140001810() {
entry:
  %tbl_ptr = load i8*, i8** @off_140004390, align 8
  %base_i32p = bitcast i8* %tbl_ptr to i32*
  %first32 = load i32, i32* %base_i32p, align 4
  %is_minus1 = icmp eq i32 %first32, -1
  %base_ptrptr = bitcast i8* %tbl_ptr to i8**
  br i1 %is_minus1, label %scan_sentinel, label %check_zero

scan_sentinel:
  br label %scan_loop

scan_loop:
  %idx_scan = phi i64 [ 1, %scan_sentinel ], [ %idx_next, %scan_iter ]
  %elem_ptr_scan = getelementptr inbounds i8*, i8** %base_ptrptr, i64 %idx_scan
  %elem_scan = load i8*, i8** %elem_ptr_scan, align 8
  %is_nonnull = icmp ne i8* %elem_scan, null
  br i1 %is_nonnull, label %scan_iter, label %after_scan

scan_iter:
  %idx_next = add i64 %idx_scan, 1
  br label %scan_loop

after_scan:
  %count_from_scan = add i64 %idx_scan, -1
  br label %do_calls

check_zero:
  %is_zero = icmp eq i32 %first32, 0
  br i1 %is_zero, label %after_calls, label %header_count

header_count:
  %count_header = zext i32 %first32 to i64
  br label %do_calls

do_calls:
  %count = phi i64 [ %count_from_scan, %after_scan ], [ %count_header, %header_count ]
  br label %call_loop

call_loop:
  %i = phi i64 [ %count, %do_calls ], [ %i_dec, %call_iter ]
  %elem_ptr = getelementptr inbounds i8*, i8** %base_ptrptr, i64 %i
  %elem = load i8*, i8** %elem_ptr, align 8
  %fn = bitcast i8* %elem to void ()*
  call void %fn()
  %i_dec = add i64 %i, -1
  %cont = icmp ne i64 %i_dec, 0
  br i1 %cont, label %call_iter, label %after_calls

call_iter:
  br label %call_loop

after_calls:
  call void @loc_140001420(void ()* @sub_1400017C0)
  ret void
}