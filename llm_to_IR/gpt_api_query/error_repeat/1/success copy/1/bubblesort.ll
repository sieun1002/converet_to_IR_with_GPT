; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !10 {
entry:
  %retval = alloca i32, align 4
  %a = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [10 x i32]* %a, metadata !15, metadata !DIExpression()), !dbg !19
  %0 = bitcast [10 x i32]* %a to i8*, !dbg !19
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast ([10 x i32]* @__const.main.a to i8*), i64 40, i1 false), !dbg !19
  call void @llvm.dbg.declare(metadata i64* %n, metadata !20, metadata !DIExpression()), !dbg !24
  store i64 10, i64* %n, align 8, !dbg !24
  %arraydecay = getelementptr inbounds [10 x i32], [10 x i32]* %a, i64 0, i64 0, !dbg !25
  %1 = load i64, i64* %n, align 8, !dbg !26
  call void @bubble_sort(i32* noundef %arraydecay, i64 noundef %1), !dbg !27
  call void @llvm.dbg.declare(metadata i64* %i, metadata !28, metadata !DIExpression()), !dbg !30
  store i64 0, i64* %i, align 8, !dbg !30
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i64, i64* %i, align 8, !dbg !32
  %3 = load i64, i64* %n, align 8, !dbg !34
  %cmp = icmp ult i64 %2, %3, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %4 = load i64, i64* %i, align 8, !dbg !37
  %arrayidx = getelementptr inbounds [10 x i32], [10 x i32]* %a, i64 0, i64 %4, !dbg !39
  %5 = load i32, i32* %arrayidx, align 4, !dbg !39
  %call = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %5), !dbg !40
  br label %for.inc, !dbg !41

for.inc:                                          ; preds = %for.body
  %6 = load i64, i64* %i, align 8, !dbg !42
  %inc = add i64 %6, 1, !dbg !42
  store i64 %inc, i64* %i, align 8, !dbg !42
  br label %for.cond, !dbg !43, !llvm.loop !44

for.end:                                          ; preds = %for.cond
  %call1 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0)), !dbg !47
  ret i32 0, !dbg !48
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @bubble_sort(i32* noundef %a, i64 noundef %n) #0 !dbg !49 {
entry:
  %a.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %end = alloca i64, align 8
  %last_swapped = alloca i64, align 8
  %i = alloca i64, align 8
  %t = alloca i32, align 4
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !53, metadata !DIExpression()), !dbg !54
  store i64 %n, i64* %n.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %n.addr, metadata !55, metadata !DIExpression()), !dbg !56
  %0 = load i64, i64* %n.addr, align 8, !dbg !57
  %cmp = icmp ult i64 %0, 2, !dbg !59
  br i1 %cmp, label %if.then, label %if.end, !dbg !60

if.then:                                          ; preds = %entry
  br label %while.end, !dbg !61

if.end:                                           ; preds = %entry
  call void @llvm.dbg.declare(metadata i64* %end, metadata !62, metadata !DIExpression()), !dbg !63
  %1 = load i64, i64* %n.addr, align 8, !dbg !64
  store i64 %1, i64* %end, align 8, !dbg !63
  br label %while.cond, !dbg !65

while.cond:                                       ; preds = %if.end15, %if.end
  %2 = load i64, i64* %end, align 8, !dbg !66
  %cmp1 = icmp ugt i64 %2, 1, !dbg !67
  br i1 %cmp1, label %while.body, label %while.end, !dbg !65

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata i64* %last_swapped, metadata !68, metadata !DIExpression()), !dbg !70
  store i64 0, i64* %last_swapped, align 8, !dbg !70
  call void @llvm.dbg.declare(metadata i64* %i, metadata !71, metadata !DIExpression()), !dbg !73
  store i64 1, i64* %i, align 8, !dbg !73
  br label %for.cond, !dbg !74

