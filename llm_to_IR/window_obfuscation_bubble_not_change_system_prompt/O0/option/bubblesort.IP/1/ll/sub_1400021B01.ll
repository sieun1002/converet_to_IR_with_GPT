; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

declare dso_local i64 @sub_140002700()
declare dso_local i32 @sub_140002708(i8*, i8*, i32)

define dso_local i8* @sub_1400021B0(i8* %arg) {
entry:
  %call0 = call i64 @sub_140002700()
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %fail, label %checkMZ

checkMZ:                                          ; preds = %entry
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %pwordptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %pwordptr, align 1
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %ntheader, label %fail

ntheader:                                         ; preds = %checkMZ
  %offptr = getelementptr inbounds i8, i8* %baseptr, i64 60
  %off32ptr = bitcast i8* %offptr to i32*
  %off32 = load i32, i32* %off32ptr, align 1
  %off64 = sext i32 %off32 to i64
  %nt = getelementptr inbounds i8, i8* %baseptr, i64 %off64
  %peptr = bitcast i8* %nt to i32*
  %pe = load i32, i32* %peptr, align 1
  %isPE = icmp eq i32 %pe, 17744
  br i1 %isPE, label %checkMagic, label %fail

checkMagic:                                       ; preds = %ntheader
  %magicptr = getelementptr inbounds i8, i8* %nt, i64 24
  %magicfield = bitcast i8* %magicptr to i16*
  %magic = load i16, i16* %magicfield, align 1
  %isPE32plus = icmp eq i16 %magic, 523
  br i1 %isPE32plus, label %checkNumSec, label %fail

checkNumSec:                                      ; preds = %checkMagic
  %numsecptr_offset = getelementptr inbounds i8, i8* %nt, i64 6
  %numsecptr = bitcast i8* %numsecptr_offset to i16*
  %numsec = load i16, i16* %numsecptr, align 1
  %isZero = icmp eq i16 %numsec, 0
  br i1 %isZero, label %fail, label %calcFirst

calcFirst:                                        ; preds = %checkNumSec
  %soh_ptr = getelementptr inbounds i8, i8* %nt, i64 20
  %soh_p = bitcast i8* %soh_ptr to i16*
  %soh = load i16, i16* %soh_p, align 1
  %soh_zext = zext i16 %soh to i64
  %nt_plus_0x18 = getelementptr inbounds i8, i8* %nt, i64 24
  %firstsec = getelementptr inbounds i8, i8* %nt_plus_0x18, i64 %soh_zext
  br label %loop

loop:                                             ; preds = %aftercheck, %calcFirst
  %i = phi i32 [ 0, %calcFirst ], [ %i.next, %aftercheck ]
  %cur = phi i8* [ %firstsec, %calcFirst ], [ %cur.next, %aftercheck ]
  %call = call i32 @sub_140002708(i8* %cur, i8* %arg, i32 8)
  %eqz = icmp eq i32 %call, 0
  br i1 %eqz, label %success, label %aftercheck

aftercheck:                                       ; preds = %loop
  %numsec2 = load i16, i16* %numsecptr, align 1
  %numsec32 = zext i16 %numsec2 to i32
  %i.next = add i32 %i, 1
  %cur.next = getelementptr inbounds i8, i8* %cur, i64 40
  %cont = icmp ult i32 %i.next, %numsec32
  br i1 %cont, label %loop, label %fail

success:                                          ; preds = %loop
  ret i8* %cur

fail:                                             ; preds = %aftercheck, %checkNumSec, %checkMagic, %ntheader, %checkMZ, %entry
  ret i8* null
}