; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.rec = type { i32, i32, i8*, i8* }

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)
declare void @loc_1405F6BA6(i8*)
declare void @sub_140024080(i8*)

define i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp eq i32 %g, 0
  br i1 %cmp0, label %ret0, label %cont

cont:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %retm1, label %alloc_ok

alloc_ok:
  %rec = bitcast i8* %p to %struct.rec*
  %f0 = getelementptr inbounds %struct.rec, %struct.rec* %rec, i32 0, i32 0
  store i32 %arg0, i32* %f0, align 4
  %f2 = getelementptr inbounds %struct.rec, %struct.rec* %rec, i32 0, i32 2
  store i8* %arg1, i8** %f2, align 8
  call void @loc_1405F6BA6(i8* @unk_140007100)
  %prev = load i8*, i8** @qword_1400070E0, align 8
  %f3 = getelementptr inbounds %struct.rec, %struct.rec* %rec, i32 0, i32 3
  store i8* %prev, i8** %f3, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_140024080(i8* @unk_140007100)
  br label %retm1

ret0:
  ret i32 0

retm1:
  ret i32 -1
}