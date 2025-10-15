; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct.matherrrec = type { i32, i32, i8*, double, double, double }

@.str_argument_singularity = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_argument_domain_error = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str_partial_loss_of_significance = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_overflow_range_error = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str_the_result_is_too_small = private unnamed_addr constant [24 x i8] c"the result is too small\00", align 1
@.str_total_loss_of_significance = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_unknown_error = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@.str_format = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_140002AA0(i8*, i8*, ...)

define i32 @sub_140001AA0(%struct.matherrrec* %rec) {
entry:
  %code.ptr = getelementptr inbounds %struct.matherrrec, %struct.matherrrec* %rec, i64 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  switch i32 %code, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                         ; case 1: argument domain
  %msg1 = getelementptr inbounds [22 x i8], [22 x i8]* @.str_argument_domain_error, i64 0, i64 0
  br label %sw.epilog

sw.case2:                                         ; case 2: argument singularity
  %msg2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_argument_singularity, i64 0, i64 0
  br label %sw.epilog

sw.case3:                                         ; case 3: overflow range error
  %msg3 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_overflow_range_error, i64 0, i64 0
  br label %sw.epilog

sw.case4:                                         ; case 4: the result is too small
  %msg4 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_the_result_is_too_small, i64 0, i64 0
  br label %sw.epilog

sw.case5:                                         ; case 5: total loss of significance
  %msg5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str_total_loss_of_significance, i64 0, i64 0
  br label %sw.epilog

sw.case6:                                         ; case 6: partial loss of significance
  %msg6 = getelementptr inbounds [29 x i8], [29 x i8]* @.str_partial_loss_of_significance, i64 0, i64 0
  br label %sw.epilog

sw.default:                                       ; default (includes case 0 and >6)
  %msgd = getelementptr inbounds [14 x i8], [14 x i8]* @.str_unknown_error, i64 0, i64 0
  br label %sw.epilog

sw.epilog:
  %msg.phi = phi i8* [ %msg1, %sw.case1 ], [ %msg2, %sw.case2 ], [ %msg3, %sw.case3 ], [ %msg4, %sw.case4 ], [ %msg5, %sw.case5 ], [ %msg6, %sw.case6 ], [ %msgd, %sw.default ]
  %name.ptr = getelementptr inbounds %struct.matherrrec, %struct.matherrrec* %rec, i64 0, i32 2
  %name = load i8*, i8** %name.ptr, align 8
  %x.ptr = getelementptr inbounds %struct.matherrrec, %struct.matherrrec* %rec, i64 0, i32 3
  %x = load double, double* %x.ptr, align 8
  %y.ptr = getelementptr inbounds %struct.matherrrec, %struct.matherrrec* %rec, i64 0, i32 4
  %y = load double, double* %y.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct.matherrrec, %struct.matherrrec* %rec, i64 0, i32 5
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str_format, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_140002AA0(i8* %stream, i8* %fmt, i8* %msg.phi, i8* %name, double %x, double %y, double %retval)
  ret i32 0
}