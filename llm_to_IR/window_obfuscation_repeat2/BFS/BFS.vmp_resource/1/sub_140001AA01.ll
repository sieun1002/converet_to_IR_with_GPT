; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Exception = type { i32, i8*, double, double, double }

@.str_argument_singularity = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_argument_domain_error = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str_partial_loss_of_significance = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_overflow_range_error = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str_result_too_small = private unnamed_addr constant [42 x i8] c"the result is too small to be represented\00", align 1
@.str_total_loss_of_significance = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_unknown_error_type = private unnamed_addr constant [19 x i8] c"unknown error type\00", align 1
@.str_format = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32 noundef)
declare i32 @sub_140002AA0(i8* noundef, i8* noundef, i8* noundef, i8* noundef, ...)

define dso_local i32 @sub_140001AA0(%struct.Exception* noundef %rcx) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct.Exception, %struct.Exception* %rcx, i32 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                          ; case 1
  %msg1 = getelementptr inbounds [22 x i8], [22 x i8]* @.str_argument_domain_error, i64 0, i64 0
  br label %common

sw.case2:                                          ; case 2
  %msg2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_argument_singularity, i64 0, i64 0
  br label %common

sw.case3:                                          ; case 3
  %msg3 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_overflow_range_error, i64 0, i64 0
  br label %common

sw.case4:                                          ; case 4
  %msg4 = getelementptr inbounds [42 x i8], [42 x i8]* @.str_result_too_small, i64 0, i64 0
  br label %common

sw.case5:                                          ; case 5
  %msg5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str_total_loss_of_significance, i64 0, i64 0
  br label %common

sw.case6:                                          ; case 6
  %msg6 = getelementptr inbounds [29 x i8], [29 x i8]* @.str_partial_loss_of_significance, i64 0, i64 0
  br label %common

sw.default:                                        ; default and case 0
  %msgd = getelementptr inbounds [19 x i8], [19 x i8]* @.str_unknown_error_type, i64 0, i64 0
  br label %common

common:
  %msg = phi i8* [ %msg2, %sw.case2 ], [ %msg1, %sw.case1 ], [ %msg3, %sw.case3 ], [ %msg4, %sw.case4 ], [ %msg5, %sw.case5 ], [ %msg6, %sw.case6 ], [ %msgd, %sw.default ]
  %name.ptr = getelementptr inbounds %struct.Exception, %struct.Exception* %rcx, i32 0, i32 1
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.Exception, %struct.Exception* %rcx, i32 0, i32 2
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.Exception, %struct.Exception* %rcx, i32 0, i32 3
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct.Exception, %struct.Exception* %rcx, i32 0, i32 4
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 noundef 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str_format, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002AA0(i8* noundef %stream, i8* noundef %fmt, i8* noundef %msg, i8* noundef %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}