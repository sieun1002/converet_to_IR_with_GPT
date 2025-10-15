; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aVirtualprotect = external constant i8*
@aVirtualqueryFa = external constant i8*
@aAddressPHasNoI = external constant i8*

declare i8* @sub_1400026F0(i8*)
declare i8* @sub_140002830()
declare i64 @loc_1403EC46A(i8*, i8*, i64)
declare i32 @sub_14030637B(i8*, i64, i32, i8*)
declare void @sub_140001BA0(i8*, ...)

define void @sub_140001C00(i8* %addr) {
entry:
  %sval = load i32, i32* @dword_1400070A4, align 4
  %spos = icmp sgt i32 %sval, 0
  br i1 %spos, label %loop.init, label %noentries

loop.init:                                         ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  br label %loop

loop:                                              ; preds = %loop.next, %loop.init
  %i = phi i32 [ 0, %loop.init ], [ %inext, %loop.next ]
  %base1 = phi i8* [ %base0, %loop.init ], [ %base0, %loop.next ]
  %i64 = sext i32 %i to i64
  %off = mul i64 %i64, 40
  %entryptr.off = add i64 %off, 24
  %entryptr = getelementptr i8, i8* %base1, i64 %entryptr.off
  %start.ptr.ptr = bitcast i8* %entryptr to i8**
  %start.ptr = load i8*, i8** %start.ptr.ptr, align 8
  %addr.i64 = ptrtoint i8* %addr to i64
  %start.i64 = ptrtoint i8* %start.ptr to i64
  %addr_below = icmp ult i64 %addr.i64, %start.i64
  br i1 %addr_below, label %loop.next, label %range.check

range.check:                                       ; preds = %loop
  %sz.ptr.loc = getelementptr i8, i8* %entryptr, i64 8
  %sz.ptr.ptr = bitcast i8* %sz.ptr.loc to i8**
  %sz.base = load i8*, i8** %sz.ptr.ptr, align 8
  %sz.field.loc = getelementptr i8, i8* %sz.base, i64 8
  %sz32.ptr = bitcast i8* %sz.field.loc to i32*
  %sz32 = load i32, i32* %sz32.ptr, align 4
  %sz64 = zext i32 %sz32 to i64
  %end.i64 = add i64 %start.i64, %sz64
  %inrange = icmp ult i64 %addr.i64, %end.i64
  br i1 %inrange, label %ret, label %loop.next

loop.next:                                         ; preds = %range.check, %loop
  %inext = add i32 %i, 1
  %cmp.cont = icmp slt i32 %inext, %sval
  br i1 %cmp.cont, label %loop, label %noentries

noentries:                                         ; preds = %loop.next, %entry
  %idx.sel = phi i32 [ 0, %entry ], [ %sval, %loop.next ]
  %img = call i8* @sub_1400026F0(i8* %addr)
  %isnull = icmp eq i8* %img, null
  br i1 %isnull, label %noimage, label %haveimage

noimage:                                           ; preds = %noentries
  %fmt.noimg = load i8*, i8** @aAddressPHasNoI, align 8
  call void (i8*, ...) @sub_140001BA0(i8* %fmt.noimg, i8* %addr)
  br label %ret

haveimage:                                         ; preds = %noentries
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %idx.sel to i64
  %entoff = mul i64 %idx64, 40
  %entry.base = getelementptr i8, i8* %base2, i64 %entoff
  %entry.plus20 = getelementptr i8, i8* %entry.base, i64 32
  %entry.plus20.p = bitcast i8* %entry.plus20 to i8**
  store i8* %img, i8** %entry.plus20.p, align 8
  %entry.dword = bitcast i8* %entry.base to i32*
  store i32 0, i32* %entry.dword, align 4
  %ret830 = call i8* @sub_140002830()
  %img.plus0C = getelementptr i8, i8* %img, i64 12
  %img.plus0C.p = bitcast i8* %img.plus0C to i32*
  %ofs32 = load i32, i32* %img.plus0C.p, align 4
  %ofs64 = zext i32 %ofs32 to i64
  %rcxptr = getelementptr i8, i8* %ret830, i64 %ofs64
  %entry.plus18 = getelementptr i8, i8* %entry.base, i64 24
  %entry.plus18.p = bitcast i8* %entry.plus18 to i8**
  store i8* %rcxptr, i8** %entry.plus18.p, align 8
  %mbi = alloca [48 x i8], align 8
  %mbi.base = getelementptr [48 x i8], [48 x i8]* %mbi, i64 0, i64 0
  %qres = call i64 @loc_1403EC46A(i8* %rcxptr, i8* %mbi.base, i64 48)
  %qzero = icmp eq i64 %qres, 0
  br i1 %qzero, label %vqfail, label %vqok

vqok:                                              ; preds = %haveimage
  %prot.ptr.loc = getelementptr i8, i8* %mbi.base, i64 36
  %prot.ptr = bitcast i8* %prot.ptr.loc to i32*
  %prot = load i32, i32* %prot.ptr, align 4
  %t1 = add i32 %prot, -4
  %t2 = and i32 %t1, -5
  %allow1 = icmp eq i32 %t2, 0
  br i1 %allow1, label %allow, label %check2

check2:                                            ; preds = %vqok
  %t3 = add i32 %prot, -64
  %t4 = and i32 %t3, -65
  %allow2 = icmp eq i32 %t4, 0
  br i1 %allow2, label %allow, label %tryprotect

allow:                                             ; preds = %check2, %vqok
  %cur = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %cur, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  br label %ret

tryprotect:                                        ; preds = %check2
  %isro = icmp eq i32 %prot, 2
  %prot.default = select i1 %isro, i32 4, i32 64
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry.base2 = getelementptr i8, i8* %base3, i64 %entoff
  %mbi.baseaddr.p = bitcast i8* %mbi.base to i8**
  %baseaddr = load i8*, i8** %mbi.baseaddr.p, align 8
  %entry.plus8 = getelementptr i8, i8* %entry.base2, i64 8
  %entry.plus8.p = bitcast i8* %entry.plus8 to i8**
  store i8* %baseaddr, i8** %entry.plus8.p, align 8
  %region.size.loc = getelementptr i8, i8* %mbi.base, i64 24
  %region.size.p = bitcast i8* %region.size.loc to i64*
  %region.size = load i64, i64* %region.size.p, align 8
  %entry.plus10 = getelementptr i8, i8* %entry.base2, i64 16
  %entry.plus10.p = bitcast i8* %entry.plus10 to i64*
  store i64 %region.size, i64* %entry.plus10.p, align 8
  %protres = call i32 @sub_14030637B(i8* %baseaddr, i64 %region.size, i32 %prot.default, i8* %entry.base2)
  %fmt.vp = load i8*, i8** @aVirtualprotect, align 8
  call void (i8*, ...) @sub_140001BA0(i8* %fmt.vp, i32 %protres)
  br label %ret

vqfail:                                            ; preds = %haveimage
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %entry.base3 = getelementptr i8, i8* %base4, i64 %entoff
  %entry.plus18.2 = getelementptr i8, i8* %entry.base3, i64 24
  %entry.plus18.2.p = bitcast i8* %entry.plus18.2 to i8**
  %addr.for.msg = load i8*, i8** %entry.plus18.2.p, align 8
  %size32.loc = getelementptr i8, i8* %img, i64 8
  %size32.p = bitcast i8* %size32.loc to i32*
  %size32 = load i32, i32* %size32.p, align 4
  %fmt.vq = load i8*, i8** @aVirtualqueryFa, align 8
  call void (i8*, ...) @sub_140001BA0(i8* %fmt.vq, i32 %size32, i8* %addr.for.msg)
  br label %ret

ret:                                               ; preds = %vqfail, %tryprotect, %allow, %noimage, %range.check
  ret void
}