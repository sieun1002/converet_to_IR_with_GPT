; ModuleID = '/home/nata20034/workspace/file/src/timsort.c'
source_filename = "/home/nata20034/workspace/file/src/timsort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [15 x i32] [i32 5, i32 3, i32 1, i32 2, i32 9, i32 5, i32 5, i32 6, i32 7, i32 8, i32 0, i32 4, i32 4, i32 10, i32 -1], align 16
@.str = private unnamed_addr constant [5 x i8] c"%d%s\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca [128 x i64], align 16
  %2 = alloca [128 x i64], align 16
  %3 = alloca [15 x i32], align 16
  %4 = bitcast [15 x i32]* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 60, i8* nonnull %4) #6
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(60) %4, i8* noundef nonnull align 16 dereferenceable(60) bitcast ([15 x i32]* @__const.main.a to i8*), i64 60, i1 false)
  %5 = tail call noalias dereferenceable_or_null(60) i8* @malloc(i64 noundef 60) #6
  %6 = bitcast i8* %5 to i32*
  %7 = icmp eq i8* %5, null
  br i1 %7, label %461, label %8

8:                                                ; preds = %0
  %9 = bitcast [128 x i64]* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 1024, i8* nonnull %9) #6
  %10 = bitcast [128 x i64]* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 1024, i8* nonnull %10) #6
  %11 = getelementptr inbounds [128 x i64], [128 x i64]* %2, i64 0, i64 0
  %12 = getelementptr inbounds [128 x i64], [128 x i64]* %2, i64 0, i64 1
  %13 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 1
  %14 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 0
  br label %19

15:                                               ; preds = %329
  %16 = icmp ugt i64 %330, 1
  br i1 %16, label %17, label %430

17:                                               ; preds = %332, %15
  %18 = phi i64 [ %330, %15 ], [ 2, %332 ]
  br label %339

19:                                               ; preds = %334, %8
  %20 = phi i64 [ 0, %8 ], [ %335, %334 ]
  %21 = phi i64 [ 0, %8 ], [ %66, %334 ]
  %22 = add nuw nsw i64 %21, 1
  %23 = icmp eq i64 %22, 15
  br i1 %23, label %65, label %24

24:                                               ; preds = %19
  %25 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %22
  %26 = load i32, i32* %25, align 4, !tbaa !5
  %27 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %21
  %28 = load i32, i32* %27, align 4, !tbaa !5
  %29 = icmp slt i32 %26, %28
  br i1 %29, label %30, label %56

30:                                               ; preds = %24, %35
  %31 = phi i64 [ %33, %35 ], [ %22, %24 ]
  %32 = phi i32 [ %37, %35 ], [ %26, %24 ]
  %33 = add i64 %31, 1
  %34 = icmp eq i64 %33, 15
  br i1 %34, label %39, label %35, !llvm.loop !9

35:                                               ; preds = %30
  %36 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %33
  %37 = load i32, i32* %36, align 4, !tbaa !5
  %38 = icmp slt i32 %37, %32
  br i1 %38, label %30, label %39

39:                                               ; preds = %35, %30
  %40 = icmp ult i64 %21, %31
  br i1 %40, label %41, label %65

41:                                               ; preds = %39
  %42 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %31
  %43 = load i32, i32* %42, align 4, !tbaa !5
  store i32 %43, i32* %27, align 4, !tbaa !5
  store i32 %28, i32* %42, align 4, !tbaa !5
  %44 = add i64 %31, -1
  %45 = icmp ult i64 %22, %44
  br i1 %45, label %46, label %65, !llvm.loop !11

46:                                               ; preds = %41, %46
  %47 = phi i64 [ %54, %46 ], [ %44, %41 ]
  %48 = phi i64 [ %53, %46 ], [ %22, %41 ]
  %49 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %48
  %50 = load i32, i32* %49, align 4, !tbaa !5
  %51 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %47
  %52 = load i32, i32* %51, align 4, !tbaa !5
  store i32 %52, i32* %49, align 4, !tbaa !5
  store i32 %50, i32* %51, align 4, !tbaa !5
  %53 = add nuw i64 %48, 1
  %54 = add i64 %47, -1
  %55 = icmp ult i64 %53, %54
  br i1 %55, label %46, label %65, !llvm.loop !11

