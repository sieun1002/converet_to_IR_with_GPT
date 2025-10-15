; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.matherr = type { i32, i32, i8*, double, double, double }

@.str_unknown = private unnamed_addr constant [19 x i8] c"unknown error type\00"
@.str_argdomain = private unnamed_addr constant [22 x i8] c"argument domain error\00"
@.str_argsing = private unnamed_addr constant [21 x i8] c"argument singularity\00"
@.str_overflow = private unnamed_addr constant [21 x i8] c"overflow range error\00"
@.str_too_small = private unnamed_addr constant [24 x i8] c"the result is too small\00"
@.str_total_loss = private unnamed_addr constant [27 x i8] c"total loss of significance\00"
@.str_partial_loss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00"
@.str_fmt = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, ...)

define dso_local i32 @sub_1400019D0(%struct.matherr* nocapture readonly %arg) local_unnamed_addr {
entry:
  %codeptr = getelementptr inbounds %struct.matherr, %struct.matherr* %arg, i32 0, i32 0
  %code = load i32, i32* %codeptr
  br label %switch.start

switch.start:
  switch i32 %code, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.default:
  %unknown_gep = getelementptr inbounds [19 x i8], [19 x i8]* @.str_unknown, i32 0, i32 0
  br label %sw.epilog

sw.case1:
  %dom_gep = getelementptr inbounds [22 x i8], [22 x i8]* @.str_argdomain, i32 0, i32 0
  br label %sw.epilog

sw.case2:
  %sing_gep = getelementptr inbounds [21 x i8], [21 x i8]* @.str_argsing, i32 0, i32 0
  br label %sw.epilog

sw.case3:
  %over_gep = getelementptr inbounds [21 x i8], [21 x i8]* @.str_overflow, i32 0, i32 0
  br label %sw.epilog

sw.case4:
  %small_gep = getelementptr inbounds [24 x i8], [24 x i8]* @.str_too_small, i32 0, i32 0
  br label %sw.epilog

sw.case5:
  %total_gep = getelementptr inbounds [27 x i8], [27 x i8]* @.str_total_loss, i32 0, i32 0
  br label %sw.epilog

sw.case6:
  %partial_gep = getelementptr inbounds [29 x i8], [29 x i8]* @.str_partial_loss, i32 0, i32 0
  br label %sw.epilog

sw.epilog:
  %msg = phi i8* [ %unknown_gep, %sw.default ], [ %dom_gep, %sw.case1 ], [ %sing_gep, %sw.case2 ], [ %over_gep, %sw.case3 ], [ %small_gep, %sw.case4 ], [ %total_gep, %sw.case5 ], [ %partial_gep, %sw.case6 ]
  %nameptrptr = getelementptr inbounds %struct.matherr, %struct.matherr* %arg, i32 0, i32 2
  %name = load i8*, i8** %nameptrptr
  %arg1ptr = getelementptr inbounds %struct.matherr, %struct.matherr* %arg, i32 0, i32 3
  %arg1 = load double, double* %arg1ptr
  %arg2ptr = getelementptr inbounds %struct.matherr, %struct.matherr* %arg, i32 0, i32 4
  %arg2 = load double, double* %arg2ptr
  %retptr = getelementptr inbounds %struct.matherr, %struct.matherr* %arg, i32 0, i32 5
  %retval = load double, double* %retptr
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str_fmt, i32 0, i32 0
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}