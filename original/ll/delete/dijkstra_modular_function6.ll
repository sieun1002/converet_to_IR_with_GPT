; ModuleID = 'dijkstra_modular.ll'
source_filename = "dijkstra_modular.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.3 = external hidden unnamed_addr constant [16 x i8], align 1
@.str.4 = external hidden unnamed_addr constant [15 x i8], align 1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print_distances(i32* noundef %dist, i32 noundef %V) #1 !dbg !10 {
entry:
  %dist.addr = alloca i32*, align 8
  %V.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %dist, i32** %dist.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %dist.addr, metadata !17, metadata !DIExpression()), !dbg !18
  store i32 %V, i32* %V.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %V.addr, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %i, metadata !21, metadata !DIExpression()), !dbg !23
  store i32 0, i32* %i, align 4, !dbg !23
  br label %for.cond, !dbg !24

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !25
  %1 = load i32, i32* %V.addr, align 4, !dbg !27
  %cmp = icmp slt i32 %0, %1, !dbg !28
  br i1 %cmp, label %for.body, label %for.end, !dbg !29

for.body:                                         ; preds = %for.cond
  %2 = load i32*, i32** %dist.addr, align 8, !dbg !30
  %3 = load i32, i32* %i, align 4, !dbg !33
  %idxprom = sext i32 %3 to i64, !dbg !30
  %arrayidx = getelementptr inbounds i32, i32* %2, i64 %idxprom, !dbg !30
  %4 = load i32, i32* %arrayidx, align 4, !dbg !30
  %cmp1 = icmp eq i32 %4, 2147483647, !dbg !34
  br i1 %cmp1, label %if.then, label %if.else, !dbg !35

if.then:                                          ; preds = %for.body
  %5 = load i32, i32* %i, align 4, !dbg !36
  %call = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.3, i64 0, i64 0), i32 noundef %5), !dbg !37
  br label %if.end, !dbg !37

if.else:                                          ; preds = %for.body
  %6 = load i32, i32* %i, align 4, !dbg !38
  %7 = load i32*, i32** %dist.addr, align 8, !dbg !39
  %8 = load i32, i32* %i, align 4, !dbg !40
  %idxprom2 = sext i32 %8 to i64, !dbg !39
  %arrayidx3 = getelementptr inbounds i32, i32* %7, i64 %idxprom2, !dbg !39
  %9 = load i32, i32* %arrayidx3, align 4, !dbg !39
  %call4 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.4, i64 0, i64 0), i32 noundef %6, i32 noundef %9), !dbg !41
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.inc, !dbg !42

for.inc:                                          ; preds = %if.end
  %10 = load i32, i32* %i, align 4, !dbg !43
  %inc = add nsw i32 %10, 1, !dbg !43
  store i32 %inc, i32* %i, align 4, !dbg !43
  br label %for.cond, !dbg !44, !llvm.loop !45

for.end:                                          ; preds = %for.cond
  ret void, !dbg !48
}

declare i32 @printf(i8* noundef, ...) #2

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "dijkstra_modular.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/original/src", checksumkind: CSK_MD5, checksum: "47bf6ecccd84048d194510cb254a0651")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "print_distances", scope: !1, file: !1, line: 73, type: !11, scopeLine: 73, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DISubroutineType(types: !12)
!12 = !{null, !13, !15}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !{}
!17 = !DILocalVariable(name: "dist", arg: 1, scope: !10, file: !1, line: 73, type: !13)
!18 = !DILocation(line: 73, column: 32, scope: !10)
!19 = !DILocalVariable(name: "V", arg: 2, scope: !10, file: !1, line: 73, type: !15)
!20 = !DILocation(line: 73, column: 44, scope: !10)
!21 = !DILocalVariable(name: "i", scope: !22, file: !1, line: 74, type: !15)
!22 = distinct !DILexicalBlock(scope: !10, file: !1, line: 74, column: 5)
!23 = !DILocation(line: 74, column: 14, scope: !22)
!24 = !DILocation(line: 74, column: 10, scope: !22)
!25 = !DILocation(line: 74, column: 21, scope: !26)
!26 = distinct !DILexicalBlock(scope: !22, file: !1, line: 74, column: 5)
!27 = !DILocation(line: 74, column: 25, scope: !26)
!28 = !DILocation(line: 74, column: 23, scope: !26)
!29 = !DILocation(line: 74, column: 5, scope: !22)
!30 = !DILocation(line: 75, column: 13, scope: !31)
!31 = distinct !DILexicalBlock(scope: !32, file: !1, line: 75, column: 13)
!32 = distinct !DILexicalBlock(scope: !26, file: !1, line: 74, column: 33)
!33 = !DILocation(line: 75, column: 18, scope: !31)
!34 = !DILocation(line: 75, column: 21, scope: !31)
!35 = !DILocation(line: 75, column: 13, scope: !32)
!36 = !DILocation(line: 75, column: 60, scope: !31)
!37 = !DILocation(line: 75, column: 33, scope: !31)
!38 = !DILocation(line: 76, column: 55, scope: !31)
!39 = !DILocation(line: 76, column: 58, scope: !31)
!40 = !DILocation(line: 76, column: 63, scope: !31)
!41 = !DILocation(line: 76, column: 29, scope: !31)
!42 = !DILocation(line: 77, column: 5, scope: !32)
!43 = !DILocation(line: 74, column: 28, scope: !26)
!44 = !DILocation(line: 74, column: 5, scope: !26)
!45 = distinct !{!45, !29, !46, !47}
!46 = !DILocation(line: 77, column: 5, scope: !22)
!47 = !{!"llvm.loop.mustprogress"}
!48 = !DILocation(line: 78, column: 1, scope: !10)
