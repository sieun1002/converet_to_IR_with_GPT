; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i32, i8*, double, double, double }

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"Argument singularity\00", align 1
@aArgumentDomain = private unnamed_addr constant [22 x i8] c"Argument domain error\00", align 1
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"Partial loss of significance\00", align 1
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"Overflow range error\00", align 1
@aTheResultIsToo = private unnamed_addr constant [24 x i8] c"The result is too small\00", align 1
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"Total loss of significance\00", align 1
@aUnknownError = private unnamed_addr constant [14 x i8] c"Unknown error\00", align 1
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i8*, i8*, double, double, double)

define i32 @sub_1400019D0(%struct._exception* %0) {
entry:
  %type.addr = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 0
  %type = load i32, i32* %type.addr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb1:                                            ; preds = %entry
  %msg1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %sw.epil

sw.bb2:                                            ; preds = %entry
  %msg2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %sw.epil

sw.bb3:                                            ; preds = %entry
  %msg3 = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %sw.epil

sw.bb4:                                            ; preds = %entry
  %msg4 = getelementptr inbounds [24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %sw.epil

sw.bb5:                                            ; preds = %entry
  %msg5 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %sw.epil

sw.bb6:                                            ; preds = %entry
  %msg6 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %sw.epil

sw.default:                                        ; preds = %entry
  %msgd = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %sw.epil

sw.epil:                                           ; preds = %sw.default, %sw.bb6, %sw.bb5, %sw.bb4, %sw.bb3, %sw.bb2, %sw.bb1
  %msg = phi i8* [ %msg1, %sw.bb1 ], [ %msg2, %sw.bb2 ], [ %msg3, %sw.bb3 ], [ %msg4, %sw.bb4 ], [ %msg5, %sw.bb5 ], [ %msg6, %sw.bb6 ], [ %msgd, %sw.default ]
  %nameptr = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 2
  %name = load i8*, i8** %nameptr, align 8
  %arg1ptr = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 3
  %arg1 = load double, double* %arg1ptr, align 8
  %arg2ptr = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 4
  %arg2 = load double, double* %arg2ptr, align 8
  %retvalptr = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 5
  %retval = load double, double* %retvalptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 @sub_1400029C0(i8* %stream, i8* %fmt, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}