56:                                               ; preds = %24, %61
  %57 = phi i64 [ %59, %61 ], [ %22, %24 ]
  %58 = phi i32 [ %63, %61 ], [ %26, %24 ]
  %59 = add i64 %57, 1
  %60 = icmp eq i64 %59, 15
  br i1 %60, label %65, label %61, !llvm.loop !12

61:                                               ; preds = %56
  %62 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %59
  %63 = load i32, i32* %62, align 4, !tbaa !5
  %64 = icmp slt i32 %63, %58
  br i1 %64, label %65, label %56

65:                                               ; preds = %61, %56, %46, %41, %39, %19
  %66 = phi i64 [ 15, %19 ], [ %33, %39 ], [ %33, %41 ], [ %33, %46 ], [ %59, %61 ], [ 15, %56 ]
  %67 = sub i64 %66, %21
  %68 = icmp ugt i64 %67, 32
  %69 = select i1 %68, i64 %67, i64 32
  %70 = add i64 %69, %21
  %71 = icmp ult i64 %70, 15
  %72 = select i1 %71, i64 %70, i64 15
  %73 = icmp ult i64 %66, %72
  br i1 %73, label %80, label %74

74:                                               ; preds = %94, %65
  %75 = sub i64 %72, %21
  %76 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 %20
  store i64 %21, i64* %76, align 8, !tbaa !13
  %77 = getelementptr inbounds [128 x i64], [128 x i64]* %2, i64 0, i64 %20
  store i64 %75, i64* %77, align 8, !tbaa !13
  %78 = add i64 %20, 1
  %79 = icmp ugt i64 %78, 1
  br i1 %79, label %99, label %329

80:                                               ; preds = %65, %94
  %81 = phi i64 [ %97, %94 ], [ %66, %65 ]
  %82 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %81
  %83 = load i32, i32* %82, align 4, !tbaa !5
  %84 = icmp ugt i64 %81, %21
  br i1 %84, label %85, label %94

85:                                               ; preds = %80, %91
  %86 = phi i64 [ %87, %91 ], [ %81, %80 ]
  %87 = add i64 %86, -1
  %88 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %87
  %89 = load i32, i32* %88, align 4, !tbaa !5
  %90 = icmp sgt i32 %89, %83
  br i1 %90, label %91, label %94

91:                                               ; preds = %85
  %92 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %86
  store i32 %89, i32* %92, align 4, !tbaa !5
  %93 = icmp ugt i64 %87, %21
  br i1 %93, label %85, label %94, !llvm.loop !15

94:                                               ; preds = %91, %85, %80
  %95 = phi i64 [ %81, %80 ], [ %86, %85 ], [ %21, %91 ]
  %96 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %95
  store i32 %83, i32* %96, align 4, !tbaa !5
  %97 = add nuw nsw i64 %81, 1
  %98 = icmp eq i64 %97, %72
  br i1 %98, label %74, label %80, !llvm.loop !16

99:                                               ; preds = %74, %282
  %100 = phi i64 [ %283, %282 ], [ %78, %74 ]
  %101 = icmp eq i64 %100, 2
  br i1 %101, label %285, label %102

102:                                              ; preds = %99
  %103 = add i64 %100, -3
  %104 = getelementptr inbounds [128 x i64], [128 x i64]* %2, i64 0, i64 %103
  %105 = load i64, i64* %104, align 8, !tbaa !13
  %106 = add i64 %100, -2
  %107 = getelementptr inbounds [128 x i64], [128 x i64]* %2, i64 0, i64 %106
  %108 = load i64, i64* %107, align 8, !tbaa !13
  %109 = add i64 %100, -1
  %110 = getelementptr inbounds [128 x i64], [128 x i64]* %2, i64 0, i64 %109
  %111 = load i64, i64* %110, align 8, !tbaa !13
  %112 = add i64 %111, %108
  %113 = icmp ugt i64 %105, %112
  %114 = icmp ugt i64 %108, %111
  %115 = and i1 %114, %113
  br i1 %115, label %329, label %116

