; ModuleID = '/home/nata20034/workspace/cfg/degpt/heapsort_main.ll'
source_filename = "heapsort_degpt.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.values = external hidden unnamed_addr constant [9 x i32], align 16
@.str = external hidden unnamed_addr constant [9 x i8], align 1
@.str.1 = external hidden unnamed_addr constant [4 x i8], align 1
@.str.2 = external hidden unnamed_addr constant [12 x i8], align 1

; Function Attrs: noinline nounwind optnone uwtable
declare dso_local void @heap_sort(i32* noundef, i64 noundef) #0

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %argc, i8** noundef %argv, i8** noundef %envp) #0 !dbg !10 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %envp.addr = alloca i8**, align 8
  %index_variable = alloca i64, align 8
  %values_array = alloca [10 x i32], align 16
  %value_store = alloca i64, align 8
  %values = alloca [9 x i32], align 16
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !19, metadata !DIExpression()), !dbg !20
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !21, metadata !DIExpression()), !dbg !22
  store i8** %envp, i8*** %envp.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %envp.addr, metadata !23, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata i64* %index_variable, metadata !25, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata [10 x i32]* %values_array, metadata !30, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata i64* %value_store, metadata !35, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata [9 x i32]* %values, metadata !37, metadata !DIExpression()), !dbg !41
  %0 = bitcast [9 x i32]* %values to i8*, !dbg !41
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast ([9 x i32]* @__const.main.values to i8*), i64 36, i1 false), !dbg !41
  %call = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0)), !dbg !42
  store i64 0, i64* %index_variable, align 8, !dbg !43
  br label %for.cond, !dbg !45

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i64, i64* %index_variable, align 8, !dbg !46
  %cmp = icmp ult i64 %1, 9, !dbg !48
  br i1 %cmp, label %for.body, label %for.end, !dbg !49

for.body:                                         ; preds = %for.cond
  %2 = load i64, i64* %index_variable, align 8, !dbg !50
  %arrayidx = getelementptr inbounds [9 x i32], [9 x i32]* %values, i64 0, i64 %2, !dbg !51
  %3 = load i32, i32* %arrayidx, align 4, !dbg !51
  %call1 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %3), !dbg !52
  br label %for.inc, !dbg !52

for.inc:                                          ; preds = %for.body
  %4 = load i64, i64* %index_variable, align 8, !dbg !53
  %inc = add i64 %4, 1, !dbg !53
  store i64 %inc, i64* %index_variable, align 8, !dbg !53
  br label %for.cond, !dbg !54, !llvm.loop !55

for.end:                                          ; preds = %for.cond
  %call2 = call i32 @putchar(i32 noundef 10), !dbg !58
  %arraydecay = getelementptr inbounds [9 x i32], [9 x i32]* %values, i64 0, i64 0, !dbg !59
  call void @heap_sort(i32* noundef %arraydecay, i64 noundef 9), !dbg !60
  %call3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2, i64 0, i64 0)), !dbg !61
  store i64 0, i64* %index_variable, align 8, !dbg !62
  br label %for.cond4, !dbg !64

for.cond4:                                        ; preds = %for.inc9, %for.end
  %5 = load i64, i64* %index_variable, align 8, !dbg !65
  %cmp5 = icmp ult i64 %5, 9, !dbg !67
  br i1 %cmp5, label %for.body6, label %for.end11, !dbg !68

for.body6:                                        ; preds = %for.cond4
  %6 = load i64, i64* %index_variable, align 8, !dbg !69
  %arrayidx7 = getelementptr inbounds [9 x i32], [9 x i32]* %values, i64 0, i64 %6, !dbg !70
  %7 = load i32, i32* %arrayidx7, align 4, !dbg !70
  %call8 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %7), !dbg !71
  br label %for.inc9, !dbg !71

for.inc9:                                         ; preds = %for.body6
  %8 = load i64, i64* %index_variable, align 8, !dbg !72
  %inc10 = add i64 %8, 1, !dbg !72
  store i64 %inc10, i64* %index_variable, align 8, !dbg !72
  br label %for.cond4, !dbg !73, !llvm.loop !74

for.end11:                                        ; preds = %for.cond4
  %call12 = call i32 @putchar(i32 noundef 10), !dbg !76
  ret i32 0, !dbg !77
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

declare i32 @printf(i8* noundef, ...) #3

