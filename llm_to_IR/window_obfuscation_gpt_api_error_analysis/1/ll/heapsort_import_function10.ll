; ModuleID = 'sub_1400022B0.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8

declare dso_local i8* @sub_140002BA8(i32 noundef, i32 noundef)
declare dso_local void @sub_1400DA76B(i8* noundef)
declare dso_local void @sub_1403CBAAE(i8* noundef)

define dso_local i32 @sub_1400022B0(i32 noundef %arg0, i8* noundef %arg1) {
entry:
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %t0 = icmp ne i32 %g0, 0
  br i1 %t0, label %alloc, label %ret_zero

ret_zero:
  ret i32 0

alloc:
  %p0 = call i8* @sub_140002BA8(i32 noundef 1, i32 noundef 24)
  %isnull = icmp eq i8* %p0, null
  br i1 %isnull, label %ret_neg1, label %init

ret_neg1:
  ret i32 -1

init:
  %p_i32 = bitcast i8* %p0 to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %p8 = getelementptr i8, i8* %p0, i64 8
  %p8ptr = bitcast i8* %p8 to i8**
  store i8* %arg1, i8** %p8ptr, align 8
  call void @sub_1400DA76B(i8* noundef @unk_140007100)
  %p16 = getelementptr i8, i8* %p0, i64 16
  %p16ptr = bitcast i8* %p16 to i8**
  store i8* null, i8** %p16ptr, align 8
  store i8* %p0, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE(i8* noundef @unk_140007100)
  ret i32 0
}