; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*, align 8

declare i8* @sub_1400027A8(i32 %ecx, i32 %edx)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8* %rcx) {
entry:
  %rax.current = alloca i8*, align 8
  %rbx.save = alloca i8*, align 8
  store i8* %rcx, i8** %rbx.save, align 8
  %0 = bitcast i8* %rcx to i8**
  %1 = load i8*, i8** %0, align 8
  %2 = bitcast i8* %1 to i32*
  %3 = load i32, i32* %2, align 4
  %4 = and i32 %3, 553648127
  %5 = icmp eq i32 %4, 542393283
  br i1 %5, label %loc_140001D60, label %loc_140001CD1

loc_140001D60:
  %ptr.plus4 = getelementptr i8, i8* %1, i64 4
  %6 = load i8, i8* %ptr.plus4, align 1
  %7 = and i8 %6, 1
  %8 = icmp ne i8 %7, 0
  br i1 %8, label %loc_140001CD1, label %default_to_def

default_to_def:
  store i8* blockaddress(@sub_140001CB0, %loc_140001D54), i8** %rax.current, align 8
  br label %def_dispatch

loc_140001CD1:
  %9 = icmp ugt i32 %3, 3221225622
  br i1 %9, label %loc_140001D1F, label %cd1.cont

cd1.cont:
  %10 = icmp ule i32 %3, 3221225611
  br i1 %10, label %loc_140001D40, label %range_table

range_table:
  %11 = add i32 %3, 1073741683
  %12 = icmp ugt i32 %11, 9
  br i1 %12, label %default_to_def, label %switch_dispatch

switch_dispatch:
  switch i32 %11, label %default_to_def [
    i32 0, label %loc_140001D00
    i32 1, label %loc_140001D00
    i32 2, label %loc_140001D00
    i32 3, label %loc_140001D00
    i32 4, label %loc_140001D00
    i32 6, label %loc_140001D00
    i32 7, label %loc_140001DC0
    i32 9, label %loc_140001D8E
  ]

loc_140001D00:
  %13 = call i8* @sub_1400027A8(i32 8, i32 0)
  %v13_int = ptrtoint i8* %13 to i64
  %is.one.d00 = icmp eq i64 %v13_int, 1
  br i1 %is.one.d00, label %loc_140001E54, label %d00.after.one

d00.after.one:
  %is.zero.d00 = icmp eq i8* %13, null
  br i1 %is.zero.d00, label %loc_140001D1F, label %loc_140001E20.prelude

loc_140001E20.prelude:
  store i8* %13, i8** %rax.current, align 8
  br label %loc_140001E20

loc_140001D1F:
  %gptr = load i8*, i8** @qword_1400070D0, align 8
  %isnull = icmp eq i8* %gptr, null
  br i1 %isnull, label %loc_140001D70, label %loc_140001D2B

loc_140001D2B:
  %rbx.val = load i8*, i8** %rbx.save, align 8
  %fp.qword = bitcast i8* %gptr to i32 (i8*)*
  %res.tail = tail call i32 %fp.qword(i8* %rbx.val)
  ret i32 %res.tail

loc_140001D40:
  %cmp_5 = icmp eq i32 %3, 3221225477
  br i1 %cmp_5, label %loc_140001DF0, label %d40.after5

d40.after5:
  %gt_5 = icmp ugt i32 %3, 3221225477
  br i1 %gt_5, label %loc_140001D80, label %d40.le5

d40.le5:
  %cmp_80000002 = icmp eq i32 %3, 2147483650
  br i1 %cmp_80000002, label %loc_140001D54, label %loc_140001D1F

loc_140001D54:
  ret i32 -1

loc_140001D70:
  ret i32 0

loc_140001D80:
  %eq_8 = icmp eq i32 %3, 3221225480
  br i1 %eq_8, label %default_to_def, label %d80.after8

d80.after8:
  %eq_1d = icmp eq i32 %3, 3221225501
  br i1 %eq_1d, label %loc_140001D8E, label %loc_140001D1F

loc_140001D8E:
  %14 = call i8* @sub_1400027A8(i32 4, i32 0)
  %v14_int = ptrtoint i8* %14 to i64
  %is.one.d8e = icmp eq i64 %v14_int, 1
  br i1 %is.one.d8e, label %loc_140001E40, label %d8e.after.one

d8e.after.one:
  %is.zero.d8e = icmp eq i8* %14, null
  br i1 %is.zero.d8e, label %loc_140001D1F, label %d8e.callfp

d8e.callfp:
  %fp.d8e = bitcast i8* %14 to i8* (i32)*
  %retptr.d8e = call i8* %fp.d8e(i32 4)
  store i8* %retptr.d8e, i8** %rax.current, align 8
  br label %def_dispatch

loc_140001DC0:
  %15 = call i8* @sub_1400027A8(i32 8, i32 0)
  %v15_int = ptrtoint i8* %15 to i64
  %is.one.dc0 = icmp eq i64 %v15_int, 1
  br i1 %is.one.dc0, label %loc_140001DD6, label %dc0.notone

dc0.notone:
  store i8* %15, i8** %rax.current, align 8
  br label %loc_140001D16

loc_140001DD6:
  %16 = call i8* @sub_1400027A8(i32 8, i32 1)
  store i8* %16, i8** %rax.current, align 8
  br label %def_dispatch

loc_140001DF0:
  %17 = call i8* @sub_1400027A8(i32 11, i32 0)
  %v17_int = ptrtoint i8* %17 to i64
  %is.one.df0 = icmp eq i64 %v17_int, 1
  br i1 %is.one.df0, label %loc_140001E2C, label %df0.after.one

df0.after.one:
  %is.zero.df0 = icmp eq i8* %17, null
  br i1 %is.zero.df0, label %loc_140001D1F, label %df0.callfp

df0.callfp:
  %fp.df0 = bitcast i8* %17 to i8* (i32)*
  %retptr.df0 = call i8* %fp.df0(i32 11)
  store i8* %retptr.df0, i8** %rax.current, align 8
  br label %def_dispatch

loc_140001D16:
  %cur = load i8*, i8** %rax.current, align 8
  %is.nz = icmp ne i8* %cur, null
  br i1 %is.nz, label %loc_140001E20, label %loc_140001D1F

loc_140001E20:
  %cur.fp = load i8*, i8** %rax.current, align 8
  %fp.call = bitcast i8* %cur.fp to i8* (i32)*
  %retptr.e20 = call i8* %fp.call(i32 8)
  store i8* %retptr.e20, i8** %rax.current, align 8
  br label %def_dispatch

loc_140001E2C:
  %18 = call i8* @sub_1400027A8(i32 11, i32 1)
  store i8* %18, i8** %rax.current, align 8
  br label %def_dispatch

loc_140001E40:
  %19 = call i8* @sub_1400027A8(i32 4, i32 1)
  store i8* %19, i8** %rax.current, align 8
  br label %def_dispatch

loc_140001E54:
  %20 = call i8* @sub_1400027A8(i32 8, i32 1)
  store i8* %20, i8** %rax.current, align 8
  call void @sub_140002120()
  br label %def_dispatch

def_dispatch:
  %tgt = load i8*, i8** %rax.current, align 8
  indirectbr i8* %tgt, [
    label %loc_140001D16,
    label %loc_140001D1F,
    label %loc_140001D40,
    label %loc_140001D70,
    label %loc_140001DF0,
    label %loc_140001E20,
    label %loc_140001E2C,
    label %loc_140001E40,
    label %loc_140001E54,
    label %loc_140001D54
  ]
}