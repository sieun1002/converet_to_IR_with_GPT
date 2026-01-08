target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1
@qword_140008258 = external global i8*, align 8
@qword_140008270 = external global i8*, align 8

declare void @sub_1400027F0(i8*)

define i32 @sub_140001F80(i32 %arg) {
entry:
  %arg.slot = alloca i32, align 4
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %g, 0
  br i1 %cmp, label %if.then, label %return0

if.then:
  store i32 %arg, i32* %arg.slot, align 4
  %pfn1.ptr = load i8*, i8** @qword_140008258, align 8
  %pfn1 = bitcast i8* %pfn1.ptr to void (i8*)*
  call void %pfn1(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %headnull = icmp eq i8* %head, null
  br i1 %headnull, label %unlock, label %loop.entry

loop.entry:
  %sarg = load i32, i32* %arg.slot, align 4
  br label %loop

loop:
  %cur = phi i8* [ %head, %loop.entry ], [ %next, %loop.back ]
  %prev = phi i8* [ null, %loop.entry ], [ %cur, %loop.back ]
  %keyptr = bitcast i8* %cur to i32*
  %key = load i32, i32* %keyptr, align 4
  %cmpkey = icmp eq i32 %key, %sarg
  %nextptr.byte = getelementptr inbounds i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextptr.byte to i8**
  %next = load i8*, i8** %nextptr, align 8
  br i1 %cmpkey, label %found, label %loop.cmp

loop.cmp:
  %nextnull = icmp eq i8* %next, null
  br i1 %nextnull, label %unlock, label %loop.back

loop.back:
  br label %loop

found:
  %prevnull = icmp eq i8* %prev, null
  br i1 %prevnull, label %headcase, label %normalcase

normalcase:
  %prevnextptr.byte = getelementptr inbounds i8, i8* %prev, i64 16
  %prevnextptr = bitcast i8* %prevnextptr.byte to i8**
  store i8* %next, i8** %prevnextptr, align 8
  call void @sub_1400027F0(i8* %cur)
  br label %unlock

headcase:
  store i8* %next, i8** @qword_1400070E0, align 8
  call void @sub_1400027F0(i8* %cur)
  br label %unlock

unlock:
  %pfn2.ptr = load i8*, i8** @qword_140008270, align 8
  %pfn2 = bitcast i8* %pfn2.ptr to void (i8*)*
  call void %pfn2(i8* @unk_140007100)
  br label %return0

return0:
  ret i32 0
}