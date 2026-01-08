; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare void @loc_140001420(i8*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %base.ptr.ptr = load i64*, i64** @off_1400043B0, align 8
  %q0 = load i64, i64* %base.ptr.ptr, align 8
  %ecx.tr = trunc i64 %q0 to i32
  %is_m1 = icmp eq i32 %ecx.tr, -1
  br i1 %is_m1, label %scan.init, label %after.count

scan.init:
  br label %scan.loop

scan.loop:
  %idx = phi i64 [ 1, %scan.init ], [ %idx.next, %scan.cont ]
  %slot.ptr = getelementptr inbounds i64, i64* %base.ptr.ptr, i64 %idx
  %val.load = load i64, i64* %slot.ptr, align 8
  %nz = icmp ne i64 %val.load, 0
  br i1 %nz, label %scan.cont, label %after.from.scan

scan.cont:
  %idx.next = add i64 %idx, 1
  br label %scan.loop

after.from.scan:
  %idx.minus1 = add i64 %idx, -1
  %ecx.scan = trunc i64 %idx.minus1 to i32
  br label %after.count

after.count:
  %ecx.final = phi i32 [ %ecx.tr, %entry ], [ %ecx.scan, %after.from.scan ]
  %is_zero = icmp eq i32 %ecx.final, 0
  br i1 %is_zero, label %after.calls, label %prep.loop

prep.loop:
  %n64 = zext i32 %ecx.final to i64
  br label %call.loop

call.loop:
  %i = phi i64 [ %n64, %prep.loop ], [ %i.dec, %call.cont ]
  %call.slot.ptr = getelementptr inbounds i64, i64* %base.ptr.ptr, i64 %i
  %faddr64 = load i64, i64* %call.slot.ptr, align 8
  %fptr = inttoptr i64 %faddr64 to void ()*
  call void %fptr()
  %i.dec = add i64 %i, -1
  %cond = icmp ne i64 %i.dec, 0
  br i1 %cond, label %call.cont, label %after.calls

call.cont:
  br label %call.loop

after.calls:
  %fn.addr = bitcast void ()* @sub_140001450 to i8*
  call void @loc_140001420(i8* %fn.addr)
  ret void
}