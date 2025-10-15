; ModuleID = 'sub_140001870'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i64*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define i32 @sub_140001870() {
entry:
  %tbl.ptr = load i64*, i64** @off_140004390, align 8
  %first.q = load i64, i64* %tbl.ptr, align 8
  %first.lo32 = trunc i64 %first.q to i32
  %is.neg1 = icmp eq i32 %first.lo32, -1
  br i1 %is.neg1, label %scan.init, label %count.path

count.path:                                         ; preds = %entry
  %n64 = zext i32 %first.lo32 to i64
  %n.is.zero = icmp eq i64 %n64, 0
  br i1 %n.is.zero, label %atexit, label %call.loop

call.loop:                                          ; preds = %count.path, %call.loop
  %i = phi i64 [ %n64, %count.path ], [ %i.dec, %call.loop ]
  %slot.ptr = getelementptr inbounds i64, i64* %tbl.ptr, i64 %i
  %f.int = load i64, i64* %slot.ptr, align 8
  %f.ptr = inttoptr i64 %f.int to void ()*
  call void %f.ptr()
  %i.dec = add i64 %i, -1
  %cont = icmp ne i64 %i.dec, 0
  br i1 %cont, label %call.loop, label %atexit

scan.init:                                          ; preds = %entry
  br label %scan.loop

scan.loop:                                          ; preds = %scan.init, %scan.body
  %idx = phi i64 [ 1, %scan.init ], [ %idx.next, %scan.body ]
  %scan.ptr = getelementptr inbounds i64, i64* %tbl.ptr, i64 %idx
  %val = load i64, i64* %scan.ptr, align 8
  %nz = icmp ne i64 %val, 0
  br i1 %nz, label %scan.body, label %after.scan

scan.body:                                          ; preds = %scan.loop
  %idx.next = add i64 %idx, 1
  br label %scan.loop

after.scan:                                         ; preds = %scan.loop
  %n.scan = add i64 %idx, -1
  %nscan.zero = icmp eq i64 %n.scan, 0
  br i1 %nscan.zero, label %atexit, label %call.loop.scan

call.loop.scan:                                     ; preds = %after.scan, %call.loop.scan
  %j = phi i64 [ %n.scan, %after.scan ], [ %j.dec, %call.loop.scan ]
  %slot.ptr2 = getelementptr inbounds i64, i64* %tbl.ptr, i64 %j
  %f.int2 = load i64, i64* %slot.ptr2, align 8
  %f.ptr2 = inttoptr i64 %f.int2 to void ()*
  call void %f.ptr2()
  %j.dec = add i64 %j, -1
  %cont2 = icmp ne i64 %j.dec, 0
  br i1 %cont2, label %call.loop.scan, label %atexit

atexit:                                             ; preds = %call.loop, %after.scan, %count.path, %call.loop.scan
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}