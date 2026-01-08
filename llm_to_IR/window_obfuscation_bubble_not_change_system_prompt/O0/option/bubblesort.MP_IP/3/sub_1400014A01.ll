; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*

declare void @sub_140001420(void ()*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %base.ptr = load i8*, i8** @off_1400043B0, align 8
  %base.i32 = bitcast i8* %base.ptr to i32*
  %cnt0 = load i32, i32* %base.i32, align 4
  %is.m1 = icmp eq i32 %cnt0, -1
  br i1 %is.m1, label %scan.init, label %have.count

have.count:
  %is.zero = icmp eq i32 %cnt0, 0
  br i1 %is.zero, label %after.calls, label %call.loop.prep

scan.init:
  br label %scan.loop

scan.loop:
  %curr = phi i64 [ 0, %scan.init ], [ %next.curr, %scan.body ]
  %ecx.prev = trunc i64 %curr to i32
  %r8 = add i64 %curr, 1
  %off = shl i64 %r8, 3
  %elem.addr.i8 = getelementptr i8, i8* %base.ptr, i64 %off
  %elem.slot = bitcast i8* %elem.addr.i8 to i8**
  %elem = load i8*, i8** %elem.slot, align 8
  %nonzero = icmp ne i8* %elem, null
  br i1 %nonzero, label %scan.body, label %scan.exit

scan.body:
  %next.curr = add i64 %curr, 1
  br label %scan.loop

scan.exit:
  %is.zero2 = icmp eq i32 %ecx.prev, 0
  br i1 %is.zero2, label %after.calls, label %call.loop.prep.from.scan

call.loop.prep.from.scan:
  br label %call.loop.prep

call.loop.prep:
  %count.phi = phi i32 [ %cnt0, %have.count ], [ %ecx.prev, %call.loop.prep.from.scan ]
  %count.zext = zext i32 %count.phi to i64
  %start.off = shl i64 %count.zext, 3
  %rbx.start = getelementptr i8, i8* %base.ptr, i64 %start.off
  br label %call.loop

call.loop:
  %rbx.cur = phi i8* [ %rbx.start, %call.loop.prep ], [ %rbx.next, %call.loop.iter ]
  %slotptr = bitcast i8* %rbx.cur to i8**
  %fp.i8 = load i8*, i8** %slotptr, align 8
  %fp = bitcast i8* %fp.i8 to void ()*
  call void %fp()
  %rbx.next = getelementptr i8, i8* %rbx.cur, i64 -8
  %cont = icmp ne i8* %rbx.next, %base.ptr
  br i1 %cont, label %call.loop.iter, label %after.calls

call.loop.iter:
  br label %call.loop

after.calls:
  tail call void @sub_140001420(void ()* @sub_140001450)
  ret void
}