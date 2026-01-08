; ModuleID = 'sub_140001EF0.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32, align 4
@qword_1400070E0 = external dso_local global i8*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local i8* @sub_1400027E8(i32, i32)
declare dso_local void @sub_1400F4AF3(i8*)
declare dso_local void @sub_1403D557D(i8*)

define dso_local i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %if.nonzero, label %ret.zero

ret.zero:
  ret i32 0

if.nonzero:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %nz = icmp eq i8* %p, null
  br i1 %nz, label %ret.minus1, label %alloc.ok

ret.minus1:
  ret i32 -1

alloc.ok:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %p_field8 = bitcast i8* %p_plus8 to i8**
  store i8* %arg1, i8** %p_field8, align 8
  %rcx = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @sub_1400F4AF3(i8* %rcx)
  %old = load i8*, i8** @qword_1400070E0, align 8
  %p_plus16 = getelementptr inbounds i8, i8* %p, i64 16
  %p_field16 = bitcast i8* %p_plus16 to i8**
  store i8* %old, i8** %p_field16, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_1403D557D(i8* %rcx)
  br label %ret.zero
}