116:                                              ; preds = %102
  %117 = icmp ult i64 %105, %111
  br i1 %117, label %118, label %201

118:                                              ; preds = %116
  %119 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 %103
  %120 = load i64, i64* %119, align 8, !tbaa !13
  %121 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 %106
  %122 = load i64, i64* %121, align 8, !tbaa !13
  store i64 %120, i64* %121, align 8, !tbaa !13
  store i64 %105, i64* %107, align 8, !tbaa !13
  store i64 %122, i64* %119, align 8, !tbaa !13
  %123 = icmp ugt i64 %108, %105
  br i1 %123, label %162, label %124

124:                                              ; preds = %118
  %125 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %122
  %126 = bitcast i32* %125 to i8*
  %127 = shl i64 %108, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %5, i8* nonnull align 4 %126, i64 %127, i1 false) #6
  %128 = add i64 %120, %105
  %129 = icmp ne i64 %108, 0
  %130 = icmp ult i64 %120, %128
  %131 = select i1 %129, i1 %130, i1 false
  br i1 %131, label %142, label %132

132:                                              ; preds = %142, %124
  %133 = phi i64 [ %122, %124 ], [ %158, %142 ]
  %134 = phi i64 [ 0, %124 ], [ %156, %142 ]
  %135 = icmp ult i64 %134, %108
  br i1 %135, label %136, label %199

136:                                              ; preds = %132
  %137 = getelementptr [15 x i32], [15 x i32]* %3, i64 0, i64 %133
  %138 = bitcast i32* %137 to i8*
  %139 = shl i64 %134, 2
  %140 = getelementptr i8, i8* %5, i64 %139
  %141 = sub i64 %127, %139
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %138, i8* align 4 %140, i64 %141, i1 false) #6, !tbaa !5
  br label %199

142:                                              ; preds = %124, %142
  %143 = phi i64 [ %156, %142 ], [ 0, %124 ]
  %144 = phi i64 [ %153, %142 ], [ %120, %124 ]
  %145 = phi i64 [ %158, %142 ], [ %122, %124 ]
  %146 = getelementptr inbounds i32, i32* %6, i64 %143
  %147 = load i32, i32* %146, align 4, !tbaa !5
  %148 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %144
  %149 = load i32, i32* %148, align 4, !tbaa !5
  %150 = icmp sgt i32 %147, %149
  %151 = select i1 %150, i32 %149, i32 %147
  %152 = zext i1 %150 to i64
  %153 = add nuw i64 %144, %152
  %154 = xor i1 %150, true
  %155 = zext i1 %154 to i64
  %156 = add nuw i64 %143, %155
  %157 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %145
  store i32 %151, i32* %157, align 4
  %158 = add i64 %145, 1
  %159 = icmp ult i64 %156, %108
  %160 = icmp ult i64 %153, %128
  %161 = select i1 %159, i1 %160, i1 false
  br i1 %161, label %142, label %132, !llvm.loop !17

162:                                              ; preds = %118
  %163 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %120
  %164 = bitcast i32* %163 to i8*
  %165 = shl i64 %105, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %5, i8* nonnull align 4 %164, i64 %165, i1 false) #6
  %166 = add i64 %122, %108
  %167 = add i64 %120, %105
  %168 = icmp ugt i64 %166, %122
  %169 = icmp ne i64 %105, 0
  %170 = select i1 %168, i1 %169, i1 false
  br i1 %170, label %180, label %171

171:                                              ; preds = %180, %162
  %172 = phi i64 [ %167, %162 ], [ %191, %180 ]
  %173 = phi i64 [ %105, %162 ], [ %194, %180 ]
  %174 = icmp eq i64 %173, 0
  br i1 %174, label %199, label %175

