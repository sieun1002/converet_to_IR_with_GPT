; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._exception = type { i32, i32, i8*, double, double, double }

@.str_arg_sing = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_arg_domain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str_partial_loss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_overflow = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str_too_large = private unnamed_addr constant [24 x i8] c"the result is too large\00", align 1
@.str_total_loss = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_unknown = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@.str_fmt = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32 noundef)
declare dso_local i32 @sub_1400029C0(i8* noundef, i8* noundef, i8* noundef, i8* noundef, ...)

define dso_local i32 @sub_1400019D0(%struct._exception* noundef %e) local_unnamed_addr {
entry:
  %typeptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 0
  %type = load i32, i32* %typeptr, align 4
  switch i32 %type, label %sw.default [
    i32 0, label %case.unknown
    i32 1, label %case.domain
    i32 2, label %case.singularity
    i32 3, label %case.overflow
    i32 4, label %case.toolarge
    i32 5, label %case.totalloss
    i32 6, label %case.partialloss
  ]

case.singularity:
  %msg_sing_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_arg_sing, i32 0, i32 0
  br label %join

case.domain:
  %msg_dom_ptr = getelementptr inbounds [22 x i8], [22 x i8]* @.str_arg_domain, i32 0, i32 0
  br label %join

case.partialloss:
  %msg_partial_ptr = getelementptr inbounds [29 x i8], [29 x i8]* @.str_partial_loss, i32 0, i32 0
  br label %join

case.overflow:
  %msg_over_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_overflow, i32 0, i32 0
  br label %join

case.toolarge:
  %msg_toolarge_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_too_large, i32 0, i32 0
  br label %join

case.totalloss:
  %msg_totalloss_ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_total_loss, i32 0, i32 0
  br label %join

case.unknown:
  %msg_unknown_ptr = getelementptr inbounds [14 x i8], [14 x i8]* @.str_unknown, i32 0, i32 0
  br label %join

sw.default:
  %msg_default_ptr = getelementptr inbounds [14 x i8], [14 x i8]* @.str_unknown, i32 0, i32 0
  br label %join

join:
  %msg = phi i8* [ %msg_sing_ptr, %case.singularity ], [ %msg_dom_ptr, %case.domain ], [ %msg_partial_ptr, %case.partialloss ], [ %msg_over_ptr, %case.overflow ], [ %msg_toolarge_ptr, %case.toolarge ], [ %msg_totalloss_ptr, %case.totalloss ], [ %msg_unknown_ptr, %case.unknown ], [ %msg_default_ptr, %sw.default ]
  %name_ptrptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 2
  %name = load i8*, i8** %name_ptrptr, align 8
  %arg1_ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 3
  %arg1 = load double, double* %arg1_ptr, align 8
  %arg2_ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 4
  %arg2 = load double, double* %arg2_ptr, align 8
  %retval_ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 5
  %retval = load double, double* %retval_ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 noundef 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str_fmt, i32 0, i32 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* noundef %stream, i8* noundef %fmt, i8* noundef %msg, i8* noundef %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}