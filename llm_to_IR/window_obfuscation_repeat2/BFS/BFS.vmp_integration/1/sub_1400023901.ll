; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_140002C88(i32, i32)
declare i8* @sub_1400438F3(i8*)
declare void @loc_14003A192(i8*)

define i8* @sub_140002390(i32 %ecx, i8* %rdx) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %cont, label %ret_null

ret_null:                                         ; preds = %entry
  ret i8* null

cont:                                             ; preds = %entry
  %2 = call i8* @sub_140002C88(i32 1, i32 24)
  %3 = icmp eq i8* %2, null
  br i1 %3, label %return_p, label %p_nonnull

return_p:                                         ; preds = %cont
  ret i8* %2

p_nonnull:                                        ; preds = %cont
  %4 = bitcast i8* %2 to i32*
  store i32 %ecx, i32* %4, align 4
  %5 = getelementptr inbounds i8, i8* %2, i64 8
  %6 = bitcast i8* %5 to i8**
  store i8* %rdx, i8** %6, align 8
  %7 = call i8* @sub_1400438F3(i8* @unk_140007100)
  %8 = getelementptr i8, i8* %7, i64 -117
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = and i32 %10, 5029141
  %12 = trunc i32 %ecx to i8
  %13 = load i8, i8* %8, align 1
  %14 = add i8 %13, %12
  store i8 %14, i8* %8, align 1
  %15 = ptrtoint i8* %7 to i64
  %16 = and i64 %15, -256
  %17 = and i64 %15, 255
  %18 = and i64 %17, 40
  %19 = or i64 %16, %18
  %20 = inttoptr i64 %19 to i8*
  %21 = getelementptr i8, i8* %20, i64 16
  %22 = bitcast i8* %21 to i64*
  store i64 24, i64* %22, align 8
  store i8* %20, i8** @qword_1400070E0, align 8
  call void @loc_14003A192(i8* @unk_140007100)
  %23 = getelementptr i8, i8* %20, i64 -1
  %24 = load volatile i8, i8* %23, align 1
  ret i8* %20
}