175:                                              ; preds = %171
  %176 = sub i64 %172, %173
  %177 = getelementptr [15 x i32], [15 x i32]* %3, i64 0, i64 %176
  %178 = bitcast i32* %177 to i8*
  %179 = shl nuw i64 %173, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %178, i8* nonnull align 4 %5, i64 %179, i1 false) #6, !tbaa !5
  br label %199

180:                                              ; preds = %162, %180
  %181 = phi i64 [ %195, %180 ], [ %166, %162 ]
  %182 = phi i64 [ %194, %180 ], [ %105, %162 ]
  %183 = phi i64 [ %191, %180 ], [ %167, %162 ]
  %184 = add i64 %181, -1
  %185 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %184
  %186 = load i32, i32* %185, align 4, !tbaa !5
  %187 = add i64 %182, -1
  %188 = getelementptr inbounds i32, i32* %6, i64 %187
  %189 = load i32, i32* %188, align 4, !tbaa !5
  %190 = icmp sgt i32 %186, %189
  %191 = add i64 %183, -1
  %192 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %191
  %193 = select i1 %190, i32 %186, i32 %189
  %194 = select i1 %190, i64 %182, i64 %187
  %195 = select i1 %190, i64 %184, i64 %181
  store i32 %193, i32* %192, align 4, !tbaa !5
  %196 = icmp ugt i64 %195, %122
  %197 = icmp ne i64 %194, 0
  %198 = select i1 %196, i1 %197, i1 false
  br i1 %198, label %180, label %171, !llvm.loop !18

199:                                              ; preds = %175, %171, %136, %132
  %200 = add i64 %108, %105
  store i64 %200, i64* %104, align 8, !tbaa !13
  br label %282

201:                                              ; preds = %116
  %202 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 %109
  %203 = load i64, i64* %202, align 8, !tbaa !13
  %204 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 %106
  %205 = load i64, i64* %204, align 8, !tbaa !13
  br i1 %114, label %244, label %206

206:                                              ; preds = %201
  %207 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %205
  %208 = bitcast i32* %207 to i8*
  %209 = shl i64 %108, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %5, i8* nonnull align 4 %208, i64 %209, i1 false) #6
  %210 = add i64 %203, %111
  %211 = icmp ne i64 %108, 0
  %212 = icmp ult i64 %203, %210
  %213 = select i1 %211, i1 %212, i1 false
  br i1 %213, label %224, label %214

214:                                              ; preds = %224, %206
  %215 = phi i64 [ 0, %206 ], [ %236, %224 ]
  %216 = phi i64 [ %205, %206 ], [ %240, %224 ]
  %217 = icmp ult i64 %215, %108
  br i1 %217, label %218, label %281

218:                                              ; preds = %214
  %219 = getelementptr [15 x i32], [15 x i32]* %3, i64 0, i64 %216
  %220 = bitcast i32* %219 to i8*
  %221 = shl i64 %215, 2
  %222 = getelementptr i8, i8* %5, i64 %221
  %223 = sub i64 %209, %221
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %220, i8* align 4 %222, i64 %223, i1 false) #6, !tbaa !5
  br label %281

224:                                              ; preds = %206, %224
  %225 = phi i64 [ %240, %224 ], [ %205, %206 ]
  %226 = phi i64 [ %238, %224 ], [ %203, %206 ]
  %227 = phi i64 [ %236, %224 ], [ 0, %206 ]
  %228 = getelementptr inbounds i32, i32* %6, i64 %227
  %229 = load i32, i32* %228, align 4, !tbaa !5
  %230 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %226
  %231 = load i32, i32* %230, align 4, !tbaa !5
  %232 = icmp sgt i32 %229, %231
  %233 = select i1 %232, i32 %231, i32 %229
  %234 = xor i1 %232, true
  %235 = zext i1 %234 to i64
  %236 = add nuw i64 %227, %235
  %237 = zext i1 %232 to i64
  %238 = add nuw i64 %226, %237
  %239 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %225
  store i32 %233, i32* %239, align 4
  %240 = add i64 %225, 1
  %241 = icmp ult i64 %236, %108
  %242 = icmp ult i64 %238, %210
  %243 = select i1 %241, i1 %242, i1 false
  br i1 %243, label %224, label %214, !llvm.loop !19

