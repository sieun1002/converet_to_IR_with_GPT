; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8

declare dso_local void @loc_1400EC4EB(i8* noundef)
declare dso_local void @sub_1400F1710(i8* noundef)
declare dso_local void @loc_1400027F0(i8* noundef)

define dso_local i32 @sub_140001F80(i32 noundef %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %locked, label %ret0

ret0:
  ret i32 0

locked:
  call void @loc_1400EC4EB(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %unlock, label %loop

loop:
  %cur = phi i8* [ %head, %locked ], [ %next, %advance ]
  %prev = phi i8* [ null, %locked ], [ %cur, %advance ]
  %keyptr = bitcast i8* %cur to i32*
  %key = load i32, i32* %keyptr, align 4
  %cmp = icmp eq i32 %key, %arg
  %nextaddr = getelementptr inbounds i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextaddr to i8**
  %next = load i8*, i8** %nextptr, align 8
  br i1 %cmp, label %found, label %neq

neq:
  %nnull = icmp eq i8* %next, null
  br i1 %nnull, label %unlock, label %advance

advance:
  br label %loop

found:
  %hasprev = icmp ne i8* %prev, null
  br i1 %hasprev, label %unlink_prev, label %unlink_head

unlink_prev:
  %prev_nextaddr = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_nextptr = bitcast i8* %prev_nextaddr to i8**
  store i8* %next, i8** %prev_nextptr, align 8
  call void @loc_1400027F0(i8* %cur)
  br label %unlock

unlink_head:
  store i8* %next, i8** @qword_1400070E0, align 8
  call void @loc_1400027F0(i8* %cur)
  br label %unlock

unlock:
  call void @sub_1400F1710(i8* @unk_140007100)
  ret i32 0
}