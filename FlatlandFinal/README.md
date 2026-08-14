# Flatland Final — Dependency-Safe Godot 4 Mobile Prototype

هذه النسخة مبنية بحيث يفتح `scenes/main.tscn` دائماً: المشهد يحتوي فقط على عقدة رئيسية وسكربت واحد، وكل الأرض والعشب واللاعب والبوابة والواجهة تُنشأ وقت التشغيل. لا توجد ملفات DAE أو WAV مطلوبة لتحميل المشهد.

افتح مجلد `FlatlandFinal` في Godot 4.3 أو أحدث، ثم شغّل `scenes/main.tscn`. الأصول الموجودة داخل `assets/` و`audio/` اختيارية؛ إذا تعذر استيراد موديل الحقيبة أو الصوت، تستمر اللعبة باستخدام حقيبة إجرائية وصوت صامت بدلاً من فشل فتح المشروع.

تبدأ اللعبة بأرض خضراء وعشب متحرك مع الرياح، عصا تحكم للموبايل، زر E، ثلاث خانات فارغة، وحقيبة قابلة للالتقاط. توجد بوابة زرقاء باسم DREAM SLIT تنقل اللاعب إلى ممر حلم مظلم أصلي.

The project is an original prototype inspired by broad liminal-survival ideas from the reference video. It does not copy Minecraft code, maps, or copyrighted assets.
