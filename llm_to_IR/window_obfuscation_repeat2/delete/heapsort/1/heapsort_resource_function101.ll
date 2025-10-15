; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define i32 @sub_140001870() {
entry:
  %p_tbl.i8 = load i8*, i8** @off_140004390, align 8
  %p_tbl = bitcast i8* %p_tbl.i8 to i64*
  %first.q = load i64, i64* %p_tbl, align 8
  %first.i32 = trunc i64 %first.q to i32
  %is_m1 = icmp eq i32 %first.i32, -1
  br i1 %is_m1, label %scan, label %after_scan

scan:
  br label %scan.loop

scan.loop:
  %j = phi i64 [ 1, %scan ], [ %j.next, %scan.body ]
  %elem.ptr = getelementptr inbounds i64, i64* %p_tbl, i64 %j
  %elem = load i64, i64* %elem.ptr, align 8
  %nz = icmp ne i64 %elem, 0
  br i1 %nz, label %scan.body, label %scan.end

scan.body:
  %j.next = add i64 %j, 1
  br label %scan.loop

scan.end:
  %count64 = sub i64 %j, 1
  %count32 = trunc i64 %count64 to i32
  br label %after_scan

after_scan:
  %count = phi i32 [ %count32, %scan.end ], [ %first.i32, %entry ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %do_atexit, label %call.loop.pre

call.loop.pre:
  %i.start = zext i32 %count to i64
  br label %call.loop

call.loop:
  %i = phi i64 [ %i.start, %call.loop.pre ], [ %i.dec, %call.loop ]
  %call.ptr.ptr = getelementptr inbounds i64, i64* %p_tbl, i64 %i
  %addr = load i64, i64* %call.ptr.ptr, align 8
  %fn = inttoptr i64 %addr to void ()*
  call void %fn()
  %i.dec = add i64 %i, -1
  %cont = icmp ne i64 %i.dec, 0
  br i1 %cont, label %call.loop, label %do_atexit

do_atexit:
  %res = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %res
}