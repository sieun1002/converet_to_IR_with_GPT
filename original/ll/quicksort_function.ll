; ModuleID = 'quicksort.ll'
source_filename = "../original/src/quicksort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

; Function Attrs: noinline nounwind optnone uwtable
define hidden void @quick_sort(i32* noundef %a, i64 noundef %lo, i64 noundef %hi) #1 !dbg !12 {
entry:
  %a.addr = alloca i32*, align 8
  %lo.addr = alloca i64, align 8
  %hi.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %pivot = alloca i32, align 4
  %t = alloca i32, align 4
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !18, metadata !DIExpression()), !dbg !19
  store i64 %lo, i64* %lo.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %lo.addr, metadata !20, metadata !DIExpression()), !dbg !21
  store i64 %hi, i64* %hi.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %hi.addr, metadata !22, metadata !DIExpression()), !dbg !23
  br label %while.cond, !dbg !24

while.cond:                                       ; preds = %if.end28, %entry
  %0 = load i64, i64* %lo.addr, align 8, !dbg !25
  %1 = load i64, i64* %hi.addr, align 8, !dbg !26
  %cmp = icmp slt i64 %0, %1, !dbg !27
  br i1 %cmp, label %while.body, label %while.end29, !dbg !24

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata i64* %i, metadata !28, metadata !DIExpression()), !dbg !30
  %2 = load i64, i64* %lo.addr, align 8, !dbg !31
  store i64 %2, i64* %i, align 8, !dbg !30
  call void @llvm.dbg.declare(metadata i64* %j, metadata !32, metadata !DIExpression()), !dbg !33
  %3 = load i64, i64* %hi.addr, align 8, !dbg !34
  store i64 %3, i64* %j, align 8, !dbg !33
  call void @llvm.dbg.declare(metadata i32* %pivot, metadata !35, metadata !DIExpression()), !dbg !36
  %4 = load i32*, i32** %a.addr, align 8, !dbg !37
  %5 = load i64, i64* %lo.addr, align 8, !dbg !38
  %6 = load i64, i64* %hi.addr, align 8, !dbg !39
  %7 = load i64, i64* %lo.addr, align 8, !dbg !40
  %sub = sub nsw i64 %6, %7, !dbg !41
  %div = sdiv i64 %sub, 2, !dbg !42
  %add = add nsw i64 %5, %div, !dbg !43
  %arrayidx = getelementptr inbounds i32, i32* %4, i64 %add, !dbg !37
  %8 = load i32, i32* %arrayidx, align 4, !dbg !37
  store i32 %8, i32* %pivot, align 4, !dbg !36
  br label %do.body, !dbg !44

do.body:                                          ; preds = %do.cond, %while.body
  br label %while.cond1, !dbg !45

while.cond1:                                      ; preds = %while.body4, %do.body
  %9 = load i32*, i32** %a.addr, align 8, !dbg !47
  %10 = load i64, i64* %i, align 8, !dbg !48
  %arrayidx2 = getelementptr inbounds i32, i32* %9, i64 %10, !dbg !47
  %11 = load i32, i32* %arrayidx2, align 4, !dbg !47
  %12 = load i32, i32* %pivot, align 4, !dbg !49
  %cmp3 = icmp slt i32 %11, %12, !dbg !50
  br i1 %cmp3, label %while.body4, label %while.end, !dbg !45

while.body4:                                      ; preds = %while.cond1
  %13 = load i64, i64* %i, align 8, !dbg !51
  %inc = add nsw i64 %13, 1, !dbg !51
  store i64 %inc, i64* %i, align 8, !dbg !51
  br label %while.cond1, !dbg !45, !llvm.loop !52

while.end:                                        ; preds = %while.cond1
  br label %while.cond5, !dbg !54

while.cond5:                                      ; preds = %while.body8, %while.end
  %14 = load i32*, i32** %a.addr, align 8, !dbg !55
  %15 = load i64, i64* %j, align 8, !dbg !56
  %arrayidx6 = getelementptr inbounds i32, i32* %14, i64 %15, !dbg !55
  %16 = load i32, i32* %arrayidx6, align 4, !dbg !55
  %17 = load i32, i32* %pivot, align 4, !dbg !57
  %cmp7 = icmp sgt i32 %16, %17, !dbg !58
  br i1 %cmp7, label %while.body8, label %while.end9, !dbg !54

while.body8:                                      ; preds = %while.cond5
  %18 = load i64, i64* %j, align 8, !dbg !59
  %dec = add nsw i64 %18, -1, !dbg !59
  store i64 %dec, i64* %j, align 8, !dbg !59
  br label %while.cond5, !dbg !54, !llvm.loop !60

