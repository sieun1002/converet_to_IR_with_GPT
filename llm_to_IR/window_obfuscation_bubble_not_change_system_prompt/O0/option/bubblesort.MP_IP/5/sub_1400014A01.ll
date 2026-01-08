; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64, align 8

declare void @loc_140001420(void ()*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %first64 = load i64, i64* @off_1400043B0, align 8
  %first32 = trunc i64 %first64 to i32
  %is_m1 = icmp eq i32 %first32, -1
  br i1 %is_m1, label %scan, label %b7

scan:                                             ; 0x1400014F0 .. 0x140001510 path
  br label %scan.loop

scan.loop:
  %prev = phi i64 [ 0, %scan ], [ %cur, %scan.body ]
  %cur = add i64 %prev, 1
  %ptr.cur = getelementptr i64, i64* @off_1400043B0, i64 %cur
  %val.cur = load i64, i64* %ptr.cur, align 8
  %nz = icmp ne i64 %val.cur, 0
  br i1 %nz, label %scan.body, label %scan.end

scan.body:
  br label %scan.loop

scan.end:
  %count32.scan = trunc i64 %prev to i32
  br label %b7

b7:                                               ; join at 0x1400014B7
  %count32 = phi i32 [ %first32, %entry ], [ %count32.scan, %scan.end ]
  %is_zero = icmp eq i32 %count32, 0
  br i1 %is_zero, label %tailcall, label %loop.setup

loop.setup:
  %count64 = zext i32 %count32 to i64
  br label %loop.header

loop.header:
  %i = phi i64 [ %count64, %loop.setup ], [ %i.next, %loop.body2 ]
  %elt.ptr = getelementptr i64, i64* @off_1400043B0, i64 %i
  %elt = load i64, i64* %elt.ptr, align 8
  %fp = inttoptr i64 %elt to void ()*
  call void %fp()
  %is_last = icmp eq i64 %i, 1
  br i1 %is_last, label %tailcall, label %loop.body2

loop.body2:
  %i.next = add i64 %i, -1
  br label %loop.header

tailcall:                                         ; 0x1400014DB tail jump
  tail call void @loc_140001420(void ()* @sub_140001450)
  ret void
}