target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8*, align 8

declare i32 @j__crt_atexit(void ()*) local_unnamed_addr
declare void @sub_140001820() local_unnamed_addr

define i32 @sub_140001870() local_unnamed_addr {
entry:
  %P.ptr = load i8*, i8** @off_140004390, align 8
  %P64ptr = bitcast i8* %P.ptr to i64*
  %head64 = load i64, i64* %P64ptr, align 8
  %count32 = trunc i64 %head64 to i32
  %is_neg1 = icmp eq i32 %count32, -1
  br i1 %is_neg1, label %scan, label %have_count

scan:
  br label %scan.loop

scan.loop:
  %prev = phi i32 [ 0, %scan ], [ %idx, %scan.cont ]
  %idx = phi i32 [ 1, %scan ], [ %idx.next, %scan.cont ]
  %idx.z = zext i32 %idx to i64
  %offset = mul i64 %idx.z, 8
  %slot.i8 = getelementptr i8, i8* %P.ptr, i64 %offset
  %slot.pp = bitcast i8* %slot.i8 to void ()**
  %fn = load void ()*, void ()** %slot.pp, align 8
  %nonzero = icmp ne void ()* %fn, null
  br i1 %nonzero, label %scan.cont, label %after_scan

scan.cont:
  %idx.next = add i32 %idx, 1
  br label %scan.loop

after_scan:
  br label %have_count

have_count:
  %count.final = phi i32 [ %count32, %entry ], [ %prev, %after_scan ]
  %is_zero = icmp eq i32 %count.final, 0
  br i1 %is_zero, label %register, label %callloop.init

callloop.init:
  %count64 = zext i32 %count.final to i64
  %endoff = mul i64 %count64, 8
  %rbx0 = getelementptr i8, i8* %P.ptr, i64 %endoff
  br label %callloop

callloop:
  %cur = phi i8* [ %rbx0, %callloop.init ], [ %next, %callloop ]
  %pp = bitcast i8* %cur to void ()**
  %f = load void ()*, void ()** %pp, align 8
  call void %f()
  %next = getelementptr i8, i8* %cur, i64 -8
  %cont = icmp ne i8* %next, %P.ptr
  br i1 %cont, label %callloop, label %register

register:
  %ret = tail call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}