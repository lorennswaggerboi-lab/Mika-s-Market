# ⚡ Pulso — Catálogo de Productos y E-Commerce

Plataforma web profesional de catálogo de productos e e-commerce ligera, con diseño limpio y moderno inspirado en Mercado Libre y Amazon, optimizada para dispositivos móviles y de escritorio.

---

## 🚀 Características Principales

### 🎨 Diseño Premium
- Interfaz limpia, minimalista y profesional
- Diseño responsive (mobile-first)
- Header con logo, barra de búsqueda y menú desplegable
- Grid de productos con tarjetas elegantes
- Animaciones y transiciones suaves

### 📦 Catálogo de Productos
- Grid adaptativo con tarjetas que muestran imagen, título y precio
- Buscador en tiempo real por título y descripción
- Vista detallada de producto con panel deslizante (estilo app)
- Carrusel de imágenes interactivo con miniaturas, flechas y puntos indicativos
- Soporte para gestos táctiles (swipe) en móviles

### 👤 Sistema de Autenticación
- Registro de usuarios con email y contraseña
- Inicio de sesión con integración a Supabase Auth
- Menú contextual con información del usuario
- Toggle de visibilidad de contraseña

### 🔒 Control de Permisos Estricto
- **Administrador único**: Solo `micaelavanesarosica@gmail.com` puede publicar, editar o eliminar productos
- Botones de administración completamente ocultos para otros usuarios
- Validación tanto en frontend como en backend (RLS de Supabase)

### 📝 Gestión de Publicaciones (Admin)
- Formulario completo: título, precio, descripción, teléfono, mensaje WhatsApp
- Carga de múltiples imágenes con vista previa
- Edición inline con datos precargados
- Eliminación con confirmación

### 💬 Integración WhatsApp
- Botón flotante "Consultar por WhatsApp" con ícono oficial
- Número y mensaje predeterminado configurables por producto
- Redirección directa a `wa.me` con texto autocompletado

---

## 🛠️ Tecnologías

- **HTML5** semántico
- **CSS3** con variables CSS custom (diseño sin frameworks pesados)
- **JavaScript ES6+** (vanilla, sin dependencias)
- **Supabase** — Auth, Database (PostgreSQL) y Storage
- **Google Fonts** (Inter) y **Material Symbols**
- **Vercel** para despliegue

---

## 📋 Configuración

### 1. Crear proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com) y crea un proyecto nuevo
2. Abre el **SQL Editor** y ejecuta el contenido de [`supabase-setup.sql`](./supabase-setup.sql)

### 2. Configurar credenciales

En `index.html`, busca estas líneas y reemplaza con tus credenciales:

```javascript
const SUPABASE_URL = 'TU_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'TU_SUPABASE_ANON_KEY';
```

Puedes encontrar estas credenciales en: **Supabase Dashboard → Settings → API**

### 3. Configurar Storage

1. En Supabase, ve a **Storage**
2. Verifica que el bucket `product-images` se creó al ejecutar el SQL
3. Si no, créalo manualmente como **público**

### 4. Crear cuenta de administrador

1. Registra la cuenta con el correo `micaelavanesarosica@gmail.com` desde la interfaz
2. Confirma el email (o desactiva la confirmación en Supabase Auth settings)
3. ¡Listo! Esta cuenta tendrá acceso completo de administración

---

## 💻 Ejecución Local

```bash
# Con Python 3
python3 -m http.server 3000

# Con Node.js
npx serve .

# Con PHP
php -S localhost:3000
```

Abre en tu navegador: [http://localhost:3000](http://localhost:3000)

> **Nota:** Sin configurar Supabase, la app funciona en **modo demo** con productos de ejemplo y autenticación simulada.

---

## 🚀 Despliegue en Vercel

```bash
# Instalar Vercel CLI
npm i -g vercel

# Desplegar
vercel --prod
```

---

## 📁 Estructura del Proyecto

```
├── index.html          # Aplicación SPA completa
├── supabase-setup.sql  # Script de configuración de base de datos
├── vercel.json         # Configuración de Vercel
├── logo_pulso/         # Assets del logo
└── README.md           # Este archivo
```
