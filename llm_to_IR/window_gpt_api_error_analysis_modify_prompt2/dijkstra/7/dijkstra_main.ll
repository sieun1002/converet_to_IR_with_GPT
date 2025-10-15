; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00"
@aDistZuZuD = internal constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"
@aNoPathFromZuTo = internal constant [25 x i8] c"no path from %zu to %zu\0A\00"
@aPathZuZu = internal constant [17 x i8] c"path %zu -> %zu:\00"
@asc_140004059 = internal constant [4 x i8] c" ->\00"
@unk_14000405D = internal constant [1 x i8] c"\00"
@aZuS = internal constant [7 x i8] c" %zu%s\00"

declare i32 @printf(i8*, ...)
declare void @dijkstra(i32*, i64, i64, i32*, i32*)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %N = alloca i64, align 8
  %idx = alloca i64, align 8
  %i = alloca i64, align 8
  %var_DC = alloca i32, align 4
  %var_D8 = alloca i32, align 4
  %var_D4 = alloca i32, align 4
  %src = alloca i64, align 8
  %j = alloca i64, align 8
  %dest = alloca i64, align 8
  %count = alloca i64, align 8
  %cur = alloca i32, align 4
  %iter = alloca i64, align 8
  %curElem = alloca i64, align 8
  %distArr = alloca [6 x i32], align 16
  %predArr = alloca [6 x i32], align 16
  %adjArr = alloca [36 x i32], align 16
  %pathArr = alloca [6 x i64], align 16
  store i64 6, i64* %N, align 8
  store i64 0, i64* %idx, align 8
  br label %fill_check

fill_body:                                        ; preds = %fill_check
  %k = load i64, i64* %idx, align 8
  %adjbase = getelementptr inbounds [36 x i32], [36 x i32]* %adjArr, i64 0, i64 0
  %ptrk = getelementptr inbounds i32, i32* %adjbase, i64 %k
  store i32 -1, i32* %ptrk, align 4
  %k.next = add i64 %k, 1
  store i64 %k.next, i64* %idx, align 8
  br label %fill_check

fill_check:                                       ; preds = %fill_body, %entry
  %idx.cur = load i64, i64* %idx, align 8
  %Nval = load i64, i64* %N, align 8
  %N2 = mul i64 %Nval, %Nval
  %cmpfill = icmp ult i64 %idx.cur, %N2
  br i1 %cmpfill, label %fill_body, label %after_fill

after_fill:                                       ; preds = %fill_check
  store i64 0, i64* %i, align 8
  br label %diag_check

diag_body:                                        ; preds = %diag_check
  %ival = load i64, i64* %i, align 8
  %Nval2 = load i64, i64* %N, align 8
  %Np1 = add i64 %Nval2, 1
  %idxdiag = mul i64 %Np1, %ival
  %adjbase2 = getelementptr inbounds [36 x i32], [36 x i32]* %adjArr, i64 0, i64 0
  %pdiag = getelementptr inbounds i32, i32* %adjbase2, i64 %idxdiag
  store i32 0, i32* %pdiag, align 4
  %i.next = add i64 %ival, 1
  store i64 %i.next, i64* %i, align 8
  br label %diag_check

diag_check:                                       ; preds = %diag_body, %after_fill
  %i.cur = load i64, i64* %i, align 8
  %Nval3 = load i64, i64* %N, align 8
  %cmpi = icmp ult i64 %i.cur, %Nval3
  br i1 %cmpi, label %diag_body, label %after_diag

