; target
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external dso_local global i32, align 4
@qword_1400070E0 = external dso_local global %struct.Node*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local %struct.Node* @sub_1400027E8(i32, i32)
declare dso_local void @loc_1405F6BA6(i8*)
declare dso_local void @sub_140024080(i8*)

define dso_local i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %g, 0
  br i1 %cmp, label %loc_140001F10, label %ret0

ret0:
  ret i32 0

loc_140001F10:
  %node = call %struct.Node* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq %struct.Node* %node, null
  br i1 %isnull, label %retm1, label %cont

cont:
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %arg0, i32* %field0ptr, align 4
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %arg1, i8** %field2ptr, align 8
  call void @loc_1405F6BA6(i8* @unk_140007100)
  %prev = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %field3ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %prev, %struct.Node** %field3ptr, align 8
  store %struct.Node* %node, %struct.Node** @qword_1400070E0, align 8
  call void @sub_140024080(i8* @unk_140007100)
  br label %retm1

retm1:
  ret i32 -1
}