; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i64
@unk_140007100 = external global i8

declare i8* @sub_14063991D(i8*)
declare i64 @sub_140016046(i8*)
declare void @"loc_1400027ED+3"()

define i32 @sub_140001F80(i32 %ecx, i32 %edx) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  %ecx.slot = alloca i32, align 4
  store i32 %ecx, i32* %ecx.slot, align 4
  %unk.ptr = getelementptr i8, i8* @unk_140007100, i64 0
  %curr0 = call i8* @sub_14063991D(i8* %unk.ptr)
  br label %loop

loop:
  %prev = phi i8* [ %unk.ptr, %cont ], [ %curr, %advance ]
  %curr = phi i8* [ %curr0, %cont ], [ %next, %advance ]
  %curr.null = icmp eq i8* %curr, null
  br i1 %curr.null, label %cleanup, label %exam

exam:
  %valptr = bitcast i8* %curr to i32*
  %val = load i32, i32* %valptr, align 4
  %nextfield.i8 = getelementptr i8, i8* %curr, i64 16
  %nextfield = bitcast i8* %nextfield.i8 to i8**
  %next = load i8*, i8** %nextfield, align 8
  %cmp = icmp eq i32 %val, %edx
  br i1 %cmp, label %found, label %advance

advance:
  br label %loop

found:
  %prev.isnull = icmp eq i8* %prev, null
  br i1 %prev.isnull, label %L2000, label %splice

splice:
  %prevnext.i8 = getelementptr i8, i8* %prev, i64 16
  %prevnext = bitcast i8* %prevnext.i8 to i8**
  store i8* %next, i8** %prevnext, align 8
  call void @"loc_1400027ED+3"()
  br label %cleanup

L2000:
  br label %cleanup

cleanup:
  %res = call i64 @sub_140016046(i8* %unk.ptr)
  store i64 %res, i64* @qword_1400070E0, align 8
  ret i32 0
}