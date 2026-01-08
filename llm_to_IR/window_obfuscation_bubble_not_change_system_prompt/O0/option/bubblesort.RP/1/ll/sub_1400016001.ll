; ModuleID = 'sub_140001600.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque
%struct.matherr = type { i32, i32, i8*, double, double, double }

@aArgumentSingul = internal unnamed_addr constant [21 x i8] c"argument singularity\00"
@aArgumentDomain = internal unnamed_addr constant [22 x i8] c"argument domain error\00"
@aPartialLossOfS = internal unnamed_addr constant [29 x i8] c"partial loss of significance\00"
@aOverflowRangeE = internal unnamed_addr constant [21 x i8] c"overflow range error\00"
@aTheResultIsToo = internal unnamed_addr constant [24 x i8] c"the result is too large\00"
@aTotalLossOfSig = internal unnamed_addr constant [27 x i8] c"total loss of significance\00"
@aUnknownError   = internal unnamed_addr constant [14 x i8] c"unknown error\00"
@aMatherrSInSGGR = internal unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"

declare %struct._iobuf* @__acrt_iob_func(i32 noundef)
declare i32 @sub_140002600(%struct._iobuf* noundef, i8* noundef, i8* noundef, i8* noundef, ...)

define dso_local i32 @sub_140001600(%struct.matherr* noundef %0) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct.matherr, %struct.matherr* %0, i64 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 0, label %case.unknown
    i32 1, label %case.domain
    i32 2, label %case.singularity
    i32 3, label %case.overflow
    i32 4, label %case.toolarge
    i32 5, label %case.totalloss
    i32 6, label %case.partloss
  ]

sw.default:                                        ; preds = %entry
  br label %case.unknown

case.singularity:                                  ; preds = %entry
  %str.sing = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %common

case.domain:                                       ; preds = %entry
  %str.dom = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %common

case.partloss:                                     ; preds = %entry
  %str.ploss = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %common

case.overflow:                                     ; preds = %entry
  %str.oflow = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %common

case.toolarge:                                     ; preds = %entry
  %str.too = getelementptr inbounds [24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %common

case.totalloss:                                    ; preds = %entry
  %str.tloss = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %common

case.unknown:                                      ; preds = %entry, %sw.default
  %str.unk = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %common

common:                                            ; preds = %case.unknown, %case.totalloss, %case.toolarge, %case.overflow, %case.partloss, %case.domain, %case.singularity
  %msg = phi i8* [ %str.sing, %case.singularity ], [ %str.dom, %case.domain ], [ %str.oflow, %case.overflow ], [ %str.too, %case.toolarge ], [ %str.tloss, %case.totalloss ], [ %str.ploss, %case.partloss ], [ %str.unk, %case.unknown ]
  %name.ptr = getelementptr inbounds %struct.matherr, %struct.matherr* %0, i64 0, i32 2
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.matherr, %struct.matherr* %0, i64 0, i32 3
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.matherr, %struct.matherr* %0, i64 0, i32 4
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct.matherr, %struct.matherr* %0, i64 0, i32 5
  %retval = load double, double* %retval.ptr, align 8
  %stream = call %struct._iobuf* @__acrt_iob_func(i32 noundef 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (%struct._iobuf*, i8*, i8*, i8*, ...) @sub_140002600(%struct._iobuf* noundef %stream, i8* noundef %fmt, i8* noundef %msg, i8* noundef %name, double noundef %arg1, double noundef %arg2, double noundef %retval)
  ret i32 0
}