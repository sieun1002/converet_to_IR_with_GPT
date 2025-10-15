; Target info
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

; extern i32* off_140004370;
@off_140004370 = external global i32*, align 8

; extern void (*unk_140004BE0[])(void);  // empty range: begin == end
@unk_140004BE0 = external global [0 x void ()*], align 8

; extern void sub_1400023D0(void* DllHandle, i32 Reason, void* Reserved);
declare void @sub_1400023D0(i8*, i32, i8*)

; void TlsCallback_1(void* DllHandle, i32 Reason, void* Reserved)
define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p.ptr = load i32*, i32** @off_140004370, align 8
  %p.val = load i32, i32* %p.ptr, align 4
  %is2 = icmp eq i32 %p.val, 2
  br i1 %is2, label %after_store, label %do_store

do_store:
  store i32 2, i32* %p.ptr, align 4
  br label %after_store

after_store:
  %is_reason_2 = icmp eq i32 %Reason, 2
  br i1 %is_reason_2, label %on_reason_2, label %check_reason_1

check_reason_1:
  %is_reason_1 = icmp eq i32 %Reason, 1
  br i1 %is_reason_1, label %on_reason_1, label %ret

on_reason_2:
  %begin = getelementptr [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %empty = icmp eq void ()** %begin, %end
  br i1 %empty, label %ret, label %loop

loop:
  %it = phi void ()** [ %begin, %on_reason_2 ], [ %next, %cont ]
  %fp = load void ()*, void ()** %it, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %cont, label %call_fp

call_fp:
  call void %fp()
  br label %cont

cont:
  %next = getelementptr void ()*, void ()** %it, i64 1
  %done = icmp eq void ()** %next, %end
  br i1 %done, label %ret, label %loop

on_reason_1:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}