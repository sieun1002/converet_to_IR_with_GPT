; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i8*, i64 }

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_140002BA8(i32, i32)
declare { i64, i64 } @sub_1400DA76B(i8*)
declare void @sub_1403CBAAE(i8*)

define i32 @sub_1400022B0(i32 %a1, i8* %a2) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag.nz = icmp ne i32 %flag, 0
  br i1 %flag.nz, label %alloc, label %ret0

ret0:
  ret i32 0

alloc:
  %mem = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %retm1, label %init

retm1:
  ret i32 -1

init:
  %p = bitcast i8* %mem to %struct.S*
  %f0ptr = getelementptr inbounds %struct.S, %struct.S* %p, i32 0, i32 0
  store i32 %a1, i32* %f0ptr, align 4
  %f2ptr = getelementptr inbounds %struct.S, %struct.S* %p, i32 0, i32 2
  store i8* %a2, i8** %f2ptr, align 8
  %call = call { i64, i64 } @sub_1400DA76B(i8* @unk_140007100)
  %rdxval = extractvalue { i64, i64 } %call, 1
  %f3ptr = getelementptr inbounds %struct.S, %struct.S* %p, i32 0, i32 3
  store i64 %rdxval, i64* %f3ptr, align 8
  store i8* %mem, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE(i8* @unk_140007100)
  ret i32 0
}