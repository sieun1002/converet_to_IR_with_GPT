; ModuleID = 'cases/dijkstra/ref.ll'
source_filename = "/home/nata20034/workspace/file/src/dijkstra.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@.str.1 = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c" %zu%s\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c" ->\00", align 1
@.str.6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca [36 x i32], align 16
  %2 = bitcast [36 x i32]* %1 to i8*
  %3 = alloca [6 x i32], align 16
  %4 = alloca [6 x i32], align 16
  %5 = alloca [6 x i64], align 16
  call void @llvm.lifetime.start.p0i8(i64 144, i8* nonnull %2) #8
  %6 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 4
  %7 = bitcast i32* %6 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(144) %7, i8 -1, i64 128, i1 false), !tbaa !5
  %8 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 7
  store i32 0, i32* %8, align 4, !tbaa !5
  %9 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 14
  store i32 0, i32* %9, align 8, !tbaa !5
  %10 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 28
  store i32 0, i32* %10, align 16, !tbaa !5
  %11 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 35
  store i32 0, i32* %11, align 4, !tbaa !5
  %12 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 6
  store i32 7, i32* %12, align 8, !tbaa !5
  %13 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 12
  store i32 9, i32* %13, align 16, !tbaa !5
  %14 = bitcast [36 x i32]* %1 to <4 x i32>*
  store <4 x i32> <i32 0, i32 7, i32 9, i32 10>, <4 x i32>* %14, align 16, !tbaa !5
  %15 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 18
  %16 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 9
  store i32 15, i32* %16, align 4, !tbaa !5
  %17 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 15
  store i32 11, i32* %17, align 4, !tbaa !5
  %18 = bitcast i32* %15 to <4 x i32>*
  store <4 x i32> <i32 10, i32 15, i32 11, i32 0>, <4 x i32>* %18, align 8, !tbaa !5
  %19 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 22
  store i32 6, i32* %19, align 8, !tbaa !5
  %20 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 27
  store i32 6, i32* %20, align 4, !tbaa !5
  %21 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 29
  store i32 9, i32* %21, align 4, !tbaa !5
  %22 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 34
  store i32 9, i32* %22, align 8, !tbaa !5
  %23 = bitcast [6 x i32]* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %23) #8
  %24 = bitcast [6 x i32]* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %24) #8
  %25 = getelementptr inbounds [6 x i32], [6 x i32]* %3, i64 0, i64 0
  %26 = getelementptr inbounds [6 x i32], [6 x i32]* %4, i64 0, i64 0
  %27 = tail call dereferenceable_or_null(24) i8* @calloc(i64 1, i64 24) #8
  %28 = bitcast i8* %27 to i32*
  %29 = icmp ne i8* %27, null
  call void @llvm.assume(i1 %29)
  %30 = getelementptr inbounds [6 x i32], [6 x i32]* %3, i64 0, i64 1
  %31 = getelementptr inbounds [6 x i32], [6 x i32]* %4, i64 0, i64 1
  %32 = getelementptr inbounds [6 x i32], [6 x i32]* %3, i64 0, i64 2
  %33 = getelementptr inbounds [6 x i32], [6 x i32]* %4, i64 0, i64 2
  %34 = getelementptr inbounds [6 x i32], [6 x i32]* %3, i64 0, i64 3
  %35 = getelementptr inbounds [6 x i32], [6 x i32]* %4, i64 0, i64 3
  %36 = getelementptr inbounds [6 x i32], [6 x i32]* %3, i64 0, i64 4
  store i32 1061109567, i32* %36, align 16, !tbaa !5
  %37 = getelementptr inbounds [6 x i32], [6 x i32]* %4, i64 0, i64 4
  %38 = getelementptr inbounds [6 x i32], [6 x i32]* %3, i64 0, i64 5
  store i32 1061109567, i32* %38, align 4, !tbaa !5
  %39 = getelementptr inbounds [6 x i32], [6 x i32]* %4, i64 0, i64 5
  %40 = bitcast [6 x i32]* %3 to <4 x i32>*
  store <4 x i32> <i32 0, i32 1061109567, i32 1061109567, i32 1061109567>, <4 x i32>* %40, align 16, !tbaa !5
  %41 = getelementptr inbounds i32, i32* %28, i64 1
  %42 = getelementptr inbounds i32, i32* %28, i64 2
  %43 = getelementptr inbounds i32, i32* %28, i64 3
  %44 = getelementptr inbounds i32, i32* %28, i64 4
  %45 = getelementptr inbounds i32, i32* %28, i64 5
  br label %46

