; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global i8*, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %arg1, i32 %arg2, i8* %arg3) {
entry:
  %p = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p, align 4
  %cmp = icmp eq i32 %val, 2
  br i1 %cmp, label %after_set, label %set

set:
  store i32 2, i32* %p, align 4
  br label %after_set

after_set:
  %is2 = icmp eq i32 %arg2, 2
  br i1 %is2, label %case2, label %chk1

chk1:
  %is1 = icmp eq i32 %arg2, 1
  br i1 %is1, label %case1, label %exit

case2:
  %start = bitcast i8** @unk_140004BE0 to i8**
  %end = bitcast i8** @unk_140004BE0 to i8**
  %init_cmp = icmp eq i8** %start, %end
  br i1 %init_cmp, label %exit, label %loop

loop:
  %cur = phi i8** [ %start, %case2 ], [ %next, %cont ]
  %ptr = load i8*, i8** %cur, align 8
  %isnull = icmp eq i8* %ptr, null
  br i1 %isnull, label %cont, label %call

call:
  %fn = bitcast i8* %ptr to void ()*
  call void %fn()
  br label %cont

cont:
  %next = getelementptr inbounds i8*, i8** %cur, i64 1
  %done = icmp eq i8** %next, %end
  br i1 %done, label %exit, label %loop

case1:
  tail call void @sub_1400023D0(i8* %arg1, i32 %arg2, i8* %arg3)
  ret void

exit:
  ret void
}