; ModuleID = 'sub_140001600.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, [4 x i8], i8*, double, double, double }

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aPartialLossOfS = external global i8
@aUnknownError = external global i8
@aMatherrSInSGGR = external global i8

define i32 @sub_140001600(%struct.S* nocapture readonly %rcx) {
entry:
  %type.ptr = getelementptr inbounds %struct.S, %struct.S* %rcx, i64 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case1:
  br label %loc_14000163F

case2:
  br label %loc_14000163F

case3:
  br label %loc_14000163F

case4:
  br label %loc_14000163F

case5:
  br label %loc_14000163F

case6:
  br label %loc_14000163F

sw.default:
  br label %loc_14000163F

loc_14000163F:
  %msg = phi i8* [ @aArgumentDomain, %case1 ],
                 [ @aArgumentSingul, %case2 ],
                 [ @aOverflowRangeE, %case3 ],
                 [ @aTheResultIsToo, %case4 ],
                 [ @aTotalLossOfSig, %case5 ],
                 [ @aPartialLossOfS, %case6 ],
                 [ @aUnknownError, %sw.default ]
  %retval.ptr = getelementptr inbounds %struct.S, %struct.S* %rcx, i64 0, i32 5
  %retval = load double, double* %retval.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.S, %struct.S* %rcx, i64 0, i32 4
  %arg2 = load double, double* %arg2.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.S, %struct.S* %rcx, i64 0, i32 3
  %arg1 = load double, double* %arg1.ptr, align 8
  %name.ptr = getelementptr inbounds %struct.S, %struct.S* %rcx, i64 0, i32 2
  %name = load i8*, i8** %name.ptr, align 8
  %fmt = getelementptr i8, i8* @aMatherrSInSGGR, i64 0
  %t0 = call i8* @sub_140002710(i32 2)
  %t1 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %t0, i8* %fmt, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}