46:                                               ; preds = %211, %0
  %47 = phi i32 [ 1061109567, %0 ], [ %207, %211 ]
  %48 = phi i32 [ 0, %0 ], [ %217, %211 ]
  %49 = phi i32 [ 1061109567, %0 ], [ %189, %211 ]
  %50 = phi i32 [ 0, %0 ], [ %216, %211 ]
  %51 = phi i32 [ 1061109567, %0 ], [ %171, %211 ]
  %52 = phi i32 [ 0, %0 ], [ %215, %211 ]
  %53 = phi i32 [ 1061109567, %0 ], [ %153, %211 ]
  %54 = phi i32 [ 0, %0 ], [ %214, %211 ]
  %55 = phi i32 [ 1061109567, %0 ], [ %135, %211 ]
  %56 = phi i32 [ 0, %0 ], [ %213, %211 ]
  %57 = phi i32 [ 0, %0 ], [ %117, %211 ]
  %58 = phi i32 [ -1, %0 ], [ %208, %211 ]
  %59 = phi i32 [ -1, %0 ], [ %190, %211 ]
  %60 = phi i32 [ -1, %0 ], [ %172, %211 ]
  %61 = phi i32 [ -1, %0 ], [ %154, %211 ]
  %62 = phi i32 [ -1, %0 ], [ %136, %211 ]
  %63 = phi i32 [ -1, %0 ], [ %118, %211 ]
  %64 = phi i32 [ 0, %0 ], [ %212, %211 ]
  %65 = phi i64 [ 0, %0 ], [ %209, %211 ]
  %66 = icmp eq i32 %64, 0
  %67 = icmp slt i32 %57, 1061109567
  %68 = select i1 %66, i1 %67, i1 false
  %69 = select i1 %68, i64 0, i64 6
  %70 = select i1 %68, i32 %57, i32 1061109567
  %71 = icmp eq i32 %56, 0
  %72 = icmp slt i32 %55, %70
  %73 = select i1 %71, i1 %72, i1 false
  %74 = select i1 %73, i64 1, i64 %69
  %75 = select i1 %73, i32 %55, i32 %70
  %76 = icmp eq i32 %54, 0
  %77 = icmp slt i32 %53, %75
  %78 = select i1 %76, i1 %77, i1 false
  %79 = select i1 %78, i64 2, i64 %74
  %80 = select i1 %78, i32 %53, i32 %75
  %81 = icmp eq i32 %52, 0
  %82 = icmp slt i32 %51, %80
  %83 = select i1 %81, i1 %82, i1 false
  %84 = select i1 %83, i64 3, i64 %79
  %85 = select i1 %83, i32 %51, i32 %80
  %86 = icmp eq i32 %50, 0
  %87 = icmp slt i32 %49, %85
  %88 = select i1 %86, i1 %87, i1 false
  %89 = select i1 %88, i64 4, i64 %84
  %90 = select i1 %88, i32 %49, i32 %85
  %91 = icmp eq i32 %48, 0
  %92 = icmp slt i32 %47, %90
  %93 = select i1 %91, i1 %92, i1 false
  br i1 %93, label %96, label %94

94:                                               ; preds = %46
  %95 = icmp eq i64 %89, 6
  br i1 %95, label %218, label %96

96:                                               ; preds = %94, %46
  %97 = phi i64 [ %89, %94 ], [ 5, %46 ]
  %98 = getelementptr inbounds i32, i32* %28, i64 %97
  store i32 1, i32* %98, align 4, !tbaa !5
  %99 = mul nuw nsw i64 %97, 6
  %100 = getelementptr inbounds [6 x i32], [6 x i32]* %3, i64 0, i64 %97
  %101 = trunc i64 %97 to i32
  %102 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 %99
  %103 = load i32, i32* %102, align 8, !tbaa !5
  %104 = icmp sgt i32 %103, -1
  br i1 %104, label %105, label %116

105:                                              ; preds = %96
  %106 = load i32, i32* %28, align 4, !tbaa !5
  %107 = icmp eq i32 %106, 0
  br i1 %107, label %108, label %116

108:                                              ; preds = %105
  %109 = load i32, i32* %100, align 4, !tbaa !5
  %110 = icmp eq i32 %109, 1061109567
  br i1 %110, label %116, label %111

111:                                              ; preds = %108
  %112 = add nsw i32 %109, %103
  %113 = icmp slt i32 %112, %57
  %114 = select i1 %113, i32 %112, i32 %57
  store i32 %114, i32* %25, align 16
  %115 = select i1 %113, i32 %101, i32 %63
  br label %116

