; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8

declare dso_local i8* @sub_1400027E8(i32, i32)
declare dso_local void @sub_1400F4AF3(i8*)
declare dso_local void @sub_1403D557D(i8*)

define dso_local i32 @sub_140001EF0(i32 %arg0, i8* %arg1) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %flag, 0
  br i1 %cond, label %if.nonzero, label %ret.zero

ret.zero:                                           ; preds = %entry, %after.calls
  ret i32 0

if.nonzero:                                         ; preds = %entry
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret.neg1, label %fill

fill:                                               ; preds = %if.nonzero
  %p.i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p.i32, align 4
  %p.off8 = getelementptr inbounds i8, i8* %p, i64 8
  %p.off8.ptr = bitcast i8* %p.off8 to i8**
  store i8* %arg1, i8** %p.off8.ptr, align 8
  call void @sub_1400F4AF3(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %p.off16 = getelementptr inbounds i8, i8* %p, i64 16
  %p.off16.ptr = bitcast i8* %p.off16 to i8**
  store i8* %head, i8** %p.off16.ptr, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_1403D557D(i8* @unk_140007100)
  br label %ret.zero

ret.neg1:                                           ; preds = %if.nonzero
  ret i32 -1
}