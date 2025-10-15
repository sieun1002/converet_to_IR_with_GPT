; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.exception = type { i32, i32, i8*, double, double, double }

@aArgumentSingul = internal unnamed_addr constant [21 x i8] c"argument singularity\00"
@aArgumentDomain = internal unnamed_addr constant [22 x i8] c"argument domain error\00"
@aPartialLossOfS = internal unnamed_addr constant [29 x i8] c"partial loss of significance\00"
@aOverflowRangeE = internal unnamed_addr constant [23 x i8] c"overflow (range error)\00"
@aTheResultIsToo = internal unnamed_addr constant [42 x i8] c"the result is too small to be represented\00"
@aTotalLossOfSig = internal unnamed_addr constant [27 x i8] c"total loss of significance\00"
@aUnknownError = internal unnamed_addr constant [14 x i8] c"unknown error\00"
@aMatherrSInSGGR = internal unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_140002960(i8*, i8*, ...)

define dso_local i32 @sub_140001970(%struct.exception* %0) {
entry:
  %typeptr = getelementptr inbounds %struct.exception, %struct.exception* %0, i32 0, i32 0
  %type = load i32, i32* %typeptr, align 4
  switch i32 %type, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case1:                                            ; case 1: argument domain error
  %str1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %common

case2:                                            ; case 2: argument singularity
  %str2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %common

case3:                                            ; case 3: overflow (range error)
  %str3 = getelementptr inbounds [23 x i8], [23 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %common

case4:                                            ; case 4: the result is too small to be represented
  %str4 = getelementptr inbounds [42 x i8], [42 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %common

case5:                                            ; case 5: total loss of significance
  %str5 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %common

case6:                                            ; case 6: partial loss of significance
  %str6 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %common

sw.default:                                       ; default and case 0: unknown error
  %strd = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %common

common:
  %errstr = phi i8* [ %str1, %case1 ], [ %str2, %case2 ], [ %str3, %case3 ], [ %str4, %case4 ], [ %str5, %case5 ], [ %str6, %case6 ], [ %strd, %sw.default ]
  %nameptr = getelementptr inbounds %struct.exception, %struct.exception* %0, i32 0, i32 2
  %name = load i8*, i8** %nameptr, align 8
  %arg1ptr = getelementptr inbounds %struct.exception, %struct.exception* %0, i32 0, i32 3
  %arg1 = load double, double* %arg1ptr, align 8
  %arg2ptr = getelementptr inbounds %struct.exception, %struct.exception* %0, i32 0, i32 4
  %arg2 = load double, double* %arg2ptr, align 8
  %retvalptr = getelementptr inbounds %struct.exception, %struct.exception* %0, i32 0, i32 5
  %retval = load double, double* %retvalptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_140002960(i8* %stream, i8* %fmt, i8* %errstr, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}