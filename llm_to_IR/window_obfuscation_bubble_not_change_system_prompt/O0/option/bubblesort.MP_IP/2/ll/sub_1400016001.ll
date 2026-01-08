; ModuleID = 'sub_140001600.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i32, i8*, double, double, double }

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError = external global i8
@aMatherrSInSGGR = external global i8

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

define i32 @sub_140001600(%struct._exception* %0) {
entry:
  %1 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 0
  %2 = load i32, i32* %1, align 4
  switch i32 %2, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case2:
  br label %sw.epilog

sw.case1:
  br label %sw.epilog

sw.case6:
  br label %sw.epilog

sw.case3:
  br label %sw.epilog

sw.case4:
  br label %sw.epilog

sw.case5:
  br label %sw.epilog

sw.default:
  br label %sw.epilog

sw.epilog:
  %3 = phi i8* [ @aArgumentSingul, %sw.case2 ], [ @aArgumentDomain, %sw.case1 ], [ @aPartialLossOfS, %sw.case6 ], [ @aOverflowRangeE, %sw.case3 ], [ @aTheResultIsToo, %sw.case4 ], [ @aTotalLossOfSig, %sw.case5 ], [ @aUnknownError, %sw.default ]
  %4 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 5
  %5 = load double, double* %4, align 8
  %6 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 4
  %7 = load double, double* %6, align 8
  %8 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 3
  %9 = load double, double* %8, align 8
  %10 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 2
  %11 = load i8*, i8** %10, align 8
  %12 = call i8* @sub_140002710(i32 2)
  %13 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %12, i8* @aMatherrSInSGGR, i8* %3, i8* %11, double %9, double %7, double %5)
  ret i32 0
}