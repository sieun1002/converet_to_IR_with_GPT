; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global [0 x void ()*]

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %after_set, label %do_set

do_set:
  store i32 2, i32* %p, align 4
  br label %after_set

after_set:
  %is2 = icmp eq i32 %Reason, 2
  br i1 %is2, label %case2, label %check_case1

check_case1:
  %is1 = icmp eq i32 %Reason, 1
  br i1 %is1, label %case1, label %ret

case2:
  %begin = getelementptr [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %empty = icmp eq void ()** %begin, %end
  br i1 %empty, label %ret, label %loop

loop:
  %cur = phi void ()** [ %begin, %case2 ], [ %next, %after_call ]
  %fnptr = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fnptr, null
  br i1 %isnull, label %after_call, label %do_call

do_call:
  call void %fnptr()
  br label %after_call

after_call:
  %next = getelementptr void ()*, void ()** %cur, i64 1
  %done = icmp eq void ()** %next, %end
  br i1 %done, label %ret, label %loop

case1:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %ret

ret:
  ret void
}