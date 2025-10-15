; ModuleID: matherr_printer
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i8*, double, double, double }

@.str = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1
@.str_arg_sing = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_arg_domain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str_partial_loss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_overflow_range = private unnamed_addr constant [23 x i8] c"overflow (range error)\00", align 1
@.str_result_too_large = private unnamed_addr constant [24 x i8] c"the result is too large\00", align 1
@.str_total_loss = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_unknown = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

define dso_local i32 @sub_1400019D0(%struct._exception* nocapture readonly %exc) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 0
  %type.val = load i32, i32* %type.ptr, align 8
  switch i32 %type.val, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case1:
  %msg.case1.ptr = getelementptr inbounds [22 x i8], [22 x i8]* @.str_arg_domain, i64 0, i64 0
  br label %cont

case2:
  %msg.case2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_arg_sing, i64 0, i64 0
  br label %cont

case3:
  %msg.case3.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_overflow_range, i64 0, i64 0
  br label %cont

case4:
  %msg.case4.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_result_too_large, i64 0, i64 0
  br label %cont

case5:
  %msg.case5.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_total_loss, i64 0, i64 0
  br label %cont

case6:
  %msg.case6.ptr = getelementptr inbounds [29 x i8], [29 x i8]* @.str_partial_loss, i64 0, i64 0
  br label %cont

sw.default:
  %msg.default.ptr = getelementptr inbounds [14 x i8], [14 x i8]* @.str_unknown, i64 0, i64 0
  br label %cont

cont:
  %msg.phi = phi i8* [ %msg.case1.ptr, %case1 ], [ %msg.case2.ptr, %case2 ], [ %msg.case3.ptr, %case3 ], [ %msg.case4.ptr, %case4 ], [ %msg.case5.ptr, %case5 ], [ %msg.case6.ptr, %case6 ], [ %msg.default.ptr, %sw.default ]
  %name.ptr.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 1
  %name.val = load i8*, i8** %name.ptr.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 2
  %arg1.val = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 3
  %arg2.val = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 4
  %retval.val = load double, double* %retval.ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt.ptr = getelementptr inbounds [43 x i8], [43 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt.ptr, i8* %msg.phi, i8* %name.val, double %arg1.val, double %arg2.val, double %retval.val)
  ret i32 0
}