after_diag:                                       ; preds = %diag_check
  store i32 7, i32* %var_DC, align 4
  %N4 = load i64, i64* %N, align 8
  %adjbase3 = getelementptr inbounds [36 x i32], [36 x i32]* %adjArr, i64 0, i64 0
  %pN = getelementptr inbounds i32, i32* %adjbase3, i64 %N4
  store i32 7, i32* %pN, align 4
  store i32 9, i32* %var_D8, align 4
  %N5 = load i64, i64* %N, align 8
  %twoN = add i64 %N5, %N5
  %p2N = getelementptr inbounds i32, i32* %adjbase3, i64 %twoN
  store i32 9, i32* %p2N, align 4
  store i32 10, i32* %var_D4, align 4
  %N6 = load i64, i64* %N, align 8
  %twoN2 = add i64 %N6, %N6
  %threeN = add i64 %twoN2, %N6
  %p3N = getelementptr inbounds i32, i32* %adjbase3, i64 %threeN
  store i32 10, i32* %p3N, align 4
  %N7 = load i64, i64* %N, align 8
  %Nplus3 = add i64 %N7, 3
  %pNplus3 = getelementptr inbounds i32, i32* %adjbase3, i64 %Nplus3
  store i32 15, i32* %pNplus3, align 4
  %N8 = load i64, i64* %N, align 8
  %twoN3 = add i64 %N8, %N8
  %threeN2 = add i64 %twoN3, %N8
  %threeNplus1 = add i64 %threeN2, 1
  %p3N1 = getelementptr inbounds i32, i32* %adjbase3, i64 %threeNplus1
  store i32 15, i32* %p3N1, align 4
  %N9 = load i64, i64* %N, align 8
  %twoN4 = add i64 %N9, %N9
  %twoNplus3 = add i64 %twoN4, 3
  %p2Nplus3 = getelementptr inbounds i32, i32* %adjbase3, i64 %twoNplus3
  store i32 11, i32* %p2Nplus3, align 4
  %N10 = load i64, i64* %N, align 8
  %twoN5 = add i64 %N10, %N10
  %threeN3 = add i64 %twoN5, %N10
  %threeNplus2 = add i64 %threeN3, 2
  %p3N2 = getelementptr inbounds i32, i32* %adjbase3, i64 %threeNplus2
  store i32 11, i32* %p3N2, align 4
  %N11 = load i64, i64* %N, align 8
  %twoN6 = add i64 %N11, %N11
  %threeN4 = add i64 %twoN6, %N11
  %threeNplus4 = add i64 %threeN4, 4
  %p3N4 = getelementptr inbounds i32, i32* %adjbase3, i64 %threeNplus4
  store i32 6, i32* %p3N4, align 4
  %N12 = load i64, i64* %N, align 8
  %fourN = shl i64 %N12, 2
  %fourNplus3 = add i64 %fourN, 3
  %p4N3 = getelementptr inbounds i32, i32* %adjbase3, i64 %fourNplus3
  store i32 6, i32* %p4N3, align 4
  %N13 = load i64, i64* %N, align 8
  %fourN2 = shl i64 %N13, 2
  %fourNplus5 = add i64 %fourN2, 5
  %p4N5 = getelementptr inbounds i32, i32* %adjbase3, i64 %fourNplus5
  store i32 9, i32* %p4N5, align 4
  %N14 = load i64, i64* %N, align 8
  %fourN3 = shl i64 %N14, 2
  %fiveN = add i64 %fourN3, %N14
  %fiveNplus4 = add i64 %fiveN, 4
  %p5N4 = getelementptr inbounds i32, i32* %adjbase3, i64 %fiveNplus4
  store i32 9, i32* %p5N4, align 4
  store i64 0, i64* %src, align 8
  %adjptr = getelementptr inbounds [36 x i32], [36 x i32]* %adjArr, i64 0, i64 0
  %Ncall = load i64, i64* %N, align 8
  %srccall = load i64, i64* %src, align 8
  %distptr = getelementptr inbounds [6 x i32], [6 x i32]* %distArr, i64 0, i64 0
  %predptr = getelementptr inbounds [6 x i32], [6 x i32]* %predArr, i64 0, i64 0
  call void @dijkstra(i32* %adjptr, i64 %Ncall, i64 %srccall, i32* %distptr, i32* %predptr)
  store i64 0, i64* %j, align 8
  br label %print_check

print_body:                                       ; preds = %print_check
  %jval = load i64, i64* %j, align 8
  %dptridx = getelementptr inbounds i32, i32* %distptr, i64 %jval
  %dval = load i32, i32* %dptridx, align 4
  %thresh = icmp sgt i32 %dval, 1061109566
  br i1 %thresh, label %print_inf, label %print_val

print_inf:                                        ; preds = %print_body
  %srcval1 = load i64, i64* %src, align 8
  %jval1 = load i64, i64* %j, align 8
  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %srcval1, i64 %jval1)
  br label %print_next

print_val:                                        ; preds = %print_body
  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %srcval2 = load i64, i64* %src, align 8
  %jval2 = load i64, i64* %j, align 8
  %dval2 = load i32, i32* %dptridx, align 4
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %srcval2, i64 %jval2, i32 %dval2)
  br label %print_next

print_next:                                       ; preds = %print_val, %print_inf
  %jinc = load i64, i64* %j, align 8
  %jnext = add i64 %jinc, 1
  store i64 %jnext, i64* %j, align 8
  br label %print_check

print_check:                                      ; preds = %print_next, %after_diag
  %jcur = load i64, i64* %j, align 8
  %Nprint = load i64, i64* %N, align 8
  %cmpp = icmp ult i64 %jcur, %Nprint
  br i1 %cmpp, label %print_body, label %after_print

