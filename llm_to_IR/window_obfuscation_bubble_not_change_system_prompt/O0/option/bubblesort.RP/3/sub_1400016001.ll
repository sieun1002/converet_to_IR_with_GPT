; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

declare dso_local i8* @__acrt_iob_func(i32 noundef)
declare dso_local i32 @sub_140002600(i8* noundef, i8* noundef, ...)

@aArgumentSingul   = external dso_local global i8
@aArgumentDomain   = external dso_local global i8
@aPartialLossOfS   = external dso_local global i8
@aOverflowRangeE   = external dso_local global i8
@aTheResultIsToo   = external dso_local global i8
@aTotalLossOfSig   = external dso_local global i8
@aUnknownError     = external dso_local global i8
@aMatherrSInSGGR   = external dso_local global i8

define dso_local i32 @sub_140001600(i8* %p) {
entry:
  %tag.ptr = bitcast i8* %p to i32*
  %tag = load i32, i32* %tag.ptr, align 4
  switch i32 %tag, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:
  br label %loadargs

sw.case2:
  br label %loadargs

sw.case3:
  br label %loadargs

sw.case4:
  br label %loadargs

sw.case5:
  br label %loadargs

sw.case6:
  br label %loadargs

sw.default:
  br label %loadargs

loadargs:
  %msg = phi i8* [ @aUnknownError, %sw.default ],
                 [ @aArgumentDomain, %sw.case1 ],
                 [ @aArgumentSingul, %sw.case2 ],
                 [ @aOverflowRangeE, %sw.case3 ],
                 [ @aTheResultIsToo, %sw.case4 ],
                 [ @aTotalLossOfSig, %sw.case5 ],
                 [ @aPartialLossOfS, %sw.case6 ]
  %fn.ptr.base = getelementptr i8, i8* %p, i64 8
  %fn.ptr.cast = bitcast i8* %fn.ptr.base to i8**
  %fn = load i8*, i8** %fn.ptr.cast, align 8
  %x.ptr.base = getelementptr i8, i8* %p, i64 16
  %x.ptr = bitcast i8* %x.ptr.base to double*
  %x = load double, double* %x.ptr, align 8
  %y.ptr.base = getelementptr i8, i8* %p, i64 24
  %y.ptr = bitcast i8* %y.ptr.base to double*
  %y = load double, double* %y.ptr, align 8
  %rv.ptr.base = getelementptr i8, i8* %p, i64 32
  %rv.ptr = bitcast i8* %rv.ptr.base to double*
  %rv = load double, double* %rv.ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %call = call i32 (i8*, i8*, ...) @sub_140002600(i8* %stream, i8* @aMatherrSInSGGR, i8* %msg, i8* %fn, double %x, double %y, double %rv)
  ret i32 0
}