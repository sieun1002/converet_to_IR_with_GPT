; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = external unnamed_addr constant i8
@aArgumentDomain = external unnamed_addr constant i8
@aPartialLossOfS = external unnamed_addr constant i8
@aOverflowRangeE = external unnamed_addr constant i8
@aTheResultIsToo = external unnamed_addr constant i8
@aTotalLossOfSig = external unnamed_addr constant i8
@aUnknownError = external unnamed_addr constant i8
@aMatherrSInSGGR = external unnamed_addr constant i8

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

define dso_local i32 @sub_140001600(i8* %0) local_unnamed_addr {
entry:
  %1 = bitcast i8* %0 to i32*
  %2 = load i32, i32* %1, align 4
  switch i32 %2, label %sw.default [
    i32 0, label %case0
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case0:                                            ; case 0
  br label %join

case1:                                            ; case 1
  br label %join

case2:                                            ; case 2
  br label %join

case3:                                            ; case 3
  br label %join

case4:                                            ; case 4
  br label %join

case5:                                            ; case 5
  br label %join

case6:                                            ; case 6
  br label %join

sw.default:                                       ; default
  br label %join

join:
  %msg = phi i8* [ @aUnknownError, %case0 ], [ @aArgumentDomain, %case1 ], [ @aArgumentSingul, %case2 ], [ @aOverflowRangeE, %case3 ], [ @aTheResultIsToo, %case4 ], [ @aTotalLossOfSig, %case5 ], [ @aPartialLossOfS, %case6 ], [ @aUnknownError, %sw.default ]
  %3 = getelementptr inbounds i8, i8* %0, i64 8
  %4 = bitcast i8* %3 to i8**
  %5 = load i8*, i8** %4, align 8
  %6 = getelementptr inbounds i8, i8* %0, i64 16
  %7 = bitcast i8* %6 to double*
  %8 = load double, double* %7, align 8
  %9 = getelementptr inbounds i8, i8* %0, i64 24
  %10 = bitcast i8* %9 to double*
  %11 = load double, double* %10, align 8
  %12 = getelementptr inbounds i8, i8* %0, i64 32
  %13 = bitcast i8* %12 to double*
  %14 = load double, double* %13, align 8
  %15 = call i8* @__acrt_iob_func(i32 2)
  %16 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %15, i8* @aMatherrSInSGGR, i8* %msg, i8* %5, double %8, double %11, double %14)
  ret i32 0
}