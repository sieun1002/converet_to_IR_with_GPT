; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare void @loc_140001420(i8*)
declare void @sub_1400018F0()

define void @sub_140001940() {
entry:
  %base_ptr = load i64*, i64** @off_1400043B0, align 8
  %first64 = load i64, i64* %base_ptr, align 8
  %first32 = trunc i64 %first64 to i32
  %is_minus1 = icmp eq i32 %first32, -1
  br i1 %is_minus1, label %sentinel, label %count_set

count_set:
  br label %decide

sentinel:
  br label %scan_check

scan_check:
  %idx.phi = phi i64 [ 1, %sentinel ], [ %idx.next, %scan_iter ]
  %curptr = getelementptr inbounds i64, i64* %base_ptr, i64 %idx.phi
  %curval = load i64, i64* %curptr, align 8
  %nonzero = icmp ne i64 %curval, 0
  br i1 %nonzero, label %scan_iter, label %scan_done

scan_iter:
  %idx.next = add i64 %idx.phi, 1
  br label %scan_check

scan_done:
  %count64_from_scan = add i64 %idx.phi, -1
  %count32_from_scan = trunc i64 %count64_from_scan to i32
  br label %decide

decide:
  %count32 = phi i32 [ %first32, %count_set ], [ %count32_from_scan, %scan_done ]
  %is_zero = icmp eq i32 %count32, 0
  br i1 %is_zero, label %after_calls, label %call_loop_entry

call_loop_entry:
  %count64 = sext i32 %count32 to i64
  br label %call_loop

call_loop:
  %i = phi i64 [ %count64, %call_loop_entry ], [ %i.next, %call_loop ]
  %ptr = getelementptr inbounds i64, i64* %base_ptr, i64 %i
  %fval = load i64, i64* %ptr, align 8
  %fptr = inttoptr i64 %fval to void ()*
  call void %fptr()
  %i.next = add i64 %i, -1
  %cont = icmp ne i64 %i.next, 0
  br i1 %cont, label %call_loop, label %after_calls

after_calls:
  %funcptr = bitcast void ()* @sub_1400018F0 to i8*
  tail call void @loc_140001420(i8* %funcptr)
  ret void
}