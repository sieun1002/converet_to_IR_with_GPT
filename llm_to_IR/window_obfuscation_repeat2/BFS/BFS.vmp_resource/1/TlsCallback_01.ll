; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i32*, align 8
@unk_140004C00 = external global i8, align 8

declare void @sub_1400024B0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p.addrptr = load i32*, i32** @off_140004390, align 8
  %val = load i32, i32* %p.addrptr, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %after_store, label %do_store

do_store:
  store i32 2, i32* %p.addrptr, align 4
  br label %after_store

after_store:
  %is2 = icmp eq i32 %Reason, 2
  br i1 %is2, label %case2, label %check1

check1:
  %is1 = icmp eq i32 %Reason, 1
  br i1 %is1, label %case1, label %ret

ret:
  ret void

case2:
  %start = getelementptr i8, i8* @unk_140004C00, i64 0
  %end = getelementptr i8, i8* @unk_140004C00, i64 0
  %cmpse = icmp eq i8* %start, %end
  br i1 %cmpse, label %after_loop, label %loop

loop:
  %cur = phi i8* [ %start, %case2 ], [ %next, %loop_latch ]
  %cur_as_ptrptr = bitcast i8* %cur to i8**
  %fp = load i8*, i8** %cur_as_ptrptr, align 8
  %isnull = icmp eq i8* %fp, null
  br i1 %isnull, label %loop_latch, label %call

call:
  %callee = bitcast i8* %fp to void ()*
  call void %callee()
  br label %loop_latch

loop_latch:
  %next = getelementptr i8, i8* %cur, i64 8
  %cont = icmp ne i8* %next, %end
  br i1 %cont, label %loop, label %after_loop

after_loop:
  ret void

case1:
  tail call void @sub_1400024B0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}