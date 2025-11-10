// Seletores principais
const loginScreen = document.getElementById("loginScreen");
const appScreen = document.getElementById("appScreen");
const settingsScreen = document.getElementById("settingsScreen");

const loginForm = document.getElementById("loginForm");
const clinicInput = document.getElementById("clinicName");
const clinicTitle = document.getElementById("clinicTitle");

const btnSettings = document.getElementById("btnSettings");
const btnBackToApp = document.getElementById("btnBackToApp");
const btnLogout = document.getElementById("btnLogout");

const navAgenda = document.getElementById("navAgenda");
const navSettings = document.getElementById("navSettings");
const navAgenda2 = document.getElementById("navAgenda2");
const navSettings2 = document.getElementById("navSettings2");

// ---------- LOGIN ----------
loginForm.addEventListener("submit", (e) => {
  e.preventDefault();

  const clinicName = clinicInput.value.trim() || "Pet Guardian";

  // Simula login
  localStorage.setItem("clinicName", clinicName);

  clinicTitle.textContent = clinicName;
  loginScreen.classList.remove("active");
  loginScreen.classList.add("d-none");

  appScreen.classList.remove("d-none");
});

// ---------- NAVEGAÇÃO ----------
btnSettings.addEventListener("click", () => {
  appScreen.classList.add("d-none");
  settingsScreen.classList.remove("d-none");
});

btnBackToApp.addEventListener("click", () => {
  settingsScreen.classList.add("d-none");
  appScreen.classList.remove("d-none");
});

// ---------- BOTTOM NAV ----------
navAgenda.addEventListener("click", () => {
  settingsScreen.classList.add("d-none");
  appScreen.classList.remove("d-none");
});

navSettings.addEventListener("click", () => {
  appScreen.classList.add("d-none");
  settingsScreen.classList.remove("d-none");
});

navAgenda2.addEventListener("click", () => {
  settingsScreen.classList.add("d-none");
  appScreen.classList.remove("d-none");
});

navSettings2.addEventListener("click", () => {
  appScreen.classList.add("d-none");
  settingsScreen.classList.remove("d-none");
});

// ---------- LOGOUT ----------
btnLogout.addEventListener("click", () => {
  localStorage.removeItem("clinicName");
  settingsScreen.classList.add("d-none");
  appScreen.classList.add("d-none");
  loginScreen.classList.remove("d-none");
});

// ---------- INICIALIZAÇÃO ----------
window.addEventListener("DOMContentLoaded", () => {
  const savedClinic = localStorage.getItem("clinicName");
  if (savedClinic) {
    clinicTitle.textContent = savedClinic;
    loginScreen.classList.add("d-none");
    appScreen.classList.remove("d-none");
  }
});

// ---------- CALENDÁRIO (simples de exemplo) ----------
const weekDays = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"];
const weekDaysContainer = document.getElementById("weekDays");
const calendarGrid = document.getElementById("calendarGrid");
const monthLabel = document.getElementById("monthLabel");
const upcomingList = document.getElementById("upcomingList");

weekDaysContainer.innerHTML = weekDays.map(d => `<div>${d}</div>`).join("");

let currentDate = new Date();

function renderCalendar(date) {
  const year = date.getFullYear();
  const month = date.getMonth();
  const firstDay = new Date(year, month, 1);
  const lastDay = new Date(year, month + 1, 0);

  monthLabel.textContent = date.toLocaleString("pt-BR", { month: "long", year: "numeric" });

  calendarGrid.innerHTML = "";
  for (let i = 0; i < firstDay.getDay(); i++) {
    calendarGrid.innerHTML += `<div></div>`;
  }
  for (let d = 1; d <= lastDay.getDate(); d++) {
    calendarGrid.innerHTML += `<div>${d}</div>`;
  }

  upcomingList.innerHTML = `
    <li class="list-group-item">💉 Vacina - 12/${month + 1}/${year}</li>
    <li class="list-group-item">🩺 Consulta - 18/${month + 1}/${year}</li>
    <li class="list-group-item">🧼 Banho & Tosa - 25/${month + 1}/${year}</li>
  `;
}

renderCalendar(currentDate);

document.getElementById("prevMonth").addEventListener("click", () => {
  currentDate.setMonth(currentDate.getMonth() - 1);
  renderCalendar(currentDate);
});

document.getElementById("nextMonth").addEventListener("click", () => {
  currentDate.setMonth(currentDate.getMonth() + 1);
  renderCalendar(currentDate);
});
