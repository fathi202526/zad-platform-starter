const dialog = document.getElementById("infoDialog");
const dialogTitle = document.getElementById("dialogTitle");
const dialogText = document.getElementById("dialogText");

function showInfo(title, message) {
  dialogTitle.textContent = title;
  dialogText.textContent = message;
  if (typeof dialog.showModal === "function") dialog.showModal();
  else alert(title + "\n\n" + message);
}

document.getElementById("year").textContent = new Date().getFullYear();

document.getElementById("menuToggle").addEventListener("click", () => {
  document.getElementById("mainNav").classList.toggle("open");
});

document.querySelectorAll("#mainNav a").forEach(link => {
  link.addEventListener("click", () => document.getElementById("mainNav").classList.remove("open"));
});

document.getElementById("loginBtn").addEventListener("click", () => {
  showInfo("تسجيل الدخول", "واجهة الحسابات جاهزة للتصميم، لكن تسجيل الدخول الحقيقي سيُفعّل بعد ربط Supabase وإعداد صلاحيات المستخدمين.");
});

document.getElementById("ctaBtn").addEventListener("click", () => {
  showInfo("إنشاء حساب في زاد", "هذه نسخة الواجهة الأولى. في المرحلة التالية سننشئ التسجيل والدخول الآمنين ونربطهما بقاعدة البيانات.");
});

document.getElementById("dialogClose").addEventListener("click", () => dialog.close());
document.getElementById("dialogOk").addEventListener("click", () => dialog.close());

document.querySelectorAll("[data-course]").forEach(button => {
  button.addEventListener("click", () => {
    const course = button.dataset.course;
    showInfo(course, "هذه بطاقة تجريبية. سنضيف الدروس الفعلية لكل مادة من لوحة الإدارة بعد ربط قاعدة البيانات.");
  });
});
