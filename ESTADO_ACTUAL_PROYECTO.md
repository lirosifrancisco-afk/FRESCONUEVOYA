# 📊 Estado Actual del Proyecto FrescoYa

**Fecha:** 29 de Julio de 2026  
**Rama:** `respaldo-local`  
**Última actualización:** Integración completa PASO A

---

## ✅ Features Implementadas y Funcionando

### 1. **Autenticación Completa**
- ✅ Login con email/contraseña
- ✅ **Google Sign-In** (probado y funcionando)
- ✅ Registro de nuevos usuarios
- ✅ Auth Gate (redirección automática según rol: admin/cliente)
- ✅ Manejo de errores mejorado con mensajes claros

**Archivos clave:**
- `lib/auth/services/auth_service.dart` - Lógica de autenticación
- `lib/auth/widgets/google_sign_in_button.dart` - Botón reutilizable de Google
- `lib/auth/screens/login_page.dart`, `register_page.dart` - UI de login/registro
- SHA-1 configurado en Firebase ✅

---

### 2. **Gestión de Productos con Unidades Detalladas**
- ✅ Modelo `Producto` extendido con:
  - `unidadMedida` (kg, caja, unidad)
  - `cantidadPorUnidad` (ej: 1 kg, 0.5 kg, 12 unidades)
- ✅ CRUD completo de productos (admin)
- ✅ Catálogo de productos para usuarios
- ✅ Productos destacados
- ✅ Búsqueda de productos

**Archivos clave:**
- `lib/models/producto.dart` - Modelo extendido
- `lib/admin/pages/nuevo_producto_page.dart` - Form de creación
- `lib/admin/pages/editar_producto_page.dart` - Form de edición
- `lib/widgets/producto_card.dart` - Card de producto para usuarios

---

### 3. **Carrito de Compras**
- ✅ Agregar productos al carrito
- ✅ Aumentar/disminuir cantidades
- ✅ Eliminar productos
- ✅ Cálculo automático de subtotales y total
- ✅ Validación de stock
- ✅ Provider para estado global del carrito

**Archivos clave:**
- `lib/providers/carrito_provider.dart` - Estado del carrito
- `lib/screens/carrito_page.dart` - UI del carrito

---

### 4. **Checkout Multi-Paso (Implementado, Pendiente de Prueba Completa)**
#### **Paso 1: Dirección**
- ✅ Formulario de datos de contacto (nombre, teléfono)
- ✅ Campo de dirección con opción de seleccionar en mapa
- ✅ Integración con Google Maps (`MapaPage`)
- ✅ **Cálculo automático de flete** según distancia:
  - Fórmula: $500 base + $100 por km
  - Ubicación del local: hardcodeada en Mendoza
  - Usa fórmula de Haversine para calcular distancia
- ✅ Estimación de costo mostrada en tiempo real

**Archivos clave:**
- `lib/screens/checkout/direccion_page.dart` - Formulario de dirección
- `lib/services/flete_service.dart` - Cálculo de distancia y costo
- `lib/screens/mapa/mapa_page.dart` - Selector de ubicación en mapa

#### **Paso 2: Método de Pago**
- ✅ Selección de método: Efectivo, Transferencia, Mercado Pago
- ✅ UI con RadioListTile

**Archivos clave:**
- `lib/screens/checkout/metodo_pago_page.dart`

#### **Paso 3: Resumen y Confirmación**
- ✅ Resumen del pedido (productos, datos, dirección, método de pago)
- ✅ Cálculo de total final (productos + flete)
- ✅ Guardado del pedido en Firestore con todos los detalles:
  - Productos con unidades
  - Datos de contacto
  - Ubicación (lat/lng)
  - Distancia y costo de flete
  - Estado: "Pendiente" o "pendiente_pago" (para MP)

**Archivos clave:**
- `lib/screens/checkout/resumen_page.dart` - Resumen y confirmación
- `lib/services/pedidos_service.dart` - Guardado en Firestore

---

### 5. **Integración con Mercado Pago (Checkout Pro)**
- ✅ Servicio completo de Mercado Pago implementado
- ✅ Creación de preferencias de pago via API
- ✅ Apertura del checkout en navegador externo (`url_launcher`)
- ✅ Manejo de errores específicos (token inválido, timeouts, API errors)
- ✅ Token TEST configurado: `TEST-7756136356459997-072719-...`
- ✅ Back URLs configuradas para diferentes resultados de pago

**Archivos clave:**
- `lib/services/mercadopago_service.dart` - Servicio de MP
- Integración en `resumen_page.dart`

**Estado:** Implementado, pendiente de prueba end-to-end

---

### 6. **Notificaciones Push (FCM)**
- ✅ Firebase Cloud Messaging integrado
- ✅ Permisos de notificaciones solicitados al usuario
- ✅ Token FCM guardado en Firestore (documento del usuario)
- ✅ Handler para mensajes en foreground (notificaciones locales)
- ✅ Handler para mensajes en background
- ✅ Canal de notificaciones Android configurado

**Archivos clave:**
- `lib/services/notificaciones_service.dart` - Servicio de notificaciones
- `lib/main.dart` - Inicialización de FCM
- `android/app/src/main/AndroidManifest.xml` - Permisos Android

---

### 7. **Perfil de Usuario**
- ✅ Visualización de datos del usuario
- ✅ Edición de nombre, teléfono, dirección
- ✅ Cierre de sesión (Firebase + Google)

**Archivos clave:**
- `lib/screens/perfil_page.dart` - Página de perfil

