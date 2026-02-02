

🍷 Wine 11.1 WCP — Сборка Wine для Winlator



Wine 11.1 WCP — это репозиторий со скриптами и конфигурациями для построения Wine версии 11.1 в формате .wcp (Wine container package), пригодного для использования в Winlator‑Bionic / Winlator Ludashi на Android‑устройствах. 

> ⚠️ Важно: текущая сборка настоящего Wine ещё не прошла доработку до полностью рабочего бинарника и не запускается напрямую в Winlator‑среде без дополнительной интеграции. Это рабочая база и автоматизация сборки, а не финальный готовый продукт.




---

📌 Описание проекта

Wine — это слой совместимости, позволяющий запускать программы Windows на системах POSIX‑сред, таких как Linux, macOS и Android‑эмуляторы. 

Проект wine_11.1wcp включает:

⚙️ скрипты сборки Wine (build.sh, build‑wine.sh)

🗃️ конфигурации для создания .wcp пакетов

📦 интеграция зависимостей и подготовка окружения


Цель: собрать Wine в формате WCP, который будет совместим с Winlator и его контейнерами.


---

📊 Текущий статус

📍 Проект находится в разработке – Wine 11.1 ещё не полностью работает в Winlator‑контейнерах; результаты сборки требуют отладки и интеграции зависимостей.

На данный момент:

✔ Скрипты могут собрать Wine с зависимостями
❌ Выйгрышного Wine‑пакета .wcp ещё нет
❌ Wine не запускается «из коробки» в Winlator
❌ Требуется ручная отладка и интеграция FEXCore / Box86 / Box64

Этот репозиторий нацелен на разработчиков и экспериментаторов, а не на конечных пользователей.


---

📦 Что такое WCP

WCP — это специальный формат контейнера Wine, используемый в Winlator‑Bionic и Ludashi для удобного распространения Wine‑билдов и зависимостей. 

Контейнеры .wcp включают Wine, библиотеки и зависимости в формате, понятном для Winlator.


---

🧩 Структура репозитория

├── build‑wine.sh         # Скрипт сборки Wine в .wcp
├── build.sh              # Главный скрипт автоматизации сборки
├── .github/workflows/    # CI настройка сборки
├── README.md             # Этот файл
└── другие файлы и зависимости


---

🚀 Как использовать

🛠 Пререквизиты

Для запуска сборки вам потребуются:

✔ Linux‑окружение (Ubuntu/Debian‑подобные)
✔ git, bash, make, pkg‑config
✔ Компиляторы (clang, gcc)
✔ Библиотеки зависимостей (freetype, zlib и т.д.)

(Список зависит от Wine‑зависимостей и Winlator‑требований).


---

🧪 Сборка Wine

1. Клонируйте репозиторий:

git clone https://github.com/kosoymiki/wine_11.1wcp.git
cd wine_11.1wcp


2. Запустите билд‑скрипт:

./build.sh


3. После успешной сборки будет создан пакет .wcp (если сборка прошла корректно).




---

🧭 Интеграция с Winlator

Собранный .wcp файл можно попытаться интегрировать в Winlator‑Bionic или Winlator Ludashi:

1. Скопируйте .wcp в каталог контейнеров Winlator.


2. Подключите его через интерфейс Winlator.


3. Отладьте переменные окружения (Box86 / Box64 / FEXCore / DLL overrides).



⚠️ Из‑за сложностей Wine на Android в WCP‑контейнере многие приложения и игры могут не запускаться без дополнительной конфигурации.


---

📣 Чего ещё нет

❌ Документации по готовому Wine‑WCP для Winlator
❌ Файлов конфигурации для автоматического запуска приложений
❌ Стандартного билда для всех Android‑устройств


---

🛠 Для разработчиков

Проект ориентирован на участников, которые готовы:

дописать и оптимизировать билд‑скрипты

добавить тесты запуска Wine внутри Winlator

интегрировать зависимости и контейнеры


Если вы разработчик, вам особенно полезны:

