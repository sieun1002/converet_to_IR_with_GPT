; ModuleID = 'sub_140002010.ll'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140001E80()
declare void @sub_1400027F0(i8*)
declare void @sub_140002120()

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8
@qword_140008250 = external global void (i8*)*
@qword_140008268 = external global void (i8*)*

define i32 @sub_140002010(i32 %arg1, i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %blk_20d8, label %after_cmp2

after_cmp2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %blk_2048, label %blk_201f

blk_201f:
  %isz = icmp eq i32 %edx, 0
  br i1 %isz, label %blk_2060, label %blk_2023

blk_2023:
  %ld1 = load i32, i32* @dword_1400070E8, align 4
  %iszero1 = icmp eq i32 %ld1, 0
  br i1 %iszero1, label %blk_2100, label %blk_2031

blk_2100:
  %fp268 = load void (i8*)*, void (i8*)** @qword_140008268, align 8
  call void %fp268(i8* @unk_140007100)
  br label %blk_2031

blk_2031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret_1

blk_2048:
  %iseq3 = icmp eq i32 %edx, 3
  br i1 %iseq3, label %blk_204d, label %ret_1

blk_204d:
  %ld2 = load i32, i32* @dword_1400070E8, align 4
  %iszero2 = icmp eq i32 %ld2, 0
  br i1 %iszero2, label %ret_1, label %blk_2057

blk_2057:
  call void @sub_140001E80()
  br label %ret_1

blk_2060:
  %ld3 = load i32, i32* @dword_1400070E8, align 4
  %nz3 = icmp ne i32 %ld3, 0
  br i1 %nz3, label %blk_20f0, label %blk_206e

blk_20f0:
  call void @sub_140001E80()
  br label %blk_206e

blk_206e:
  %ld4 = load i32, i32* @dword_1400070E8, align 4
  %isone = icmp eq i32 %ld4, 1
  br i1 %isone, label %blk_2079, label %ret_1

blk_2079:
  %p0 = load i8*, i8** @qword_1400070E0, align 8
  %isnullp0 = icmp eq i8* %p0, null
  br i1 %isnullp0, label %blk_20ab, label %blk_2090

blk_2090:
  %cur = phi i8* [ %p0, %blk_2079 ], [ %next, %blk_after_call ]
  %addr16 = getelementptr i8, i8* %cur, i64 16
  %addr16p = bitcast i8* %addr16 to i8**
  %next_loaded = load i8*, i8** %addr16p, align 8
  store i8* %next_loaded, i8** %var10, align 8
  call void @sub_1400027F0(i8* %cur)
  br label %blk_after_call

blk_after_call:
  %next = load i8*, i8** %var10, align 8
  %cont = icmp ne i8* %next, null
  br i1 %cont, label %blk_2090, label %blk_20ab

blk_20ab:
  %fp250 = load void (i8*)*, void (i8*)** @qword_140008250, align 8
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void %fp250(i8* @unk_140007100)
  br label %ret_1

blk_20d8:
  call void @sub_140002120()
  br label %ret_1

ret_1:
  ret i32 1
}