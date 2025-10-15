; ModuleID = 'sub_1400019D0.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque
%struct._exception = type { i32, i8*, double, double, double }

@.str.fmt = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1
@.str.unknown = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@.str.argdom = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str.argsing = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str.overflow = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str.toosmall = private unnamed_addr constant [24 x i8] c"the result is too small\00", align 1
@.str.totalloss = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str.partialloss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1

declare dso_local %struct._iobuf* @__acrt_iob_func(i32)
declare dso_local i32 @fprintf(%struct._iobuf*, i8*, ...)

define dso_local i32 @sub_1400019D0(%struct._exception* nocapture readonly %exc) local_unnamed_addr {
entry:
  %typeptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 0
  %typeval = load i32, i32* %typeptr, align 4
  switch i32 %typeval, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb1:                                            ; preds = %entry
  %p1 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.argdom, i64 0, i64 0
  br label %sw.epilog

sw.bb2:                                            ; preds = %entry
  %p2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.argsing, i64 0, i64 0
  br label %sw.epilog

sw.bb3:                                            ; preds = %entry
  %p3 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.overflow, i64 0, i64 0
  br label %sw.epilog

sw.bb4:                                            ; preds = %entry
  %p4 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.toosmall, i64 0, i64 0
  br label %sw.epilog

sw.bb5:                                            ; preds = %entry
  %p5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.totalloss, i64 0, i64 0
  br label %sw.epilog

sw.bb6:                                            ; preds = %entry
  %p6 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.partialloss, i64 0, i64 0
  br label %sw.epilog

sw.default:                                        ; preds = %entry, %entry
  %pd = getelementptr inbounds [14 x i8], [14 x i8]* @.str.unknown, i64 0, i64 0
  br label %sw.epilog

sw.epilog:                                         ; preds = %sw.default, %sw.bb6, %sw.bb5, %sw.bb4, %sw.bb3, %sw.bb2, %sw.bb1
  %errstr = phi i8* [ %p1, %sw.bb1 ], [ %p2, %sw.bb2 ], [ %p3, %sw.bb3 ], [ %p4, %sw.bb4 ], [ %p5, %sw.bb5 ], [ %p6, %sw.bb6 ], [ %pd, %sw.default ]
  %nameptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 1
  %name = load i8*, i8** %nameptr, align 8
  %a1ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 2
  %a1 = load double, double* %a1ptr, align 8
  %a2ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 3
  %a2 = load double, double* %a2ptr, align 8
  %retptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i64 0, i32 4
  %retval = load double, double* %retptr, align 8
  %file = call dso_local %struct._iobuf* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str.fmt, i64 0, i64 0
  %call = call dso_local i32 (%struct._iobuf*, i8*, ...) @fprintf(%struct._iobuf* %file, i8* %fmt, i8* %errstr, i8* %name, double %a1, double %a2, double %retval)
  ret i32 0
}