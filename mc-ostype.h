# HG changeset patch
# Parent faab78643465fbd8e6a93c57ffc4ead449855e2c
diff -r faab78643465 -r 10b5d4c6192a include/llvm/MC/MCSubtargetInfo.h
--- a/include/llvm/MC/MCSubtargetInfo.h	Sat Aug 13 13:44:27 2011 -0700
+++ b/include/llvm/MC/MCSubtargetInfo.h	Sat Aug 13 13:50:06 2011 -0700
@@ -57,6 +57,10 @@
     return FeatureBits;
   }
 
+  /// getOSType - return the OSType from the target triple
+  /// FIXME: pull in the full TargetTriple class
+  StringRef getOSType(StringRef TT);
+
   /// ReInitMCSubtargetInfo - Change CPU (and optionally supplemented with
   /// feature string), recompute and return feature bits.
   uint64_t ReInitMCSubtargetInfo(StringRef CPU, StringRef FS);
