; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.EX = type { i32, i8*, double, double, double }

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul  = external dso_local constant i8
@aArgumentDomain  = external dso_local constant i8
@aPartialLossOfS  = external dso_local constant i8
@aOverflowRangeE  = external dso_local constant i8
@aTheResultIsToo  = external dso_local constant i8
@aTotalLossOfSig  = external dso_local constant i8
@aUnknownError    = external dso_local constant i8
@aMatherrSInSGGR  = external dso_local constant i8

define dso_local i32 @sub_1400019D0(%struct.EX* nocapture readonly %0) {
entry:
  %type.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case1:                                            ; case 1: aArgumentDomain
  br label %cont

case2:                                            ; case 2: aArgumentSingul
  br label %cont

case3:                                            ; case 3: aOverflowRangeE
  br label %cont

case4:                                            ; case 4: aTheResultIsToo
  br label %cont

case5:                                            ; case 5: aTotalLossOfSig
  br label %cont

case6:                                            ; case 6: aPartialLossOfS
  br label %cont

sw.default:                                       ; default and case 0: aUnknownError
  br label %cont

cont:
  %msg = phi i8* [ @aUnknownError, %sw.default ],
               [ @aArgumentDomain, %case1 ],
               [ @aArgumentSingul, %case2 ],
               [ @aOverflowRangeE, %case3 ],
               [ @aTheResultIsToo, %case4 ],
               [ @aTotalLossOfSig, %case5 ],
               [ @aPartialLossOfS, %case6 ]
  %name.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 1
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 2
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 3
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 4
  %retval = load double, double* %retval.ptr, align 8
  %file = call i8* @__acrt_iob_func(i32 2)
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %file, i8* @aMatherrSInSGGR, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}