; ModuleID = 'sub_1400019D0_module'
target triple = "x86_64-pc-windows-msvc"

%struct._exception = type { i32, ptr, double, double, double }

@.str_format = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1
@.str_arg_domain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@.str_arg_singularity = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_overflow_range = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str_result_too_large = private unnamed_addr constant [24 x i8] c"the result is too large\00", align 1
@.str_total_loss = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_partial_loss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_unknown = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1

declare ptr @sub_140002AD0(i32 noundef)
declare i32 @sub_1400029C0(ptr noundef, ptr noundef, ...)

define dso_local i32 @sub_1400019D0(ptr noundef %exc) local_unnamed_addr {
entry:
  %type.ptr = getelementptr inbounds %struct._exception, ptr %exc, i32 0, i32 0
  %type = load i32, ptr %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
    i32 0, label %sw.default
  ]

case1:                                            ; case 1: argument domain error
  br label %dispatch

case2:                                            ; case 2: argument singularity
  br label %dispatch

case3:                                            ; case 3: overflow range error
  br label %dispatch

case4:                                            ; case 4: the result is too large
  br label %dispatch

case5:                                            ; case 5: total loss of significance
  br label %dispatch

case6:                                            ; case 6: partial loss of significance
  br label %dispatch

sw.default:                                       ; default and case 0: unknown error
  br label %dispatch

dispatch:
  %type.phi = phi i32 [ 1, %case1 ], [ 2, %case2 ], [ 3, %case3 ], [ 4, %case4 ], [ 5, %case5 ], [ 6, %case6 ], [ 0, %sw.default ]
  %msg.ptr = phi ptr [ @.str_arg_domain, %case1 ],
                   [ @.str_arg_singularity, %case2 ],
                   [ @.str_overflow_range, %case3 ],
                   [ @.str_result_too_large, %case4 ],
                   [ @.str_total_loss, %case5 ],
                   [ @.str_partial_loss, %case6 ],
                   [ @.str_unknown, %sw.default ]
  %name.ptr = getelementptr inbounds %struct._exception, ptr %exc, i32 0, i32 1
  %name = load ptr, ptr %name.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct._exception, ptr %exc, i32 0, i32 2
  %arg1 = load double, ptr %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct._exception, ptr %exc, i32 0, i32 3
  %arg2 = load double, ptr %arg2.ptr, align 8
  %retval.ptr = getelementptr inbounds %struct._exception, ptr %exc, i32 0, i32 4
  %retval = load double, ptr %retval.ptr, align 8
  %file = call ptr @sub_140002AD0(i32 noundef 2)
  %call = call i32 (ptr, ptr, ...) @sub_1400029C0(ptr noundef %file, ptr noundef @.str_format, ptr noundef %msg, ptr noundef %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}