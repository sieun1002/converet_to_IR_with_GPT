; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = external constant [0 x i8], align 1
@aArgumentDomain = external constant [0 x i8], align 1
@aPartialLossOfS = external constant [0 x i8], align 1
@aOverflowRangeE = external constant [0 x i8], align 1
@aTheResultIsToo = external constant [0 x i8], align 1
@aTotalLossOfSig = external constant [0 x i8], align 1
@aUnknownError = external constant [0 x i8], align 1
@aMatherrSInSGGR = external constant [0 x i8], align 1

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

define i32 @sub_140001600(i8* %rcx) local_unnamed_addr {
entry:
  %p_code = bitcast i8* %rcx to i32*
  %code = load i32, i32* %p_code, align 4
  switch i32 %code, label %sw.default [
    i32 0, label %case.unknown
    i32 1, label %case.domain
    i32 2, label %case.singular
    i32 3, label %case.overflow
    i32 4, label %case.too
    i32 5, label %case.totalloss
    i32 6, label %case.partloss
  ]

case.singular:                                    ; case 2
  %sing.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %after.switch

case.domain:                                      ; case 1
  %dom.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %after.switch

case.partloss:                                    ; case 6
  %part.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %after.switch

case.overflow:                                    ; case 3
  %over.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %after.switch

case.too:                                         ; case 4
  %too.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %after.switch

case.totalloss:                                   ; case 5
  %total.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %after.switch

case.unknown:                                     ; case 0
  %unk.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aUnknownError, i64 0, i64 0
  br label %after.switch

sw.default:                                       ; default
  %def.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aUnknownError, i64 0, i64 0
  br label %after.switch

after.switch:
  %errstr = phi i8* [ %unk.ptr, %case.unknown ], [ %def.ptr, %sw.default ], [ %sing.ptr, %case.singular ], [ %dom.ptr, %case.domain ], [ %over.ptr, %case.overflow ], [ %too.ptr, %case.too ], [ %total.ptr, %case.totalloss ], [ %part.ptr, %case.partloss ]
  %p_name = getelementptr inbounds i8, i8* %rcx, i64 8
  %namepp = bitcast i8* %p_name to i8**
  %name = load i8*, i8** %namepp, align 8
  %p_d1 = getelementptr inbounds i8, i8* %rcx, i64 16
  %d1p = bitcast i8* %p_d1 to double*
  %d1 = load double, double* %d1p, align 8
  %p_d2 = getelementptr inbounds i8, i8* %rcx, i64 24
  %d2p = bitcast i8* %p_d2 to double*
  %d2 = load double, double* %d2p, align 8
  %p_ret = getelementptr inbounds i8, i8* %rcx, i64 32
  %retp = bitcast i8* %p_ret to double*
  %ret = load double, double* %retp, align 8
  %call.tag = call i8* @sub_140002710(i32 2)
  %fmt.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call.print = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %call.tag, i8* %fmt.ptr, i8* %errstr, i8* %name, double %d1, double %d2, double %ret)
  ret i32 0
}