; ModuleID = 'fixed-ir'
source_filename = "fixed-ir"
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8*, align 8

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define i32 @sub_140001870() local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_140004390, align 8
  %count_ptr = bitcast i8* %base_ptr to i32*
  %count0 = load i32, i32* %count_ptr, align 4
  %is_m1 = icmp eq i32 %count0, -1
  br i1 %is_m1, label %scan_init, label %have_count

scan_init:
  br label %scan_loop

scan_loop:
  %idx = phi i32 [ 1, %scan_init ], [ %idx.next, %scan_body ]
  %prev = phi i32 [ 0, %scan_init ], [ %idx, %scan_body ]
  %idx.z = zext i32 %idx to i64
  %offset = mul i64 %idx.z, 8
  %elem_i8 = getelementptr i8, i8* %base_ptr, i64 %offset
  %elem = bitcast i8* %elem_i8 to i64*
  %val = load i64, i64* %elem, align 8
  %cond = icmp ne i64 %val, 0
  br i1 %cond, label %scan_body, label %have_count_from_scan

scan_body:
  %idx.next = add i32 %idx, 1
  br label %scan_loop

have_count_from_scan:
  %count_scanned = phi i32 [ %prev, %scan_loop ]
  br label %have_count

have_count:
  %count = phi i32 [ %count0, %entry ], [ %count_scanned, %have_count_from_scan ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %do_atexit, label %loop

loop:
  %i = phi i32 [ %count, %have_count ], [ %i.dec, %loop ]
  %i.z = zext i32 %i to i64
  %off2 = mul i64 %i.z, 8
  %ep_i8 = getelementptr i8, i8* %base_ptr, i64 %off2
  %ep = bitcast i8* %ep_i8 to i8**
  %fp_i8 = load i8*, i8** %ep, align 8
  %fp = bitcast i8* %fp_i8 to void ()*
  call void %fp()
  %i.dec = add i32 %i, -1
  %cont = icmp ne i32 %i.dec, 0
  br i1 %cont, label %loop, label %do_atexit

do_atexit:
  %p = bitcast void ()* @sub_140001820 to void ()*
  %r = call i32 @j__crt_atexit(void ()* %p)
  ret i32 %r
}