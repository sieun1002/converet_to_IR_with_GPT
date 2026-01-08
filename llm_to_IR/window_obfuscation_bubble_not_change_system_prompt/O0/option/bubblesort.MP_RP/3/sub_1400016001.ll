; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

%struct.MATHERR = type { i32, i8*, double, double, double }

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*, i8*, i8*, double, double, double)

@aArgumentSingul   = external constant i8
@aMatherrSInSGGR   = external constant i8
@aArgumentDomain   = external constant i8
@aPartialLossOfS   = external constant i8
@aOverflowRangeE   = external constant i8
@aTheResultIsToo   = external constant i8
@aTotalLossOfSig   = external constant i8
@aUnknownError     = external constant i8

define i32 @sub_140001600(%struct.MATHERR* %0) {
entry:
  %1 = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %0, i64 0, i32 0
  %2 = load i32, i32* %1, align 4
  switch i32 %2, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1: ; case 1 -> aArgumentDomain
  %3 = getelementptr i8, i8* @aArgumentDomain, i64 0
  br label %cont

sw.case2: ; case 2 -> aArgumentSingul
  %4 = getelementptr i8, i8* @aArgumentSingul, i64 0
  br label %cont

sw.case3: ; case 3 -> aOverflowRangeE
  %5 = getelementptr i8, i8* @aOverflowRangeE, i64 0
  br label %cont

sw.case4: ; case 4 -> aTheResultIsToo
  %6 = getelementptr i8, i8* @aTheResultIsToo, i64 0
  br label %cont

sw.case5: ; case 5 -> aTotalLossOfSig
  %7 = getelementptr i8, i8* @aTotalLossOfSig, i64 0
  br label %cont

sw.case6: ; case 6 -> aPartialLossOfS
  %8 = getelementptr i8, i8* @aPartialLossOfS, i64 0
  br label %cont

sw.default: ; default and case 0 -> aUnknownError
  %9 = getelementptr i8, i8* @aUnknownError, i64 0
  br label %cont

cont:
  %10 = phi i8* [ %3, %sw.case1 ], [ %4, %sw.case2 ], [ %5, %sw.case3 ], [ %6, %sw.case4 ], [ %7, %sw.case5 ], [ %8, %sw.case6 ], [ %9, %sw.default ]
  %11 = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %0, i64 0, i32 1
  %12 = load i8*, i8** %11, align 8
  %13 = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %0, i64 0, i32 2
  %14 = load double, double* %13, align 8
  %15 = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %0, i64 0, i32 3
  %16 = load double, double* %15, align 8
  %17 = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %0, i64 0, i32 4
  %18 = load double, double* %17, align 8
  %19 = call i8* @sub_140002710(i32 2)
  %20 = getelementptr i8, i8* @aMatherrSInSGGR, i64 0
  call void @sub_140002600(i8* %19, i8* %20, i8* %10, i8* %12, double %14, double %16, double %18)
  ret i32 0
}