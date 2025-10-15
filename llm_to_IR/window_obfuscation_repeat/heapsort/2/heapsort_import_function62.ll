; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type { i8*, i32, i8*, i32, i32, i32, i32, i8* }
%struct.MATHERR = type { i32, i32, i8*, double, double, double }

@.str.format = internal constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"
@.str.arg_domain = internal constant [22 x i8] c"Argument domain error\00"
@.str.arg_sing = internal constant [21 x i8] c"Argument singularity\00"
@.str.overflow = internal constant [21 x i8] c"Overflow range error\00"
@.str.too_small = internal constant [24 x i8] c"The result is too small\00"
@.str.total_loss = internal constant [27 x i8] c"Total loss of significance\00"
@.str.partial_loss = internal constant [29 x i8] c"Partial loss of significance\00"
@.str.unknown = internal constant [14 x i8] c"Unknown error\00"

@stdin = external dllimport global %struct._iobuf*
@stdout = external dllimport global %struct._iobuf*
@stderr = external dllimport global %struct._iobuf*

declare dllimport i32 @fprintf(%struct._iobuf*, i8*, ...)

define dso_local %struct._iobuf* @sub_140002AD0(i32 %idx) {
entry:
  switch i32 %idx, label %sw.default [
    i32 0, label %sw.case0
    i32 1, label %sw.case1
    i32 2, label %sw.case2
  ]

sw.case0:
  %stdin.val.ptrptr = load %struct._iobuf*, %struct._iobuf** @stdin, align 8
  br label %sw.end

sw.case1:
  %stdout.val.ptrptr = load %struct._iobuf*, %struct._iobuf** @stdout, align 8
  br label %sw.end

sw.case2:
  %stderr.val.ptrptr = load %struct._iobuf*, %struct._iobuf** @stderr, align 8
  br label %sw.end

sw.default:
  %stderr.def.ptr = load %struct._iobuf*, %struct._iobuf** @stderr, align 8
  br label %sw.end

sw.end:
  %res = phi %struct._iobuf* [ %stdin.val.ptrptr, %sw.case0 ], [ %stdout.val.ptrptr, %sw.case1 ], [ %stderr.val.ptrptr, %sw.case2 ], [ %stderr.def.ptr, %sw.default ]
  ret %struct._iobuf* %res
}

define dso_local i32 @sub_1400029C0(%struct._iobuf* %f, i8* %fmt, i8* %arg1, i8* %arg2, double %x, double %y, double %retv) {
entry:
  %call = call i32 (%struct._iobuf*, i8*, ...) @fprintf(%struct._iobuf* %f, i8* %fmt, i8* %arg1, i8* %arg2, double %x, double %y, double %retv)
  ret i32 %call
}

define dso_local i32 @sub_1400019D0(%struct.MATHERR* nocapture readonly %rec) {
entry:
  %code.ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rec, i32 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  switch i32 %code, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:
  %msg.case1.ptr = getelementptr inbounds [22 x i8], [22 x i8]* @.str.arg_domain, i64 0, i64 0
  br label %cont

sw.case2:
  %msg.case2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.arg_sing, i64 0, i64 0
  br label %cont

sw.case3:
  %msg.case3.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.overflow, i64 0, i64 0
  br label %cont

sw.case4:
  %msg.case4.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.too_small, i64 0, i64 0
  br label %cont

sw.case5:
  %msg.case5.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.total_loss, i64 0, i64 0
  br label %cont

sw.case6:
  %msg.case6.ptr = getelementptr inbounds [29 x i8], [29 x i8]* @.str.partial_loss, i64 0, i64 0
  br label %cont

sw.default:
  %msg.def.ptr = getelementptr inbounds [14 x i8], [14 x i8]* @.str.unknown, i64 0, i64 0
  br label %cont

cont:
  %msg = phi i8* [ %msg.case1.ptr, %sw.case1 ], [ %msg.case2.ptr, %sw.case2 ], [ %msg.case3.ptr, %sw.case3 ], [ %msg.case4.ptr, %sw.case4 ], [ %msg.case5.ptr, %sw.case5 ], [ %msg.case6.ptr, %sw.case6 ], [ %msg.def.ptr, %sw.default ]
  %name.ptrptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rec, i32 0, i32 2
  %name = load i8*, i8** %name.ptrptr, align 8
  %x.ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rec, i32 0, i32 3
  %x = load double, double* %x.ptr, align 8
  %y.ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rec, i32 0, i32 4
  %y = load double, double* %y.ptr, align 8
  %retv.ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rec, i32 0, i32 5
  %retv = load double, double* %retv.ptr, align 8
  %fmt.ptr = getelementptr inbounds [43 x i8], [43 x i8]* @.str.format, i64 0, i64 0
  %file = call %struct._iobuf* @sub_140002AD0(i32 2)
  %call.printf = call i32 @sub_1400029C0(%struct._iobuf* %file, i8* %fmt.ptr, i8* %msg, i8* %name, double %x, double %y, double %retv)
  ret i32 0
}