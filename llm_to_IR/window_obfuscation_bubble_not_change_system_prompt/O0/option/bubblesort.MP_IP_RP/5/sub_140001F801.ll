; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare { i8*, i8* } @sub_140015A7A(i8*, i32)
declare i8* @sub_140027826(i8*)

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

define i8* @sub_140001F80(i32 %ecx, i32 %edx) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %nz = icmp ne i32 %g, 0
  br i1 %nz, label %cont, label %ret0

ret0:
  ret i8* null

cont:
  %pair = call { i8*, i8* } @sub_140015A7A(i8* @unk_140007100, i32 %edx)
  %prev.init = extractvalue { i8*, i8* } %pair, 0
  %cur.init = extractvalue { i8*, i8* } %pair, 1
  %cur.null = icmp eq i8* %cur.init, null
  br i1 %cur.null, label %empty, label %loop

loop:
  %prev.cur = phi i8* [ %prev.init, %cont ], [ %cur.cur, %loop_cont2 ]
  %cur.cur = phi i8* [ %cur.init, %cont ], [ %next.val, %loop_cont2 ]
  %cur.key.ptr = bitcast i8* %cur.cur to i32*
  %key = load i32, i32* %cur.key.ptr, align 4
  %eq = icmp eq i32 %key, %edx
  %cur.next.ptr.i8 = getelementptr i8, i8* %cur.cur, i64 16
  %cur.next.ptr = bitcast i8* %cur.next.ptr.i8 to i8**
  %next.val = load i8*, i8** %cur.next.ptr, align 8
  br i1 %eq, label %found, label %mismatch

mismatch:
  %next.null = icmp eq i8* %next.val, null
  br i1 %next.null, label %empty, label %loop_cont2

loop_cont2:
  br label %loop

found:
  %prev.isnull = icmp eq i8* %prev.cur, null
  br i1 %prev.isnull, label %head_remove, label %splice

splice:
  %prev.next.ptr.i8 = getelementptr i8, i8* %prev.cur, i64 16
  %prev.next.ptr = bitcast i8* %prev.next.ptr.i8 to i8**
  store i8* %next.val, i8** %prev.next.ptr, align 8
  ret i8* %next.val

head_remove:
  store i8* %next.val, i8** @qword_1400070E0, align 8
  ret i8* %next.val

empty:
  %res = call i8* @sub_140027826(i8* @unk_140007100)
  store i8* %res, i8** @qword_1400070E0, align 8
  ret i8* %res
}