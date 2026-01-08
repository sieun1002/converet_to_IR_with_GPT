; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_14063991D(i8* %rcx)
declare i8* @sub_140016046(...)

define dso_local i32 @sub_140001F80(i32 %ecx, i32 %edx) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag.nz = icmp ne i32 %flag, 0
  br i1 %flag.nz, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  %sentinel.ptr0 = getelementptr i8, i8* @unk_140007100, i64 0
  %head.init = call i8* @sub_14063991D(i8* %sentinel.ptr0)
  br label %loop

loop:
  %prev.phi = phi i8* [ null, %cont ], [ %cur.phi, %loop.cont ]
  %cur.phi = phi i8* [ %head.init, %cont ], [ %next.phi, %loop.cont ]
  %cur.null = icmp eq i8* %cur.phi, null
  br i1 %cur.null, label %tail, label %loop.body

loop.body:
  %cur.as.i32ptr = bitcast i8* %cur.phi to i32*
  %key = load i32, i32* %cur.as.i32ptr, align 4
  %cmp.eq = icmp eq i32 %key, %edx
  %next.ptr.i8 = getelementptr i8, i8* %cur.phi, i64 16
  %next.ptr = bitcast i8* %next.ptr.i8 to i8**
  %next.val = load i8*, i8** %next.ptr, align 8
  br i1 %cmp.eq, label %found, label %loop.cont

loop.cont:
  %next.phi = phi i8* [ %next.val, %loop.body ]
  br label %loop

found:
  %prev.isnull = icmp eq i8* %prev.phi, null
  br i1 %prev.isnull, label %remove.head, label %remove.nonhead

remove.nonhead:
  %prev.next.field.i8 = getelementptr i8, i8* %prev.phi, i64 16
  %prev.next.field.ptr = bitcast i8* %prev.next.field.i8 to i8**
  store i8* %next.val, i8** %prev.next.field.ptr, align 8
  br label %call_near

remove.head:
  store i8* %next.val, i8** @qword_1400070E0, align 8
  br label %call_near

call_near:
  %callee.addr = inttoptr i64 1400027F0 to void (... )*
  call void %callee.addr()
  br label %tail

tail:
  %sentinel.ptr1 = getelementptr i8, i8* @unk_140007100, i64 0
  %newhead = call i8* @sub_140016046(i8* %sentinel.ptr1)
  store i8* %newhead, i8** @qword_1400070E0, align 8
  %callee.addr2 = inttoptr i64 1400027F0 to void (... )*
  call void %callee.addr2()
  ret i32 0
}