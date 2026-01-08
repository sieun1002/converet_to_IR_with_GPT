; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i8* @sub_140002250(i8* %rcx) {
entry:
  %0 = load i8*, i8** @off_1400043C0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 2
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %after_mz, label %ret0

after_mz:                                            ; preds = %entry
  %4 = getelementptr inbounds i8, i8* %0, i32 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 4
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 4
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %after_pe, label %ret0

after_pe:                                            ; preds = %after_mz
  %12 = getelementptr inbounds i8, i8* %8, i32 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 2
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %after_magic, label %ret0

after_magic:                                         ; preds = %after_pe
  %16 = getelementptr inbounds i8, i8* %8, i32 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 2
  %19 = zext i16 %18 to i32
  %20 = icmp ne i32 %19, 0
  br i1 %20, label %calc, label %ret0

calc:                                                ; preds = %after_magic
  %21 = ptrtoint i8* %rcx to i64
  %22 = ptrtoint i8* %0 to i64
  %23 = sub i64 %21, %22
  %24 = getelementptr inbounds i8, i8* %8, i32 20
  %25 = bitcast i8* %24 to i16*
  %26 = load i16, i16* %25, align 2
  %27 = zext i16 %26 to i64
  %28 = add i64 %27, 24
  %29 = getelementptr inbounds i8, i8* %8, i64 %28
  %30 = add i32 %19, -1
  %31 = zext i32 %30 to i64
  %32 = mul i64 %31, 5
  %33 = mul i64 %32, 8
  %34 = add i64 %33, 40
  %35 = getelementptr inbounds i8, i8* %29, i64 %34
  br label %loop_head

loop_head:                                           ; preds = %advance, %calc
  %36 = phi i8* [ %29, %calc ], [ %40, %advance ]
  %37 = getelementptr inbounds i8, i8* %36, i32 12
  %38 = bitcast i8* %37 to i32*
  %39 = load i32, i32* %38, align 4
  %va64 = zext i32 %39 to i64
  %41 = icmp ult i64 %23, %va64
  br i1 %41, label %advance, label %check_in

check_in:                                            ; preds = %loop_head
  %42 = getelementptr inbounds i8, i8* %36, i32 8
  %43 = bitcast i8* %42 to i32*
  %44 = load i32, i32* %43, align 4
  %45 = add i32 %39, %44
  %46 = zext i32 %45 to i64
  %47 = icmp ult i64 %23, %46
  br i1 %47, label %ret_found, label %advance

advance:                                             ; preds = %check_in, %loop_head
  %40 = getelementptr inbounds i8, i8* %36, i32 40
  %48 = icmp eq i8* %40, %35
  br i1 %48, label %ret0_after, label %loop_head

ret_found:                                           ; preds = %check_in
  ret i8* %36

ret0:                                                ; preds = %after_magic, %after_pe, %after_mz, %entry
  ret i8* null

ret0_after:                                          ; preds = %advance
  ret i8* null
}