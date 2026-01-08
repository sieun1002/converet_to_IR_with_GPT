; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*

declare void @sub_140001450()
declare void @loc_140001420(void ()*)

define void @sub_1400014A0() {
entry:
  %p = load i8*, i8** @off_1400043B0, align 8
  %cnt.ptr = bitcast i8* %p to i32*
  %cnt = load i32, i32* %cnt.ptr, align 4
  %is.m1 = icmp eq i32 %cnt, -1
  br i1 %is.m1, label %sent.init, label %chk0

sent.init:
  br label %sent.loop

sent.loop:
  %idx = phi i64 [ 1, %sent.init ], [ %idx.next, %sent.cont ]
  %idx.bytes = mul i64 %idx, 8
  %elt.i8 = getelementptr i8, i8* %p, i64 %idx.bytes
  %elt.p = bitcast i8* %elt.i8 to i64*
  %elt = load i64, i64* %elt.p, align 8
  %nz = icmp ne i64 %elt, 0
  br i1 %nz, label %sent.cont, label %tail

sent.cont:
  %idx.next = add i64 %idx, 1
  br label %sent.loop

chk0:
  %is.z = icmp eq i32 %cnt, 0
  br i1 %is.z, label %tail, label %loop.prep

loop.prep:
  %base8 = getelementptr i8, i8* %p, i64 8
  %arr = bitcast i8* %base8 to void ()**
  %n64 = zext i32 %cnt to i64
  br label %loop.hdr

loop.hdr:
  %j = phi i64 [ %n64, %loop.prep ], [ %j.next, %loop.body ]
  %cond = icmp ugt i64 %j, 0
  br i1 %cond, label %loop.body, label %tail

loop.body:
  %jm1 = add i64 %j, -1
  %fpp = getelementptr void ()*, void ()** %arr, i64 %jm1
  %fp = load void ()*, void ()** %fpp, align 8
  call void %fp()
  %j.next = add i64 %j, -1
  br label %loop.hdr

tail:
  tail call void @loc_140001420(void ()* @sub_140001450)
  ret void
}