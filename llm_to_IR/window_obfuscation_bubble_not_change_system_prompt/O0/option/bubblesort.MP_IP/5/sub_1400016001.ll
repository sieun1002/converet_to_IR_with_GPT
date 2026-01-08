; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, double, double, double)

@aArgumentSingul = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError   = external constant i8
@aMatherrSInSGGR = external constant i8

define dso_local i32 @sub_140001600(i8* %rcx) {
entry:
  %val.ptr = bitcast i8* %rcx to i32*
  %val = load i32, i32* %val.ptr, align 4
  switch i32 %val, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:
  br label %sw.merge

sw.case2:
  br label %sw.merge

sw.case3:
  br label %sw.merge

sw.case4:
  br label %sw.merge

sw.case5:
  br label %sw.merge

sw.case6:
  br label %sw.merge

sw.default:
  br label %sw.merge

sw.merge:
  %err.sel = phi i8* [ bitcast (i8* @aArgumentDomain to i8*), %sw.case1 ],
                 [ bitcast (i8* @aArgumentSingul to i8*), %sw.case2 ],
                 [ bitcast (i8* @aOverflowRangeE to i8*), %sw.case3 ],
                 [ bitcast (i8* @aTheResultIsToo to i8*), %sw.case4 ],
                 [ bitcast (i8* @aTotalLossOfSig to i8*), %sw.case5 ],
                 [ bitcast (i8* @aPartialLossOfS to i8*), %sw.case6 ],
                 [ bitcast (i8* @aUnknownError to i8*), %sw.default ]
  %fn.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 8
  %fn.ptr.pp = bitcast i8* %fn.ptr.i8 to i8**
  %fn.ptr = load i8*, i8** %fn.ptr.pp, align 8
  %x.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 16
  %x.ptr = bitcast i8* %x.ptr.i8 to double*
  %x = load double, double* %x.ptr, align 8
  %y.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 24
  %y.ptr = bitcast i8* %y.ptr.i8 to double*
  %y = load double, double* %y.ptr, align 8
  %rv.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 32
  %rv.ptr = bitcast i8* %rv.ptr.i8 to double*
  %rv = load double, double* %rv.ptr, align 8
  %tmp = call i8* @sub_140002710(i32 2)
  %fmt = bitcast i8* @aMatherrSInSGGR to i8*
  %call = call i32 @sub_140002600(i8* %tmp, i8* %fmt, i8* %err.sel, i8* %fn.ptr, double %x, double %y, double %rv)
  ret i32 0
}