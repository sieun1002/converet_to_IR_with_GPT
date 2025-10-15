; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@aArgumentSingul = internal constant [21 x i8] c"Argument singularity\00", align 1
@aArgumentDomain = internal constant [22 x i8] c"Argument domain error\00", align 1
@aPartialLossOfS = internal constant [29 x i8] c"Partial loss of significance\00", align 1
@aOverflowRangeE = internal constant [21 x i8] c"Overflow range error\00", align 1
@aTheResultIsToo = internal constant [42 x i8] c"The result is too small to be represented\00", align 1
@aTotalLossOfSig = internal constant [27 x i8] c"Total loss of significance\00", align 1
@aUnknownError = internal constant [14 x i8] c"Unknown error\00", align 1
@aMatherrSInSGGR = internal constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare %struct._iobuf* @loc_140002BAD(i32)
declare i32 @sub_140002AA0(%struct._iobuf*, i8*, ...)

define i32 @sub_140001AA0(i8* %rcx.ptr) {
entry:
  %type.ptr = bitcast i8* %rcx.ptr to i32*
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
    i32 0, label %sw.default
  ]

case1:                                            ; "Argument domain error"
  %msg1.gep = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %loc_140001ADF

case2:                                            ; "Argument singularity"
  %msg2.gep = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %loc_140001ADF

case3:                                            ; "Overflow range error"
  %msg3.gep = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %loc_140001ADF

case4:                                            ; "The result is too small to be represented"
  %msg4.gep = getelementptr inbounds [42 x i8], [42 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %loc_140001ADF

case5:                                            ; "Total loss of significance"
  %msg5.gep = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %loc_140001ADF

case6:                                            ; "Partial loss of significance"
  %msg6.gep = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %loc_140001ADF

sw.default:                                       ; "Unknown error"
  %msgd.gep = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %loc_140001ADF

loc_140001ADF:
  %msg.phi = phi i8* [ %msg2.gep, %case2 ], [ %msg1.gep, %case1 ], [ %msg6.gep, %case6 ], [ %msg3.gep, %case3 ], [ %msg4.gep, %case4 ], [ %msg5.gep, %case5 ], [ %msgd.gep, %sw.default ]
  %name.ptr.i8 = getelementptr inbounds i8, i8* %rcx.ptr, i64 8
  %name.ptr = bitcast i8* %name.ptr.i8 to i8**
  %name = load i8*, i8** %name.ptr, align 8
  %val1.ptr.i8 = getelementptr inbounds i8, i8* %rcx.ptr, i64 16
  %val1.ptr = bitcast i8* %val1.ptr.i8 to double*
  %val1 = load double, double* %val1.ptr, align 8
  %val2.ptr.i8 = getelementptr inbounds i8, i8* %rcx.ptr, i64 24
  %val2.ptr = bitcast i8* %val2.ptr.i8 to double*
  %val2 = load double, double* %val2.ptr, align 8
  %retval.ptr.i8 = getelementptr inbounds i8, i8* %rcx.ptr, i64 32
  %retval.ptr = bitcast i8* %retval.ptr.i8 to double*
  %retval = load double, double* %retval.ptr, align 8
  %file = call %struct._iobuf* @loc_140002BAD(i32 2)
  %fmt.gep = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (%struct._iobuf*, i8*, ...) @sub_140002AA0(%struct._iobuf* %file, i8* %fmt.gep, i8* %msg.phi, i8* %name, double %val1, double %val2, double %retval)
  ret i32 0
}