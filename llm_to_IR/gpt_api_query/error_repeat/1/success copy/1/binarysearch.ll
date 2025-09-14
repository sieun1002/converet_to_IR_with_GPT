; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], align 16
@__const.main.keys = private unnamed_addr constant [3 x i32] [i32 2, i32 5, i32 -5], align 4
@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !12 {
entry:
  %retval = alloca i32, align 4
  %a = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %keys = alloca [3 x i32], align 4
  %qn = alloca i64, align 8
  %i = alloca i64, align 8
  %idx = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [9 x i32]* %a, metadata !17, metadata !DIExpression()), !dbg !21
  %0 = bitcast [9 x i32]* %a to i8*, !dbg !21
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast ([9 x i32]* @__const.main.a to i8*), i64 36, i1 false), !dbg !21
  call void @llvm.dbg.declare(metadata i64* %n, metadata !22, metadata !DIExpression()), !dbg !26
  store i64 9, i64* %n, align 8, !dbg !26
  call void @llvm.dbg.declare(metadata [3 x i32]* %keys, metadata !27, metadata !DIExpression()), !dbg !31
  %1 = bitcast [3 x i32]* %keys to i8*, !dbg !31
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %1, i8* align 4 bitcast ([3 x i32]* @__const.main.keys to i8*), i64 12, i1 false), !dbg !31
  call void @llvm.dbg.declare(metadata i64* %qn, metadata !32, metadata !DIExpression()), !dbg !33
  store i64 3, i64* %qn, align 8, !dbg !33
  call void @llvm.dbg.declare(metadata i64* %i, metadata !34, metadata !DIExpression()), !dbg !36
  store i64 0, i64* %i, align 8, !dbg !36
  br label %for.cond, !dbg !37

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i64, i64* %i, align 8, !dbg !38
  %3 = load i64, i64* %qn, align 8, !dbg !40
  %cmp = icmp ult i64 %2, %3, !dbg !41
  br i1 %cmp, label %for.body, label %for.end, !dbg !42

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i64* %idx, metadata !43, metadata !DIExpression()), !dbg !45
  %arraydecay = getelementptr inbounds [9 x i32], [9 x i32]* %a, i64 0, i64 0, !dbg !46
  %4 = load i64, i64* %n, align 8, !dbg !47
  %5 = load i64, i64* %i, align 8, !dbg !48
  %arrayidx = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %5, !dbg !49
  %6 = load i32, i32* %arrayidx, align 4, !dbg !49
  %call = call i64 @binary_search(i32* noundef %arraydecay, i64 noundef %4, i32 noundef %6), !dbg !50
  store i64 %call, i64* %idx, align 8, !dbg !45
  %7 = load i64, i64* %idx, align 8, !dbg !51
  %cmp1 = icmp sge i64 %7, 0, !dbg !53
  br i1 %cmp1, label %if.then, label %if.else, !dbg !54

if.then:                                          ; preds = %for.body
  %8 = load i64, i64* %i, align 8, !dbg !55
  %arrayidx2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %8, !dbg !56
  %9 = load i32, i32* %arrayidx2, align 4, !dbg !56
  %10 = load i64, i64* %idx, align 8, !dbg !57
  %call3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i32 noundef %9, i64 noundef %10), !dbg !58
  br label %if.end, !dbg !58

if.else:                                          ; preds = %for.body
  %11 = load i64, i64* %i, align 8, !dbg !59
  %arrayidx4 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %11, !dbg !60
  %12 = load i32, i32* %arrayidx4, align 4, !dbg !60
  %call5 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef %12), !dbg !61
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.inc, !dbg !62

for.inc:                                          ; preds = %if.end
  %13 = load i64, i64* %i, align 8, !dbg !63
  %inc = add i64 %13, 1, !dbg !63
  store i64 %inc, i64* %i, align 8, !dbg !63
  br label %for.cond, !dbg !64, !llvm.loop !65