244:                                              ; preds = %201
  %245 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %203
  %246 = bitcast i32* %245 to i8*
  %247 = shl i64 %111, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %5, i8* nonnull align 4 %246, i64 %247, i1 false) #6
  %248 = add i64 %205, %108
  %249 = add i64 %203, %111
  %250 = icmp ugt i64 %248, %205
  %251 = icmp ne i64 %111, 0
  %252 = select i1 %250, i1 %251, i1 false
  br i1 %252, label %262, label %253

253:                                              ; preds = %262, %244
  %254 = phi i64 [ %111, %244 ], [ %277, %262 ]
  %255 = phi i64 [ %249, %244 ], [ %273, %262 ]
  %256 = icmp eq i64 %254, 0
  br i1 %256, label %281, label %257

257:                                              ; preds = %253
  %258 = sub i64 %255, %254
  %259 = getelementptr [15 x i32], [15 x i32]* %3, i64 0, i64 %258
  %260 = bitcast i32* %259 to i8*
  %261 = shl nuw i64 %254, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %260, i8* nonnull align 4 %5, i64 %261, i1 false) #6, !tbaa !5
  br label %281

262:                                              ; preds = %244, %262
  %263 = phi i64 [ %273, %262 ], [ %249, %244 ]
  %264 = phi i64 [ %277, %262 ], [ %111, %244 ]
  %265 = phi i64 [ %276, %262 ], [ %248, %244 ]
  %266 = add i64 %265, -1
  %267 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %266
  %268 = load i32, i32* %267, align 4, !tbaa !5
  %269 = add i64 %264, -1
  %270 = getelementptr inbounds i32, i32* %6, i64 %269
  %271 = load i32, i32* %270, align 4, !tbaa !5
  %272 = icmp sgt i32 %268, %271
  %273 = add i64 %263, -1
  %274 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %273
  %275 = select i1 %272, i32 %268, i32 %271
  %276 = select i1 %272, i64 %266, i64 %265
  %277 = select i1 %272, i64 %264, i64 %269
  store i32 %275, i32* %274, align 4, !tbaa !5
  %278 = icmp ugt i64 %276, %205
  %279 = icmp ne i64 %277, 0
  %280 = select i1 %278, i1 %279, i1 false
  br i1 %280, label %262, label %253, !llvm.loop !20

281:                                              ; preds = %257, %253, %218, %214
  store i64 %112, i64* %107, align 8, !tbaa !13
  br label %282

282:                                              ; preds = %281, %199
  %283 = phi i64 [ %106, %199 ], [ %109, %281 ]
  %284 = icmp ugt i64 %283, 1
  br i1 %284, label %99, label %329

285:                                              ; preds = %99
  %286 = load i64, i64* %11, align 16, !tbaa !13
  %287 = load i64, i64* %12, align 8, !tbaa !13
  %288 = icmp ugt i64 %286, %287
  br i1 %288, label %332, label %289

289:                                              ; preds = %285
  %290 = load i64, i64* %13, align 8, !tbaa !13
  %291 = load i64, i64* %14, align 16, !tbaa !13
  %292 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %291
  %293 = bitcast i32* %292 to i8*
  %294 = shl i64 %286, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %5, i8* nonnull align 4 %293, i64 %294, i1 false) #6
  %295 = add i64 %290, %287
  %296 = icmp ne i64 %286, 0
  %297 = icmp ult i64 %290, %295
  %298 = select i1 %296, i1 %297, i1 false
  br i1 %298, label %309, label %299

299:                                              ; preds = %309, %289
  %300 = phi i64 [ 0, %289 ], [ %321, %309 ]
  %301 = phi i64 [ %291, %289 ], [ %325, %309 ]
  %302 = icmp ult i64 %300, %286
  br i1 %302, label %303, label %336

