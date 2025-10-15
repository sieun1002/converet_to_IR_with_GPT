; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i8*, double, double, double }

@aArgumentSingul = internal unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@aArgumentDomain = internal unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@aPartialLossOfS = internal unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@aOverflowRangeE = internal unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@aTheResultIsToo = internal unnamed_addr constant [24 x i8] c"the result is too small\00", align 1
@aTotalLossOfSig = internal unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@aUnknownError = internal unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@aMatherrSInSGGR = internal unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @sub_140002AD0(i32 noundef)
declare i32 @sub_1400029C0(i8* noundef, i8* noundef, ...)

define i32 @sub_1400019D0(%struct._exception* noundef %ex) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct._exception, %struct._exception* %ex, i32 0, i32 0
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
  %msg.case1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %sw.merge

sw.case2:                                          ; case 2
  %msg.case2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %sw.merge

sw.case3:                                          ; case 3
  %msg.case3 = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %sw.merge

sw.case4:                                          ; case 4
  %msg.case4 = getelementptr inbounds [24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %sw.merge

sw.case5:                                          ; case 5
  %msg.case5 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %sw.merge

sw.case6:                                          ; case 6
  %msg.case6 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %sw.merge

sw.default:                                        ; default and case 0
  %msg.default = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %sw.merge

sw.merge:
  %msg = phi i8* [ %msg.case2, %sw.case2 ], [ %msg.case1, %sw.case1 ], [ %msg.case6, %sw.case6 ], [ %msg.case3, %sw.case3 ], [ %msg.case4, %sw.case4 ], [ %msg.case5, %sw.case5 ], [ %msg.default, %sw.default ]
  %name.ptr = getelementptr inbounds %struct._exception, %struct._exception* %ex, i32 0, i32 1
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct._exception, %struct._exception* %ex, i32 0, i32 2
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct._exception, %struct._exception* %ex, i32 0, i32 3
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct._exception, %struct._exception* %ex, i32 0, i32 4
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @sub_140002AD0(i32 noundef 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* noundef %stream, i8* noundef %fmt, i8* noundef %msg, i8* noundef %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}