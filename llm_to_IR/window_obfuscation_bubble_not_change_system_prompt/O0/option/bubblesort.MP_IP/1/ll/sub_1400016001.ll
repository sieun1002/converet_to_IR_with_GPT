; ModuleID = 'sub_140001600.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i32, i8*, double, double, double }

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul = external dso_local global i8
@aArgumentDomain = external dso_local global i8
@aPartialLossOfS = external dso_local global i8
@aOverflowRangeE = external dso_local global i8
@aTheResultIsToo = external dso_local global i8
@aTotalLossOfSig = external dso_local global i8
@aUnknownError = external dso_local global i8
@aMatherrSInSGGR = external dso_local global i8

define dso_local i32 @sub_140001600(%struct._exception* %0) local_unnamed_addr {
entry:
  %1 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 0
  %2 = load i32, i32* %1, align 4
  %3 = icmp ugt i32 %2, 6
  br i1 %3, label %default, label %switch

switch:
  switch i32 %2, label %default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case1:
  br label %select

case2:
  br label %select

case3:
  br label %select

case4:
  br label %select

case5:
  br label %select

case6:
  br label %select

default:
  br label %select

select:
  %err = phi i8* [ @aArgumentDomain, %case1 ], [ @aArgumentSingul, %case2 ], [ @aOverflowRangeE, %case3 ], [ @aTheResultIsToo, %case4 ], [ @aTotalLossOfSig, %case5 ], [ @aPartialLossOfS, %case6 ], [ @aUnknownError, %default ]
  %4 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 2
  %5 = load i8*, i8** %4, align 8
  %6 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 3
  %7 = load double, double* %6, align 8
  %8 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 4
  %9 = load double, double* %8, align 8
  %10 = getelementptr inbounds %struct._exception, %struct._exception* %0, i32 0, i32 5
  %11 = load double, double* %10, align 8
  %12 = call i8* @sub_140002710(i32 2)
  %13 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %12, i8* @aMatherrSInSGGR, i8* %err, i8* %5, double %7, double %9, double %11)
  ret i32 0
}