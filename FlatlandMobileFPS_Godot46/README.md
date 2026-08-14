# Flatland Mobile FPS — Godot 4.6 Clean Copy

هذه هي النسخة النظيفة المتوافقة مع Godot 4.6. افتح **مجلد `FlatlandMobileFPS_Godot46` نفسه** في Godot، وليس مجلد `godot_mobile_fps` القديم أو نسخة ZIP قديمة.

## فتح المشروع

أغلق المشروع القديم من خلال **Project > Quit to Project List**. ثم اختر **Import**، وحدد هذا المجلد، ثم اختر **Import & Edit**. افتح المشهد `scenes/main.tscn` واضغط **3D** لرؤية العالم، ثم اضغط زر التشغيل في الأعلى.

تم حذف صيغة الاستدلال المختصرة `:=` من جميع السكربتات حتى لا يظهر خطأ `Cannot infer the type of delta` في Godot 4.6. يحتوي المشروع أيضاً على سماء إجرائية، ضباب جوي، إضاءة شمس وظلال، أرض مسطحة، لاعب منظور أول، عصا تحكم للمس، وزر **E / USE**.

## Controls

On mobile, use the left virtual joystick to move, drag the right side of the screen to look, and press **E / USE** to interact. On desktop, use **WASD** or the arrow keys, hold the left mouse button to look, and press **E** to interact.

## Important

If Godot still shows the old line `var delta :=`, you are opening the old project. Close it completely and import the folder named `FlatlandMobileFPS_Godot46` from the new archive.
