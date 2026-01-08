; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

%struct.EXC = type { i32, i32, i8*, double, double, double }

declare dso_local i8* @sub_140002710(i32 noundef)
declare dso_local i32 @sub_140002600(i8* noundef, i8* noundef, i8* noundef, i8* noundef, ...)

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError = external global i8
@aMatherrSInSGGR = external global i8

define dso_local i32 @sub_140001600(%struct.EXC* noundef %0) {
entry:
  %1 = getelementptr inbounds %struct.EXC, %struct.EXC* %0, i32 0, i32 0
  %2 = load i32, i32* %1, align 4
  switch i32 %2, label %sw.default [
    i32 0, label %sw.case0
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case0:                                         ; case 0
  br label %select

sw.case1:                                         ; case 1
  br label %select

sw.case2:                                         ; case 2
  br label %select

sw.case3:                                         ; case 3
  br label %select

sw.case4:                                         ; case 4
  br label %select

sw.case5:                                         ; case 5
  br label %select

sw.case6:                                         ; case 6
  br label %select

sw.default:
  br label %select

select:
  %3 = phi i8* [ @aUnknownError, %sw.case0 ], [ @aArgumentDomain, %sw.case1 ], [ @aArgumentSingul, %sw.case2 ], [ @aOverflowRangeE, %sw.case3 ], [ @aTheResultIsToo, %sw.case4 ], [ @aTotalLossOfSig, %sw.case5 ], [ @aPartialLossOfS, %sw.case6 ], [ @aUnknownError, %sw.default ]
  %4 = getelementptr inbounds %struct.EXC, %struct.EXC* %0, i32 0, i32 2
  %5 = load i8*, i8** %4, align 8
  %6 = getelementptr inbounds %struct.EXC, %struct.EXC* %0, i32 0, i32 3
  %7 = load double, double* %6, align 8
  %8 = getelementptr inbounds %struct.EXC, %struct.EXC* %0, i32 0, i32 4
  %9 = load double, double* %8, align 8
  %10 = getelementptr inbounds %struct.EXC, %struct.EXC* %0, i32 0, i32 5
  %11 = load double, double* %10, align 8
  %12 = call i8* @sub_140002710(i32 noundef 2)
  %13 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* noundef %12, i8* noundef @aMatherrSInSGGR, i8* noundef %3, i8* noundef %5, double %7, double %9, double %11)
  ret i32 0
}