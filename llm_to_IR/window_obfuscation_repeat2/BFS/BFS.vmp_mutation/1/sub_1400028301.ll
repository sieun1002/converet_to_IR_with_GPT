; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i8* @sub_140002830() {
entry:
  %0 = load i8*, i8** @off_1400043C0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret_null

check_pe:                                         ; preds = %entry
  %4 = getelementptr inbounds i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_optmagic, label %ret_null

check_optmagic:                                   ; preds = %check_pe
  %12 = getelementptr inbounds i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %ret_base, label %ret_null

ret_base:                                         ; preds = %check_optmagic
  ret i8* %0

ret_null:                                         ; preds = %check_optmagic, %check_pe, %entry
  ret i8* null
}