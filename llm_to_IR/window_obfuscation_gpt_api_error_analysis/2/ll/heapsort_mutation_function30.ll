; ModuleID = 'pe_section_scan'
source_filename = "pe_section_scan.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %count) local_unnamed_addr nounwind {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret0

check_pe:
  %4 = getelementptr inbounds i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_opt, label %ret0

check_opt:
  %12 = getelementptr inbounds i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %load_counts, label %ret0

load_counts:
  %16 = getelementptr inbounds i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %ret0, label %preheader

preheader:
  %20 = getelementptr inbounds i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 1
  %23 = zext i16 %22 to i64
  %24 = getelementptr inbounds i8, i8* %8, i64 24
  %25 = getelementptr inbounds i8, i8* %24, i64 %23
  %26 = zext i16 %18 to i64
  %27 = mul i64 %26, 40
  %28 = getelementptr inbounds i8, i8* %25, i64 %27
  br label %loop

loop:
  %29 = phi i8* [ %25, %preheader ], [ %35, %inc ]
  %30 = phi i64 [ %count, %preheader ], [ %34, %inc ]
  %31 = getelementptr inbounds i8, i8* %29, i64 39
  %32 = load i8, i8* %31, align 1
  %33 = and i8 %32, 32
  %34cond = icmp ne i8 %33, 0
  br i1 %34cond, label %exec_check, label %inc_no_dec

exec_check:
  %zero = icmp eq i64 %30, 0
  br i1 %zero, label %ret0, label %dec_path

dec_path:
  %dec = add i64 %30, -1
  br label %inc

inc_no_dec:
  br label %inc

inc:
  %34 = phi i64 [ %dec, %dec_path ], [ %30, %inc_no_dec ]
  %35 = getelementptr inbounds i8, i8* %29, i64 40
  %done = icmp eq i8* %35, %28
  br i1 %done, label %ret0, label %loop

ret0:
  ret i32 0
}