declare i32 @putchar(i32 noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "heapsort_degpt.c", directory: "/mnt/c/Users/EMSEC/DeGPT/testcase", checksumkind: CSK_MD5, checksum: "336e173c3ca00c4ee6213863b23cf9b9")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.6"}
!10 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 46, type: !11, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!11 = !DISubroutineType(types: !12)
!12 = !{!13, !13, !14, !14}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!17 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!18 = !{}
!19 = !DILocalVariable(name: "argc", arg: 1, scope: !10, file: !1, line: 46, type: !13)
!20 = !DILocation(line: 46, column: 14, scope: !10)
!21 = !DILocalVariable(name: "argv", arg: 2, scope: !10, file: !1, line: 46, type: !14)
!22 = !DILocation(line: 46, column: 33, scope: !10)
!23 = !DILocalVariable(name: "envp", arg: 3, scope: !10, file: !1, line: 46, type: !14)
!24 = !DILocation(line: 46, column: 52, scope: !10)
!25 = !DILocalVariable(name: "index_variable", scope: !10, file: !1, line: 48, type: !26)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !27, line: 46, baseType: !28)
!27 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!28 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!29 = !DILocation(line: 48, column: 11, scope: !10)
!30 = !DILocalVariable(name: "values_array", scope: !10, file: !1, line: 49, type: !31)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 320, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 10)
!34 = !DILocation(line: 49, column: 6, scope: !10)
!35 = !DILocalVariable(name: "value_store", scope: !10, file: !1, line: 50, type: !26)
!36 = !DILocation(line: 50, column: 11, scope: !10)
!37 = !DILocalVariable(name: "values", scope: !10, file: !1, line: 53, type: !38)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 288, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 9)
!41 = !DILocation(line: 53, column: 6, scope: !10)
!42 = !DILocation(line: 54, column: 2, scope: !10)
!43 = !DILocation(line: 55, column: 26, scope: !44)
!44 = distinct !DILexicalBlock(scope: !10, file: !1, line: 55, column: 5)
!45 = !DILocation(line: 55, column: 11, scope: !44)
!46 = !DILocation(line: 55, column: 31, scope: !47)
!47 = distinct !DILexicalBlock(scope: !44, file: !1, line: 55, column: 5)
!48 = !DILocation(line: 55, column: 46, scope: !47)
!49 = !DILocation(line: 55, column: 5, scope: !44)
!50 = !DILocation(line: 56, column: 24, scope: !47)
!51 = !DILocation(line: 56, column: 17, scope: !47)
!52 = !DILocation(line: 56, column: 3, scope: !47)
!53 = !DILocation(line: 55, column: 51, scope: !47)
!54 = !DILocation(line: 55, column: 5, scope: !47)
!55 = distinct !{!55, !49, !56, !57}
!56 = !DILocation(line: 56, column: 39, scope: !44)
!57 = !{!"llvm.loop.mustprogress"}
!58 = !DILocation(line: 57, column: 2, scope: !10)
!59 = !DILocation(line: 58, column: 12, scope: !10)
!60 = !DILocation(line: 58, column: 2, scope: !10)
!61 = !DILocation(line: 59, column: 2, scope: !10)
!62 = !DILocation(line: 60, column: 23, scope: !63)
!63 = distinct !DILexicalBlock(scope: !10, file: !1, line: 60, column: 2)
!64 = !DILocation(line: 60, column: 8, scope: !63)
!65 = !DILocation(line: 60, column: 28, scope: !66)
!66 = distinct !DILexicalBlock(scope: !63, file: !1, line: 60, column: 2)
!67 = !DILocation(line: 60, column: 43, scope: !66)
!68 = !DILocation(line: 60, column: 2, scope: !63)
!69 = !DILocation(line: 61, column: 24, scope: !66)
!70 = !DILocation(line: 61, column: 17, scope: !66)
!71 = !DILocation(line: 61, column: 3, scope: !66)
!72 = !DILocation(line: 60, column: 48, scope: !66)
!73 = !DILocation(line: 60, column: 2, scope: !66)
!74 = distinct !{!74, !68, !75, !57}
!75 = !DILocation(line: 61, column: 39, scope: !63)
!76 = !DILocation(line: 62, column: 2, scope: !10)
!77 = !DILocation(line: 63, column: 2, scope: !10)
