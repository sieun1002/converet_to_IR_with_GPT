target triple = "x86_64-pc-windows-msvc"

%struct.anon = type { i32, i32, i8*, double, double, double }

@aArgumentSingul = external global i8
@aMatherrSInSGGR = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError = external global i8

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

define i32 @sub_1400019D0(%struct.anon* %p) {
entry:
  %codeptr = getelementptr inbounds %struct.anon, %struct.anon* %p, i32 0, i32 0
  %code = load i32, i32* %codeptr, align 4
  switch i32 %code, label %sw.default [
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb1:
  br label %sw.epilog

sw.bb2:
  br label %sw.epilog

sw.bb3:
  br label %sw.epilog

sw.bb4:
  br label %sw.epilog

sw.bb5:
  br label %sw.epilog

sw.bb6:
  br label %sw.epilog

sw.default:
  br label %sw.epilog

sw.epilog:
  %msg = phi i8* [ @aUnknownError, %sw.default ], [ @aArgumentDomain, %sw.bb1 ], [ @aArgumentSingul, %sw.bb2 ], [ @aOverflowRangeE, %sw.bb3 ], [ @aTheResultIsToo, %sw.bb4 ], [ @aTotalLossOfSig, %sw.bb5 ], [ @aPartialLossOfS, %sw.bb6 ]
  %fnameptr = getelementptr inbounds %struct.anon, %struct.anon* %p, i32 0, i32 2
  %fname = load i8*, i8** %fnameptr, align 8
  %d1ptr = getelementptr inbounds %struct.anon, %struct.anon* %p, i32 0, i32 3
  %d1 = load double, double* %d1ptr, align 8
  %d2ptr = getelementptr inbounds %struct.anon, %struct.anon* %p, i32 0, i32 4
  %d2 = load double, double* %d2ptr, align 8
  %d3ptr = getelementptr inbounds %struct.anon, %struct.anon* %p, i32 0, i32 5
  %d3 = load double, double* %d3ptr, align 8
  %file = call i8* @__acrt_iob_func(i32 2)
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %file, i8* @aMatherrSInSGGR, i8* %msg, i8* %fname, double %d1, double %d2, double %d3)
  ret i32 0
}