; ModuleID = 'fixed_ir_module'
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, i8*, double, double, double }
%struct._iobuf = type { i8*, i32, i8*, i32, i32, i32, i32, i8* }

@.str_arg_sing      = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_arg_domain    = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str_partial_loss  = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_overflow      = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str_too_large     = private unnamed_addr constant [24 x i8] c"the result is too large\00", align 1
@.str_total_loss    = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_unknown       = private unnamed_addr constant [19 x i8] c"unknown error type\00", align 1
@.str_fmt           = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32)
declare i32 @fprintf(%struct._iobuf*, i8*, ...)

define i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %fmt, i8* %errstr, i8* %name, double %a1, double %a2, double %ret) {
entry:
  %call = call i32 (%struct._iobuf*, i8*, ...) @fprintf(%struct._iobuf* %stream, i8* %fmt, i8* %errstr, i8* %name, double %a1, double %a2, double %ret)
  ret i32 %call
}

define i32 @sub_1400019D0(%struct._exception* %exc) {
entry:
  %type_ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 0
  %type = load i32, i32* %type_ptr, align 4
  %cmp1 = icmp eq i32 %type, 1
  br i1 %cmp1, label %case1, label %sw.next1

case1:
  br label %sw.end

sw.next1:
  %cmp2 = icmp eq i32 %type, 2
  br i1 %cmp2, label %case2, label %sw.next2

case2:
  br label %sw.end

sw.next2:
  %cmp3 = icmp eq i32 %type, 3
  br i1 %cmp3, label %case3, label %sw.next3

case3:
  br label %sw.end

sw.next3:
  %cmp4 = icmp eq i32 %type, 4
  br i1 %cmp4, label %case4, label %sw.next4

case4:
  br label %sw.end

sw.next4:
  %cmp5 = icmp eq i32 %type, 5
  br i1 %cmp5, label %case5, label %sw.next5

case5:
  br label %sw.end

sw.next5:
  %cmp6 = icmp eq i32 %type, 6
  br i1 %cmp6, label %case6, label %default

case6:
  br label %sw.end

default:
  br label %sw.end

sw.end:
  %msg = phi i8* [ getelementptr inbounds ([22 x i8], [22 x i8]* @.str_arg_domain, i32 0, i32 0), %case1 ],
                 [ getelementptr inbounds ([21 x i8], [21 x i8]* @.str_arg_sing, i32 0, i32 0), %case2 ],
                 [ getelementptr inbounds ([21 x i8], [21 x i8]* @.str_overflow, i32 0, i32 0), %case3 ],
                 [ getelementptr inbounds ([24 x i8], [24 x i8]* @.str_too_large, i32 0, i32 0), %case4 ],
                 [ getelementptr inbounds ([27 x i8], [27 x i8]* @.str_total_loss, i32 0, i32 0), %case5 ],
                 [ getelementptr inbounds ([29 x i8], [29 x i8]* @.str_partial_loss, i32 0, i32 0), %case6 ],
                 [ getelementptr inbounds ([19 x i8], [19 x i8]* @.str_unknown, i32 0, i32 0), %default ]
  %name_ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 1
  %name = load i8*, i8** %name_ptr, align 8
  %arg1_ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 2
  %arg1 = load double, double* %arg1_ptr, align 8
  %arg2_ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 3
  %arg2 = load double, double* %arg2_ptr, align 8
  %ret_ptr = getelementptr inbounds %struct._exception, %struct._exception* %exc, i32 0, i32 4
  %retval = load double, double* %ret_ptr, align 8
  %stream = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %fmtptr = getelementptr inbounds [43 x i8], [43 x i8]* @.str_fmt, i32 0, i32 0
  %call = call i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %fmtptr, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}