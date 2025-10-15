; ModuleID = 'matherr_handler'
target triple = "x86_64-pc-windows-msvc"

%struct.__exception = type { i32, i8*, double, double, double }

@.str.argsing      = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str.argdomain    = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str.partialloss  = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str.overflow     = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str.toosmall     = private unnamed_addr constant [42 x i8] c"the result is too small to be represented\00", align 1
@.str.totalloss    = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str.unknown      = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@.str.fmt          = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i8*, ...)

define dso_local i32 @sub_1400019D0(%struct.__exception* nocapture readonly %exc) {
entry:
  %type.ptr = getelementptr inbounds %struct.__exception, %struct.__exception* %exc, i32 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1: ; argument domain error
  %msg.case1 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.argdomain, i64 0, i64 0
  br label %print

sw.case2: ; argument singularity
  %msg.case2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.argsing, i64 0, i64 0
  br label %print

sw.case3: ; overflow range error
  %msg.case3 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.overflow, i64 0, i64 0
  br label %print

sw.case4: ; result too small
  %msg.case4 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.toosmall, i64 0, i64 0
  br label %print

sw.case5: ; total loss of significance
  %msg.case5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.totalloss, i64 0, i64 0
  br label %print

sw.case6: ; partial loss of significance
  %msg.case6 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.partialloss, i64 0, i64 0
  br label %print

sw.default: ; unknown error (includes case 0 and others)
  %msg.default = getelementptr inbounds [14 x i8], [14 x i8]* @.str.unknown, i64 0, i64 0
  br label %print

print:
  %msg = phi i8* [ %msg.case1, %sw.case1 ], [ %msg.case2, %sw.case2 ], [ %msg.case3, %sw.case3 ], [ %msg.case4, %sw.case4 ], [ %msg.case5, %sw.case5 ], [ %msg.case6, %sw.case6 ], [ %msg.default, %sw.default ]
  %name.ptr = getelementptr inbounds %struct.__exception, %struct.__exception* %exc, i32 0, i32 1
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.__exception, %struct.__exception* %exc, i32 0, i32 2
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.__exception, %struct.__exception* %exc, i32 0, i32 3
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct.__exception, %struct.__exception* %exc, i32 0, i32 4
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str.fmt, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}