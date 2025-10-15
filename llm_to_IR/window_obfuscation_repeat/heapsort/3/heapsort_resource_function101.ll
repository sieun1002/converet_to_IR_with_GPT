; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

declare i32 @j__crt_atexit(void ()*)

@init_array = internal constant [4 x void ()*] [
  void ()* inttoptr (i64 -1 to void ()*),
  void ()* @init1,
  void ()* @init2,
  void ()* null
]

@off_140004390 = global void ()** getelementptr inbounds ([4 x void ()*], [4 x void ()*]* @init_array, i64 0, i64 0)

define i32 @sub_140001870() {
entry:
  %base.ptrptr = load void ()**, void ()*** @off_140004390
  %first.ptr = load void ()*, void ()** %base.ptrptr
  %first.i64 = ptrtoint void ()* %first.ptr to i64
  %first.i32 = trunc i64 %first.i64 to i32
  %is.neg1 = icmp eq i32 %first.i32, -1
  br i1 %is.neg1, label %scan, label %from_first

from_first:
  br label %have_count

scan:
  br label %scan.loop

scan.loop:
  %i.ph = phi i64 [ 0, %scan ], [ %i.next, %scan.iter ]
  %next = add i64 %i.ph, 1
  %elem.next.ptr = getelementptr inbounds void ()*, void ()** %base.ptrptr, i64 %next
  %elem.next = load void ()*, void ()** %elem.next.ptr
  %notnull = icmp ne void ()* %elem.next, null
  br i1 %notnull, label %scan.iter, label %scanned

scan.iter:
  %i.next = add i64 %i.ph, 1
  br label %scan.loop

scanned:
  %count.scan.i32 = trunc i64 %i.ph to i32
  br label %have_count

have_count:
  %count.i32 = phi i32 [ %first.i32, %from_first ], [ %count.scan.i32, %scanned ]
  %is.zero = icmp eq i32 %count.i32, 0
  br i1 %is.zero, label %atexit, label %loop.prep

loop.prep:
  %count.i64 = sext i32 %count.i32 to i64
  br label %loop

loop:
  %idx = phi i64 [ %count.i64, %loop.prep ], [ %idx.next, %loop.body ]
  %elem.ptr = getelementptr inbounds void ()*, void ()** %base.ptrptr, i64 %idx
  %func.ptr = load void ()*, void ()** %elem.ptr
  call void %func.ptr()
  br label %loop.body

loop.body:
  %idx.next = add i64 %idx, -1
  %cont = icmp ne i64 %idx.next, 0
  br i1 %cont, label %loop, label %after_calls

after_calls:
  br label %atexit

atexit:
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}

define void @sub_140001820() {
entry:
  ret void
}

define void @init1() {
entry:
  ret void
}

define void @init2() {
entry:
  ret void
}