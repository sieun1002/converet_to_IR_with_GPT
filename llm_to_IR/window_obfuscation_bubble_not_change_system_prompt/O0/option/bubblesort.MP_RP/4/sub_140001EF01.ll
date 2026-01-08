; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, i8* }

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@qword_140008258 = external global void (i8*)*
@qword_140008270 = external global void (i8*)*
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)

define dso_local i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp eq i32 %0, 0
  br i1 %1, label %ret_zero, label %alloc

ret_zero:                                        ; preds = %entry
  ret i32 0

alloc:                                            ; preds = %entry
  %2 = call i8* @sub_1400027E8(i32 1, i32 24)
  %3 = icmp eq i8* %2, null
  br i1 %3, label %fail, label %cont

fail:                                             ; preds = %alloc
  ret i32 -1

cont:                                             ; preds = %alloc
  %4 = bitcast i8* %2 to %struct.Node*
  %5 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 0
  store i32 %arg0, i32* %5, align 4
  %6 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 2
  store i8* %arg1, i8** %6, align 8
  %7 = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %7(i8* @unk_140007100)
  %8 = load i8*, i8** @qword_1400070E0, align 8
  %9 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 3
  store i8* %8, i8** %9, align 8
  store i8* %2, i8** @qword_1400070E0, align 8
  %10 = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  call void %10(i8* @unk_140007100)
  ret i32 0
}