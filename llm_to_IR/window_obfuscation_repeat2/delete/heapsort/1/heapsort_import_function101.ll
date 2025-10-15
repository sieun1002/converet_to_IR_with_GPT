; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_140002BA8(i32, i32)
declare i64 @sub_1400DA76B(i8*)
declare void @sub_1403CBAAE(i8*)

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp eq i32 %g, 0
  br i1 %cond, label %ret0, label %L1

ret0:
  ret i32 0

L1:
  %p = call i8* @sub_140002BA8(i32 1, i32 24)
  %null = icmp eq i8* %p, null
  br i1 %null, label %retm1, label %L2

retm1:
  ret i32 -1

L2:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %p_plus8 = getelementptr i8, i8* %p, i64 8
  %pptr = bitcast i8* %p_plus8 to i8**
  store i8* %arg1, i8** %pptr, align 8
  %rdxval = call i64 @sub_1400DA76B(i8* @unk_140007100)
  %p_plus16 = getelementptr i8, i8* %p, i64 16
  %p64 = bitcast i8* %p_plus16 to i64*
  store i64 %rdxval, i64* %p64, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE(i8* @unk_140007100)
  ret i32 0
}