; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*

declare void @sub_140001420(void ()*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %baseptr.ptr = load i8*, i8** @off_1400043B0, align 8
  %base_as_i64p = bitcast i8* %baseptr.ptr to i64*
  %first64 = load i64, i64* %base_as_i64p, align 8
  %first32 = trunc i64 %first64 to i32
  %is_m1 = icmp eq i32 %first32, -1
  br i1 %is_m1, label %scan.init, label %count.init

count.init:                                        ; not -1: use value as count
  br label %count.merge

scan.init:                                         ; -1: scan for first zero entry
  br label %scan.loop

scan.loop:
  %i.prev = phi i64 [ 0, %scan.init ], [ %i.next, %scan.loop ]
  %i.next = add i64 %i.prev, 1
  %offs.bytes = mul i64 %i.next, 8
  %slot.ptr.byte = getelementptr i8, i8* %baseptr.ptr, i64 %offs.bytes
  %slot.ptr = bitcast i8* %slot.ptr.byte to void ()**
  %fn.scan = load void ()*, void ()** %slot.ptr, align 8
  %nonzero = icmp ne void ()* %fn.scan, null
  br i1 %nonzero, label %scan.loop, label %scan.done

scan.done:
  %scan.count32 = trunc i64 %i.prev to i32
  br label %count.merge

count.merge:
  %count = phi i32 [ %first32, %count.init ], [ %scan.count32, %scan.done ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %tail, label %call.loop.init

call.loop.init:
  %idx64 = zext i32 %count to i64
  br label %call.loop

call.loop:
  %idx.cur = phi i64 [ %idx64, %call.loop.init ], [ %idx.dec, %call.loop ]
  %offs2 = mul i64 %idx.cur, 8
  %slot2.byte = getelementptr i8, i8* %baseptr.ptr, i64 %offs2
  %slot2 = bitcast i8* %slot2.byte to void ()**
  %fn = load void ()*, void ()** %slot2, align 8
  call void %fn()
  %idx.dec = add i64 %idx.cur, -1
  %cont = icmp ne i64 %idx.dec, 0
  br i1 %cont, label %call.loop, label %tail

tail:
  tail call void @sub_140001420(void ()* @sub_140001450)
  ret void
}