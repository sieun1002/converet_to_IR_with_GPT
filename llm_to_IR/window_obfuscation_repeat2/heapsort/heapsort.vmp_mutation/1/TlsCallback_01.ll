; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global i8*

declare void @sub_140002370()

define dso_local void @TlsCallback_0(i8* %rcx, i32 %edx, i8* %r8) {
entry:
  %gptr = load i32*, i32** @off_140004370
  %gval = load i32, i32* %gptr
  %is2 = icmp eq i32 %gval, 2
  br i1 %is2, label %after_set, label %store2

store2:
  store i32 2, i32* %gptr
  br label %after_set

after_set:
  %edx_is2 = icmp eq i32 %edx, 2
  br i1 %edx_is2, label %case2, label %check1

check1:
  %edx_is1 = icmp eq i32 %edx, 1
  br i1 %edx_is1, label %case1, label %ret

ret:
  ret void

case2:
  %start = getelementptr inbounds i8*, i8** @unk_140004BE0, i64 0
  %end = getelementptr inbounds i8*, i8** @unk_140004BE0, i64 0
  %empty = icmp eq i8** %start, %end
  br i1 %empty, label %ret2, label %loop

loop:
  %i = phi i8** [ %start, %case2 ], [ %i_next, %cont ]
  %cur = load i8*, i8** %i
  %isnull = icmp eq i8* %cur, null
  br i1 %isnull, label %cont, label %docall

docall:
  %fn = bitcast i8* %cur to void ()*
  call void %fn()
  br label %cont

cont:
  %i_next = getelementptr inbounds i8*, i8** %i, i64 1
  %more = icmp ne i8** %i_next, %end
  br i1 %more, label %loop, label %ret2

ret2:
  ret void

case1:
  tail call void @sub_140002370()
  unreachable
}