; ModuleID = 'sub_1400019D0.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i32, i8*, double, double, double }

@.str.msg.unknown = private unnamed_addr constant [14 x i8] c"Unknown error\00", align 1
@.str.msg.domain = private unnamed_addr constant [22 x i8] c"Argument domain error\00", align 1
@.str.msg.singularity = private unnamed_addr constant [21 x i8] c"Argument singularity\00", align 1
@.str.msg.overflow = private unnamed_addr constant [21 x i8] c"Overflow range error\00", align 1
@.str.msg.too_small = private unnamed_addr constant [42 x i8] c"The result is too small to be represented\00", align 1
@.str.msg.total_loss = private unnamed_addr constant [27 x i8] c"Total loss of significance\00", align 1
@.str.msg.partial_loss = private unnamed_addr constant [29 x i8] c"Partial loss of significance\00", align 1
@.str.fmt = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32 noundef)
declare dso_local i32 @sub_1400029C0(i8* noundef, i8* noundef, ...)

define dso_local i32 @sub_1400019D0(%struct._exception* noundef %e) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                           ; case 1: Argument domain error
  %msg1.gep = getelementptr inbounds [22 x i8], [22 x i8]* @.str.msg.domain, i64 0, i64 0
  br label %cont

sw.case2:                                           ; case 2: Argument singularity
  %msg2.gep = getelementptr inbounds [21 x i8], [21 x i8]* @.str.msg.singularity, i64 0, i64 0
  br label %cont

sw.case3:                                           ; case 3: Overflow range error
  %msg3.gep = getelementptr inbounds [21 x i8], [21 x i8]* @.str.msg.overflow, i64 0, i64 0
  br label %cont

sw.case4:                                           ; case 4: The result is too small to be represented
  %msg4.gep = getelementptr inbounds [42 x i8], [42 x i8]* @.str.msg.too_small, i64 0, i64 0
  br label %cont

sw.case5:                                           ; case 5: Total loss of significance
  %msg5.gep = getelementptr inbounds [27 x i8], [27 x i8]* @.str.msg.total_loss, i64 0, i64 0
  br label %cont

sw.case6:                                           ; case 6: Partial loss of significance
  %msg6.gep = getelementptr inbounds [29 x i8], [29 x i8]* @.str.msg.partial_loss, i64 0, i64 0
  br label %cont

sw.default:                                         ; default (includes case 0 and >6)
  %msgd.gep = getelementptr inbounds [14 x i8], [14 x i8]* @.str.msg.unknown, i64 0, i64 0
  br label %cont

cont:
  %msg = phi i8* [ %msg1.gep, %sw.case1 ], [ %msg2.gep, %sw.case2 ], [ %msg3.gep, %sw.case3 ], [ %msg4.gep, %sw.case4 ], [ %msg5.gep, %sw.case5 ], [ %msg6.gep, %sw.case6 ], [ %msgd.gep, %sw.default ]
  %name.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 2
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 3
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 4
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i64 0, i32 5
  %retval = load double, double* %retval.ptr, align 8
  %fh = call i8* @__acrt_iob_func(i32 noundef 2)
  %fmt.gep = getelementptr inbounds [43 x i8], [43 x i8]* @.str.fmt, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* noundef %fh, i8* noundef %fmt.gep, i8* noundef %msg, i8* noundef %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}