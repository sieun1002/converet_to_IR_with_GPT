; ModuleID = 'recovered'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.errinfo = type { i32, i32, i8*, double, double, double }

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError    = external global i8
@aMatherrSInSGGR  = external global i8

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

define i32 @sub_140001600(%struct.errinfo* %rcx) {
entry:
  %code.ptr = getelementptr inbounds %struct.errinfo, %struct.errinfo* %rcx, i32 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  switch i32 %code, label %sw.default [
    i32 0, label %sw.case0
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case2:                                           ; case 2: aArgumentSingul
  br label %cont

sw.case1:                                           ; case 1: aArgumentDomain
  br label %cont

sw.case6:                                           ; case 6: aPartialLossOfS
  br label %cont

sw.case3:                                           ; case 3: aOverflowRangeE
  br label %cont

sw.case4:                                           ; case 4: aTheResultIsToo
  br label %cont

sw.case5:                                           ; case 5: aTotalLossOfSig
  br label %cont

sw.case0:                                           ; case 0: aUnknownError
  br label %cont

sw.default:                                         ; default: aUnknownError
  br label %cont

cont:
  %msg = phi i8* [ @aArgumentSingul, %sw.case2 ],
               [ @aArgumentDomain, %sw.case1 ],
               [ @aPartialLossOfS, %sw.case6 ],
               [ @aOverflowRangeE, %sw.case3 ],
               [ @aTheResultIsToo, %sw.case4 ],
               [ @aTotalLossOfSig, %sw.case5 ],
               [ @aUnknownError, %sw.case0 ],
               [ @aUnknownError, %sw.default ]
  %fn.ptr.ptr = getelementptr inbounds %struct.errinfo, %struct.errinfo* %rcx, i32 0, i32 2
  %fn = load i8*, i8** %fn.ptr.ptr, align 8
  %d1.ptr = getelementptr inbounds %struct.errinfo, %struct.errinfo* %rcx, i32 0, i32 3
  %d1 = load double, double* %d1.ptr, align 8
  %d2.ptr = getelementptr inbounds %struct.errinfo, %struct.errinfo* %rcx, i32 0, i32 4
  %d2 = load double, double* %d2.ptr, align 8
  %d3.ptr = getelementptr inbounds %struct.errinfo, %struct.errinfo* %rcx, i32 0, i32 5
  %d3 = load double, double* %d3.ptr, align 8
  %file = call i8* @sub_140002710(i32 2)
  %fmt = bitcast i8* @aMatherrSInSGGR to i8*
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %file, i8* %fmt, i8* %msg, i8* %fn, double %d1, double %d2, double %d3)
  ret i32 0
}