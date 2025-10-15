; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque
%struct._exception = type { i32, i8*, double, double, double }

@str_format = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1
@str_argument_singularity = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@str_argument_domain_error = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@str_partial_loss_of_significance = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@str_overflow_range_error = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@str_result_too_small = private unnamed_addr constant [42 x i8] c"The result is too small to be represented\00", align 1
@str_total_loss_of_significance = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@str_unknown_error = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1

declare dso_local %struct._iobuf* @__acrt_iob_func(i32)
declare dso_local i32 @fprintf(%struct._iobuf*, i8*, ...)

define dso_local i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %fmt, i8* %msg, i8* %name, double %a1, double %a2, double %retval) {
entry:
  %call = call i32 (%struct._iobuf*, i8*, ...) @fprintf(%struct._iobuf* %stream, i8* %fmt, i8* %msg, i8* %name, double %a1, double %a2, double %retval)
  ret i32 %call
}

define dso_local i32 @sub_1400019D0(%struct._exception* %exc) {
entry:
  %typeptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 0
  %type = load i32, i32* %typeptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                           ; case 1: argument domain error
  %p1 = getelementptr inbounds [22 x i8], [22 x i8]* @str_argument_domain_error, i64 0, i64 0
  br label %selectmsg

sw.case2:                                           ; case 2: argument singularity
  %p2 = getelementptr inbounds [21 x i8], [21 x i8]* @str_argument_singularity, i64 0, i64 0
  br label %selectmsg

sw.case3:                                           ; case 3: overflow range error
  %p3 = getelementptr inbounds [21 x i8], [21 x i8]* @str_overflow_range_error, i64 0, i64 0
  br label %selectmsg

sw.case4:                                           ; case 4: result too small
  %p4 = getelementptr inbounds [42 x i8], [42 x i8]* @str_result_too_small, i64 0, i64 0
  br label %selectmsg

sw.case5:                                           ; case 5: total loss of significance
  %p5 = getelementptr inbounds [27 x i8], [27 x i8]* @str_total_loss_of_significance, i64 0, i64 0
  br label %selectmsg

sw.case6:                                           ; case 6: partial loss of significance
  %p6 = getelementptr inbounds [29 x i8], [29 x i8]* @str_partial_loss_of_significance, i64 0, i64 0
  br label %selectmsg

sw.default:                                         ; default (and case 0): unknown error
  %pdef = getelementptr inbounds [14 x i8], [14 x i8]* @str_unknown_error, i64 0, i64 0
  br label %selectmsg

selectmsg:
  %msg = phi i8* [ %p1, %sw.case1 ], [ %p2, %sw.case2 ], [ %p3, %sw.case3 ], [ %p4, %sw.case4 ], [ %p5, %sw.case5 ], [ %p6, %sw.case6 ], [ %pdef, %sw.default ]
  %nameptrptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 1
  %name = load i8*, i8** %nameptrptr, align 8
  %a1ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 2
  %a1 = load double, double* %a1ptr, align 8
  %a2ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 3
  %a2 = load double, double* %a2ptr, align 8
  %retvalptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 4
  %retval = load double, double* %retvalptr, align 8
  %stream = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %fmtptr = getelementptr inbounds [43 x i8], [43 x i8]* @str_format, i64 0, i64 0
  %call2 = call i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %fmtptr, i8* %msg, i8* %name, double %a1, double %a2, double %retval)
  ret i32 0
}