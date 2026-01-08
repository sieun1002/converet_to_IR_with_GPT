; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @sub_140001E80(...)
declare void @sub_1400027F0(...)
declare void @sub_1400CDFE0(...)
declare void @sub_1400E50C4(...)
declare void @sub_140002120(...)

define dso_local i32 @sub_140002010(i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %loc_1400020D8, label %cmp_gt

cmp_gt:                                           ; edx != 2
  %gt2 = icmp ugt i32 %edx, 2
  br i1 %gt2, label %loc_140002048, label %test_zero

test_zero:                                        ; 0x14000201F
  %iszero = icmp eq i32 %edx, 0
  br i1 %iszero, label %loc_140002060, label %loc_140002023

loc_140002023:                                    ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1iszero = icmp eq i32 %g1, 0
  br i1 %g1iszero, label %loc_140002100, label %loc_140002031

loc_140002031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

loc_140002048:                                    ; edx > 2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %loc_14000204D, label %ret1

loc_14000204D:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2iszero = icmp eq i32 %g2, 0
  br i1 %g2iszero, label %ret1, label %loc_140002057

loc_140002057:
  call void (...) @sub_140001E80()
  br label %ret1

loc_140002060:                                    ; edx == 0
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3nz = icmp ne i32 %g3, 0
  br i1 %g3nz, label %loc_1400020F0, label %loc_14000206E

loc_1400020F0:
  call void (...) @sub_140001E80()
  br label %loc_14000206E

loc_14000206E:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g4, 1
  br i1 %is1, label %iter_entry, label %ret1

iter_entry:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %headnull = icmp eq i8* %head, null
  br i1 %headnull, label %loc_1400020AB, label %loop_body

loop_body:
  %cur = phi i8* [ %head, %iter_entry ], [ %next, %after_call ]
  %nextptr.raw = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextptr.raw to i8**
  %next.pre = load i8*, i8** %nextptr, align 8
  store i8* %next.pre, i8** %var10, align 8
  call void (...) @sub_1400027F0()
  br label %after_call

after_call:
  %next = load i8*, i8** %var10, align 8
  %hasnext = icmp ne i8* %next, null
  br i1 %hasnext, label %loop_body, label %loc_1400020AB

loc_1400020AB:
  %p_unk = bitcast i8* addrspace(0)* null to i8*        ; placeholder to satisfy SSA (not used)
  ; rcx = &unk_140007100
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void (...) @sub_1400CDFE0()
  br label %ret1

loc_1400020D8:
  call void (...) @sub_140002120()
  br label %ret1

loc_140002100:
  call void (...) @sub_1400E50C4()
  br label %loc_140002031

ret1:
  ret i32 1
}