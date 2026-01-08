; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i64
@unk_140007100 = external global [0 x i8]

declare i8* @sub_14063991D(i8*)
declare i64 @sub_140016046(i8*, ...)

define dso_local i32 @sub_140001F80(i32 %ecx, i32 %edx) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %nz = icmp ne i32 %g, 0
  br i1 %nz, label %loc_140001F98, label %ret_zero

ret_zero:
  ret i32 0

loc_140001F98:
  %ecx.slot = alloca i32, align 4
  store i32 %ecx, i32* %ecx.slot, align 4
  %unk.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @unk_140007100, i64 0, i64 0
  %first = call i8* @sub_14063991D(i8* %unk.ptr)
  br label %loc_140001FC0

loc_140001FC0:
  %prev = phi i8* [ %unk.ptr, %loc_140001F98 ], [ %cur, %loc_body ]
  %cur = phi i8* [ %first, %loc_140001F98 ], [ %next, %loc_body ]
  %cur_isnull = icmp eq i8* %cur, null
  br i1 %cur_isnull, label %loc_140001FE3, label %loc_body

loc_body:
  %keyptr = bitcast i8* %cur to i32*
  %key = load i32, i32* %keyptr, align 4
  %cmp = icmp eq i32 %key, %edx
  %next_i8 = getelementptr inbounds i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %next_i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  br i1 %cmp, label %loc_found, label %loc_140001FC0

loc_found:
  %prev_isnull = icmp eq i8* %prev, null
  br i1 %prev_isnull, label %loc_140002000_from_found, label %loc_unlink

loc_unlink:
  %prev_next_i8 = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_next = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next, align 8
  br label %loc_140001FDE

loc_140001FDE:
  %fnptr = inttoptr i64 5368719344 to void (...)*
  call void (...) %fnptr()
  br label %loc_140001FE3

loc_140001FE3:
  %unk.ptr2 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_140007100, i64 0, i64 0
  %res = call i64 (i8*, ...) @sub_140016046(i8* %unk.ptr2, i8* %unk.ptr2)
  br label %loc_140002000

loc_140002000_from_found:
  %next_i64 = ptrtoint i8* %next to i64
  br label %loc_140002000

loc_140002000:
  %storeval = phi i64 [ %next_i64, %loc_140002000_from_found ], [ %res, %loc_140001FE3 ]
  store i64 %storeval, i64* @qword_1400070E0, align 8
  br label %loc_140001FDE
}