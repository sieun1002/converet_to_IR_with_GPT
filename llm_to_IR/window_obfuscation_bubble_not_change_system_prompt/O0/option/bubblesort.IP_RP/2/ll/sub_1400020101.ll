; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external global i8*, align 8
@dword_1400070E8 = external global i32, align 4
@unk_140007100 = external global i8, align 1

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @loc_1400027F0(i8*)
declare i32 @sub_1400FEC71(i8*)
declare void @loc_1400E441D(i8*)

define i32 @sub_140002010(i8* %rcx, i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp_edx_2 = icmp eq i32 %edx, 2
  br i1 %cmp_edx_2, label %loc_20D8, label %after_cmp2

after_cmp2:                                         ; 0x14000201d
  %edx_gt_2 = icmp ugt i32 %edx, 2
  br i1 %edx_gt_2, label %loc_2048, label %loc_201f

loc_201f:                                           ; 0x14000201f
  %edx_is_zero = icmp eq i32 %edx, 0
  br i1 %edx_is_zero, label %loc_2060, label %loc_2023

loc_2023:                                           ; 0x140002023
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %loc_2100, label %loc_2031

loc_2031:                                           ; 0x140002031
  store i32 1, i32* @dword_1400070E8, align 4
  br label %loc_203b

loc_203b:                                           ; 0x14000203b
  ret i32 1

loc_2048:                                           ; 0x140002048
  %edx_ne_3 = icmp ne i32 %edx, 3
  br i1 %edx_ne_3, label %loc_203b, label %loc_204d

loc_204d:                                           ; 0x14000204d
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %loc_203b, label %loc_2057

loc_2057:                                           ; 0x140002057
  call void @sub_140001E80()
  br label %loc_2060

loc_2060:                                           ; 0x140002060
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %loc_20F0, label %loc_206e

loc_206e:                                           ; 0x14000206e
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_is_one = icmp eq i32 %g4, 1
  br i1 %g4_is_one, label %loc_2079, label %loc_203b

loc_2079:                                           ; 0x140002079
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %loc_20ab, label %loop

loop:                                               ; corresponds to 0x140002090..0x1400020A9
  %cur = phi i8* [ %head, %loc_2079 ], [ %next2, %loc_iter_cont ]
  %next_addr = getelementptr i8, i8* %cur, i64 16
  %next_ptr = bitcast i8* %next_addr to i8**
  %next = load i8*, i8** %next_ptr, align 8
  store i8* %next, i8** %var10, align 8
  call void @loc_1400027F0(i8* %cur)
  %next2 = load i8*, i8** %var10, align 8
  %has_next = icmp ne i8* %next2, null
  br i1 %has_next, label %loc_iter_cont, label %loc_20ab

loc_iter_cont:
  br label %loop

loc_20ab:                                           ; 0x1400020ab
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %rcx_cleanup = bitcast i8* @unk_140007100 to i8*
  %call_cleanup = call i32 @sub_1400FEC71(i8* %rcx_cleanup)
  br label %loc_20D8

loc_20F0:                                           ; 0x1400020f0
  call void @sub_140001E80()
  br label %loc_2100

loc_2100:                                           ; 0x140002100
  %rcx_init = bitcast i8* @unk_140007100 to i8*
  call void @loc_1400E441D(i8* %rcx_init)
  br label %loc_2031

loc_20D8:                                           ; 0x1400020d8
  call void @sub_140002120()
  ret i32 1
}