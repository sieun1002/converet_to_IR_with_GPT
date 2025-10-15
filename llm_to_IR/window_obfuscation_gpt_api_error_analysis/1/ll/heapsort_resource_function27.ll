; ModuleID = 'pe_check'
source_filename = "sub_1400024F0"
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* noundef %rcx) local_unnamed_addr #0 {
entry:
  %ptr16 = bitcast i8* %rcx to i16*
  %m = load i16, i16* %ptr16, align 1
  %mz_ok = icmp eq i16 %m, 23117
  br i1 %mz_ok, label %mz_true, label %ret0

mz_true:
  %p3c = getelementptr i8, i8* %rcx, i64 60
  %p3c32 = bitcast i8* %p3c to i32*
  %e_lfanew = load i32, i32* %p3c32, align 1
  %lfanew64 = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %rcx, i64 %lfanew64
  %pehdr32p = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %pehdr32p, align 1
  %pe_ok = icmp eq i32 %sig, 17744
  br i1 %pe_ok, label %check_opt, label %ret0

check_opt:
  %magic.ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is64 = icmp eq i16 %magic, 523
  %res = zext i1 %is64 to i32
  ret i32 %res

ret0:
  ret i32 0
}

attributes #0 = { nounwind }