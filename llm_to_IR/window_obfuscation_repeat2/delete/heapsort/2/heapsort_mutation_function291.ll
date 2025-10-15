; ModuleID = 'peutils'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002690() {
entry:
  %p0 = load i8*, i8** @off_1400043A0, align 8
  %p16 = bitcast i8* %p0 to i16*
  %w0 = load i16, i16* %p16, align 1
  %cmpMZ = icmp eq i16 %w0, 23117
  br i1 %cmpMZ, label %mz_ok, label %ret0

mz_ok:
  %p3c = getelementptr i8, i8* %p0, i64 60
  %p3c32 = bitcast i8* %p3c to i32*
  %lfanew = load i32, i32* %p3c32, align 1
  %lfanew64 = sext i32 %lfanew to i64
  %nt = getelementptr i8, i8* %p0, i64 %lfanew64
  %nt32ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %nt32ptr, align 1
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %pe_ok, label %ret0

pe_ok:
  %nt_plus_24 = getelementptr i8, i8* %nt, i64 24
  %magicptr = bitcast i8* %nt_plus_24 to i16*
  %magic = load i16, i16* %magicptr, align 1
  %is64 = icmp eq i16 %magic, 523
  br i1 %is64, label %ok64, label %ret0

ok64:
  %nt_plus_6 = getelementptr i8, i8* %nt, i64 6
  %nsptr = bitcast i8* %nt_plus_6 to i16*
  %ns = load i16, i16* %nsptr, align 1
  %zext = zext i16 %ns to i32
  ret i32 %zext

ret0:
  ret i32 0
}