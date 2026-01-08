target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002310(i64 %rcx) local_unnamed_addr {
entry:
  %0 = load i8*, i8** @off_1400043C0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret0

check_pe:                                            ; preds = %entry
  %4 = getelementptr inbounds i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_magic, label %ret0

check_magic:                                         ; preds = %check_pe
  %12 = getelementptr inbounds i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %load_counts, label %ret0

load_counts:                                         ; preds = %check_magic
  %16 = getelementptr inbounds i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %ret0, label %calc_tables

calc_tables:                                         ; preds = %load_counts
  %20 = getelementptr inbounds i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 1
  %23 = zext i16 %22 to i64
  %24 = add i64 %23, 24
  %25 = getelementptr inbounds i8, i8* %8, i64 %24
  %26 = zext i16 %18 to i64
  %27 = add i64 %26, -1
  %28 = mul i64 %27, 5
  %29 = mul i64 %28, 8
  %30 = add i64 %29, 40
  %31 = getelementptr inbounds i8, i8* %25, i64 %30
  br label %loop

loop:                                                ; preds = %cont, %calc_tables
  %32 = phi i8* [ %25, %calc_tables ], [ %37, %cont ]
  %33 = phi i64 [ %rcx, %calc_tables ], [ %36, %cont ]
  %34 = getelementptr inbounds i8, i8* %32, i64 39
  %35 = load i8, i8* %34, align 1
  %mask = and i8 %35, 32
  %flag = icmp ne i8 %mask, 0
  br i1 %flag, label %flagged, label %cont

flagged:                                             ; preds = %loop
  %iszero = icmp eq i64 %33, 0
  br i1 %iszero, label %ret0, label %dec

dec:                                                 ; preds = %flagged
  %decval = add i64 %33, -1
  br label %cont

cont:                                                ; preds = %dec, %loop
  %36 = phi i64 [ %33, %loop ], [ %decval, %dec ]
  %37 = getelementptr inbounds i8, i8* %32, i64 40
  %38 = icmp ne i8* %37, %31
  br i1 %38, label %loop, label %ret0

ret0:                                                ; preds = %cont, %flagged, %load_counts, %check_magic, %check_pe, %entry
  ret i32 0
}