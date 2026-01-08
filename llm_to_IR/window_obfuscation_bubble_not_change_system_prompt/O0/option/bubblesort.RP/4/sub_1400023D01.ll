; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_1400023D0(i8* %rcx) local_unnamed_addr {
entry:
  %0 = load i8*, i8** @off_1400043C0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %pecheck, label %retzero

pecheck:                                          ; preds = %entry
  %4 = getelementptr inbounds i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %optcheck, label %retzero

optcheck:                                         ; preds = %pecheck
  %12 = getelementptr inbounds i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %getnsec, label %retzero

getnsec:                                          ; preds = %optcheck
  %16 = getelementptr inbounds i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %retzero, label %cont

cont:                                             ; preds = %getnsec
  %20 = getelementptr inbounds i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 1
  %23 = zext i16 %22 to i64
  %24 = ptrtoint i8* %rcx to i64
  %25 = ptrtoint i8* %0 to i64
  %26 = sub i64 %24, %25
  %27 = zext i16 %18 to i32
  %28 = add i32 %27, -1
  %29 = mul i32 %28, 5
  %30 = zext i32 %29 to i64
  %31 = add i64 %23, 24
  %32 = getelementptr inbounds i8, i8* %8, i64 %31
  %33 = mul i64 %30, 8
  %34 = getelementptr inbounds i8, i8* %32, i64 %33
  %35 = getelementptr inbounds i8, i8* %34, i64 40
  br label %loop.head

loop.head:                                        ; preds = %advance, %cont
  %36 = phi i8* [ %32, %cont ], [ %38, %advance ]
  %37 = icmp ne i8* %36, %35
  br i1 %37, label %loop.body, label %notfound

loop.body:                                        ; preds = %loop.head
  %38 = getelementptr inbounds i8, i8* %36, i64 40
  %39 = getelementptr inbounds i8, i8* %36, i64 12
  %40 = bitcast i8* %39 to i32*
  %41 = load i32, i32* %40, align 1
  %42 = zext i32 %41 to i64
  %43 = icmp ult i64 %26, %42
  br i1 %43, label %advance, label %checkrange

checkrange:                                       ; preds = %loop.body
  %44 = getelementptr inbounds i8, i8* %36, i64 8
  %45 = bitcast i8* %44 to i32*
  %46 = load i32, i32* %45, align 1
  %47 = add i32 %41, %46
  %48 = zext i32 %47 to i64
  %49 = icmp ult i64 %26, %48
  br i1 %49, label %found, label %advance

advance:                                          ; preds = %checkrange, %loop.body
  br label %loop.head

found:                                            ; preds = %checkrange
  %50 = getelementptr inbounds i8, i8* %36, i64 36
  %51 = bitcast i8* %50 to i32*
  %52 = load i32, i32* %51, align 1
  %53 = xor i32 %52, -1
  %54 = lshr i32 %53, 31
  ret i32 %54

notfound:                                         ; preds = %loop.head
  ret i32 0

retzero:                                          ; preds = %getnsec, %optcheck, %pecheck, %entry
  ret i32 0
}