303:                                              ; preds = %299
  %304 = getelementptr [15 x i32], [15 x i32]* %3, i64 0, i64 %301
  %305 = bitcast i32* %304 to i8*
  %306 = shl i64 %300, 2
  %307 = getelementptr i8, i8* %5, i64 %306
  %308 = sub i64 %294, %306
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %305, i8* align 4 %307, i64 %308, i1 false) #6, !tbaa !5
  br label %336

309:                                              ; preds = %289, %309
  %310 = phi i64 [ %325, %309 ], [ %291, %289 ]
  %311 = phi i64 [ %323, %309 ], [ %290, %289 ]
  %312 = phi i64 [ %321, %309 ], [ 0, %289 ]
  %313 = getelementptr inbounds i32, i32* %6, i64 %312
  %314 = load i32, i32* %313, align 4, !tbaa !5
  %315 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %311
  %316 = load i32, i32* %315, align 4, !tbaa !5
  %317 = icmp sgt i32 %314, %316
  %318 = select i1 %317, i32 %316, i32 %314
  %319 = xor i1 %317, true
  %320 = zext i1 %319 to i64
  %321 = add nuw i64 %312, %320
  %322 = zext i1 %317 to i64
  %323 = add nuw i64 %311, %322
  %324 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %310
  store i32 %318, i32* %324, align 4
  %325 = add i64 %310, 1
  %326 = icmp ult i64 %321, %286
  %327 = icmp ult i64 %323, %295
  %328 = select i1 %326, i1 %327, i1 false
  br i1 %328, label %309, label %299, !llvm.loop !21

329:                                              ; preds = %282, %102, %74
  %330 = phi i64 [ %78, %74 ], [ %283, %282 ], [ %100, %102 ]
  %331 = icmp ult i64 %66, 15
  br i1 %331, label %334, label %15

332:                                              ; preds = %285
  %333 = icmp ult i64 %66, 15
  br i1 %333, label %334, label %17

334:                                              ; preds = %332, %336, %329
  %335 = phi i64 [ %330, %329 ], [ 1, %336 ], [ 2, %332 ]
  br label %19, !llvm.loop !22

336:                                              ; preds = %303, %299
  %337 = add i64 %287, %286
  store i64 %337, i64* %11, align 16, !tbaa !13
  %338 = icmp ult i64 %66, 15
  br i1 %338, label %334, label %430

339:                                              ; preds = %17, %427
  %340 = phi i64 [ %341, %427 ], [ %18, %17 ]
  %341 = add i64 %340, -1
  %342 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 %341
  %343 = load i64, i64* %342, align 8, !tbaa !13
  %344 = getelementptr inbounds [128 x i64], [128 x i64]* %2, i64 0, i64 %341
  %345 = load i64, i64* %344, align 8, !tbaa !13
  %346 = add i64 %340, -2
  %347 = getelementptr inbounds [128 x i64], [128 x i64]* %1, i64 0, i64 %346
  %348 = load i64, i64* %347, align 8, !tbaa !13
  %349 = getelementptr inbounds [128 x i64], [128 x i64]* %2, i64 0, i64 %346
  %350 = load i64, i64* %349, align 8, !tbaa !13
  %351 = icmp ugt i64 %350, %345
  br i1 %351, label %390, label %352

352:                                              ; preds = %339
  %353 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %348
  %354 = bitcast i32* %353 to i8*
  %355 = shl i64 %350, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %5, i8* nonnull align 4 %354, i64 %355, i1 false) #6
  %356 = add i64 %345, %343
  %357 = icmp ne i64 %350, 0
  %358 = icmp ult i64 %343, %356
  %359 = select i1 %357, i1 %358, i1 false
  br i1 %359, label %370, label %360

360:                                              ; preds = %370, %352
  %361 = phi i64 [ 0, %352 ], [ %382, %370 ]
  %362 = phi i64 [ %348, %352 ], [ %386, %370 ]
  %363 = icmp ult i64 %361, %350
  br i1 %363, label %364, label %427