---

### 8. **Panel de Administración**
- ✅ Dashboard con estadísticas
- ✅ Gestión de productos (CRUD completo)
- ✅ Visualización de pedidos
- ✅ Gestión de clientes
- ✅ Reportes en PDF
- ✅ Gráficos de ventas

**Archivos clave:**
- `lib/admin/` - Todo el módulo de admin

---

## ⚠️ Pendiente de Prueba

### **Checkout Completo**
- ⏸️ Flujo end-to-end con efectivo/transferencia
- ⏸️ Selector de ubicación en mapa funcionando
- ⏸️ Cálculo de flete con ubicación real
- ⏸️ Apertura de Mercado Pago en navegador
- ⏸️ Pago de prueba con tarjeta TEST

### **Notificaciones**
- ⏸️ Envío de notificación de prueba desde Firebase Console
- ⏸️ Notificación al cambiar estado del pedido

---

## 🔧 Configuración Actual

### **Firebase**
- ✅ Proyecto: FrescoYa Mendoza
- ✅ Authentication: Google habilitado
- ✅ Firestore: Colecciones configuradas (usuarios, productos, pedidos, etc.)
- ✅ Cloud Messaging: Activado
- ✅ SHA-1 agregado: `5D:26:27:47:C7:F7:4A:3B:15:C7:12:0B:8A:06:C7:11:DE:3C:4F:4E`
- ✅ `google-services.json` actualizado (28/07/2026)

### **Mercado Pago**
- ✅ Access Token TEST configurado
- ✅ Aplicación: FrescoYa
- ✅ Package name: `com.frescoya.frescoya`

### **Android**
- ✅ `minSdk`: 23 (Android 6.0)
- ✅ `compileSdk`: versión de Flutter
- ✅ Core library desugaring habilitado
- ✅ MultiDex habilitado
- ✅ Permisos: INTERNET, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED

### **Dependencias Principales**
```yaml
firebase_core: 4.12.1
firebase_auth: 6.5.6
cloud_firestore: 6.7.1
firebase_storage: 13.4.5
firebase_messaging: 16.4.3

google_sign_in: ^6.2.2
google_maps_flutter: 2.12.3

http: ^1.2.2
url_launcher: ^6.3.1

flutter_local_notifications: ^18.0.1

provider: 6.1.5
pdf: 3.12.0
```

---

## 📁 Estructura del Proyecto

```
lib/
├── auth/                    # Autenticación
│   ├── screens/            # Login, Register, AuthGate
│   ├── services/           # AuthService
│   └── widgets/            # GoogleSignInButton
├── admin/                   # Panel de administración
│   ├── pages/              # Pantallas de admin
│   ├── services/           # Servicios de admin
│   └── widgets/            # Widgets de admin
├── models/                  # Modelos de datos (Producto, Cliente, etc.)
├── providers/               # Providers de estado (Carrito, Productos, etc.)
├── screens/                 # Pantallas principales
│   ├── checkout/           # Flujo de checkout (3 pasos)
│   ├── mapa/               # Selector de ubicación
│   └── ...
├── services/                # Servicios de backend
│   ├── firestore_service.dart
│   ├── mercadopago_service.dart
│   ├── pedidos_service.dart
│   ├── flete_service.dart
│   └── notificaciones_service.dart
├── shared/                  # Componentes compartidos
│   ├── theme/              # Colores, estilos de texto
│   └── widgets/            # Widgets reutilizables
├── widgets/                 # Widgets específicos
└── main.dart               # Punto de entrada
```

---

## 🚀 Próximos Pasos

### **Inmediato:**
1. ✅ Probar checkout completo (efectivo)
2. ✅ Probar selector de mapa y cálculo de flete
3. ✅ Probar Mercado Pago end-to-end
4. ✅ Verificar que las notificaciones se envíen correctamente

### **PASO B (Siguiente fase):**
1. ⏸️ Integración con Uber Direct API
2. ⏸️ Seguimiento de entregas en tiempo real
3. ⏸️ Asignación automática de repartidores

---

## 📝 Notas Técnicas

### **Cálculo de Flete**
- Ubicación del local: `-32.889458, -68.845839` (Mendoza centro)
- Fórmula: $500 (base) + $100 × distancia_km
- Distancia calculada con Haversine (precisión ~99%)

### **Estados de Pedidos**
- `"Pendiente"`: Pedido confirmado (efectivo/transferencia)
- `"pendiente_pago"`: Esperando pago de Mercado Pago
- Otros estados: `"En preparación"`, `"En camino"`, `"Entregado"`, `"Cancelado"`

### **Mercado Pago**
- Modo: TEST (sandbox)
- Token expira cada 180 días
- Tarjetas de prueba disponibles en docs de MP
- Init point: URL del checkout que se abre en navegador

---

## 🐛 Issues Conocidos

1. **Checkout se minimiza al tocar "Finalizar compra"**
   - Causa probable: Crash silencioso
   - Solución: Revisar logs en Android Studio al momento del crash
   - Posibles causas: Permisos, configuración de Maps API, error en tiempo de ejecución

---

## 📞 Soporte

Si algo no funciona, revisá:
1. `GUIA_PRUEBAS_COMPLETA.md` - Pasos detallados de prueba
2. Logs de Android Studio (consola abajo)
3. Firestore Console (verificar que se guarden los datos)

**Ante cualquier error:**
- Copiá el mensaje de error completo
- Tomá captura de la pantalla donde falló
- Indicá qué prueba estabas realizando
