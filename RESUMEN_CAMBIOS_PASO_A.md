# Resumen de cambios realizados (PASO A)

## Rama de trabajo

- `respaldo-local`

## 1) Google Sign-In

- Se reforzó `AuthService` (`lib/auth/services/auth_service.dart`):
  - Flujo de Google Sign-In más robusto.
  - Mensajes de error amigables (FirebaseAuth + PlatformException + ApiException:10).
  - Soporte opcional de `GOOGLE_SERVER_CLIENT_ID` vía `--dart-define`.
  - Sincronización de perfil en Firestore para usuarios nuevos/existentes.
- Login/Registro usan mensajes claros en pantalla:
  - `lib/auth/screens/login_page.dart`
  - `lib/auth/screens/register_page.dart`
- Se agregó documentación:
  - `CONFIGURACION_GOOGLE_SIGNIN.md`

## 2) Mercado Pago

- Se mejoró `lib/services/mercadopago_service.dart`:
  - Validación de formato de token.
  - Timeout controlado.
  - Parseo de errores de API (message/cause).
  - Mensajes específicos para token inválido/permisos.
  - Fallback de URL `init_point` / `sandbox_init_point`.
- Checkout integrado con manejo de estado:
  - `lib/screens/checkout/resumen_page.dart`
  - `pendiente_pago` para pagos con MP
  - `Pendiente` para efectivo/transferencia

## 3) Google Maps + cálculo de flete

- Se actualizó `lib/services/flete_service.dart`:
  - Fórmula aplicada: **$500 base + $100 por km**.
  - Distancia en km con Haversine.
- Se integró al checkout:
  - `lib/screens/checkout/direccion_page.dart` muestra distancia y costo estimado.
  - `lib/screens/checkout/resumen_page.dart` muestra flete y total final.
- Persistencia en pedidos:
  - `lib/services/pedidos_service.dart` guarda `costoFlete`, `distanciaKm`, `subtotal`, `tipoEntrega`, `referencia`.

## 4) Modelo de Producto

- Se amplió `lib/models/producto.dart` con:
  - `unidadMedida` (`kg`, `caja`, `unidad`)
  - `cantidadPorUnidad` (`double`)
- Se actualizó persistencia:
  - `lib/services/firestore_service.dart`
  - `lib/providers/productos_provider.dart`
- Se actualizaron pantallas/formularios:
  - `lib/admin/pages/nuevo_producto_page.dart`
  - `lib/admin/pages/editar_producto_page.dart`
  - `lib/screens/productos/producto_form_page.dart`
  - visualización en catálogo/cards de producto

## 5) Documentación de pruebas

- `INSTRUCCIONES_PRUEBA.md` con flujo completo de validación.
