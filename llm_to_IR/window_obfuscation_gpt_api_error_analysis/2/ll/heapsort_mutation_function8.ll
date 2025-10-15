; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

@off_140004390 = external global i64*

define i32 @sub_140001870() {
entry:
  %base.ptr = load i64*, i64** @off_140004390, align 8
  %first.qword = load i64, i64* %base.ptr, align 8
  %first.i32 = trunc i64 %first.qword to i32
  %is.neg1 = icmp eq i32 %first.i32, -1
  br i1 %is.neg1, label %scan.start, label %have.count

scan.start:
  br label %scan.loop

scan.loop:
  %idx = phi i64 [ 1, %scan.start ], [ %idx.next, %scan.cont ]
  %elt.ptr = getelementptr inbounds i64, i64* %base.ptr, i64 %idx
  %elt = load i64, i64* %elt.ptr, align 8
  %is.zero = icmp eq i64 %elt, 0
  br i1 %is.zero, label %scan.done, label %scan.cont

scan.cont:
  %idx.next = add i64 %idx, 1
  br label %scan.loop

scan.done:
  %count.scan = add i64 %idx, -1
  br label %join.count

have.count:
  %count.zext = zext i32 %first.i32 to i64
  br label %join.count

join.count:
  %count = phi i64 [ %count.scan, %scan.done ], [ %count.zext, %have.count ]
  %count.iszero = icmp eq i64 %count, 0
  br i1 %count.iszero, label %after.calls, label %revloop.pre

revloop.pre:
  %p.init = getelementptr inbounds i64, i64* %base.ptr, i64 %count
  br label %revloop

revloop:
  %p = phi i64* [ %p.init, %revloop.pre ], [ %p.next, %revloop ]
  %fn.addr.i64 = load i64, i64* %p, align 8
  %fn.ptr = inttoptr i64 %fn.addr.i64 to void ()*
  call void %fn.ptr()
  %p.next = getelementptr inbounds i64, i64* %p, i64 -1
  %more = icmp ne i64* %p.next, %base.ptr
  br i1 %more, label %revloop, label %after.calls

after.calls:
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}