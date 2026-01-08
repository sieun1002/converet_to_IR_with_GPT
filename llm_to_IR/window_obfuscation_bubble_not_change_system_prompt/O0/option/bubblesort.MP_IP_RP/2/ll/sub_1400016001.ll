; ModuleID = 'sub_140001600.ll'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.ctx = type { i32, i32, i8*, double, double, double }

declare dso_local void @sub_140002710(i32)

@aArgumentSingul  = external dso_local global i8
@aArgumentDomain  = external dso_local global i8
@aPartialLossOfS  = external dso_local global i8
@aOverflowRangeE  = external dso_local global i8
@aTheResultIsToo  = external dso_local global i8
@aTotalLossOfSig  = external dso_local global i8
@aUnknownError    = external dso_local global i8

define dso_local void @sub_140001600(%struct.ctx* %0) {
entry:
  %code.ptr = getelementptr inbounds %struct.ctx, %struct.ctx* %0, i32 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  switch i32 %code, label %default [
    i32 0, label %case0
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case2:
  br label %cont

case1:
  br label %cont

case6:
  br label %cont

case3:
  br label %cont

case4:
  br label %cont

case5:
  br label %cont

case0:
  br label %cont

default:
  br label %cont

cont:
  %msg = phi i8* [ @aArgumentSingul, %case2 ],
                [ @aArgumentDomain, %case1 ],
                [ @aPartialLossOfS, %case6 ],
                [ @aOverflowRangeE, %case3 ],
                [ @aTheResultIsToo, %case4 ],
                [ @aTotalLossOfSig, %case5 ],
                [ @aUnknownError, %case0 ],
                [ @aUnknownError, %default ]
  %ptr.ptr = getelementptr inbounds %struct.ctx, %struct.ctx* %0, i32 0, i32 2
  %ptr = load i8*, i8** %ptr.ptr, align 8
  %d0.ptr = getelementptr inbounds %struct.ctx, %struct.ctx* %0, i32 0, i32 3
  %d0 = load double, double* %d0.ptr, align 8
  %d1.ptr = getelementptr inbounds %struct.ctx, %struct.ctx* %0, i32 0, i32 4
  %d1 = load double, double* %d1.ptr, align 8
  %d2.ptr = getelementptr inbounds %struct.ctx, %struct.ctx* %0, i32 0, i32 5
  %d2 = load double, double* %d2.ptr, align 8
  call void @sub_140002710(i32 2)
  ret void
}