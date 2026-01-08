; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@unk_140007100 = external global i8, align 1
@qword_1400070E0 = external global i8*, align 8

declare i8* @sub_14063991D(i8* noundef)
declare i8* @sub_140016046(i8* noundef)
declare void @"loc_1400027ED+3"()

define i32 @sub_140001F80(i32 %ecx, i32 %edx) local_unnamed_addr {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %bb1, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

bb1:                                              ; preds = %entry
  %2 = getelementptr i8, i8* @unk_140007100, i64 0
  %3 = call i8* @sub_14063991D(i8* %2)
  br label %loop

loop:                                             ; preds = %cont, %bb1
  %curr = phi i8* [ %3, %bb1 ], [ %nextVal, %cont ]
  %prev = phi i8* [ %2, %bb1 ], [ %currVal, %cont ]
  %4 = icmp eq i8* %curr, null
  br i1 %4, label %emptyPath, label %check

check:                                            ; preds = %loop
  %5 = bitcast i8* %curr to i32*
  %6 = load i32, i32* %5, align 4
  %7 = icmp eq i32 %6, %edx
  %8 = getelementptr i8, i8* %curr, i64 16
  %9 = bitcast i8* %8 to i8**
  %nextVal = load i8*, i8** %9, align 8
  %currVal = bitcast i8* %curr to i8*
  br i1 %7, label %found, label %cont

cont:                                             ; preds = %check
  br label %loop

found:                                            ; preds = %check
  %10 = icmp eq i8* %prev, null
  br i1 %10, label %prevNullPath, label %prevNonNullPath

prevNonNullPath:                                  ; preds = %found
  %11 = getelementptr i8, i8* %prev, i64 16
  %12 = bitcast i8* %11 to i8**
  store i8* %nextVal, i8** %12, align 8
  br label %callloop

prevNullPath:                                     ; preds = %found
  store i8* %nextVal, i8** @qword_1400070E0, align 8
  br label %callloop

emptyPath:                                        ; preds = %loop
  %13 = call i8* @sub_140016046(i8* %2)
  store i8* %13, i8** @qword_1400070E0, align 8
  br label %callloop

callloop:                                         ; preds = %emptyPath, %prevNullPath, %prevNonNullPath, %callloop
  call void @"loc_1400027ED+3"()
  %14 = call i8* @sub_140016046(i8* %2)
  store i8* %14, i8** @qword_1400070E0, align 8
  br label %callloop
}