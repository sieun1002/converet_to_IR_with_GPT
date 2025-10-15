; Target: Windows x86_64 MSVC
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"Argument singularity\00", align 1
@aArgumentDomain = private unnamed_addr constant [22 x i8] c"Argument domain error\00", align 1
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"Partial loss of significance\00", align 1
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"Overflow range error\00", align 1
@aTheResultIsToo = private unnamed_addr constant [23 x i8] c"The result is too large\00", align 1
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"Total loss of significance\00", align 1
@aUnknownError   = private unnamed_addr constant [14 x i8] c"Unknown error\00", align 1
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, ...)

define dso_local i32 @sub_1400019D0(i8* %p) {
entry:
  %p_i32 = bitcast i8* %p to i32*
  %type = load i32, i32* %p_i32, align 4
  switch i32 %type, label %case_unknown [
    i32 0, label %case_unknown
    i32 1, label %case_domain
    i32 2, label %case_singularity
    i32 3, label %case_overflow
    i32 4, label %case_toolarge
    i32 5, label %case_total_loss
    i32 6, label %case_partial_loss
  ]

case_singularity:
  %sing_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %dispatch

case_domain:
  %dom_ptr = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %dispatch

case_overflow:
  %ovf_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %dispatch

case_toolarge:
  %toolarge_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %dispatch

case_total_loss:
  %totloss_ptr = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %dispatch

case_partial_loss:
  %partloss_ptr = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %dispatch

case_unknown:
  %unk_ptr = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %dispatch

dispatch:
  %msg = phi i8* [ %sing_ptr, %case_singularity ],
               [ %dom_ptr, %case_domain ],
               [ %ovf_ptr, %case_overflow ],
               [ %toolarge_ptr, %case_toolarge ],
               [ %totloss_ptr, %case_total_loss ],
               [ %partloss_ptr, %case_partial_loss ],
               [ %unk_ptr, %case_unknown ]

  %p_pcharptr = bitcast i8* %p to i8**
  %name_ptr_ptr = getelementptr inbounds i8*, i8** %p_pcharptr, i64 1
  %name = load i8*, i8** %name_ptr_ptr, align 8

  %p_double = bitcast i8* %p to double*
  %arg1_ptr = getelementptr inbounds double, double* %p_double, i64 2
  %arg1 = load double, double* %arg1_ptr, align 8
  %arg2_ptr = getelementptr inbounds double, double* %p_double, i64 3
  %arg2 = load double, double* %arg2_ptr, align 8
  %retval_ptr = getelementptr inbounds double, double* %p_double, i64 4
  %retval = load double, double* %retval_ptr, align 8

  %file = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* %file, i8* %fmt, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}