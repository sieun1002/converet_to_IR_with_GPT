target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i64
@unk_140007100 = external dso_local global i8

declare dso_local i8* @sub_140015A7A(i8* noundef)
declare dso_local i64 @sub_140027826(i8* noundef)

define dso_local i64 @sub_140001F80(i32 noundef %ecx, i32 noundef %edx) local_unnamed_addr {
entry:
  %t0 = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %t0, 0
  br i1 %cond, label %proceed, label %ret_zero

ret_zero:
  ret i64 0

proceed:
  %curr0 = call i8* @sub_140015A7A(i8* noundef @unk_140007100)
  br label %loop

loop:
  %prev = phi i8* [ null, %proceed ], [ %curr, %neq ]
  %curr = phi i8* [ %curr0, %proceed ], [ %next, %neq ]
  %isnull = icmp eq i8* %curr, null
  br i1 %isnull, label %notfound, label %check

check:
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %nextptr.raw = getelementptr i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %nextptr.raw to i8**
  %next = load i8*, i8** %nextptr, align 8
  %match = icmp eq i32 %key, %edx
  br i1 %match, label %found, label %neq

neq:
  br label %loop

found:
  %ishead = icmp eq i8* %prev, null
  br i1 %ishead, label %headcase, label %nonhead

nonhead:
  %prev_next_ptr.raw = getelementptr i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_ptr.raw to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  %ret_nonhead_val = ptrtoint i8* %next to i64
  ret i64 %ret_nonhead_val

headcase:
  %next_i64 = ptrtoint i8* %next to i64
  store i64 %next_i64, i64* @qword_1400070E0, align 8
  ret i64 %next_i64

notfound:
  %r = call i64 @sub_140027826(i8* noundef @unk_140007100)
  store i64 %r, i64* @qword_1400070E0, align 8
  ret i64 %r
}