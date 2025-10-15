; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @sub_140002AC0(i8*)
declare i32 @sub_140002AC8(i8*, i8*, i32)

define i8* @sub_140002570(i8* %arg) {
entry:
  %len = call i64 @sub_140002AC0(i8* %arg)
  %cmp = icmp ugt i64 %len, 8
  br i1 %cmp, label %fail, label %chkBase

chkBase:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base_i16 = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_i16, align 1
  %mzok = icmp eq i16 %mz, 23117
  br i1 %mzok, label %chkPE, label %fail

chkPE:
  %p_e = getelementptr i8, i8* %base, i64 60
  %p_e_i32 = bitcast i8* %p_e to i32*
  %e = load i32, i32* %p_e_i32, align 1
  %e64 = sext i32 %e to i64
  %nt = getelementptr i8, i8* %base, i64 %e64
  %nt_i32 = bitcast i8* %nt to i32*
  %sig = load i32, i32* %nt_i32, align 1
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %chkOpt, label %fail

chkOpt:
  %p_optmagic = getelementptr i8, i8* %nt, i64 24
  %p_optmagic_i16 = bitcast i8* %p_optmagic to i16*
  %optmagic = load i16, i16* %p_optmagic_i16, align 1
  %isPE32Plus = icmp eq i16 %optmagic, 523
  br i1 %isPE32Plus, label %chkSections, label %fail

chkSections:
  %p_num = getelementptr i8, i8* %nt, i64 6
  %p_num_i16 = bitcast i8* %p_num to i16*
  %num16 = load i16, i16* %p_num_i16, align 1
  %isZero = icmp eq i16 %num16, 0
  br i1 %isZero, label %fail, label %computeFirst

computeFirst:
  %p_optSize = getelementptr i8, i8* %nt, i64 20
  %p_optSize_i16 = bitcast i8* %p_optSize to i16*
  %optSize16 = load i16, i16* %p_optSize_i16, align 1
  %optSize64 = zext i16 %optSize16 to i64
  %secStartOff = add i64 %optSize64, 24
  %firstSec = getelementptr i8, i8* %nt, i64 %secStartOff
  br label %loop

loop:
  %idx = phi i32 [ 0, %computeFirst ], [ %idxNext, %afterCall ]
  %cur = phi i8* [ %firstSec, %computeFirst ], [ %curNext, %afterCall ]
  %ret = call i32 @sub_140002AC8(i8* %cur, i8* %arg, i32 8)
  %isZeroRet = icmp eq i32 %ret, 0
  br i1 %isZeroRet, label %retCur, label %afterCall

afterCall:
  %idxNext = add i32 %idx, 1
  %num16_2 = load i16, i16* %p_num_i16, align 1
  %num32 = zext i16 %num16_2 to i32
  %curNext = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ult i32 %idxNext, %num32
  br i1 %cont, label %loop, label %fail

retCur:
  ret i8* %cur

fail:
  ret i8* null
}