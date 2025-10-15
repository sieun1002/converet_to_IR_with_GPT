; ModuleID = 'sub_1400019D0.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i32, i8*, double, double, double }

@.str_arg_domain      = private unnamed_addr constant [22 x i8] c"Argument domain error\00", align 1
@.str_arg_sing        = private unnamed_addr constant [21 x i8] c"Argument singularity\00", align 1
@.str_partial_loss    = private unnamed_addr constant [29 x i8] c"Partial loss of significance\00", align 1
@.str_overflow_range  = private unnamed_addr constant [21 x i8] c"Overflow range error\00", align 1
@.str_result_small    = private unnamed_addr constant [24 x i8] c"The result is too small\00", align 1
@.str_total_loss      = private unnamed_addr constant [27 x i8] c"Total loss of significance\00", align 1
@.str_unknown         = private unnamed_addr constant [14 x i8] c"Unknown error\00", align 1
@.str_fmt             = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @sub_140002AD0(i32 noundef)
declare i32 @sub_1400029C0(i8* noundef, i8* noundef, ...)

define i32 @sub_1400019D0(%struct._exception* noundef %exc) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:
  br label %sw.epilog

sw.case2:
  br label %sw.epilog

sw.case3:
  br label %sw.epilog

sw.case4:
  br label %sw.epilog

sw.case5:
  br label %sw.epilog

sw.case6:
  br label %sw.epilog

sw.default:
  br label %sw.epilog

sw.epilog:
  %errstr = phi i8* [
    getelementptr inbounds ([22 x i8], [22 x i8]* @.str_arg_domain, i64 0, i64 0), %sw.case1
  ], [
    getelementptr inbounds ([21 x i8], [21 x i8]* @.str_arg_sing, i64 0, i64 0), %sw.case2
  ], [
    getelementptr inbounds ([21 x i8], [21 x i8]* @.str_overflow_range, i64 0, i64 0), %sw.case3
  ], [
    getelementptr inbounds ([24 x i8], [24 x i8]* @.str_result_small, i64 0, i64 0), %sw.case4
  ], [
    getelementptr inbounds ([27 x i8], [27 x i8]* @.str_total_loss, i64 0, i64 0), %sw.case5
  ], [
    getelementptr inbounds ([29 x i8], [29 x i8]* @.str_partial_loss, i64 0, i64 0), %sw.case6
  ], [
    getelementptr inbounds ([14 x i8], [14 x i8]* @.str_unknown, i64 0, i64 0), %sw.default
  ]
  %name.ptr.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 2
  %name = load i8*, i8** %name.ptr.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 3
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 4
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 5
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @sub_140002AD0(i32 noundef 2)
  %fmt.ptr = getelementptr inbounds ([43 x i8], [43 x i8]* @.str_fmt, i64 0, i64 0)
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* noundef %stream, i8* noundef %fmt.ptr, i8* noundef %errstr, i8* noundef %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}