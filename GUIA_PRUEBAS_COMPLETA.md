# 🧪 Guía Completa de Pruebas - FrescoYa App

## ✅ Estado Actual (Confirmado Funcionando)

### 1. **Google Sign-In** ✅
- Botón "Continuar con Google" visible en login
- Autenticación exitosa
- Usuario se loguea correctamente

### 2. **Productos con Unidades** ✅
- Cada producto muestra su unidad correctamente (kg, caja, unidad)
- Precio por unidad visible (ej: "$6900 por 1.0 CAJA")
- Stock visible

### 3. **Carrito de Compras** ✅
- Agregar productos funciona
- Aumentar/disminuir cantidad funciona
- Eliminar productos funciona
- Total se calcula correctamente

---

## 🧪 Pruebas que Faltan Realizar

### **PRUEBA 1: Checkout Completo (SIN Mercado Pago)**

**Objetivo:** Verificar que el flujo de checkout funciona hasta el final con efectivo/transferencia.

**Pasos:**
1. Agregá 2-3 productos al carrito
2. Tocá "Finalizar compra"
3. **PASO 1 - Dirección:**
   - Completá nombre
   - Completá teléfono
   - Escribí una dirección manualmente (ej: "Av. San Martín 1234, Mendoza")
   - Tocá "Continuar"
4. **PASO 2 - Método de pago:**
   - Dejá seleccionado "Efectivo" (por defecto)
   - Tocá "Continuar"
5. **PASO 3 - Resumen:**
   - Verificá que aparezcan todos los datos correctamente
   - Verificá que el costo de flete sea $500 (base, sin ubicación de mapa)
   - Tocá "Confirmar"

**Resultado Esperado:**
- ✅ Se guarda el pedido en Firestore
- ✅ Se vacía el carrito
- ✅ Te muestra la pantalla "Pedido Exitoso" con el número de pedido

**Si falla:** Anotá en qué paso exacto se traba o minimiza.

---

### **PRUEBA 2: Selector de Ubicación en Mapa**

**Objetivo:** Verificar que el mapa funciona y calcula el flete correctamente.

**Pasos:**
1. Agregá productos al carrito
2. Tocá "Finalizar compra"
3. En la pantalla de dirección, tocá el **ícono del mapa** 🗺️ (al lado del campo de dirección)
4. Debería abrirse Google Maps
5. Movete por el mapa y tocá un punto en Mendoza
6. Confirmá la ubicación
7. Volvé a la pantalla anterior

**Resultado Esperado:**
- ✅ La dirección se completa automáticamente
- ✅ Aparece un recuadro verde que dice: "Ubicación seleccionada correctamente"
- ✅ Muestra "Distancia aproximada: X.XX km"
- ✅ Muestra "Costo de flete: $XXX" (calculado como $500 base + $100 por km)

**Si falla:** Anotá el error específico.

---

### **PRUEBA 3: Mercado Pago Checkout**

**Objetivo:** Verificar que se abre el checkout de Mercado Pago correctamente.

**Pasos:**
1. Agregá productos al carrito
2. Tocá "Finalizar compra"
3. Completá la dirección (puede ser manual, sin mapa)
4. Tocá "Continuar"
5. En "Método de pago", seleccioná **"💳 Mercado Pago"**
6. Tocá "Continuar"
7. Verificá el resumen
8. Tocá **"Confirmar"**

**Resultado Esperado:**
- ✅ Se guarda el pedido con estado "pendiente_pago"
- ✅ Se abre el **navegador del emulador** (Chrome)
- ✅ Se muestra el checkout de Mercado Pago
- ✅ Podés ingresar datos de tarjeta de prueba:
  - **Tarjeta:** `4509 9535 6623 3704`
  - **CVV:** `123`
  - **Vencimiento:** `11/25`
  - **Nombre:** `APRO` (para que se apruebe)

**Si falla:** 
- Si dice "Token inválido" → el token de Mercado Pago puede estar vencido
- Si no se abre el navegador → hay un problema con `url_launcher`
- Si crashea → anotá el error en la consola de Android Studio

---

## 🔧 Soluciones a Problemas Comunes

### **Problema 1: La app se minimiza al tocar "Finalizar compra"**

**Causa probable:** Crash silencioso por falta de permisos o configuración.

**Solución:**
1. En Android Studio, mirá la consola/logcat (abajo) cuando tocás "Finalizar compra"
2. Buscá líneas en rojo que digan "Exception" o "Error"
3. Copiá el error completo y compartilo

---

### **Problema 2: El mapa no se abre**

**Causa probable:** Google Maps API Key no configurada o permisos de ubicación.

**Solución:**
1. Verificá que tengas una Google Maps API Key en Firebase
2. Asegurate de que el `google-services.json` esté actualizado
3. El emulador debe tener permisos de ubicación habilitados

---

### **Problema 3: Mercado Pago dice "Token inválido"**

**Causa:** El token TEST puede haber vencido o estar mal configurado.

**Solución:**
1. Andá a Mercado Pago Developers
2. Copiá un nuevo Access Token de prueba
3. Reemplazalo en el código (archivo `lib/services/mercadopago_service.dart`)

---

## 📋 Checklist Final

Marcá con ✅ lo que ya probaste y funciona:

- [✅] Google Sign-In
- [✅] Ver catálogo de productos
- [✅] Agregar productos al carrito
- [✅] Modificar cantidades en el carrito
- [ ] Completar checkout con efectivo (sin mapa)
- [ ] Seleccionar ubicación en mapa
- [ ] Ver cálculo de flete automático
- [ ] Checkout con Mercado Pago
- [ ] Pago de prueba con tarjeta TEST

---

## 🆘 Si algo no funciona

**Enviame:**
1. ✅ Qué prueba estabas haciendo (ej: "PRUEBA 3 - Mercado Pago")
2. ✅ En qué paso exacto falló
3. ✅ Captura del error en la consola de Android Studio (si hay)
4. ✅ Captura de la pantalla del emulador

Con eso te lo arreglo en minutos.

---

**Próximos pasos después de que todo funcione:**
- Panel de administración (ver y gestionar pedidos)
- Notificaciones push cuando cambien los estados
- Uber Direct para logística (PASO B)
