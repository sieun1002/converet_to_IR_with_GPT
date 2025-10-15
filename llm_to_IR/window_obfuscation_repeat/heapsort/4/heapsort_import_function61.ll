; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.matherr_info = type { i32, i8*, double, double, double }

@.str.format = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1
@.str.arg_sing = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str.arg_domain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str.overflow = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str.too_small = private unnamed_addr constant [24 x i8] c"the result is too small\00", align 1
@.str.tloss = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str.ploss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str.unknown = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1

declare dso_local i8* @sub_140002AD0(i32 noundef)
declare dso_local i32 @sub_1400029C0(i8* noundef, i8* noundef, ...)

define dso_local i32 @sub_1400019D0(%struct.matherr_info* nocapture readonly noundef %p) local_unnamed_addr {
entry:
  %code.ptr = getelementptr inbounds %struct.matherr_info, %struct.matherr_info* %p, i64 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  switch i32 %code, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:
  %msg.case1 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.arg_domain, i64 0, i64 0
  br label %cont

sw.case2:
  %msg.case2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.arg_sing, i64 0, i64 0
  br label %cont

sw.case3:
  %msg.case3 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.overflow, i64 0, i64 0
  br label %cont

sw.case4:
  %msg.case4 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.too_small, i64 0, i64 0
  br label %cont

sw.case5:
  %msg.case5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.tloss, i64 0, i64 0
  br label %cont

sw.case6:
  %msg.case6 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.ploss, i64 0, i64 0
  br label %cont

sw.default:
  %msg.default = getelementptr inbounds [14 x i8], [14 x i8]* @.str.unknown, i64 0, i64 0
  br label %cont

cont:
  %msg = phi i8* [ %msg.case2, %sw.case2 ], [ %msg.case1, %sw.case1 ], [ %msg.case3, %sw.case3 ], [ %msg.case4, %sw.case4 ], [ %msg.case5, %sw.case5 ], [ %msg.case6, %sw.case6 ], [ %msg.default, %sw.default ]
  %fname.ptr = getelementptr inbounds %struct.matherr_info, %struct.matherr_info* %p, i64 0, i32 1
  %fname = load i8*, i8** %fname.ptr, align 8
  %x.ptr = getelementptr inbounds %struct.matherr_info, %struct.matherr_info* %p, i64 0, i32 2
  %x = load double, double* %x.ptr, align 8
  %y.ptr = getelementptr inbounds %struct.matherr_info, %struct.matherr_info* %p, i64 0, i32 3
  %y = load double, double* %y.ptr, align 8
  %ret.ptr = getelementptr inbounds %struct.matherr_info, %struct.matherr_info* %p, i64 0, i32 4
  %ret = load double, double* %ret.ptr, align 8
  %stream = call i8* @sub_140002AD0(i32 noundef 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str.format, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* noundef %stream, i8* noundef %fmt, i8* noundef %msg, i8* noundef %fname, double %x, double %y, double %ret)
  ret i32 0
}