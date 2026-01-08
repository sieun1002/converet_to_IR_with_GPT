; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = external dso_local global i8
@aMatherrSInSGGR = external dso_local global i8
@aArgumentDomain = external dso_local global i8
@aPartialLossOfS = external dso_local global i8
@aOverflowRangeE = external dso_local global i8
@aTheResultIsToo = external dso_local global i8
@aTotalLossOfSig = external dso_local global i8
@aUnknownError = external dso_local global i8

declare dso_local i8* @sub_140002710(i32)
declare dso_local i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

define dso_local i32 @sub_140001600(i8* %rcx.param) {
entry:
  %type.ptr = bitcast i8* %rcx.param to i32*
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb1:
  br label %sw.epilog

sw.bb2:
  br label %sw.epilog

sw.bb3:
  br label %sw.epilog

sw.bb4:
  br label %sw.epilog

sw.bb5:
  br label %sw.epilog

sw.bb6:
  br label %sw.epilog

sw.default:
  br label %sw.epilog

sw.epilog:
  %errstr = phi i8* [ @aArgumentDomain, %sw.bb1 ],
                   [ @aArgumentSingul, %sw.bb2 ],
                   [ @aOverflowRangeE, %sw.bb3 ],
                   [ @aTheResultIsToo, %sw.bb4 ],
                   [ @aTotalLossOfSig, %sw.bb5 ],
                   [ @aPartialLossOfS, %sw.bb6 ],
                   [ @aUnknownError, %sw.default ],
                   [ @aUnknownError, %entry ]
  %name.ptr.ptr.i8 = getelementptr inbounds i8, i8* %rcx.param, i64 8
  %name.ptr.ptr = bitcast i8* %name.ptr.ptr.i8 to i8**
  %name = load i8*, i8** %name.ptr.ptr, align 8
  %arg1.ptr.i8 = getelementptr inbounds i8, i8* %rcx.param, i64 16
  %arg1.ptr = bitcast i8* %arg1.ptr.i8 to double*
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr.i8 = getelementptr inbounds i8, i8* %rcx.param, i64 24
  %arg2.ptr = bitcast i8* %arg2.ptr.i8 to double*
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr.i8 = getelementptr inbounds i8, i8* %rcx.param, i64 32
  %retval.ptr = bitcast i8* %retval.ptr.i8 to double*
  %retval = load double, double* %retval.ptr, align 8
  %call.buf = call i8* @sub_140002710(i32 2)
  %fmt = bitcast i8* @aMatherrSInSGGR to i8*
  %call.print = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %call.buf, i8* %fmt, i8* %errstr, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}