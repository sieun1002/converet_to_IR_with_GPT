; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global i8, align 1

declare void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %p_ptr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p_ptr, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %after_store, label %do_store

do_store:
  store i32 2, i32* %p_ptr, align 4
  br label %after_store

after_store:
  %is2 = icmp eq i32 %Reason, 2
  br i1 %is2, label %case2, label %check1

check1:
  %is1 = icmp eq i32 %Reason, 1
  br i1 %is1, label %case1, label %ret

case2:
  %start = bitcast i8* @unk_140004BE0 to void ()**
  %end = bitcast i8* @unk_140004BE0 to void ()**
  %start_eq_end = icmp eq void ()** %start, %end
  br i1 %start_eq_end, label %ret, label %loop

loop:
  %it = phi void ()** [ %start, %case2 ], [ %it_next, %aftercall ]
  %fptr2 = load void ()*, void ()** %it, align 8
  %isnull2 = icmp eq void ()* %fptr2, null
  br i1 %isnull2, label %aftercall, label %docall2

docall2:
  call void %fptr2()
  br label %aftercall

aftercall:
  %it_next = getelementptr inbounds void ()*, void ()** %it, i64 1
  %cont2 = icmp ne void ()** %it_next, %end
  br i1 %cont2, label %loop, label %ret

case1:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}