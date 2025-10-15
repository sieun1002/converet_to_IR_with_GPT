; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.exception = type { i32, i8*, double, double, double }

declare i8* @sub_140002AD0(i32 noundef)
declare void @sub_1400029C0(i8* noundef, i8* noundef, i8* noundef, i8* noundef, double, double, double)

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError = external global i8
@aMatherrSInSGGR = external global i8

define i32 @sub_1400019D0(%struct.exception* noundef %ex) {
entry:
  %typeptr = getelementptr inbounds %struct.exception, %struct.exception* %ex, i32 0, i32 0
  %type = load i32, i32* %typeptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:
  br label %cont

sw.case2:
  br label %cont

sw.case3:
  br label %cont

sw.case4:
  br label %cont

sw.case5:
  br label %cont

sw.case6:
  br label %cont

sw.default:
  br label %cont

cont:
  %msg = phi i8* [ @aArgumentDomain, %sw.case1 ],
                 [ @aArgumentSingul, %sw.case2 ],
                 [ @aOverflowRangeE, %sw.case3 ],
                 [ @aTheResultIsToo, %sw.case4 ],
                 [ @aTotalLossOfSig, %sw.case5 ],
                 [ @aPartialLossOfS, %sw.case6 ],
                 [ @aUnknownError, %sw.default ]
  %nameptr = getelementptr inbounds %struct.exception, %struct.exception* %ex, i32 0, i32 1
  %name = load i8*, i8** %nameptr, align 8
  %arg1ptr = getelementptr inbounds %struct.exception, %struct.exception* %ex, i32 0, i32 2
  %arg1 = load double, double* %arg1ptr, align 8
  %arg2ptr = getelementptr inbounds %struct.exception, %struct.exception* %ex, i32 0, i32 3
  %arg2 = load double, double* %arg2ptr, align 8
  %retvalptr = getelementptr inbounds %struct.exception, %struct.exception* %ex, i32 0, i32 4
  %retval = load double, double* %retvalptr, align 8
  %stream = call i8* @sub_140002AD0(i32 noundef 2)
  call void @sub_1400029C0(i8* noundef %stream, i8* noundef @aMatherrSInSGGR, i8* noundef %msg, i8* noundef %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}