116:                                              ; preds = %111, %108, %105, %96
  %117 = phi i32 [ %57, %108 ], [ %57, %105 ], [ %57, %96 ], [ %114, %111 ]
  %118 = phi i32 [ %63, %108 ], [ %63, %105 ], [ %63, %96 ], [ %115, %111 ]
  %119 = or i64 %99, 1
  %120 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 %119
  %121 = load i32, i32* %120, align 4, !tbaa !5
  %122 = icmp sgt i32 %121, -1
  br i1 %122, label %123, label %134

123:                                              ; preds = %116
  %124 = load i32, i32* %41, align 4, !tbaa !5
  %125 = icmp eq i32 %124, 0
  br i1 %125, label %126, label %134

126:                                              ; preds = %123
  %127 = load i32, i32* %100, align 4, !tbaa !5
  %128 = icmp eq i32 %127, 1061109567
  br i1 %128, label %134, label %129

129:                                              ; preds = %126
  %130 = add nsw i32 %127, %121
  %131 = icmp slt i32 %130, %55
  %132 = select i1 %131, i32 %130, i32 %55
  store i32 %132, i32* %30, align 4
  %133 = select i1 %131, i32 %101, i32 %62
  br label %134

134:                                              ; preds = %129, %126, %123, %116
  %135 = phi i32 [ %55, %126 ], [ %55, %123 ], [ %55, %116 ], [ %132, %129 ]
  %136 = phi i32 [ %62, %126 ], [ %62, %123 ], [ %62, %116 ], [ %133, %129 ]
  %137 = add nuw nsw i64 %99, 2
  %138 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 %137
  %139 = load i32, i32* %138, align 8, !tbaa !5
  %140 = icmp sgt i32 %139, -1
  br i1 %140, label %141, label %152

141:                                              ; preds = %134
  %142 = load i32, i32* %42, align 4, !tbaa !5
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %144, label %152

144:                                              ; preds = %141
  %145 = load i32, i32* %100, align 4, !tbaa !5
  %146 = icmp eq i32 %145, 1061109567
  br i1 %146, label %152, label %147

147:                                              ; preds = %144
  %148 = add nsw i32 %145, %139
  %149 = icmp slt i32 %148, %53
  %150 = select i1 %149, i32 %148, i32 %53
  store i32 %150, i32* %32, align 8
  %151 = select i1 %149, i32 %101, i32 %61
  br label %152

152:                                              ; preds = %147, %144, %141, %134
  %153 = phi i32 [ %53, %144 ], [ %53, %141 ], [ %53, %134 ], [ %150, %147 ]
  %154 = phi i32 [ %61, %144 ], [ %61, %141 ], [ %61, %134 ], [ %151, %147 ]
  %155 = add nuw nsw i64 %99, 3
  %156 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 %155
  %157 = load i32, i32* %156, align 4, !tbaa !5
  %158 = icmp sgt i32 %157, -1
  br i1 %158, label %159, label %170

159:                                              ; preds = %152
  %160 = load i32, i32* %43, align 4, !tbaa !5
  %161 = icmp eq i32 %160, 0
  br i1 %161, label %162, label %170

162:                                              ; preds = %159
  %163 = load i32, i32* %100, align 4, !tbaa !5
  %164 = icmp eq i32 %163, 1061109567
  br i1 %164, label %170, label %165

165:                                              ; preds = %162
  %166 = add nsw i32 %163, %157
  %167 = icmp slt i32 %166, %51
  %168 = select i1 %167, i32 %166, i32 %51
  store i32 %168, i32* %34, align 4
  %169 = select i1 %167, i32 %101, i32 %60
  br label %170

170:                                              ; preds = %165, %162, %159, %152
  %171 = phi i32 [ %51, %162 ], [ %51, %159 ], [ %51, %152 ], [ %168, %165 ]
  %172 = phi i32 [ %60, %162 ], [ %60, %159 ], [ %60, %152 ], [ %169, %165 ]
  %173 = add nuw nsw i64 %99, 4
  %174 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 %173
  %175 = load i32, i32* %174, align 8, !tbaa !5
  %176 = icmp sgt i32 %175, -1
  br i1 %176, label %177, label %188

177:                                              ; preds = %170
  %178 = load i32, i32* %44, align 4, !tbaa !5
  %179 = icmp eq i32 %178, 0
  br i1 %179, label %180, label %188

180:                                              ; preds = %177
  %181 = load i32, i32* %100, align 4, !tbaa !5
  %182 = icmp eq i32 %181, 1061109567
  br i1 %182, label %188, label %183