while.end9:                                       ; preds = %while.cond5
  %19 = load i64, i64* %i, align 8, !dbg !61
  %20 = load i64, i64* %j, align 8, !dbg !63
  %cmp10 = icmp sle i64 %19, %20, !dbg !64
  br i1 %cmp10, label %if.then, label %if.end, !dbg !65

if.then:                                          ; preds = %while.end9
  call void @llvm.dbg.declare(metadata i32* %t, metadata !66, metadata !DIExpression()), !dbg !68
  %21 = load i32*, i32** %a.addr, align 8, !dbg !69
  %22 = load i64, i64* %i, align 8, !dbg !70
  %arrayidx11 = getelementptr inbounds i32, i32* %21, i64 %22, !dbg !69
  %23 = load i32, i32* %arrayidx11, align 4, !dbg !69
  store i32 %23, i32* %t, align 4, !dbg !68
  %24 = load i32*, i32** %a.addr, align 8, !dbg !71
  %25 = load i64, i64* %j, align 8, !dbg !72
  %arrayidx12 = getelementptr inbounds i32, i32* %24, i64 %25, !dbg !71
  %26 = load i32, i32* %arrayidx12, align 4, !dbg !71
  %27 = load i32*, i32** %a.addr, align 8, !dbg !73
  %28 = load i64, i64* %i, align 8, !dbg !74
  %arrayidx13 = getelementptr inbounds i32, i32* %27, i64 %28, !dbg !73
  store i32 %26, i32* %arrayidx13, align 4, !dbg !75
  %29 = load i32, i32* %t, align 4, !dbg !76
  %30 = load i32*, i32** %a.addr, align 8, !dbg !77
  %31 = load i64, i64* %j, align 8, !dbg !78
  %arrayidx14 = getelementptr inbounds i32, i32* %30, i64 %31, !dbg !77
  store i32 %29, i32* %arrayidx14, align 4, !dbg !79
  %32 = load i64, i64* %i, align 8, !dbg !80
  %inc15 = add nsw i64 %32, 1, !dbg !80
  store i64 %inc15, i64* %i, align 8, !dbg !80
  %33 = load i64, i64* %j, align 8, !dbg !81
  %dec16 = add nsw i64 %33, -1, !dbg !81
  store i64 %dec16, i64* %j, align 8, !dbg !81
  br label %if.end, !dbg !82

if.end:                                           ; preds = %if.then, %while.end9
  br label %do.cond, !dbg !83

do.cond:                                          ; preds = %if.end
  %34 = load i64, i64* %i, align 8, !dbg !84
  %35 = load i64, i64* %j, align 8, !dbg !85
  %cmp17 = icmp sle i64 %34, %35, !dbg !86
  br i1 %cmp17, label %do.body, label %do.end, !dbg !83, !llvm.loop !87

do.end:                                           ; preds = %do.cond
  %36 = load i64, i64* %j, align 8, !dbg !89
  %37 = load i64, i64* %lo.addr, align 8, !dbg !91
  %sub18 = sub nsw i64 %36, %37, !dbg !92
  %38 = load i64, i64* %hi.addr, align 8, !dbg !93
  %39 = load i64, i64* %i, align 8, !dbg !94
  %sub19 = sub nsw i64 %38, %39, !dbg !95
  %cmp20 = icmp slt i64 %sub18, %sub19, !dbg !96
  br i1 %cmp20, label %if.then21, label %if.else, !dbg !97

if.then21:                                        ; preds = %do.end
  %40 = load i64, i64* %lo.addr, align 8, !dbg !98
  %41 = load i64, i64* %j, align 8, !dbg !101
  %cmp22 = icmp slt i64 %40, %41, !dbg !102
  br i1 %cmp22, label %if.then23, label %if.end24, !dbg !103

if.then23:                                        ; preds = %if.then21
  %42 = load i32*, i32** %a.addr, align 8, !dbg !104
  %43 = load i64, i64* %lo.addr, align 8, !dbg !105
  %44 = load i64, i64* %j, align 8, !dbg !106
  call void @quick_sort(i32* noundef %42, i64 noundef %43, i64 noundef %44), !dbg !107
  br label %if.end24, !dbg !107

if.end24:                                         ; preds = %if.then23, %if.then21
  %45 = load i64, i64* %i, align 8, !dbg !108
  store i64 %45, i64* %lo.addr, align 8, !dbg !109
  br label %if.end28, !dbg !110

if.else:                                          ; preds = %do.end
  %46 = load i64, i64* %i, align 8, !dbg !111
  %47 = load i64, i64* %hi.addr, align 8, !dbg !114
  %cmp25 = icmp slt i64 %46, %47, !dbg !115
  br i1 %cmp25, label %if.then26, label %if.end27, !dbg !116

