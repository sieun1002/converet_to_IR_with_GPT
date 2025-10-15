; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002750() local_unnamed_addr {
entry:
  %gptr = load i8*, i8** @off_1400043A0, align 8
  %p16 = bitcast i8* %gptr to i16*
  %sig = load i16, i16* %p16, align 1
  %isMZ = icmp eq i16 %sig, 23117
  br i1 %isMZ, label %checkPE, label %retzero

checkPE:
  %offptr = getelementptr i8, i8* %gptr, i64 60
  %off32ptr = bitcast i8* %offptr to i32*
  %off32 = load i32, i32* %off32ptr, align 1
  %off64 = sext i32 %off32 to i64
  %pehdr = getelementptr i8, i8* %gptr, i64 %off64
  %pe32ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pe32ptr, align 1
  %isPE = icmp eq i32 %pesig, 17744
  br i1 %isPE, label %checkOpt, label %retzero

checkOpt:
  %optptr = getelementptr i8, i8* %pehdr, i64 24
  %opt16ptr = bitcast i8* %optptr to i16*
  %opt = load i16, i16* %opt16ptr, align 1
  %isPE32plus = icmp eq i16 %opt, 523
  %ret = select i1 %isPE32plus, i8* %gptr, i8* null
  ret i8* %ret

retzero:
  ret i8* null
}