for.cond:                                         ; preds = %for.inc, %while.body
  %3 = load i64, i64* %i, align 8, !dbg !75
  %4 = load i64, i64* %end, align 8, !dbg !77
  %cmp2 = icmp ult i64 %3, %4, !dbg !78
  br i1 %cmp2, label %for.body, label %for.end, !dbg !79

for.body:                                         ; preds = %for.cond
  %5 = load i32*, i32** %a.addr, align 8, !dbg !80
  %6 = load i64, i64* %i, align 8, !dbg !83
  %sub = sub i64 %6, 1, !dbg !84
  %arrayidx = getelementptr inbounds i32, i32* %5, i64 %sub, !dbg !80
  %7 = load i32, i32* %arrayidx, align 4, !dbg !80
  %8 = load i32*, i32** %a.addr, align 8, !dbg !85
  %9 = load i64, i64* %i, align 8, !dbg !86
  %arrayidx3 = getelementptr inbounds i32, i32* %8, i64 %9, !dbg !85
  %10 = load i32, i32* %arrayidx3, align 4, !dbg !85
  %cmp4 = icmp sgt i32 %7, %10, !dbg !87
  br i1 %cmp4, label %if.then5, label %if.end12, !dbg !88

if.then5:                                         ; preds = %for.body
  call void @llvm.dbg.declare(metadata i32* %t, metadata !89, metadata !DIExpression()), !dbg !91
  %11 = load i32*, i32** %a.addr, align 8, !dbg !92
  %12 = load i64, i64* %i, align 8, !dbg !93
  %sub6 = sub i64 %12, 1, !dbg !94
  %arrayidx7 = getelementptr inbounds i32, i32* %11, i64 %sub6, !dbg !92
  %13 = load i32, i32* %arrayidx7, align 4, !dbg !92
  store i32 %13, i32* %t, align 4, !dbg !91
  %14 = load i32*, i32** %a.addr, align 8, !dbg !95
  %15 = load i64, i64* %i, align 8, !dbg !96
  %arrayidx8 = getelementptr inbounds i32, i32* %14, i64 %15, !dbg !95
  %16 = load i32, i32* %arrayidx8, align 4, !dbg !95
  %17 = load i32*, i32** %a.addr, align 8, !dbg !97
  %18 = load i64, i64* %i, align 8, !dbg !98
  %sub9 = sub i64 %18, 1, !dbg !99
  %arrayidx10 = getelementptr inbounds i32, i32* %17, i64 %sub9, !dbg !97
  store i32 %16, i32* %arrayidx10, align 4, !dbg !100
  %19 = load i32, i32* %t, align 4, !dbg !101
  %20 = load i32*, i32** %a.addr, align 8, !dbg !102
  %21 = load i64, i64* %i, align 8, !dbg !103
  %arrayidx11 = getelementptr inbounds i32, i32* %20, i64 %21, !dbg !102
  store i32 %19, i32* %arrayidx11, align 4, !dbg !104
  %22 = load i64, i64* %i, align 8, !dbg !105
  store i64 %22, i64* %last_swapped, align 8, !dbg !106
  br label %if.end12, !dbg !107

if.end12:                                         ; preds = %if.then5, %for.body
  br label %for.inc, !dbg !108

for.inc:                                          ; preds = %if.end12
  %23 = load i64, i64* %i, align 8, !dbg !109
  %inc = add i64 %23, 1, !dbg !109
  store i64 %inc, i64* %i, align 8, !dbg !109
  br label %for.cond, !dbg !110, !llvm.loop !111

for.end:                                          ; preds = %for.cond
  %24 = load i64, i64* %last_swapped, align 8, !dbg !113
  %cmp13 = icmp eq i64 %24, 0, !dbg !115
  br i1 %cmp13, label %if.then14, label %if.end15, !dbg !116

if.then14:                                        ; preds = %for.end
  br label %while.end, !dbg !117

if.end15:                                         ; preds = %for.end
  %25 = load i64, i64* %last_swapped, align 8, !dbg !118
  store i64 %25, i64* %end, align 8, !dbg !119
  br label %while.cond, !dbg !65, !llvm.loop !120

