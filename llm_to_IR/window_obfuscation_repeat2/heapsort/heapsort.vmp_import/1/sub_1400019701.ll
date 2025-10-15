; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = internal unnamed_addr constant [21 x i8] c"argument singularity\00"
@aArgumentDomain = internal unnamed_addr constant [22 x i8] c"argument domain error\00"
@aPartialLossOfS = internal unnamed_addr constant [29 x i8] c"partial loss of significance\00"
@aOverflowRangeE = internal unnamed_addr constant [21 x i8] c"overflow range error\00"
@aTheResultIsToo = internal unnamed_addr constant [36 x i8] c"the result is too small (underflow)\00"
@aTotalLossOfSig = internal unnamed_addr constant [27 x i8] c"total loss of significance\00"
@aUnknownError = internal unnamed_addr constant [14 x i8] c"unknown error\00"
@aMatherrSInSGGR = internal unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"

declare i8* @loc_140002A6D(i32)
declare i32 @sub_140002960(i8*, i8*, ...)

define i32 @sub_140001970(i8* %rcx.param) local_unnamed_addr {
entry:
  %type.ptr = bitcast i8* %rcx.param to i32*
  %type = load i32, i32* %type.ptr, align 4
  %inrange = icmp ule i32 %type, 6
  br i1 %inrange, label %sw.bb, label %sw.default

sw.bb:                                            ; preds = %entry
  switch i32 %type, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
    i32 0, label %sw.default
  ]

case1:                                            ; preds = %sw.bb
  %msg1.gep = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %cont

case2:                                            ; preds = %sw.bb
  %msg2.gep = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %cont

case3:                                            ; preds = %sw.bb
  %msg3.gep = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %cont

case4:                                            ; preds = %sw.bb
  %msg4.gep = getelementptr inbounds [36 x i8], [36 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %cont

case5:                                            ; preds = %sw.bb
  %msg5.gep = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %cont

case6:                                            ; preds = %sw.bb
  %msg6.gep = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %cont

sw.default:                                       ; preds = %sw.bb, %entry, %sw.bb
  %msgd.gep = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %cont

cont:                                             ; preds = %case6, %case5, %case4, %case3, %case2, %case1, %sw.default
  %msg = phi i8* [ %msg1.gep, %case1 ], [ %msg2.gep, %case2 ], [ %msg3.gep, %case3 ], [ %msg4.gep, %case4 ], [ %msg5.gep, %case5 ], [ %msg6.gep, %case6 ], [ %msgd.gep, %sw.default ]
  %name.ptr.i8 = getelementptr inbounds i8, i8* %rcx.param, i64 8
  %name.ptr = bitcast i8* %name.ptr.i8 to i8**
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr.i8 = getelementptr inbounds i8, i8* %rcx.param, i64 16
  %arg1.ptr = bitcast i8* %arg1.ptr.i8 to double*
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr.i8 = getelementptr inbounds i8, i8* %rcx.param, i64 24
  %arg2.ptr = bitcast i8* %arg2.ptr.i8 to double*
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr.i8 = getelementptr inbounds i8, i8* %rcx.param, i64 32
  %retval.ptr = bitcast i8* %retval.ptr.i8 to double*
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @loc_140002A6D(i32 2)
  %fmt.gep = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_140002960(i8* %stream, i8* %fmt.gep, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}