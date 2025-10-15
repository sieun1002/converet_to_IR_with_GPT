; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.MERR = type { i32, i32, i8*, double, double, double }

@aArgumentSingul = external dso_local unnamed_addr constant [0 x i8]
@aMatherrSInSGGR = external dso_local unnamed_addr constant [0 x i8]
@aArgumentDomain = external dso_local unnamed_addr constant [0 x i8]
@aPartialLossOfS = external dso_local unnamed_addr constant [0 x i8]
@aOverflowRangeE = external dso_local unnamed_addr constant [0 x i8]
@aTheResultIsToo = external dso_local unnamed_addr constant [0 x i8]
@aTotalLossOfSig = external dso_local unnamed_addr constant [0 x i8]
@aUnknownError = external dso_local unnamed_addr constant [0 x i8]

declare dso_local i8* @sub_140002BB0(i32)
declare dso_local i32 @sub_140002AA0(i8*, i8*, i8*, i8*, double, double, double)

define dso_local void @sub_140001AA0(%struct.MERR* nocapture readonly %p) {
entry:
  %type.ptr = getelementptr inbounds %struct.MERR, %struct.MERR* %p, i64 0, i32 0
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

case2:                                            ; case 2
  %msgptr.c2 = getelementptr inbounds [0 x i8], [0 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %cont

case1:                                            ; case 1
  %msgptr.c1 = getelementptr inbounds [0 x i8], [0 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %cont

case6:                                            ; case 6
  %msgptr.c6 = getelementptr inbounds [0 x i8], [0 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %cont

case3:                                            ; case 3
  %msgptr.c3 = getelementptr inbounds [0 x i8], [0 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %cont

case4:                                            ; case 4
  %msgptr.c4 = getelementptr inbounds [0 x i8], [0 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %cont

case5:                                            ; case 5
  %msgptr.c5 = getelementptr inbounds [0 x i8], [0 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %cont

sw.default:                                       ; default and case 0
  %msgptr.def = getelementptr inbounds [0 x i8], [0 x i8]* @aUnknownError, i64 0, i64 0
  br label %cont

cont:
  %msgptr = phi i8* [ %msgptr.c2, %case2 ], [ %msgptr.c1, %case1 ], [ %msgptr.c6, %case6 ], [ %msgptr.c3, %case3 ], [ %msgptr.c4, %case4 ], [ %msgptr.c5, %case5 ], [ %msgptr.def, %sw.default ]
  %name.ptr.ptr = getelementptr inbounds %struct.MERR, %struct.MERR* %p, i64 0, i32 2
  %name.ptr = load i8*, i8** %name.ptr.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.MERR, %struct.MERR* %p, i64 0, i32 3
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.MERR, %struct.MERR* %p, i64 0, i32 4
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct.MERR, %struct.MERR* %p, i64 0, i32 5
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @sub_140002BB0(i32 2)
  %fmt = getelementptr inbounds [0 x i8], [0 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 @sub_140002AA0(i8* %stream, i8* %fmt, i8* %msgptr, i8* %name.ptr, double %arg1, double %arg2, double %retval)
  ret void
}