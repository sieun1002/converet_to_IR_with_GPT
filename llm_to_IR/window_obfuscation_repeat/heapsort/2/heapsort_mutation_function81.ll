; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@func_table = internal global [2 x void ()*] [void ()* inttoptr (i64 -1 to void ()*), void ()* null], align 8
@off_140004390 = dso_local global void ()** getelementptr inbounds ([2 x void ()*], [2 x void ()*]* @func_table, i64 0, i64 0), align 8

declare dso_local i32 @atexit(void ()*)

define dso_local i32 @j__crt_atexit(void ()* %fn) {
entry:
  %res = call i32 @atexit(void ()* %fn)
  ret i32 %res
}

define dso_local void @sub_140001820() {
entry:
  ret void
}

define dso_local i32 @sub_140001870() {
entry:
  %base.ptr = load void ()**, void ()*** @off_140004390, align 8
  %first.elem = load void ()*, void ()** %base.ptr, align 8
  %first.i64 = ptrtoint void ()* %first.elem to i64
  %first.i32 = trunc i64 %first.i64 to i32
  %is.neg1 = icmp eq i32 %first.i32, -1
  br i1 %is.neg1, label %scan, label %normal

scan:
  %eax.phi = phi i32 [ 0, %entry ], [ %r8.next, %scan ]
  %r8.next = add i32 %eax.phi, 1
  %r8.ext = zext i32 %r8.next to i64
  %elem.ptr = getelementptr inbounds void ()*, void ()** %base.ptr, i64 %r8.ext
  %elem.val = load void ()*, void ()** %elem.ptr, align 8
  %nonzero = icmp ne void ()* %elem.val, null
  br i1 %nonzero, label %scan, label %join

normal:
  br label %join

join:
  %ecx.phi = phi i32 [ %first.i32, %normal ], [ %eax.phi, %scan ]
  %is.zero = icmp eq i32 %ecx.phi, 0
  br i1 %is.zero, label %register, label %callprep

callprep:
  %i.init = zext i32 %ecx.phi to i64
  br label %callloop

callloop:
  %i = phi i64 [ %i.init, %callprep ], [ %i.dec, %callloop ]
  %call.ptr = getelementptr inbounds void ()*, void ()** %base.ptr, i64 %i
  %fn.ptr = load void ()*, void ()** %call.ptr, align 8
  call void %fn.ptr()
  %i.dec = add i64 %i, -1
  %more = icmp ne i64 %i.dec, 0
  br i1 %more, label %callloop, label %register

register:
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}