for.end:                                          ; preds = %for.cond
  ret i32 0, !dbg !68
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @binary_search(i32* noundef %a, i64 noundef %n, i32 noundef %key) #0 !dbg !69 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %key.addr = alloca i32, align 4
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  %mid = alloca i64, align 8
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !74, metadata !DIExpression()), !dbg !75
  store i64 %n, i64* %n.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %n.addr, metadata !76, metadata !DIExpression()), !dbg !77
  store i32 %key, i32* %key.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %key.addr, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.declare(metadata i64* %lo, metadata !80, metadata !DIExpression()), !dbg !81
  store i64 0, i64* %lo, align 8, !dbg !81
  call void @llvm.dbg.declare(metadata i64* %hi, metadata !82, metadata !DIExpression()), !dbg !83
  %0 = load i64, i64* %n.addr, align 8, !dbg !84
  store i64 %0, i64* %hi, align 8, !dbg !83
  br label %while.cond, !dbg !85

while.cond:                                       ; preds = %if.end, %entry
  %1 = load i64, i64* %lo, align 8, !dbg !86
  %2 = load i64, i64* %hi, align 8, !dbg !87
  %cmp = icmp ult i64 %1, %2, !dbg !88
  br i1 %cmp, label %while.body, label %while.end, !dbg !85

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata i64* %mid, metadata !89, metadata !DIExpression()), !dbg !91
  %3 = load i64, i64* %lo, align 8, !dbg !92
  %4 = load i64, i64* %hi, align 8, !dbg !93
  %5 = load i64, i64* %lo, align 8, !dbg !94
  %sub = sub i64 %4, %5, !dbg !95
  %div = udiv i64 %sub, 2, !dbg !96
  %add = add i64 %3, %div, !dbg !97
  store i64 %add, i64* %mid, align 8, !dbg !91
  %6 = load i32*, i32** %a.addr, align 8, !dbg !98
  %7 = load i64, i64* %mid, align 8, !dbg !100
  %arrayidx = getelementptr inbounds i32, i32* %6, i64 %7, !dbg !98
  %8 = load i32, i32* %arrayidx, align 4, !dbg !98
  %9 = load i32, i32* %key.addr, align 4, !dbg !101
  %cmp1 = icmp slt i32 %8, %9, !dbg !102
  br i1 %cmp1, label %if.then, label %if.else, !dbg !103

if.then:                                          ; preds = %while.body
  %10 = load i64, i64* %mid, align 8, !dbg !104
  %add2 = add i64 %10, 1, !dbg !105
  store i64 %add2, i64* %lo, align 8, !dbg !106
  br label %if.end, !dbg !107

if.else:                                          ; preds = %while.body
  %11 = load i64, i64* %mid, align 8, !dbg !108
  store i64 %11, i64* %hi, align 8, !dbg !109
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %while.cond, !dbg !85, !llvm.loop !110

while.end:                                        ; preds = %while.cond
  %12 = load i64, i64* %lo, align 8, !dbg !112
  %13 = load i64, i64* %n.addr, align 8, !dbg !114
  %cmp3 = icmp ult i64 %12, %13, !dbg !115
  br i1 %cmp3, label %land.lhs.true, label %if.end7, !dbg !116

land.lhs.true:                                    ; preds = %while.end
  %14 = load i32*, i32** %a.addr, align 8, !dbg !117
  %15 = load i64, i64* %lo, align 8, !dbg !118
  %arrayidx4 = getelementptr inbounds i32, i32* %14, i64 %15, !dbg !117
  %16 = load i32, i32* %arrayidx4, align 4, !dbg !117
  %17 = load i32, i32* %key.addr, align 4, !dbg !119
  %cmp5 = icmp eq i32 %16, %17, !dbg !120
  br i1 %cmp5, label %if.then6, label %if.end7, !dbg !121

if.then6:                                         ; preds = %land.lhs.true
  %18 = load i64, i64* %lo, align 8, !dbg !122
  store i64 %18, i64* %retval, align 8, !dbg !123
  br label %return, !dbg !123

if.end7:                                          ; preds = %land.lhs.true, %while.end
  store i64 -1, i64* %retval, align 8, !dbg !124
  br label %return, !dbg !124

return:                                           ; preds = %if.end7, %if.then6
  %19 = load i64, i64* %retval, align 8, !dbg !125
  ret i64 %19, !dbg !125
}

