; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

%struct.argrec = type { i32, i32, i8*, double, double, double }

declare dso_local i8* @loc_140002710(i32)
declare dso_local i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul = external dso_local constant i8
@aArgumentDomain = external dso_local constant i8
@aPartialLossOfS = external dso_local constant i8
@aOverflowRangeE = external dso_local constant i8
@aTheResultIsToo = external dso_local constant i8
@aTotalLossOfSig = external dso_local constant i8
@aUnknownError = external dso_local constant i8
@aMatherrSInSGGR = external dso_local constant i8

define dso_local i32 @sub_140001600(%struct.argrec* %p) {
entry:
  %code.ptr = getelementptr inbounds %struct.argrec, %struct.argrec* %p, i32 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  switch i32 %code, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                           ; case 1
  br label %sw.cont

sw.case2:                                           ; case 2
  br label %sw.cont

sw.case3:                                           ; case 3
  br label %sw.cont

sw.case4:                                           ; case 4
  br label %sw.cont

sw.case5:                                           ; case 5
  br label %sw.cont

sw.case6:                                           ; case 6
  br label %sw.cont

sw.default:                                         ; default (includes case 0)
  br label %sw.cont

sw.cont:
  %desc = phi i8* [ bitcast (i8* @aArgumentDomain to i8*), %sw.case1 ],
                [ bitcast (i8* @aArgumentSingul to i8*), %sw.case2 ],
                [ bitcast (i8* @aOverflowRangeE to i8*), %sw.case3 ],
                [ bitcast (i8* @aTheResultIsToo to i8*), %sw.case4 ],
                [ bitcast (i8* @aTotalLossOfSig to i8*), %sw.case5 ],
                [ bitcast (i8* @aPartialLossOfS to i8*), %sw.case6 ],
                [ bitcast (i8* @aUnknownError to i8*), %sw.default ]
  %name.ptrptr = getelementptr inbounds %struct.argrec, %struct.argrec* %p, i32 0, i32 2
  %name = load i8*, i8** %name.ptrptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.argrec, %struct.argrec* %p, i32 0, i32 3
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.argrec, %struct.argrec* %p, i32 0, i32 4
  %arg2 = load double, double* %arg2.ptr, align 8
  %arg3.ptr = getelementptr inbounds %struct.argrec, %struct.argrec* %p, i32 0, i32 5
  %arg3 = load double, double* %arg3.ptr, align 8
  %tmpstr = call i8* @loc_140002710(i32 2)
  %fmt = bitcast i8* @aMatherrSInSGGR to i8*
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %tmpstr, i8* %fmt, i8* %desc, i8* %name, double %arg1, double %arg2, double %arg3)
  ret i32 0
}