364:                                              ; preds = %360
  %365 = getelementptr [15 x i32], [15 x i32]* %3, i64 0, i64 %362
  %366 = bitcast i32* %365 to i8*
  %367 = shl i64 %361, 2
  %368 = getelementptr i8, i8* %5, i64 %367
  %369 = sub i64 %355, %367
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %366, i8* align 4 %368, i64 %369, i1 false) #6, !tbaa !5
  br label %427

370:                                              ; preds = %352, %370
  %371 = phi i64 [ %386, %370 ], [ %348, %352 ]
  %372 = phi i64 [ %384, %370 ], [ %343, %352 ]
  %373 = phi i64 [ %382, %370 ], [ 0, %352 ]
  %374 = getelementptr inbounds i32, i32* %6, i64 %373
  %375 = load i32, i32* %374, align 4, !tbaa !5
  %376 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %372
  %377 = load i32, i32* %376, align 4, !tbaa !5
  %378 = icmp sgt i32 %375, %377
  %379 = select i1 %378, i32 %377, i32 %375
  %380 = xor i1 %378, true
  %381 = zext i1 %380 to i64
  %382 = add nuw i64 %373, %381
  %383 = zext i1 %378 to i64
  %384 = add nuw i64 %372, %383
  %385 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %371
  store i32 %379, i32* %385, align 4
  %386 = add i64 %371, 1
  %387 = icmp ult i64 %382, %350
  %388 = icmp ult i64 %384, %356
  %389 = select i1 %387, i1 %388, i1 false
  br i1 %389, label %370, label %360, !llvm.loop !23

390:                                              ; preds = %339
  %391 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %343
  %392 = bitcast i32* %391 to i8*
  %393 = shl i64 %345, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %5, i8* nonnull align 4 %392, i64 %393, i1 false) #6
  %394 = add i64 %350, %348
  %395 = add i64 %345, %343
  %396 = icmp ugt i64 %394, %348
  %397 = icmp ne i64 %345, 0
  %398 = select i1 %396, i1 %397, i1 false
  br i1 %398, label %408, label %399

399:                                              ; preds = %408, %390
  %400 = phi i64 [ %345, %390 ], [ %423, %408 ]
  %401 = phi i64 [ %395, %390 ], [ %419, %408 ]
  %402 = icmp eq i64 %400, 0
  br i1 %402, label %427, label %403

403:                                              ; preds = %399
  %404 = sub i64 %401, %400
  %405 = getelementptr [15 x i32], [15 x i32]* %3, i64 0, i64 %404
  %406 = bitcast i32* %405 to i8*
  %407 = shl nuw i64 %400, 2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %406, i8* nonnull align 4 %5, i64 %407, i1 false) #6, !tbaa !5
  br label %427

408:                                              ; preds = %390, %408
  %409 = phi i64 [ %419, %408 ], [ %395, %390 ]
  %410 = phi i64 [ %423, %408 ], [ %345, %390 ]
  %411 = phi i64 [ %422, %408 ], [ %394, %390 ]
  %412 = add i64 %411, -1
  %413 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %412
  %414 = load i32, i32* %413, align 4, !tbaa !5
  %415 = add i64 %410, -1
  %416 = getelementptr inbounds i32, i32* %6, i64 %415
  %417 = load i32, i32* %416, align 4, !tbaa !5
  %418 = icmp sgt i32 %414, %417
  %419 = add i64 %409, -1
  %420 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 %419
  %421 = select i1 %418, i32 %414, i32 %417
  %422 = select i1 %418, i64 %412, i64 %411
  %423 = select i1 %418, i64 %410, i64 %415
  store i32 %421, i32* %420, align 4, !tbaa !5
  %424 = icmp ugt i64 %422, %348
  %425 = icmp ne i64 %423, 0
  %426 = select i1 %424, i1 %425, i1 false
  br i1 %426, label %408, label %399, !llvm.loop !24

427:                                              ; preds = %403, %399, %364, %360
  %428 = add i64 %350, %345
  store i64 %428, i64* %349, align 8, !tbaa !13
  %429 = icmp ugt i64 %341, 1
  br i1 %429, label %339, label %430, !llvm.loop !25

