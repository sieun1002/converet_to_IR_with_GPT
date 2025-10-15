; ModuleID = 'tls_callback.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global void ()*

declare void @sub_1400023D0(i8* noundef, i32 noundef, i8* noundef)

define void @TlsCallback_0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved) {
entry:
  %p.ptr = load i32*, i32** @off_140004370, align 8
  %p.val = load i32, i32* %p.ptr, align 4
  %cmp.init = icmp eq i32 %p.val, 2
  br i1 %cmp.init, label %check_reason, label %set_two

set_two:
  store i32 2, i32* %p.ptr, align 4
  br label %check_reason

check_reason:
  %is_two = icmp eq i32 %Reason, 2
  br i1 %is_two, label %on_two, label %check_one

check_one:
  %is_one = icmp eq i32 %Reason, 1
  br i1 %is_one, label %tail, label %ret

on_two:
  %start.ptr = getelementptr inbounds void ()*, void ()** @unk_140004BE0, i64 0
  %end.ptr = getelementptr inbounds void ()*, void ()** @unk_140004BE0, i64 0
  %empty = icmp eq void ()** %start.ptr, %end.ptr
  br i1 %empty, label %ret, label %loop.header

loop.header:
  %iter.ptr = phi void ()** [ %start.ptr, %on_two ], [ %next.ptr, %after.call ]
  %fp = load void ()*, void ()** %iter.ptr, align 8
  %is.null = icmp eq void ()* %fp, null
  br i1 %is.null, label %after.call, label %do.call

do.call:
  call void %fp()
  br label %after.call

after.call:
  %next.ptr = getelementptr inbounds void ()*, void ()** %iter.ptr, i64 1
  %cont = icmp ne void ()** %next.ptr, %end.ptr
  br i1 %cont, label %loop.header, label %ret

tail:
  tail call void @sub_1400023D0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved)
  ret void

ret:
  ret void
}