if.then26:                                        ; preds = %if.else
  %48 = load i32*, i32** %a.addr, align 8, !dbg !117
  %49 = load i64, i64* %i, align 8, !dbg !118
  %50 = load i64, i64* %hi.addr, align 8, !dbg !119
  call void @quick_sort(i32* noundef %48, i64 noundef %49, i64 noundef %50), !dbg !120
  br label %if.end27, !dbg !120

if.end27:                                         ; preds = %if.then26, %if.else
  %51 = load i64, i64* %j, align 8, !dbg !121
  store i64 %51, i64* %hi.addr, align 8, !dbg !122
  br label %if.end28

if.end28:                                         ; preds = %if.end27, %if.end24
  br label %while.cond, !dbg !24, !llvm.loop !123

while.end29:                                      ; preds = %while.cond
  ret void, !dbg !125
}

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../original/src/quicksort.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/IR_Test", checksumkind: CSK_MD5, checksum: "3238381465f040c99953b92e9de03463")
!2 = !{!3}
!3 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 7, !"PIC Level", i32 2}
!8 = !{i32 7, !"PIE Level", i32 2}
!9 = !{i32 7, !"uwtable", i32 1}
!10 = !{i32 7, !"frame-pointer", i32 2}
!11 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!12 = distinct !DISubprogram(name: "quick_sort", scope: !1, file: !1, line: 4, type: !13, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !17)
!13 = !DISubroutineType(types: !14)
!14 = !{null, !15, !3, !3}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{}
!18 = !DILocalVariable(name: "a", arg: 1, scope: !12, file: !1, line: 4, type: !15)
!19 = !DILocation(line: 4, column: 29, scope: !12)
!20 = !DILocalVariable(name: "lo", arg: 2, scope: !12, file: !1, line: 4, type: !3)
!21 = !DILocation(line: 4, column: 37, scope: !12)
!22 = !DILocalVariable(name: "hi", arg: 3, scope: !12, file: !1, line: 4, type: !3)
!23 = !DILocation(line: 4, column: 46, scope: !12)
!24 = !DILocation(line: 5, column: 5, scope: !12)
!25 = !DILocation(line: 5, column: 12, scope: !12)
!26 = !DILocation(line: 5, column: 17, scope: !12)
!27 = !DILocation(line: 5, column: 15, scope: !12)
!28 = !DILocalVariable(name: "i", scope: !29, file: !1, line: 6, type: !3)
!29 = distinct !DILexicalBlock(scope: !12, file: !1, line: 5, column: 21)
!30 = !DILocation(line: 6, column: 14, scope: !29)
!31 = !DILocation(line: 6, column: 18, scope: !29)
!32 = !DILocalVariable(name: "j", scope: !29, file: !1, line: 6, type: !3)
!33 = !DILocation(line: 6, column: 22, scope: !29)
!34 = !DILocation(line: 6, column: 26, scope: !29)
!35 = !DILocalVariable(name: "pivot", scope: !29, file: !1, line: 7, type: !16)
!36 = !DILocation(line: 7, column: 13, scope: !29)
!37 = !DILocation(line: 7, column: 21, scope: !29)
!38 = !DILocation(line: 7, column: 23, scope: !29)
!39 = !DILocation(line: 7, column: 29, scope: !29)
!40 = !DILocation(line: 7, column: 34, scope: !29)
!41 = !DILocation(line: 7, column: 32, scope: !29)
!42 = !DILocation(line: 7, column: 38, scope: !29)
!43 = !DILocation(line: 7, column: 26, scope: !29)
!44 = !DILocation(line: 9, column: 9, scope: !29)
!45 = !DILocation(line: 10, column: 13, scope: !46)
!46 = distinct !DILexicalBlock(scope: !29, file: !1, line: 9, column: 12)
!47 = !DILocation(line: 10, column: 20, scope: !46)
!48 = !DILocation(line: 10, column: 22, scope: !46)
!49 = !DILocation(line: 10, column: 27, scope: !46)
!50 = !DILocation(line: 10, column: 25, scope: !46)
!51 = !DILocation(line: 10, column: 35, scope: !46)
!52 = distinct !{!52, !45, !51, !53}
!53 = !{!"llvm.loop.mustprogress"}
!54 = !DILocation(line: 11, column: 13, scope: !46)
!55 = !DILocation(line: 11, column: 20, scope: !46)
!56 = !DILocation(line: 11, column: 22, scope: !46)
!57 = !DILocation(line: 11, column: 27, scope: !46)
!58 = !DILocation(line: 11, column: 25, scope: !46)
!59 = !DILocation(line: 11, column: 35, scope: !46)
!60 = distinct !{!60, !54, !59, !53}
!61 = !DILocation(line: 12, column: 17, scope: !62)
!62 = distinct !DILexicalBlock(scope: !46, file: !1, line: 12, column: 17)
!63 = !DILocation(line: 12, column: 22, scope: !62)
!64 = !DILocation(line: 12, column: 19, scope: !62)
!65 = !DILocation(line: 12, column: 17, scope: !46)
!66 = !DILocalVariable(name: "t", scope: !67, file: !1, line: 13, type: !16)
!67 = distinct !DILexicalBlock(scope: !62, file: !1, line: 12, column: 25)
!68 = !DILocation(line: 13, column: 21, scope: !67)
!69 = !DILocation(line: 13, column: 25, scope: !67)
!70 = !DILocation(line: 13, column: 27, scope: !67)
!71 = !DILocation(line: 13, column: 38, scope: !67)
!72 = !DILocation(line: 13, column: 40, scope: !67)
!73 = !DILocation(line: 13, column: 31, scope: !67)
!74 = !DILocation(line: 13, column: 33, scope: !67)
!75 = !DILocation(line: 13, column: 36, scope: !67)
!76 = !DILocation(line: 13, column: 51, scope: !67)
!77 = !DILocation(line: 13, column: 44, scope: !67)
!78 = !DILocation(line: 13, column: 46, scope: !67)
!79 = !DILocation(line: 13, column: 49, scope: !67)
!80 = !DILocation(line: 14, column: 18, scope: !67)
!81 = !DILocation(line: 14, column: 23, scope: !67)
!82 = !DILocation(line: 15, column: 13, scope: !67)
!83 = !DILocation(line: 16, column: 9, scope: !46)
!84 = !DILocation(line: 16, column: 18, scope: !29)
!85 = !DILocation(line: 16, column: 23, scope: !29)
!86 = !DILocation(line: 16, column: 20, scope: !29)
!87 = distinct !{!87, !44, !88, !53}
!88 = !DILocation(line: 16, column: 24, scope: !29)
!89 = !DILocation(line: 18, column: 14, scope: !90)
!90 = distinct !DILexicalBlock(scope: !29, file: !1, line: 18, column: 13)
!91 = !DILocation(line: 18, column: 18, scope: !90)
!92 = !DILocation(line: 18, column: 16, scope: !90)
!93 = !DILocation(line: 18, column: 25, scope: !90)
!94 = !DILocation(line: 18, column: 30, scope: !90)
!95 = !DILocation(line: 18, column: 28, scope: !90)
!96 = !DILocation(line: 18, column: 22, scope: !90)
!97 = !DILocation(line: 18, column: 13, scope: !29)
!98 = !DILocation(line: 19, column: 17, scope: !99)
!99 = distinct !DILexicalBlock(scope: !100, file: !1, line: 19, column: 17)
!100 = distinct !DILexicalBlock(scope: !90, file: !1, line: 18, column: 34)
!101 = !DILocation(line: 19, column: 22, scope: !99)
!102 = !DILocation(line: 19, column: 20, scope: !99)
!103 = !DILocation(line: 19, column: 17, scope: !100)
!104 = !DILocation(line: 19, column: 36, scope: !99)
!105 = !DILocation(line: 19, column: 39, scope: !99)
!106 = !DILocation(line: 19, column: 43, scope: !99)
!107 = !DILocation(line: 19, column: 25, scope: !99)
!108 = !DILocation(line: 20, column: 18, scope: !100)
!109 = !DILocation(line: 20, column: 16, scope: !100)
!110 = !DILocation(line: 21, column: 9, scope: !100)
!111 = !DILocation(line: 22, column: 17, scope: !112)
!112 = distinct !DILexicalBlock(scope: !113, file: !1, line: 22, column: 17)
!113 = distinct !DILexicalBlock(scope: !90, file: !1, line: 21, column: 16)
!114 = !DILocation(line: 22, column: 21, scope: !112)
!115 = !DILocation(line: 22, column: 19, scope: !112)
!116 = !DILocation(line: 22, column: 17, scope: !113)
!117 = !DILocation(line: 22, column: 36, scope: !112)
!118 = !DILocation(line: 22, column: 39, scope: !112)
!119 = !DILocation(line: 22, column: 42, scope: !112)
!120 = !DILocation(line: 22, column: 25, scope: !112)
!121 = !DILocation(line: 23, column: 18, scope: !113)
!122 = !DILocation(line: 23, column: 16, scope: !113)
!123 = distinct !{!123, !24, !124, !53}
!124 = !DILocation(line: 25, column: 5, scope: !12)
!125 = !DILocation(line: 26, column: 1, scope: !12)