declare i32 @printf(i8* noundef, ...) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!4}
!llvm.module.flags = !{!5, !6, !7, !8, !9, !10, !11}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../original/src/binarysearch.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/IR_Test", checksumkind: CSK_MD5, checksum: "08f90fb2bdfb727335b70b6850a46ad9")
!2 = !{!3}
!3 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{i32 7, !"Dwarf Version", i32 5}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{i32 7, !"PIC Level", i32 2}
!9 = !{i32 7, !"PIE Level", i32 2}
!10 = !{i32 7, !"uwtable", i32 1}
!11 = !{i32 7, !"frame-pointer", i32 2}
!12 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 15, type: !13, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!13 = !DISubroutineType(types: !14)
!14 = !{!15}
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !{}
!17 = !DILocalVariable(name: "a", scope: !12, file: !1, line: 16, type: !18)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 288, elements: !19)
!19 = !{!20}
!20 = !DISubrange(count: 9)
!21 = !DILocation(line: 16, column: 9, scope: !12)
!22 = !DILocalVariable(name: "n", scope: !12, file: !1, line: 17, type: !23)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !24, line: 46, baseType: !25)
!24 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!25 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!26 = !DILocation(line: 17, column: 12, scope: !12)
!27 = !DILocalVariable(name: "keys", scope: !12, file: !1, line: 19, type: !28)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 96, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 3)
!31 = !DILocation(line: 19, column: 9, scope: !12)
!32 = !DILocalVariable(name: "qn", scope: !12, file: !1, line: 20, type: !23)
!33 = !DILocation(line: 20, column: 12, scope: !12)
!34 = !DILocalVariable(name: "i", scope: !35, file: !1, line: 22, type: !23)
!35 = distinct !DILexicalBlock(scope: !12, file: !1, line: 22, column: 5)
!36 = !DILocation(line: 22, column: 17, scope: !35)
!37 = !DILocation(line: 22, column: 10, scope: !35)
!38 = !DILocation(line: 22, column: 24, scope: !39)
!39 = distinct !DILexicalBlock(scope: !35, file: !1, line: 22, column: 5)
!40 = !DILocation(line: 22, column: 28, scope: !39)
!41 = !DILocation(line: 22, column: 26, scope: !39)
!42 = !DILocation(line: 22, column: 5, scope: !35)
!43 = !DILocalVariable(name: "idx", scope: !44, file: !1, line: 23, type: !3)
!44 = distinct !DILexicalBlock(scope: !39, file: !1, line: 22, column: 37)
!45 = !DILocation(line: 23, column: 14, scope: !44)
!46 = !DILocation(line: 23, column: 34, scope: !44)
!47 = !DILocation(line: 23, column: 37, scope: !44)
!48 = !DILocation(line: 23, column: 45, scope: !44)
!49 = !DILocation(line: 23, column: 40, scope: !44)
!50 = !DILocation(line: 23, column: 20, scope: !44)
!51 = !DILocation(line: 24, column: 13, scope: !52)
!52 = distinct !DILexicalBlock(scope: !44, file: !1, line: 24, column: 13)
!53 = !DILocation(line: 24, column: 17, scope: !52)
!54 = !DILocation(line: 24, column: 13, scope: !44)
!55 = !DILocation(line: 24, column: 60, scope: !52)
!56 = !DILocation(line: 24, column: 55, scope: !52)
!57 = !DILocation(line: 24, column: 64, scope: !52)
!58 = !DILocation(line: 24, column: 23, scope: !52)
!59 = !DILocation(line: 25, column: 60, scope: !52)
!60 = !DILocation(line: 25, column: 55, scope: !52)
!61 = !DILocation(line: 25, column: 23, scope: !52)
!62 = !DILocation(line: 26, column: 5, scope: !44)
!63 = !DILocation(line: 22, column: 32, scope: !39)
!64 = !DILocation(line: 22, column: 5, scope: !39)
!65 = distinct !{!65, !42, !66, !67}
!66 = !DILocation(line: 26, column: 5, scope: !35)
!67 = !{!"llvm.loop.mustprogress"}
!68 = !DILocation(line: 27, column: 5, scope: !12)
!69 = distinct !DISubprogram(name: "binary_search", scope: !1, file: !1, line: 4, type: !70, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !16)
!70 = !DISubroutineType(types: !71)
!71 = !{!3, !72, !23, !15}
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!74 = !DILocalVariable(name: "a", arg: 1, scope: !69, file: !1, line: 4, type: !72)
!75 = !DILocation(line: 4, column: 38, scope: !69)
!76 = !DILocalVariable(name: "n", arg: 2, scope: !69, file: !1, line: 4, type: !23)
!77 = !DILocation(line: 4, column: 48, scope: !69)
!78 = !DILocalVariable(name: "key", arg: 3, scope: !69, file: !1, line: 4, type: !15)
!79 = !DILocation(line: 4, column: 55, scope: !69)
!80 = !DILocalVariable(name: "lo", scope: !69, file: !1, line: 5, type: !23)
!81 = !DILocation(line: 5, column: 12, scope: !69)
!82 = !DILocalVariable(name: "hi", scope: !69, file: !1, line: 5, type: !23)
!83 = !DILocation(line: 5, column: 20, scope: !69)
!84 = !DILocation(line: 5, column: 25, scope: !69)
!85 = !DILocation(line: 6, column: 5, scope: !69)
!86 = !DILocation(line: 6, column: 12, scope: !69)
!87 = !DILocation(line: 6, column: 17, scope: !69)
!88 = !DILocation(line: 6, column: 15, scope: !69)
!89 = !DILocalVariable(name: "mid", scope: !90, file: !1, line: 7, type: !23)
!90 = distinct !DILexicalBlock(scope: !69, file: !1, line: 6, column: 21)
!91 = !DILocation(line: 7, column: 16, scope: !90)
!92 = !DILocation(line: 7, column: 22, scope: !90)
!93 = !DILocation(line: 7, column: 28, scope: !90)
!94 = !DILocation(line: 7, column: 33, scope: !90)
!95 = !DILocation(line: 7, column: 31, scope: !90)
!96 = !DILocation(line: 7, column: 37, scope: !90)
!97 = !DILocation(line: 7, column: 25, scope: !90)
!98 = !DILocation(line: 8, column: 13, scope: !99)
!99 = distinct !DILexicalBlock(scope: !90, file: !1, line: 8, column: 13)
!100 = !DILocation(line: 8, column: 15, scope: !99)
!101 = !DILocation(line: 8, column: 22, scope: !99)
!102 = !DILocation(line: 8, column: 20, scope: !99)
!103 = !DILocation(line: 8, column: 13, scope: !90)
!104 = !DILocation(line: 8, column: 32, scope: !99)
!105 = !DILocation(line: 8, column: 36, scope: !99)
!106 = !DILocation(line: 8, column: 30, scope: !99)
!107 = !DILocation(line: 8, column: 27, scope: !99)
!108 = !DILocation(line: 9, column: 19, scope: !99)
!109 = !DILocation(line: 9, column: 17, scope: !99)
!110 = distinct !{!110, !85, !111, !67}
!111 = !DILocation(line: 10, column: 5, scope: !69)
!112 = !DILocation(line: 11, column: 9, scope: !113)
!113 = distinct !DILexicalBlock(scope: !69, file: !1, line: 11, column: 9)
!114 = !DILocation(line: 11, column: 14, scope: !113)
!115 = !DILocation(line: 11, column: 12, scope: !113)
!116 = !DILocation(line: 11, column: 16, scope: !113)
!117 = !DILocation(line: 11, column: 19, scope: !113)
!118 = !DILocation(line: 11, column: 21, scope: !113)
!119 = !DILocation(line: 11, column: 28, scope: !113)
!120 = !DILocation(line: 11, column: 25, scope: !113)
!121 = !DILocation(line: 11, column: 9, scope: !69)
!122 = !DILocation(line: 11, column: 46, scope: !113)
!123 = !DILocation(line: 11, column: 33, scope: !113)
!124 = !DILocation(line: 12, column: 5, scope: !69)
!125 = !DILocation(line: 13, column: 1, scope: !69)
