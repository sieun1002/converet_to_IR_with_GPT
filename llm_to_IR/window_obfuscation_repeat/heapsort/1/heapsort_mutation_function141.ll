; ModuleID = 'matherr_wrapper'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct._iobuf = type { i8* }
%struct._exception = type { i32, i8*, double, double, double }

@.str_fmt = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1
@.str_arg_sing = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_arg_domain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str_overflow = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str_underflow = private unnamed_addr constant [24 x i8] c"the result is too small\00", align 1
@.str_tloss = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_ploss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_unknown = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32)
declare i32 @fprintf(%struct._iobuf*, i8*, ...)

define i32 @sub_1400019D0(%struct._exception* nocapture readonly %e) {
entry:
  %type.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 0
  %type = load i32, i32* %type.ptr, align 4
  %name.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 1
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 2
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 3
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct._exception, %struct._exception* %e, i32 0, i32 4
  %retval = load double, double* %retval.ptr, align 8
  %cmp = icmp ult i32 %type, 7
  br i1 %cmp, label %inrange, label %def

inrange:                                          ; preds = %entry
  switch i32 %type, label %def [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
    i32 0, label %def
  ]

case1:                                            ; preds = %inrange
  %p1 = getelementptr inbounds [22 x i8], [22 x i8]* @.str_arg_domain, i32 0, i32 0
  br label %select_done

case2:                                            ; preds = %inrange
  %p2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_arg_sing, i32 0, i32 0
  br label %select_done

case3:                                            ; preds = %inrange
  %p3 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_overflow, i32 0, i32 0
  br label %select_done

case4:                                            ; preds = %inrange
  %p4 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_underflow, i32 0, i32 0
  br label %select_done

case5:                                            ; preds = %inrange
  %p5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str_tloss, i32 0, i32 0
  br label %select_done

case6:                                            ; preds = %inrange
  %p6 = getelementptr inbounds [29 x i8], [29 x i8]* @.str_ploss, i32 0, i32 0
  br label %select_done

def:                                              ; preds = %inrange, %entry
  %pdef = getelementptr inbounds [14 x i8], [14 x i8]* @.str_unknown, i32 0, i32 0
  br label %select_done

select_done:                                      ; preds = %def, %case6, %case5, %case4, %case3, %case2, %case1
  %msg = phi i8* [ %p1, %case1 ], [ %p2, %case2 ], [ %p3, %case3 ], [ %p4, %case4 ], [ %p5, %case5 ], [ %p6, %case6 ], [ %pdef, %def ]
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @.str_fmt, i32 0, i32 0
  %fh = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %call = call i32 (%struct._iobuf*, i8*, ...) @fprintf(%struct._iobuf* %fh, i8* %fmt, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}