✔ понимание зависимости Wine
✔ опыт в кросс‑компиляции
✔ опыт с Android‑Wine интеграцией


---

📄 Лицензия

Проект распространяется под лицензией, совместимой с лицензией Wine — LGPL или MIT (в зависимости от включённых компонентов).

Для точного указания лицензии см. файлы проекта.


------------------

🍷 Wine 11.1 WCP — Wine Build for Winlator



Wine 11.1 WCP is a collection of build scripts and configuration files designed to automate the process of compiling Wine 11.1 into a .wcp package usable by Winlator (Winlator‑Bionic / Winlator Ludashi) on Android devices.

> ⚠️ Important: This repository does not yet produce a complete, runnable Wine build for Winlator. The work here is experimental; further development and integration are still required before Wine can be launched in Winlator environments.




---

📌 Overview

Wine (Wine Is Not an Emulator) is a compatibility layer that allows Windows applications to run on POSIX‑compliant systems like Linux and Android.
This project aims to produce a Wine build that can be packaged as a WCP (Wine Container Package) that Winlator can load and use to run Windows executables on Android.


---

🚧 Current Status

❌ Not fully functional yet — At the present stage:

The repository contains build automation scripts, but

The output is not a finished .wcp file that Winlator can load and run reliably.

Additional work is needed for integration with FEXCore / Box86 / Box64 and full Android runtime support.


This repo serves as an infrastructure and development base rather than a final product.


---

📦 What Is a WCP?

A WCP (Wine Container Package) is a custom container format used by Winlator to encapsulate Wine and required libraries in a way that the Android host can load and use.

It bundles:

Wine binaries

Libraries and dependencies

Metadata for Winlator


This format is standard for Winlator/Bionic distributions and is required for seamless loading.


---

📁 Repository Structure

├── build‑wine.sh         # Script to build Wine and wrap into .wcp
├── build.sh              # Primary build automation script
├── .github/              # CI workflows and automation
├── README.md             # This file
└── Other supporting files


---

🛠 Prerequisites

To build Wine, you’ll need a Linux environment with:

✔ git
✔ Development tools (gcc, clang, make, etc.)
✔ pkg-config
✔ Libraries (freetype, zlib, libpng, etc.)
✔ Meson, Ninja (optional for some dependencies)

Ensure the environment is prepared for cross‑building to Android/Winlator.


---

🚀 Building Wine

1. Clone the repository:

git clone https://github.com/kosoymiki/wine_11.1wcp.git
cd wine_11.1wcp


2. Execute the build script:

./build.sh


3. If all steps succeed, a partial Wine build and possibly a .wcp container will be output (depending on progress).



> Due to the experimental nature, some steps may fail or require manual intervention.




---

🧠 Intended Use

After building a Wine .wcp file, the intended usage path is:

1. Copy the .wcp package into your Winlator container directory.


2. Load it in Winlator‑Bionic or Winlator Ludashi.


3. Configure Winlator to use this Wine container to attempt running Windows applications.



Note: This flow will require significant testing, and in many cases further patches, before it runs reliably.


---

📄 Limitations

The following are known limitations:

❌ No fully working Wine build for Android/Winlator yet
❌ Manual dependency integration required
❌ FEXCore / Box86 / Box64 integration is incomplete
❌ Advanced graphics API support (Vulkan / DXVK) is experimental

This repository is a work in progress and should be treated as such.


---

🧪 Target Audience

This repository is primarily intended for:

Developers working on Wine cross‑compilation

Maintainers of Winlator builds

Advanced users experimenting with Windows on Android

Contributors to emulation and compatibility layers



---

🛠 Developer Notes

In this repo you will find:

✔ Custom build automation (bash scripts)
✔ Dependency patching (e.g., harfbuzz + brotli integration)
✔ CI actions (in .github/workflows)
✔ Attempts to integrate Android‑specific libs

This is infrastructure for experimentation, not a final distributable.


---

🧾 License

Wine and its dependencies retain their original open‑source licenses (LGPL, MIT, etc.).
Check each component for its license details.
