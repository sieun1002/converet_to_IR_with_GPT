; Target: Windows x86_64 MSVC
target triple = "x86_64-pc-windows-msvc"

%struct.exc = type { i32, i32, i8*, double, double, double }

@.str_argument_singularity = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_argument_domain      = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str_partial_loss         = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_overflow_range       = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str_result_too_small     = private unnamed_addr constant [24 x i8] c"The result is too small\00", align 1
@.str_total_loss           = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_unknown_error        = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@.str_fmt                  = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare dso_local i8* @sub_140002AD0(i32 noundef)
declare dso_local i32 @sub_1400029C0(i8* noundef, i8* noundef, i8* noundef, i8* noundef, double noundef, double noundef, double noundef)

define dso_local i32 @sub_1400019D0(%struct.exc* noundef %0) {
entry:
  %1 = getelementptr inbounds %struct.exc, %struct.exc* %0, i32 0, i32 0
  %2 = load i32, i32* %1, align 4
  switch i32 %2, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:
  %3 = getelementptr inbounds [22 x i8], [22 x i8]* @.str_argument_domain, i64 0, i64 0
  br label %select.end

sw.case2:
  %4 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_argument_singularity, i64 0, i64 0
  br label %select.end

sw.case3:
  %5 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_overflow_range, i64 0, i64 0
  br label %select.end

sw.case4:
  %6 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_result_too_small, i64 0, i64 0
  br label %select.end

sw.case5:
  %7 = getelementptr inbounds [27 x i8], [27 x i8]* @.str_total_loss, i64 0, i64 0
  br label %select.end

sw.case6:
  %8 = getelementptr inbounds [29 x i8], [29 x i8]* @.str_partial_loss, i64 0, i64 0
  br label %select.end

sw.default:
  %9 = getelementptr inbounds [14 x i8], [14 x i8]* @.str_unknown_error, i64 0, i64 0
  br label %select.end

select.end:
  %10 = phi i8* [ %3, %sw.case1 ], [ %4, %sw.case2 ], [ %5, %sw.case3 ], [ %6, %sw.case4 ], [ %7, %sw.case5 ], [ %8, %sw.case6 ], [ %9, %sw.default ]
  %11 = getelementptr inbounds %struct.exc, %struct.exc* %0, i32 0, i32 2
  %12 = load i8*, i8** %11, align 8
  %13 = getelementptr inbounds %struct.exc, %struct.exc* %0, i32 0, i32 3
  %14 = load double, double* %13, align 8
  %15 = getelementptr inbounds %struct.exc, %struct.exc* %0, i32 0, i32 4
  %16 = load double, double* %15, align 8
  %17 = getelementptr inbounds %struct.exc, %struct.exc* %0, i32 0, i32 5
  %18 = load double, double* %17, align 8
  %19 = call i8* @sub_140002AD0(i32 noundef 2)
  %20 = getelementptr inbounds [43 x i8], [43 x i8]* @.str_fmt, i64 0, i64 0
  %21 = call i32 @sub_1400029C0(i8* noundef %19, i8* noundef %20, i8* noundef %10, i8* noundef %12, double noundef %14, double noundef %16, double noundef %18)
  ret i32 0
}