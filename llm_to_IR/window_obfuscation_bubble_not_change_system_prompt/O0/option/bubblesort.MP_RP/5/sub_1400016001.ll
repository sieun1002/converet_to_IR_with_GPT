; ModuleID = 'sub_140001600.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.EX = type { i32, i32, i8*, double, double, double }

declare dso_local i8* @sub_140002710(i32 noundef)
declare dso_local i32 @sub_140002600(i8* noundef, i8* noundef, i8* noundef, i8* noundef, ...)

@aArgumentSingul = external dso_local constant i8
@aArgumentDomain = external dso_local constant i8
@aPartialLossOfS = external dso_local constant i8
@aOverflowRangeE = external dso_local constant i8
@aTheResultIsToo = external dso_local constant i8
@aTotalLossOfSig = external dso_local constant i8
@aUnknownError = external dso_local constant i8
@aMatherrSInSGGR = external dso_local constant i8

define dso_local i32 @sub_140001600(%struct.EX* noundef %0) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %case0 [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case0:                                            ; case 0 and default
  br label %cont

case1:
  br label %cont

case2:
  br label %cont

case3:
  br label %cont

case4:
  br label %cont

case5:
  br label %cont

case6:
  br label %cont

cont:
  %msg = phi i8* [ @aUnknownError, %case0 ], [ @aArgumentDomain, %case1 ], [ @aArgumentSingul, %case2 ], [ @aOverflowRangeE, %case3 ], [ @aTheResultIsToo, %case4 ], [ @aTotalLossOfSig, %case5 ], [ @aPartialLossOfS, %case6 ]
  %name.ptr.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 2
  %name.ptr = load i8*, i8** %name.ptr.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 3
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 4
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct.EX, %struct.EX* %0, i32 0, i32 5
  %retval = load double, double* %retval.ptr, align 8
  %cat = call i8* @sub_140002710(i32 noundef 2)
  %call = call i32 @sub_140002600(i8* noundef %cat, i8* noundef @aMatherrSInSGGR, i8* noundef %msg, i8* noundef %name.ptr, double %arg1, double %arg2, double %retval)
  ret i32 0
}