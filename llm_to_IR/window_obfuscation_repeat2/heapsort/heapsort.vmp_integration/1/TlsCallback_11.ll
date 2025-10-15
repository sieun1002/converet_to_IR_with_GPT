; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = global i8* null, align 8

declare void @sub_140002370()

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %pLoc = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %pLoc, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %after_set, label %set2

set2:                                             ; preds = %entry
  store i32 2, i32* %pLoc, align 4
  br label %after_set

after_set:                                        ; preds = %set2, %entry
  %cmpR2 = icmp eq i32 %Reason, 2
  br i1 %cmpR2, label %handle2, label %checkR1

checkR1:                                          ; preds = %after_set
  %cmpR1 = icmp eq i32 %Reason, 1
  br i1 %cmpR1, label %tail, label %ret

handle2:                                          ; preds = %after_set
  %start = bitcast i8** @unk_140004BE0 to i8*
  %end = bitcast i8** @unk_140004BE0 to i8*
  %eq = icmp eq i8* %start, %end
  br i1 %eq, label %ret, label %loop

loop:                                             ; preds = %next, %handle2
  %cur = phi i8* [ %start, %handle2 ], [ %nextptr, %next ]
  %fptrptr = bitcast i8* %cur to i8**
  %fptr = load i8*, i8** %fptrptr, align 8
  %isnull = icmp eq i8* %fptr, null
  br i1 %isnull, label %next, label %call

call:                                             ; preds = %loop
  %callee = bitcast i8* %fptr to void ()*
  call void %callee()
  br label %next

next:                                             ; preds = %call, %loop
  %nextptr = getelementptr i8, i8* %cur, i64 8
  %continue = icmp ne i8* %nextptr, %end
  br i1 %continue, label %loop, label %ret

tail:                                             ; preds = %checkR1
  tail call void @sub_140002370()
  ret void

ret:                                              ; preds = %next, %handle2, %checkR1
  ret void
}