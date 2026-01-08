; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*, align 8

declare void @loc_140001420(i8*)
declare void @sub_140001450()

define void @sub_1400014A0() local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043B0, align 8
  %count.ptr = bitcast i8* %base.ptr to i32*
  %count32.raw = load i32, i32* %count.ptr, align 4
  %is.m1 = icmp eq i32 %count32.raw, -1
  br i1 %is.m1, label %scan.start, label %direct.count

direct.count:                                      ; preds = %entry
  br label %have.count

scan.start:                                        ; preds = %entry
  br label %scan.loop

scan.loop:                                         ; preds = %scan.cont, %scan.start
  %k.phi = phi i64 [ 1, %scan.start ], [ %k.next, %scan.cont ]
  %off.k = mul i64 %k.phi, 8
  %slot.addr = getelementptr i8, i8* %base.ptr, i64 %off.k
  %slot.pp = bitcast i8* %slot.addr to i8**
  %slot.val = load i8*, i8** %slot.pp, align 8
  %nonzero = icmp ne i8* %slot.val, null
  br i1 %nonzero, label %scan.cont, label %count.got

scan.cont:                                         ; preds = %scan.loop
  %k.next = add i64 %k.phi, 1
  br label %scan.loop

count.got:                                         ; preds = %scan.loop
  %k.minus1 = add i64 %k.phi, -1
  %count.from.scan32 = trunc i64 %k.minus1 to i32
  br label %have.count

have.count:                                        ; preds = %count.got, %direct.count
  %count.phi = phi i32 [ %count32.raw, %direct.count ], [ %count.from.scan32, %count.got ]
  %is.zero = icmp eq i32 %count.phi, 0
  br i1 %is.zero, label %tail, label %setup.loop

setup.loop:                                        ; preds = %have.count
  %count64 = sext i32 %count.phi to i64
  %off.bytes = mul i64 %count64, 8
  %rbx.init = getelementptr i8, i8* %base.ptr, i64 %off.bytes
  br label %call.loop

call.loop:                                         ; preds = %call.loop, %setup.loop
  %rbx.phi = phi i8* [ %rbx.init, %setup.loop ], [ %rbx.prev, %call.loop ]
  %pp = bitcast i8* %rbx.phi to i8**
  %fn.i8 = load i8*, i8** %pp, align 8
  %fn.void = bitcast i8* %fn.i8 to void ()*
  call void %fn.void()
  %rbx.prev = getelementptr i8, i8* %rbx.phi, i64 -8
  %cont = icmp ne i8* %rbx.prev, %base.ptr
  br i1 %cont, label %call.loop, label %tail

tail:                                              ; preds = %call.loop, %have.count
  %arg = bitcast void ()* @sub_140001450 to i8*
  tail call void @loc_140001420(i8* %arg)
  ret void
}