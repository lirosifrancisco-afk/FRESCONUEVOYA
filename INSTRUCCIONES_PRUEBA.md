# Instrucciones de prueba - FrescoYa (PASO A)

## Pre-requisitos

- Proyecto abierto en rama `respaldo-local`.
- `google-services.json` actualizado en `android/app/`.
- Google Sign-In habilitado en Firebase (ver `CONFIGURACION_GOOGLE_SIGNIN.md`).
- Access Token de Mercado Pago configurado en `lib/services/mercadopago_service.dart`.

## 1) Preparación

```bash
flutter clean
flutter pub get
flutter run
```

## 2) Probar Login con Google

1. Desde la pantalla de login, tocar **Continuar con Google**.
2. Seleccionar una cuenta Google.
3. Resultado esperado:
   - Si el usuario es admin → abre panel admin.
   - Si no es admin → abre app cliente.
4. Si falla, revisar mensaje mostrado en SnackBar (ahora son mensajes claros).

## 3) Probar catálogo y carrito

1. Entrar al catálogo.
2. Verificar que el producto muestre:
   - precio
   - unidad de medida
   - cantidad por unidad
3. Agregar 2 o más productos al carrito.

## 4) Probar cálculo de flete

1. Ir a checkout.
2. Completar nombre y teléfono.
3. Seleccionar dirección en el mapa.
4. Verificar que aparezca:
   - Distancia aproximada (km)
   - Costo de flete estimado
5. En resumen, validar:
   - Subtotal
   - Flete
   - Total final

## 5) Probar checkout con Mercado Pago

1. En método de pago elegir **Mercado Pago**.
2. Confirmar pedido.
3. Resultado esperado:
   - Se guarda pedido en Firestore con estado `pendiente_pago`.
   - Se abre navegador externo con checkout de Mercado Pago.
4. Si falla por token:
   - Debe mostrar mensaje claro de credencial inválida/permisos.

## 6) Probar checkout con efectivo o transferencia

1. Repetir checkout eligiendo **efectivo** o **transferencia**.
2. Resultado esperado:
   - Se guarda pedido con estado `Pendiente`.
   - Navega a pantalla de pedido exitoso.

## 7) Verificación en Firestore (colección pedidos)

Cada pedido nuevo debe tener:

- `uid`
- `nombre`, `telefono`, `direccion`
- `metodoPago`
- `estado`
- `subtotal`, `costoFlete`, `distanciaKm`, `total`
- `latitud`, `longitud`
- `productos[]` con unidad y cantidad

## 8) Verificación en Firestore (colección productos)

Productos deben incluir:

- `unidad`
- `unidadMedida`
- `cantidadPorUnidad`

## 9) Qué revisar en Firebase Console

- Authentication → Google habilitado.
- App Android con package `com.frescoya.frescoya`.
- SHA-1 y SHA-256 cargados.
- `google-services.json` actualizado.
- (Opcional) Cloud Messaging habilitado para notificaciones.
