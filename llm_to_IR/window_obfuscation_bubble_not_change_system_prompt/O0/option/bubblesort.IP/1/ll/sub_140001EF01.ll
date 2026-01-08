; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)
declare void @sub_1400F4AF3(i8*)
declare void @sub_1403D557D(i8*)

define i32 @sub_140001EF0(i32 %ecx, i8* %rdx) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %loc_140001F10, label %loc_140001F01

loc_140001F01:                                  ; returns 0
  ret i32 0

loc_140001F10:
  %call.p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %call.p, null
  br i1 %isnull, label %loc_140001F77, label %hasptr

loc_140001F77:                                  ; returns -1
  ret i32 -1

hasptr:
  %p.i32 = bitcast i8* %call.p to i32*
  store i32 %ecx, i32* %p.i32, align 4
  %p.plus8 = getelementptr inbounds i8, i8* %call.p, i64 8
  %p.plus8.pp = bitcast i8* %p.plus8 to i8**
  store i8* %rdx, i8** %p.plus8.pp, align 8
  call void @sub_1400F4AF3(i8* @unk_140007100)
  %old = load i8*, i8** @qword_1400070E0, align 8
  %p.plus16 = getelementptr inbounds i8, i8* %call.p, i64 16
  %p.plus16.pp = bitcast i8* %p.plus16 to i8**
  store i8* %old, i8** %p.plus16.pp, align 8
  store i8* %call.p, i8** @qword_1400070E0, align 8
  call void @sub_1403D557D(i8* @unk_140007100)
  br label %loc_140001F01
}