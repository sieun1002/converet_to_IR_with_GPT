; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i8* @sub_140002750() local_unnamed_addr {
entry:
  %g = load i8*, i8** @off_1400043A0, align 8
  %p16 = bitcast i8* %g to i16*
  %w = load i16, i16* %p16, align 1
  %cmp_mz = icmp eq i16 %w, 23117
  br i1 %cmp_mz, label %pe, label %ret0

pe:
  %p32ptr_i8 = getelementptr i8, i8* %g, i64 60
  %p32ptr = bitcast i8* %p32ptr_i8 to i32*
  %off32 = load i32, i32* %p32ptr, align 1
  %off64 = sext i32 %off32 to i64
  %nt = getelementptr i8, i8* %g, i64 %off64
  %nts1 = bitcast i8* %nt to i32*
  %sig = load i32, i32* %nts1, align 1
  %cmppe = icmp eq i32 %sig, 17744
  br i1 %cmppe, label %magic, label %ret0

magic:
  %moffs = getelementptr i8, i8* %nt, i64 24
  %mptr = bitcast i8* %moffs to i16*
  %magicv = load i16, i16* %mptr, align 1
  %isplus = icmp eq i16 %magicv, 523
  %retv = select i1 %isplus, i8* %g, i8* null
  ret i8* %retv

ret0:
  ret i8* null
}