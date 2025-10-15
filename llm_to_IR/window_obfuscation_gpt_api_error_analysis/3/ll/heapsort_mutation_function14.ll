; ModuleID = 'sub_1400019D0_module'
target triple = "x86_64-pc-windows-msvc"

%struct.MErr = type { i32, i32, i8*, double, double, double }

@.str_domain = private unnamed_addr constant [16 x i8] c"argument domain\00", align 1
@.str_sing = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@.str_overflow = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@.str_underflow = private unnamed_addr constant [42 x i8] c"the result is too small to be represented\00", align 1
@.str_tloss = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@.str_ploss = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@.str_unknown = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@.fmt = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32 noundef)
declare i32 @sub_1400029C0(i8* noundef, i8* noundef, i8* noundef, i8* noundef, ...)

define i32 @sub_1400019D0(%struct.MErr* noundef %rec) {
entry:
  %code.ptr = getelementptr inbounds %struct.MErr, %struct.MErr* %rec, i32 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  %cmp = icmp ugt i32 %code, 6
  br i1 %cmp, label %sw.default, label %sw.switch

sw.switch:                                        ; preds = %entry
  switch i32 %code, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case1:                                            ; preds = %sw.switch
  %p.domain = getelementptr inbounds [16 x i8], [16 x i8]* @.str_domain, i64 0, i64 0
  br label %cont

case2:                                            ; preds = %sw.switch
  %p.sing = getelementptr inbounds [21 x i8], [21 x i8]* @.str_sing, i64 0, i64 0
  br label %cont

case3:                                            ; preds = %sw.switch
  %p.overflow = getelementptr inbounds [21 x i8], [21 x i8]* @.str_overflow, i64 0, i64 0
  br label %cont

case4:                                            ; preds = %sw.switch
  %p.underflow = getelementptr inbounds [42 x i8], [42 x i8]* @.str_underflow, i64 0, i64 0
  br label %cont

case5:                                            ; preds = %sw.switch
  %p.tloss = getelementptr inbounds [27 x i8], [27 x i8]* @.str_tloss, i64 0, i64 0
  br label %cont

case6:                                            ; preds = %sw.switch
  %p.ploss = getelementptr inbounds [29 x i8], [29 x i8]* @.str_ploss, i64 0, i64 0
  br label %cont

sw.default:                                       ; preds = %sw.switch, %entry
  %p.unknown = getelementptr inbounds [14 x i8], [14 x i8]* @.str_unknown, i64 0, i64 0
  br label %cont

cont:                                             ; preds = %case6, %case5, %case4, %case3, %case2, %case1, %sw.default
  %errstr = phi i8* [ %p.domain, %case1 ], [ %p.sing, %case2 ], [ %p.overflow, %case3 ], [ %p.underflow, %case4 ], [ %p.tloss, %case5 ], [ %p.ploss, %case6 ], [ %p.unknown, %sw.default ]
  %func.ptr.ptr = getelementptr inbounds %struct.MErr, %struct.MErr* %rec, i32 0, i32 2
  %func.ptr = load i8*, i8** %func.ptr.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.MErr, %struct.MErr* %rec, i32 0, i32 3
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.MErr, %struct.MErr* %rec, i32 0, i32 4
  %arg2 = load double, double* %arg2.ptr, align 8
  %retv.ptr = getelementptr inbounds %struct.MErr, %struct.MErr* %rec, i32 0, i32 5
  %retv = load double, double* %retv.ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 noundef 2)
  %fmt.ptr = getelementptr inbounds [43 x i8], [43 x i8]* @.fmt, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* noundef %stream, i8* noundef %fmt.ptr, i8* noundef %errstr, i8* noundef %func.ptr, double %arg1, double %arg2, double %retv)
  ret i32 0
}