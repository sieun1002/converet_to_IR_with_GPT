; ModuleID = 'sub_1400022B0.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32, align 4
@qword_1400070E0 = external dso_local global i8*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local i8* @sub_140002BA8(i32 noundef, i32 noundef)
declare dso_local i128 @sub_1400DA76B(i8* noundef)
declare dso_local void @sub_1403CBAAE(i8* noundef)

define dso_local i32 @sub_1400022B0(i32 noundef %arg0, i8* noundef %arg1) local_unnamed_addr {
entry:
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %t0 = icmp eq i32 %g0, 0
  br i1 %t0, label %ret0, label %alloc

ret0:
  ret i32 0

alloc:
  %p0 = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %p0, null
  br i1 %isnull, label %retm1, label %init

retm1:
  ret i32 -1

init:
  %pi32 = bitcast i8* %p0 to i32*
  store i32 %arg0, i32* %pi32, align 4
  %p8 = getelementptr inbounds i8, i8* %p0, i64 8
  %pptr = bitcast i8* %p8 to i8**
  store i8* %arg1, i8** %pptr, align 8
  %unkptr = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  %ret128 = call i128 @sub_1400DA76B(i8* %unkptr)
  %hi = lshr i128 %ret128, 64
  %hi64 = trunc i128 %hi to i64
  %p16 = getelementptr inbounds i8, i8* %p0, i64 16
  %p16i64 = bitcast i8* %p16 to i64*
  store i64 %hi64, i64* %p16i64, align 8
  store i8* %p0, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE(i8* %unkptr)
  ret i32 0
}