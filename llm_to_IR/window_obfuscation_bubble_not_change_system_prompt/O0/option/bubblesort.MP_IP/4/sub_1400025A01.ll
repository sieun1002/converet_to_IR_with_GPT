; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002710(i64, i64, i64, i64, i64*)
declare i64 @sub_140002650()
declare i64 @sub_140002728(i64, i64, i64, i64, i64*)

define i64 @sub_1400025A0(i64 %rcx, i64 %rdx, i64 %r8, i64 %r9) local_unnamed_addr {
entry:
  %arr = alloca [3 x i64], align 8
  %p0 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 0
  store i64 %rdx, i64* %p0, align 8
  %p1 = getelementptr inbounds i64, i64* %p0, i64 1
  store i64 %r8, i64* %p1, align 8
  %p2 = getelementptr inbounds i64, i64* %p0, i64 2
  store i64 %r9, i64* %p2, align 8
  %ret1 = call i64 @sub_140002710(i64 1, i64 %rdx, i64 %r8, i64 %r9, i64* %p0)
  %ret2 = call i64 @sub_140002650()
  %ptr = inttoptr i64 %ret2 to i64*
  %loaded = load i64, i64* %ptr, align 8
  %res = call i64 @sub_140002728(i64 %loaded, i64 %ret1, i64 %rcx, i64 0, i64* %p0)
  ret i64 %res
}