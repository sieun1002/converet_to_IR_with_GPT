; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare void @sub_140001450()
declare void @loc_140001420(void ()*)

define void @sub_1400014A0() {
entry:
  %base.ptr.ptr = load i64*, i64** @off_1400043B0, align 8
  %first.qword = load i64, i64* %base.ptr.ptr, align 8
  %first32 = trunc i64 %first.qword to i32
  %is.minus1 = icmp eq i32 %first32, -1
  br i1 %is.minus1, label %sentinel, label %have_count_pre

have_count_pre:                                     ; preds = %entry
  br label %have_count

sentinel:                                           ; preds = %entry
  %fparray0 = bitcast i64* %base.ptr.ptr to void ()**
  br label %scan

scan:                                               ; preds = %scan, %sentinel
  %rax.idx = phi i64 [ 0, %sentinel ], [ %r8.idx, %scan ]
  %r8.idx = add i64 %rax.idx, 1
  %ptr.s = getelementptr inbounds void ()*, void ()** %fparray0, i64 %r8.idx
  %fp.s = load void ()*, void ()** %ptr.s, align 8
  %nonzero = icmp ne void ()* %fp.s, null
  br i1 %nonzero, label %scan, label %scan_exit

scan_exit:                                          ; preds = %scan
  %count.scan32 = trunc i64 %rax.idx to i32
  br label %have_count

have_count:                                         ; preds = %scan_exit, %have_count_pre
  %count = phi i32 [ %first32, %have_count_pre ], [ %count.scan32, %scan_exit ]
  %is.zero = icmp eq i32 %count, 0
  br i1 %is.zero, label %afterLoop, label %prep

prep:                                               ; preds = %have_count
  %count64 = zext i32 %count to i64
  %fparray = bitcast i64* %base.ptr.ptr to void ()**
  %rbx.start = getelementptr inbounds void ()*, void ()** %fparray, i64 %count64
  br label %loop

loop:                                               ; preds = %loop, %prep
  %rbx.cur = phi void ()** [ %rbx.start, %prep ], [ %rbx.next, %loop ]
  %fp = load void ()*, void ()** %rbx.cur, align 8
  call void %fp()
  %rbx.next = getelementptr inbounds void ()*, void ()** %rbx.cur, i64 -1
  %done = icmp eq void ()** %rbx.next, %fparray
  br i1 %done, label %afterLoop, label %loop

afterLoop:                                          ; preds = %loop, %have_count
  tail call void @loc_140001420(void ()* @sub_140001450)
  ret void
}