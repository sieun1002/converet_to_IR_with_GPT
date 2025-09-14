; ModuleID = 'shift_rows.ll'
source_filename = "shift_rows"
target triple = "x86_64-pc-linux-gnu"

define void @shift_rows(i8* %state) {
entry:
  %state.addr = alloca i8*, align 8
  %tmp = alloca i8, align 1
  store i8* %state, i8** %state.addr, align 8

  ; Rotate row 1 left by 1: indices 1,5,9,13
  %s1 = load i8*, i8** %state.addr, align 8
  %p1 = getelementptr inbounds i8, i8* %s1, i64 1
  %v1 = load i8, i8* %p1, align 1
  store i8 %v1, i8* %tmp, align 1
  %s1b = load i8*, i8** %state.addr, align 8
  %p5 = getelementptr inbounds i8, i8* %s1b, i64 5
  %v5 = load i8, i8* %p5, align 1
  store i8 %v5, i8* %p1, align 1
  %s1c = load i8*, i8** %state.addr, align 8
  %p9 = getelementptr inbounds i8, i8* %s1c, i64 9
  %v9 = load i8, i8* %p9, align 1
  store i8 %v9, i8* %p5, align 1
  %s1d = load i8*, i8** %state.addr, align 8
  %p13 = getelementptr inbounds i8, i8* %s1d, i64 13
  %v13 = load i8, i8* %p13, align 1
  store i8 %v13, i8* %p9, align 1
  %t1 = load i8, i8* %tmp, align 1
  store i8 %t1, i8* %p13, align 1

  ; Rotate row 2 left by 2: swap 2 <-> 10
  %s2 = load i8*, i8** %state.addr, align 8
  %p2 = getelementptr inbounds i8, i8* %s2, i64 2
  %v2 = load i8, i8* %p2, align 1
  store i8 %v2, i8* %tmp, align 1
  %s2b = load i8*, i8** %state.addr, align 8
  %p10 = getelementptr inbounds i8, i8* %s2b, i64 10
  %v10 = load i8, i8* %p10, align 1
  store i8 %v10, i8* %p2, align 1
  %t2 = load i8, i8* %tmp, align 1
  store i8 %t2, i8* %p10, align 1

  ; Rotate row 2 left by 2: swap 6 <-> 14
  %s2c = load i8*, i8** %state.addr, align 8
  %p6 = getelementptr inbounds i8, i8* %s2c, i64 6
  %v6 = load i8, i8* %p6, align 1
  store i8 %v6, i8* %tmp, align 1
  %s2d = load i8*, i8** %state.addr, align 8
  %p14 = getelementptr inbounds i8, i8* %s2d, i64 14
  %v14 = load i8, i8* %p14, align 1
  store i8 %v14, i8* %p6, align 1
  %t3 = load i8, i8* %tmp, align 1
  store i8 %t3, i8* %p14, align 1

  ; Rotate row 3 left by 3: indices 3,7,11,15
  %s3 = load i8*, i8** %state.addr, align 8
  %p3 = getelementptr inbounds i8, i8* %s3, i64 3
  %v3 = load i8, i8* %p3, align 1
  store i8 %v3, i8* %tmp, align 1
  %s3b = load i8*, i8** %state.addr, align 8
  %p15 = getelementptr inbounds i8, i8* %s3b, i64 15
  %v15 = load i8, i8* %p15, align 1
  store i8 %v15, i8* %p3, align 1
  %s3c = load i8*, i8** %state.addr, align 8
  %p11 = getelementptr inbounds i8, i8* %s3c, i64 11
  %v11 = load i8, i8* %p11, align 1
  store i8 %v11, i8* %p15, align 1
  %s3d = load i8*, i8** %state.addr, align 8
  %p7 = getelementptr inbounds i8, i8* %s3d, i64 7
  %v7 = load i8, i8* %p7, align 1
  store i8 %v7, i8* %p11, align 1
  %t4 = load i8, i8* %tmp, align 1
  store i8 %t4, i8* %p7, align 1

  ret void
}