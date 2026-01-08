; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140001E80()
declare void @sub_1400027F0(i8*)
declare void @sub_1400CDFE0(i8*)
declare void @sub_140002120()
declare void @sub_1400E50C4(i8*, i32)

define i32 @sub_140002010(i32 %edx) {
entry:
  %var_next = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %loc_20D8, label %after_cmp2

after_cmp2:                                       ; 0x14000201d
  %gt2 = icmp ugt i32 %edx, 2
  br i1 %gt2, label %loc_2048, label %loc_201f

loc_201f:                                         ; 0x14000201f
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %loc_2060, label %loc_2023

loc_2023:                                         ; 0x140002023
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %loc_2100, label %loc_2031

loc_2100:                                         ; 0x140002100
  call void @sub_1400E50C4(i8* @unk_140007100, i32 %edx)
  br label %loc_2031

loc_2031:                                         ; 0x140002031
  store i32 1, i32* @dword_1400070E8, align 4
  br label %loc_203B

loc_203B:                                         ; 0x14000203b
  ret i32 1

loc_2048:                                         ; 0x140002048
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %loc_204d, label %loc_203B

loc_204d:                                         ; 0x14000204d
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %loc_203B, label %loc_2057

loc_2057:                                         ; 0x140002057
  call void @sub_140001E80()
  br label %loc_203B

loc_2060:                                         ; 0x140002060
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %loc_20F0, label %loc_206E

loc_20F0:                                         ; 0x1400020f0
  call void @sub_140001E80()
  br label %loc_206E

loc_206E:                                         ; 0x14000206e
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g4, 1
  br i1 %is1, label %loc_2079, label %loc_203B

loc_2079:                                         ; 0x140002079
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %loc_20AB, label %loc_2090

loc_2090:                                         ; 0x140002090
  br label %loop_header

loop_header:
  %cur = phi i8* [ %head, %loc_2090 ], [ %next_reload, %loc_20A9 ]
  %byteptr = getelementptr i8, i8* %cur, i64 16
  %next_addr = bitcast i8* %byteptr to i8**
  %next = load i8*, i8** %next_addr, align 8
  store i8* %next, i8** %var_next, align 8
  call void @sub_1400027F0(i8* %cur)
  %next_reload = load i8*, i8** %var_next, align 8
  %hasnext = icmp ne i8* %next_reload, null
  br i1 %hasnext, label %loc_20A9, label %loc_20AB

loc_20A9:                                         ; 0x1400020a9
  br label %loop_header

loc_20AB:                                         ; 0x1400020ab
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1400CDFE0(i8* @unk_140007100)
  br label %loc_20D8

loc_20D8:                                         ; 0x1400020d8
  call void @sub_140002120()
  br label %loc_203B
}