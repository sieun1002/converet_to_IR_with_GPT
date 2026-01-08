; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64

declare i32 @loc_140001420(i8*)
declare void @sub_140001450()

define i32 @sub_1400014A0() {
entry:
  %firstq = load i64, i64* @off_1400043B0, align 8
  %first32 = trunc i64 %firstq to i32
  %is_m1 = icmp eq i32 %first32, -1
  br i1 %is_m1, label %scan.init, label %have_count

have_count:
  %count32 = add i32 %first32, 0
  br label %test_count

scan.init:
  br label %scan.loop

scan.loop:
  %k = phi i64 [ 1, %scan.init ], [ %k.next, %scan.body ]
  %prev = phi i64 [ 0, %scan.init ], [ %k, %scan.body ]
  %eltptr = getelementptr inbounds i64, i64* @off_1400043B0, i64 %k
  %elt = load i64, i64* %eltptr, align 8
  %ne = icmp ne i64 %elt, 0
  br i1 %ne, label %scan.body, label %scan.exit

scan.body:
  %k.next = add i64 %k, 1
  br label %scan.loop

scan.exit:
  %count64 = add i64 %prev, 0
  %count32.fromscan = trunc i64 %count64 to i32
  br label %test_count

test_count:
  %count.phi = phi i32 [ %count32, %have_count ], [ %count32.fromscan, %scan.exit ]
  %iszero = icmp eq i32 %count.phi, 0
  br i1 %iszero, label %after_calls, label %prep_loop

prep_loop:
  %idx64 = zext i32 %count.phi to i64
  %rbx.ptr = getelementptr inbounds i64, i64* @off_1400043B0, i64 %idx64
  br label %loop

loop:
  %p = phi i64* [ %rbx.ptr, %prep_loop ], [ %p.next, %loop ]
  %fp64 = load i64, i64* %p, align 8
  %fp = inttoptr i64 %fp64 to void ()*
  call void %fp()
  %p.next = getelementptr inbounds i64, i64* %p, i64 -1
  %done = icmp eq i64* %p.next, @off_1400043B0
  br i1 %done, label %after_calls, label %loop

after_calls:
  %funcptr = bitcast void ()* @sub_140001450 to i8*
  %ret = tail call i32 @loc_140001420(i8* %funcptr)
  ret i32 %ret
}