183:                                              ; preds = %180
  %184 = add nsw i32 %181, %175
  %185 = icmp slt i32 %184, %49
  %186 = select i1 %185, i32 %184, i32 %49
  store i32 %186, i32* %36, align 16
  %187 = select i1 %185, i32 %101, i32 %59
  br label %188

188:                                              ; preds = %183, %180, %177, %170
  %189 = phi i32 [ %49, %180 ], [ %49, %177 ], [ %49, %170 ], [ %186, %183 ]
  %190 = phi i32 [ %59, %180 ], [ %59, %177 ], [ %59, %170 ], [ %187, %183 ]
  %191 = add nuw nsw i64 %99, 5
  %192 = getelementptr inbounds [36 x i32], [36 x i32]* %1, i64 0, i64 %191
  %193 = load i32, i32* %192, align 4, !tbaa !5
  %194 = icmp sgt i32 %193, -1
  br i1 %194, label %195, label %206

195:                                              ; preds = %188
  %196 = load i32, i32* %45, align 4, !tbaa !5
  %197 = icmp eq i32 %196, 0
  br i1 %197, label %198, label %206

198:                                              ; preds = %195
  %199 = load i32, i32* %100, align 4, !tbaa !5
  %200 = icmp eq i32 %199, 1061109567
  br i1 %200, label %206, label %201

201:                                              ; preds = %198
  %202 = add nsw i32 %199, %193
  %203 = icmp slt i32 %202, %47
  %204 = select i1 %203, i32 %202, i32 %47
  store i32 %204, i32* %38, align 4
  %205 = select i1 %203, i32 %101, i32 %58
  br label %206

206:                                              ; preds = %201, %198, %195, %188
  %207 = phi i32 [ %47, %198 ], [ %47, %195 ], [ %47, %188 ], [ %204, %201 ]
  %208 = phi i32 [ %58, %198 ], [ %58, %195 ], [ %58, %188 ], [ %205, %201 ]
  %209 = add nuw nsw i64 %65, 1
  %210 = icmp eq i64 %209, 6
  br i1 %210, label %218, label %211, !llvm.loop !9

211:                                              ; preds = %206
  %212 = load i32, i32* %28, align 4, !tbaa !5
  %213 = load i32, i32* %41, align 4, !tbaa !5
  %214 = load i32, i32* %42, align 4, !tbaa !5
  %215 = load i32, i32* %43, align 4, !tbaa !5
  %216 = load i32, i32* %44, align 4, !tbaa !5
  %217 = load i32, i32* %45, align 4, !tbaa !5
  br label %46

218:                                              ; preds = %206, %94
  %219 = phi i32 [ %207, %206 ], [ %47, %94 ]
  %220 = phi i32 [ %189, %206 ], [ %49, %94 ]
  %221 = phi i32 [ %171, %206 ], [ %51, %94 ]
  %222 = phi i32 [ %153, %206 ], [ %53, %94 ]
  %223 = phi i32 [ %135, %206 ], [ %55, %94 ]
  %224 = phi i32 [ %117, %206 ], [ %57, %94 ]
  %225 = phi i32 [ %208, %206 ], [ %58, %94 ]
  %226 = phi i32 [ %190, %206 ], [ %59, %94 ]
  %227 = phi i32 [ %172, %206 ], [ %60, %94 ]
  %228 = phi i32 [ %154, %206 ], [ %61, %94 ]
  %229 = phi i32 [ %136, %206 ], [ %62, %94 ]
  %230 = phi i32 [ %118, %206 ], [ %63, %94 ]
  store i32 %230, i32* %26, align 16, !tbaa !5
  store i32 %229, i32* %31, align 4, !tbaa !5
  store i32 %228, i32* %33, align 8, !tbaa !5
  store i32 %227, i32* %35, align 4, !tbaa !5
  store i32 %226, i32* %37, align 16, !tbaa !5
  store i32 %225, i32* %39, align 4, !tbaa !5
  tail call void @free(i8* noundef nonnull %27) #8
  %231 = icmp sgt i32 %224, 1061109566
  br i1 %231, label %232, label %234

232:                                              ; preds = %218
  %233 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef 0, i64 noundef 0)
  br label %236

234:                                              ; preds = %218
  %235 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i64 noundef 0, i64 noundef 0, i32 noundef %224)
  br label %236

236:                                              ; preds = %234, %232
  %237 = icmp sgt i32 %223, 1061109566
  br i1 %237, label %240, label %238

238:                                              ; preds = %236
  %239 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i64 noundef 0, i64 noundef 1, i32 noundef %223)
  br label %242

240:                                              ; preds = %236
  %241 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef 0, i64 noundef 1)
  br label %242