after_print:                                      ; preds = %print_check
  store i64 5, i64* %dest, align 8
  %destval = load i64, i64* %dest, align 8
  %dpdest = getelementptr inbounds i32, i32* %distptr, i64 %destval
  %ddest = load i32, i32* %dpdest, align 4
  %noPath = icmp sgt i32 %ddest, 1061109566
  br i1 %noPath, label %no_path, label %has_path

no_path:                                          ; preds = %after_print
  %srcnp = load i64, i64* %src, align 8
  %destnp = load i64, i64* %dest, align 8
  %fmtnp = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %callnp = call i32 (i8*, ...) @printf(i8* %fmtnp, i64 %srcnp, i64 %destnp)
  br label %ret

has_path:                                         ; preds = %after_print
  store i64 0, i64* %count, align 8
  %dest32 = trunc i64 %destval to i32
  store i32 %dest32, i32* %cur, align 4
  br label %path_loop_check

path_loop_body:                                   ; preds = %path_loop_check
  %cnt = load i64, i64* %count, align 8
  %cntplus = add i64 %cnt, 1
  store i64 %cntplus, i64* %count, align 8
  %curv = load i32, i32* %cur, align 4
  %curvsext = sext i32 %curv to i64
  %pathbase = getelementptr inbounds [6 x i64], [6 x i64]* %pathArr, i64 0, i64 0
  %ppos = getelementptr inbounds i64, i64* %pathbase, i64 %cnt
  store i64 %curvsext, i64* %ppos, align 8
  %curv2 = load i32, i32* %cur, align 4
  %curidx = sext i32 %curv2 to i64
  %ppred = getelementptr inbounds i32, i32* %predptr, i64 %curidx
  %nextv = load i32, i32* %ppred, align 4
  store i32 %nextv, i32* %cur, align 4
  br label %path_loop_check

path_loop_check:                                  ; preds = %path_loop_body, %has_path
  %curc = load i32, i32* %cur, align 4
  %cmpend = icmp ne i32 %curc, -1
  br i1 %cmpend, label %path_loop_body, label %after_path_build

after_path_build:                                 ; preds = %path_loop_check
  %fmtpath = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %srcpp = load i64, i64* %src, align 8
  %destpp = load i64, i64* %dest, align 8
  %callp = call i32 (i8*, ...) @printf(i8* %fmtpath, i64 %srcpp, i64 %destpp)
  store i64 0, i64* %iter, align 8
  br label %iter_check

iter_body:                                        ; preds = %iter_check
  %cnt2 = load i64, i64* %count, align 8
  %it = load i64, i64* %iter, align 8
  %tmp1 = sub i64 %cnt2, %it
  %idxrev = sub i64 %tmp1, 1
  %pathbase2 = getelementptr inbounds [6 x i64], [6 x i64]* %pathArr, i64 0, i64 0
  %pelem = getelementptr inbounds i64, i64* %pathbase2, i64 %idxrev
  %valelem = load i64, i64* %pelem, align 8
  store i64 %valelem, i64* %curElem, align 8
  %it1 = load i64, i64* %iter, align 8
  %itplus1 = add i64 %it1, 1
  %cnt3 = load i64, i64* %count, align 8
  %condlast = icmp uge i64 %itplus1, %cnt3
  br i1 %condlast, label %choose_empty, label %choose_arrow

choose_arrow:                                     ; preds = %iter_body
  %arrow = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  br label %after_choose

choose_empty:                                     ; preds = %iter_body
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  br label %after_choose

after_choose:                                     ; preds = %choose_empty, %choose_arrow
  %str = phi i8* [ %arrow, %choose_arrow ], [ %empty, %choose_empty ]
  %fmtzs = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %elem = load i64, i64* %curElem, align 8
  %call3 = call i32 (i8*, ...) @printf(i8* %fmtzs, i64 %elem, i8* %str)
  %it2 = load i64, i64* %iter, align 8
  %itnext = add i64 %it2, 1
  store i64 %itnext, i64* %iter, align 8
  br label %iter_check

iter_check:                                       ; preds = %after_choose, %after_path_build
  %itcur = load i64, i64* %iter, align 8
  %cnt4 = load i64, i64* %count, align 8
  %cmplit = icmp ult i64 %itcur, %cnt4
  br i1 %cmplit, label %iter_body, label %after_iter

after_iter:                                       ; preds = %iter_check
  %nl = call i32 @putchar(i32 10)
  br label %ret

ret:                                              ; preds = %after_iter, %no_path
  ret i32 0
}