while.end:                                        ; preds = %if.then14, %while.cond, %if.then
  ret void, !dbg !122
}

declare i32 @printf(i8* noundef, ...) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../original/src/bubblesort.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/IR_Test", checksumkind: CSK_MD5, checksum: "f238373db38a29134f118a094ca6d8a0")
!2 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 23, type: !11, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !{}
!15 = !DILocalVariable(name: "a", scope: !10, file: !1, line: 24, type: !16)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 320, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 10)
!19 = !DILocation(line: 24, column: 9, scope: !10)
!20 = !DILocalVariable(name: "n", scope: !10, file: !1, line: 25, type: !21)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !22, line: 46, baseType: !23)
!22 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!23 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!24 = !DILocation(line: 25, column: 12, scope: !10)
!25 = !DILocation(line: 27, column: 17, scope: !10)
!26 = !DILocation(line: 27, column: 20, scope: !10)
!27 = !DILocation(line: 27, column: 5, scope: !10)
!28 = !DILocalVariable(name: "i", scope: !29, file: !1, line: 29, type: !21)
!29 = distinct !DILexicalBlock(scope: !10, file: !1, line: 29, column: 5)
!30 = !DILocation(line: 29, column: 17, scope: !29)
!31 = !DILocation(line: 29, column: 10, scope: !29)
!32 = !DILocation(line: 29, column: 24, scope: !33)
!33 = distinct !DILexicalBlock(scope: !29, file: !1, line: 29, column: 5)
!34 = !DILocation(line: 29, column: 28, scope: !33)
!35 = !DILocation(line: 29, column: 26, scope: !33)
!36 = !DILocation(line: 29, column: 5, scope: !29)
!37 = !DILocation(line: 30, column: 25, scope: !38)
!38 = distinct !DILexicalBlock(scope: !33, file: !1, line: 29, column: 36)
!39 = !DILocation(line: 30, column: 23, scope: !38)
!40 = !DILocation(line: 30, column: 9, scope: !38)
!41 = !DILocation(line: 31, column: 5, scope: !38)
!42 = !DILocation(line: 29, column: 31, scope: !33)
!43 = !DILocation(line: 29, column: 5, scope: !33)
!44 = distinct !{!44, !36, !45, !46}
!45 = !DILocation(line: 31, column: 5, scope: !29)
!46 = !{!"llvm.loop.mustprogress"}
!47 = !DILocation(line: 32, column: 5, scope: !10)
!48 = !DILocation(line: 33, column: 5, scope: !10)
!49 = distinct !DISubprogram(name: "bubble_sort", scope: !1, file: !1, line: 4, type: !50, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !14)
!50 = !DISubroutineType(types: !51)
!51 = !{null, !52, !21}
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!53 = !DILocalVariable(name: "a", arg: 1, scope: !49, file: !1, line: 4, type: !52)
!54 = !DILocation(line: 4, column: 30, scope: !49)
!55 = !DILocalVariable(name: "n", arg: 2, scope: !49, file: !1, line: 4, type: !21)
!56 = !DILocation(line: 4, column: 40, scope: !49)
!57 = !DILocation(line: 5, column: 9, scope: !58)
!58 = distinct !DILexicalBlock(scope: !49, file: !1, line: 5, column: 9)
!59 = !DILocation(line: 5, column: 11, scope: !58)
!60 = !DILocation(line: 5, column: 9, scope: !49)
!61 = !DILocation(line: 5, column: 16, scope: !58)
!62 = !DILocalVariable(name: "end", scope: !49, file: !1, line: 7, type: !21)
!63 = !DILocation(line: 7, column: 12, scope: !49)
!64 = !DILocation(line: 7, column: 18, scope: !49)
!65 = !DILocation(line: 8, column: 5, scope: !49)
!66 = !DILocation(line: 8, column: 12, scope: !49)
!67 = !DILocation(line: 8, column: 16, scope: !49)
!68 = !DILocalVariable(name: "last_swapped", scope: !69, file: !1, line: 9, type: !21)
!69 = distinct !DILexicalBlock(scope: !49, file: !1, line: 8, column: 21)
!70 = !DILocation(line: 9, column: 16, scope: !69)
!71 = !DILocalVariable(name: "i", scope: !72, file: !1, line: 10, type: !21)
!72 = distinct !DILexicalBlock(scope: !69, file: !1, line: 10, column: 9)
!73 = !DILocation(line: 10, column: 21, scope: !72)
!74 = !DILocation(line: 10, column: 14, scope: !72)
!75 = !DILocation(line: 10, column: 28, scope: !76)
!76 = distinct !DILexicalBlock(scope: !72, file: !1, line: 10, column: 9)
!77 = !DILocation(line: 10, column: 32, scope: !76)
!78 = !DILocation(line: 10, column: 30, scope: !76)
!79 = !DILocation(line: 10, column: 9, scope: !72)
!80 = !DILocation(line: 11, column: 17, scope: !81)
!81 = distinct !DILexicalBlock(scope: !82, file: !1, line: 11, column: 17)
!82 = distinct !DILexicalBlock(scope: !76, file: !1, line: 10, column: 42)
!83 = !DILocation(line: 11, column: 19, scope: !81)
!84 = !DILocation(line: 11, column: 21, scope: !81)
!85 = !DILocation(line: 11, column: 28, scope: !81)
!86 = !DILocation(line: 11, column: 30, scope: !81)
!87 = !DILocation(line: 11, column: 26, scope: !81)
!88 = !DILocation(line: 11, column: 17, scope: !82)
!89 = !DILocalVariable(name: "t", scope: !90, file: !1, line: 12, type: !13)
!90 = distinct !DILexicalBlock(scope: !81, file: !1, line: 11, column: 34)
!91 = !DILocation(line: 12, column: 21, scope: !90)
!92 = !DILocation(line: 12, column: 25, scope: !90)
!93 = !DILocation(line: 12, column: 27, scope: !90)
!94 = !DILocation(line: 12, column: 29, scope: !90)
!95 = !DILocation(line: 13, column: 28, scope: !90)
!96 = !DILocation(line: 13, column: 30, scope: !90)
!97 = !DILocation(line: 13, column: 17, scope: !90)
!98 = !DILocation(line: 13, column: 19, scope: !90)
!99 = !DILocation(line: 13, column: 21, scope: !90)
!100 = !DILocation(line: 13, column: 26, scope: !90)
!101 = !DILocation(line: 14, column: 24, scope: !90)
!102 = !DILocation(line: 14, column: 17, scope: !90)
!103 = !DILocation(line: 14, column: 19, scope: !90)
!104 = !DILocation(line: 14, column: 22, scope: !90)
!105 = !DILocation(line: 15, column: 32, scope: !90)
!106 = !DILocation(line: 15, column: 30, scope: !90)
!107 = !DILocation(line: 16, column: 13, scope: !90)
!108 = !DILocation(line: 17, column: 9, scope: !82)
!109 = !DILocation(line: 10, column: 37, scope: !76)
!110 = !DILocation(line: 10, column: 9, scope: !76)
!111 = distinct !{!111, !79, !112, !46}
!112 = !DILocation(line: 17, column: 9, scope: !72)
!113 = !DILocation(line: 18, column: 13, scope: !114)
!114 = distinct !DILexicalBlock(scope: !69, file: !1, line: 18, column: 13)
!115 = !DILocation(line: 18, column: 26, scope: !114)
!116 = !DILocation(line: 18, column: 13, scope: !69)
!117 = !DILocation(line: 18, column: 32, scope: !114)
!118 = !DILocation(line: 19, column: 15, scope: !69)
!119 = !DILocation(line: 19, column: 13, scope: !69)
!120 = distinct !{!120, !65, !121, !46}
!121 = !DILocation(line: 20, column: 5, scope: !49)
!122 = !DILocation(line: 21, column: 1, scope: !49)
