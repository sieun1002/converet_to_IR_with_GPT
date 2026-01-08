; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.node = type { i32, i32, i8*, i8* }

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_1400027E8(i32, i32)
declare void @sub_1400D1A4D(i8*)
declare void @sub_1400FEC0A(i8*)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %cont, label %ret_zero

ret_zero:                                         ; preds = %entry
  ret i32 0

cont:                                             ; preds = %entry
  %2 = call i8* @sub_1400027E8(i32 1, i32 24)
  %3 = icmp eq i8* %2, null
  br i1 %3, label %ret_neg1, label %alloc_ok

ret_neg1:                                         ; preds = %cont
  ret i32 -1

alloc_ok:                                         ; preds = %cont
  %4 = bitcast i8* %2 to %struct.node*
  %5 = getelementptr inbounds %struct.node, %struct.node* %4, i64 0, i32 0
  store i32 %arg0, i32* %5, align 4
  %6 = getelementptr inbounds %struct.node, %struct.node* %4, i64 0, i32 2
  store i8* %arg1, i8** %6, align 8
  call void @sub_1400D1A4D(i8* @unk_140007100)
  %7 = load i8*, i8** @qword_1400070E0, align 8
  %8 = getelementptr inbounds %struct.node, %struct.node* %4, i64 0, i32 3
  store i8* %7, i8** %8, align 8
  store i8* %2, i8** @qword_1400070E0, align 8
  call void @sub_1400FEC0A(i8* @unk_140007100)
  ret i32 0
}