242:                                              ; preds = %240, %238
  %243 = icmp sgt i32 %222, 1061109566
  br i1 %243, label %246, label %244

244:                                              ; preds = %242
  %245 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i64 noundef 0, i64 noundef 2, i32 noundef %222)
  br label %248

246:                                              ; preds = %242
  %247 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef 0, i64 noundef 2)
  br label %248

248:                                              ; preds = %246, %244
  %249 = icmp sgt i32 %221, 1061109566
  br i1 %249, label %252, label %250

250:                                              ; preds = %248
  %251 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i64 noundef 0, i64 noundef 3, i32 noundef %221)
  br label %254

252:                                              ; preds = %248
  %253 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef 0, i64 noundef 3)
  br label %254

254:                                              ; preds = %252, %250
  %255 = icmp sgt i32 %220, 1061109566
  br i1 %255, label %258, label %256

256:                                              ; preds = %254
  %257 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i64 noundef 0, i64 noundef 4, i32 noundef %220)
  br label %260

258:                                              ; preds = %254
  %259 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef 0, i64 noundef 4)
  br label %260

260:                                              ; preds = %258, %256
  %261 = icmp sgt i32 %219, 1061109566
  br i1 %261, label %262, label %265

262:                                              ; preds = %260
  %263 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef 0, i64 noundef 5)
  %264 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([25 x i8], [25 x i8]* @.str.2, i64 0, i64 0), i64 noundef 0, i64 noundef 5)
  br label %296

265:                                              ; preds = %260
  %266 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i64 noundef 0, i64 noundef 5, i32 noundef %219)
  %267 = bitcast [6 x i64]* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %267) #8
  %268 = getelementptr inbounds [6 x i64], [6 x i64]* %5, i64 0, i64 0
  store i64 5, i64* %268, align 16, !tbaa !11
  %269 = icmp eq i32 %225, -1
  br i1 %269, label %270, label %275, !llvm.loop !13

270:                                              ; preds = %275, %265
  %271 = phi i64 [ 0, %265 ], [ %276, %275 ]
  %272 = phi i64 [ 1, %265 ], [ %281, %275 ]
  %273 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0), i64 noundef 0, i64 noundef 5)
  %274 = icmp eq i64 %272, 0
  br i1 %274, label %284, label %286

275:                                              ; preds = %275, %265
  %276 = phi i64 [ %281, %275 ], [ 1, %265 ]
  %277 = phi i32 [ %280, %275 ], [ %225, %265 ]
  %278 = sext i32 %277 to i64
  %279 = getelementptr inbounds [6 x i32], [6 x i32]* %4, i64 0, i64 %278
  %280 = load i32, i32* %279, align 4, !tbaa !5
  %281 = add i64 %276, 1
  %282 = getelementptr inbounds [6 x i64], [6 x i64]* %5, i64 0, i64 %276
  store i64 %278, i64* %282, align 8, !tbaa !11
  %283 = icmp eq i32 %280, -1
  br i1 %283, label %270, label %275, !llvm.loop !13

284:                                              ; preds = %286, %270
  %285 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %267) #8
  br label %296

286:                                              ; preds = %286, %270
  %287 = phi i64 [ %291, %286 ], [ 0, %270 ]
  %288 = sub i64 %271, %287
  %289 = getelementptr inbounds [6 x i64], [6 x i64]* %5, i64 0, i64 %288
  %290 = load i64, i64* %289, align 8, !tbaa !11
  %291 = add nuw i64 %287, 1
  %292 = icmp ult i64 %291, %272
  %293 = select i1 %292, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.6, i64 0, i64 0)
  %294 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i64 noundef %290, i8* noundef %293)
  %295 = icmp eq i64 %271, %287
  br i1 %295, label %284, label %286, !llvm.loop !14

296:                                              ; preds = %284, %262
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %24) #8
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %23) #8
  call void @llvm.lifetime.end.p0i8(i64 144, i8* nonnull %2) #8
  ret i32 0
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #3

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #4

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #5

; Function Attrs: inaccessiblememonly nofree nounwind willreturn
declare noalias noundef i8* @calloc(i64 noundef, i64 noundef) local_unnamed_addr #6

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #7

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree nounwind }
attributes #5 = { argmemonly nofree nounwind willreturn writeonly }
attributes #6 = { inaccessiblememonly nofree nounwind willreturn }
attributes #7 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #8 = { nounwind }

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
!11 = !{!12, !12, i64 0}
!12 = !{!"long", !7, i64 0}
!13 = distinct !{!13, !10}
!14 = distinct !{!14, !10}
