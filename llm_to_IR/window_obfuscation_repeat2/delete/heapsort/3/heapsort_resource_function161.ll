; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul = external dso_local global i8
@aArgumentDomain = external dso_local global i8
@aPartialLossOfS = external dso_local global i8
@aOverflowRangeE = external dso_local global i8
@aTheResultIsToo = external dso_local global i8
@aTotalLossOfSig = external dso_local global i8
@aUnknownError = external dso_local global i8
@aMatherrSInSGGR = external dso_local global i8

define dso_local i32 @sub_1400019D0(i8* %0) {
entry:
  %type.ptr = bitcast i8* %0 to i32*
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
    i32 0, label %sw.default
  ]

sw.case1: ; case 1 -> aArgumentDomain
  br label %cont

sw.case2: ; case 2 -> aArgumentSingul
  br label %cont

sw.case3: ; case 3 -> aOverflowRangeE
  br label %cont

sw.case4: ; case 4 -> aTheResultIsToo
  br label %cont

sw.case5: ; case 5 -> aTotalLossOfSig
  br label %cont

sw.case6: ; case 6 -> aPartialLossOfS
  br label %cont

sw.default: ; default and case 0 -> aUnknownError
  br label %cont

cont:
  %msg = phi i8* [ @aArgumentDomain, %sw.case1 ], [ @aArgumentSingul, %sw.case2 ], [ @aOverflowRangeE, %sw.case3 ], [ @aTheResultIsToo, %sw.case4 ], [ @aTotalLossOfSig, %sw.case5 ], [ @aPartialLossOfS, %sw.case6 ], [ @aUnknownError, %sw.default ]
  %name.ptr.i8 = getelementptr i8, i8* %0, i64 8
  %name.ptr = bitcast i8* %name.ptr.i8 to i8**
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr.i8 = getelementptr i8, i8* %0, i64 16
  %arg1.ptr = bitcast i8* %arg1.ptr.i8 to double*
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr.i8 = getelementptr i8, i8* %0, i64 24
  %arg2.ptr = bitcast i8* %arg2.ptr.i8 to double*
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr.i8 = getelementptr i8, i8* %0, i64 32
  %retval.ptr = bitcast i8* %retval.ptr.i8 to double*
  %retval = load double, double* %retval.ptr, align 8
  %file = call i8* @__acrt_iob_func(i32 2)
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %file, i8* @aMatherrSInSGGR, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}