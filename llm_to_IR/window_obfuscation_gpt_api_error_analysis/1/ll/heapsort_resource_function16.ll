; Target: Windows x64 MSVC
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque
%struct._exception = type { i32, i8*, double, double, double }

@.str.format = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"
@.str.arg_domain = private unnamed_addr constant [22 x i8] c"argument domain error\00"
@.str.arg_singularity = private unnamed_addr constant [21 x i8] c"argument singularity\00"
@.str.overflow_range = private unnamed_addr constant [21 x i8] c"overflow range error\00"
@.str.result_too_small = private unnamed_addr constant [42 x i8] c"the result is too small to be represented\00"
@.str.total_loss = private unnamed_addr constant [27 x i8] c"total loss of significance\00"
@.str.partial_loss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00"
@.str.unknown_error = private unnamed_addr constant [14 x i8] c"unknown error\00"

declare %struct._iobuf* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(%struct._iobuf*, i8*, ...)

define dso_local i32 @sub_1400019D0(%struct._exception* nocapture readonly %e) {
entry:
  %type.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                          ; argument domain error
  br label %sw.merge

sw.case2:                                          ; argument singularity
  br label %sw.merge

sw.case3:                                          ; overflow range error
  br label %sw.merge

sw.case4:                                          ; the result is too small to be represented
  br label %sw.merge

sw.case5:                                          ; total loss of significance
  br label %sw.merge

sw.case6:                                          ; partial loss of significance
  br label %sw.merge

sw.default:                                        ; unknown error (includes case 0 and others)
  br label %sw.merge

sw.merge:
  %err.sel = phi i8* [
    getelementptr inbounds ([22 x i8], [22 x i8]* @.str.arg_domain, i64 0, i64 0), %sw.case1
  ], [
    getelementptr inbounds ([21 x i8], [21 x i8]* @.str.arg_singularity, i64 0, i64 0), %sw.case2
  ], [
    getelementptr inbounds ([21 x i8], [21 x i8]* @.str.overflow_range, i64 0, i64 0), %sw.case3
  ], [
    getelementptr inbounds ([42 x i8], [42 x i8]* @.str.result_too_small, i64 0, i64 0), %sw.case4
  ], [
    getelementptr inbounds ([27 x i8], [27 x i8]* @.str.total_loss, i64 0, i64 0), %sw.case5
  ], [
    getelementptr inbounds ([29 x i8], [29 x i8]* @.str.partial_loss, i64 0, i64 0), %sw.case6
  ], [
    getelementptr inbounds ([14 x i8], [14 x i8]* @.str.unknown_error, i64 0, i64 0), %sw.default
  ]
  %name.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 1
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 2
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 3
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 4
  %retval = load double, double* %retval.ptr, align 8
  %stderr = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str.format, i64 0, i64 0
  %call = call i32 (%struct._iobuf*, i8*, ...) @sub_1400029C0(%struct._iobuf* %stderr, i8* %fmt, i8* %err.sel, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}