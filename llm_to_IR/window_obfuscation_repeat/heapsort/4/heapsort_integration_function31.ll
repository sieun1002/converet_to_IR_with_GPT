; ModuleID = 'tls_module'
source_filename = "tls_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@g_tls_state = dso_local global i32 0, align 4
@off_140004370 = dso_local global i32* @g_tls_state, align 8
@unk_140004BE0 = dso_local global [0 x void (i8*, i32, i8*)*] zeroinitializer, align 8

declare dso_local void @sub_1400023D0(i8*, i32, i8*) local_unnamed_addr

define dso_local void @TlsCallback_1(i8* %h, i32 %reason, i8* %reserved) local_unnamed_addr {
entry:
  %p = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p, align 4
  %cmp = icmp eq i32 %val, 2
  br i1 %cmp, label %after_set, label %set

set:
  store i32 2, i32* %p, align 4
  br label %after_set

after_set:
  %is2 = icmp eq i32 %reason, 2
  br i1 %is2, label %threadAttach, label %check1

check1:
  %is1 = icmp eq i32 %reason, 1
  br i1 %is1, label %processAttach, label %ret

threadAttach:
  %beg_ptr = getelementptr [0 x void (i8*, i32, i8*)*], [0 x void (i8*, i32, i8*)*]* @unk_140004BE0, i64 0, i64 0
  %start = bitcast void (i8*, i32, i8*)** %beg_ptr to i8*
  %end = bitcast void (i8*, i32, i8*)** %beg_ptr to i8*
  %eq = icmp eq i8* %start, %end
  br i1 %eq, label %ret, label %loop

loop:
  %cur = phi i8* [ %start, %threadAttach ], [ %next, %cont ]
  %curpp = bitcast i8* %cur to void (i8*, i32, i8*)**
  %fp = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %curpp, align 8
  %isnull = icmp eq void (i8*, i32, i8*)* %fp, null
  br i1 %isnull, label %cont, label %docall

docall:
  call void %fp(i8* %h, i32 %reason, i8* %reserved)
  br label %cont

cont:
  %next = getelementptr i8, i8* %cur, i64 8
  %done = icmp eq i8* %next, %end
  br i1 %done, label %ret, label %loop

processAttach:
  tail call void @sub_1400023D0(i8* %h, i32 %reason, i8* %reserved)
  ret void

ret:
  ret void
}