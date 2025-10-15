; ModuleID = 'matherr_handler'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._exception = type { i32, i8*, double, double, double }

@.str.domain = private unnamed_addr constant [22 x i8] c"Argument domain error\00", align 1
@.str.singular = private unnamed_addr constant [21 x i8] c"Argument singularity\00", align 1
@.str.overflow = private unnamed_addr constant [21 x i8] c"Overflow range error\00", align 1
@.str.too_small = private unnamed_addr constant [24 x i8] c"The result is too small\00", align 1
@.str.tloss = private unnamed_addr constant [27 x i8] c"Total loss of significance\00", align 1
@.str.ploss = private unnamed_addr constant [29 x i8] c"Partial loss of significance\00", align 1
@.str.unknown = private unnamed_addr constant [14 x i8] c"Unknown error\00", align 1
@.str.fmt = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32 noundef)
declare i32 @fprintf(i8* noundef, i8* noundef, ...)

define i32 @sub_1400019D0(%struct._exception* noundef %exc) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 0
  %type.val = load i32, i32* %type.ptr, align 4
  switch i32 %type.val, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                          ; _DOMAIN
  %msg.case1 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.domain, i32 0, i32 0
  br label %cont

sw.case2:                                          ; _SING
  %msg.case2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.singular, i32 0, i32 0
  br label %cont

sw.case3:                                          ; _OVERFLOW
  %msg.case3 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.overflow, i32 0, i32 0
  br label %cont

sw.case4:                                          ; _UNDERFLOW
  %msg.case4 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.too_small, i32 0, i32 0
  br label %cont

sw.case5:                                          ; _TLOSS
  %msg.case5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.tloss, i32 0, i32 0
  br label %cont

sw.case6:                                          ; _PLOSS
  %msg.case6 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.ploss, i32 0, i32 0
  br label %cont

sw.default:
  %msg.default = getelementptr inbounds [14 x i8], [14 x i8]* @.str.unknown, i32 0, i32 0
  br label %cont

cont:
  %msg = phi i8* [ %msg.case1, %sw.case1 ], [ %msg.case2, %sw.case2 ], [ %msg.case3, %sw.case3 ], [ %msg.case4, %sw.case4 ], [ %msg.case5, %sw.case5 ], [ %msg.case6, %sw.case6 ], [ %msg.default, %sw.default ]
  %name.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 1
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 2
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 3
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 4
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 noundef 2)
  %fmt.ptr = getelementptr inbounds [43 x i8], [43 x i8]* @.str.fmt, i32 0, i32 0
  %call = call i32 (i8*, i8*, ...) @fprintf(i8* noundef %stream, i8* noundef %fmt.ptr, i8* noundef %msg, i8* noundef %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}