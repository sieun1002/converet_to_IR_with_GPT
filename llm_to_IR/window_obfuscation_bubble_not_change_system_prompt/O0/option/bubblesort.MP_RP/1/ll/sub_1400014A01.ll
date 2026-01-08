target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*, align 8

declare void @sub_140001420(void ()*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %base = load i64*, i64** @off_1400043B0, align 8
  %first64 = load i64, i64* %base, align 8
  %first32 = trunc i64 %first64 to i32
  %is_neg1 = icmp eq i32 %first32, -1
  br i1 %is_neg1, label %scan.init, label %count.check

count.check:
  %is_zero = icmp eq i32 %first32, 0
  br i1 %is_zero, label %tail, label %loop.prep

loop.prep:
  %count64 = zext i32 %first32 to i64
  br label %call.loop

call.loop:
  %cur = phi i64 [ %count64, %loop.prep ], [ %cur.dec, %call.loop ], [ %last, %loop.fromscan ]
  %elem.ptr = getelementptr inbounds i64, i64* %base, i64 %cur
  %fp64 = load i64, i64* %elem.ptr, align 8
  %fp = inttoptr i64 %fp64 to void ()*
  call void %fp()
  %is_one = icmp eq i64 %cur, 1
  %cur.dec = add i64 %cur, -1
  br i1 %is_one, label %tail, label %call.loop

scan.init:
  br label %scan.loop

scan.loop:
  %idx = phi i64 [ 1, %scan.init ], [ %idx.next, %scan.step ]
  %last = phi i64 [ 0, %scan.init ], [ %last.next, %scan.step ]
  %gep = getelementptr inbounds i64, i64* %base, i64 %idx
  %val = load i64, i64* %gep, align 8
  %nz = icmp ne i64 %val, 0
  br i1 %nz, label %scan.step, label %scan.exit

scan.step:
  %last.next = add i64 %idx, 0
  %idx.next = add i64 %idx, 1
  br label %scan.loop

scan.exit:
  %is_last_zero = icmp eq i64 %last, 0
  br i1 %is_last_zero, label %tail, label %loop.fromscan

loop.fromscan:
  br label %call.loop

tail:
  tail call void @sub_140001420(void ()* @sub_140001450)
  ret void
}