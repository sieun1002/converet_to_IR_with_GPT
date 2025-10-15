; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32, align 4
@qword_1400070E0 = external dso_local global i8*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local i8* @sub_140002B38(i32, i32)
declare dso_local void @sub_1400EC867(i8*)
declare dso_local void @sub_140001701(i8*)

define dso_local i32 @sub_140002250(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %isnz = icmp ne i32 %g, 0
  br i1 %isnz, label %loc_270, label %ret0

loc_270:                                          ; preds = %entry
  %p = call i8* @sub_140002B38(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %retneg1, label %after_alloc

after_alloc:                                      ; preds = %loc_270
  %p_i32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %p_i32, align 4
  %off8 = getelementptr i8, i8* %p, i64 8
  %off8_ptr = bitcast i8* %off8 to i8**
  store i8* %arg1, i8** %off8_ptr, align 8
  call void @sub_1400EC867(i8* @unk_140007100)
  %old = load i8*, i8** @qword_1400070E0, align 8
  %off16 = getelementptr i8, i8* %p, i64 16
  %off16_ptr = bitcast i8* %off16 to i8**
  store i8* %old, i8** %off16_ptr, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_140001701(i8* @unk_140007100)
  br label %ret0

retneg1:                                          ; preds = %loc_270
  ret i32 -1

ret0:                                             ; preds = %after_alloc, %entry
  ret i32 0
}