430:                                              ; preds = %336, %427, %15
  tail call void @free(i8* noundef %5) #6
  call void @llvm.lifetime.end.p0i8(i64 1024, i8* nonnull %10) #6
  call void @llvm.lifetime.end.p0i8(i64 1024, i8* nonnull %9) #6
  %431 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 0
  %432 = load i32, i32* %431, align 16, !tbaa !5
  %433 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 1
  %434 = load i32, i32* %433, align 4, !tbaa !5
  %435 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 2
  %436 = load i32, i32* %435, align 8, !tbaa !5
  %437 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 3
  %438 = load i32, i32* %437, align 4, !tbaa !5
  %439 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 4
  %440 = load i32, i32* %439, align 16, !tbaa !5
  %441 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 5
  %442 = load i32, i32* %441, align 4, !tbaa !5
  %443 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 6
  %444 = load i32, i32* %443, align 8, !tbaa !5
  %445 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 7
  %446 = load i32, i32* %445, align 4, !tbaa !5
  %447 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 8
  %448 = load i32, i32* %447, align 16, !tbaa !5
  %449 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 9
  %450 = load i32, i32* %449, align 4, !tbaa !5
  %451 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 10
  %452 = load i32, i32* %451, align 8, !tbaa !5
  %453 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 11
  %454 = load i32, i32* %453, align 4, !tbaa !5
  %455 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 12
  %456 = load i32, i32* %455, align 16, !tbaa !5
  %457 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 13
  %458 = load i32, i32* %457, align 4, !tbaa !5
  %459 = getelementptr inbounds [15 x i32], [15 x i32]* %3, i64 0, i64 14
  %460 = load i32, i32* %459, align 8, !tbaa !5
  br label %461

461:                                              ; preds = %0, %430
  %462 = phi i32 [ -1, %0 ], [ %460, %430 ]
  %463 = phi i32 [ 10, %0 ], [ %458, %430 ]
  %464 = phi i32 [ 4, %0 ], [ %456, %430 ]
  %465 = phi i32 [ 4, %0 ], [ %454, %430 ]
  %466 = phi i32 [ 0, %0 ], [ %452, %430 ]
  %467 = phi i32 [ 8, %0 ], [ %450, %430 ]
  %468 = phi i32 [ 7, %0 ], [ %448, %430 ]
  %469 = phi i32 [ 6, %0 ], [ %446, %430 ]
  %470 = phi i32 [ 5, %0 ], [ %444, %430 ]
  %471 = phi i32 [ 5, %0 ], [ %442, %430 ]
  %472 = phi i32 [ 9, %0 ], [ %440, %430 ]
  %473 = phi i32 [ 2, %0 ], [ %438, %430 ]
  %474 = phi i32 [ 1, %0 ], [ %436, %430 ]
  %475 = phi i32 [ 3, %0 ], [ %434, %430 ]
  %476 = phi i32 [ 5, %0 ], [ %432, %430 ]
  %477 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %476, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %478 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %475, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %479 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %474, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %480 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %473, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %481 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %472, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %482 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %471, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %483 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %470, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %484 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %469, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %485 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %468, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %486 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %467, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %487 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %466, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %488 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %465, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %489 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %464, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %490 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %463, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %491 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 noundef %462, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0))
  call void @llvm.lifetime.end.p0i8(i64 60, i8* nonnull %4) #6
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #3

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #4

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #5

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #3 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { inaccessiblememonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10}
!12 = distinct !{!12, !10}
!13 = !{!14, !14, i64 0}
!14 = !{!"long", !7, i64 0}
!15 = distinct !{!15, !10}
!16 = distinct !{!16, !10}
!17 = distinct !{!17, !10}
!18 = distinct !{!18, !10}
!19 = distinct !{!19, !10}
!20 = distinct !{!20, !10}
!21 = distinct !{!21, !10}
!22 = distinct !{!22, !10}
!23 = distinct !{!23, !10}
!24 = distinct !{!24, !10}
!25 = distinct !{!25, !10}
