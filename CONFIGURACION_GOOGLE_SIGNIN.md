# Configuración de Google Sign-In (Firebase + Android)

Este checklist te ayuda a resolver errores típicos de Google Sign-In como `ApiException: 10`, `DEVELOPER_ERROR` o cierre inmediato del selector de cuenta.

## 1) Habilitar proveedor Google en Firebase

1. Abrí Firebase Console → **Authentication**.
2. Entrá a **Sign-in method**.
3. Activá **Google**.
4. Guardá los cambios.

## 2) Verificar paquete Android

En Firebase Console → **Project Settings** → **Your apps** (Android):

- Debe existir una app Android con package name:
  - `com.frescoya.frescoya`

Si el package name no coincide, Google Sign-In falla.

## 3) Cargar SHA-1 y SHA-256

En la app Android de Firebase agregá huellas de certificado:

- SHA-1 de debug (la que ya obtuviste):
  - `5D:26:27:47:C7:F7:4A:3B:15:C7:12:0B:8A:06:C7:11:DE:3C:4F:4E`
- Recomendado también: SHA-256

Si vas a publicar, también agregá SHA-1/SHA-256 del keystore de release.

## 4) Descargar de nuevo google-services.json

Después de agregar huellas:

1. Descargá nuevamente `google-services.json` desde Firebase.
2. Reemplazá el archivo en:
   - `android/app/google-services.json`
3. Ejecutá:
   - `flutter clean`
   - `flutter pub get`

## 5) Validar OAuth clients dentro de google-services.json

Revisá que `android/app/google-services.json` tenga `oauth_client` con datos.

Si aparece vacío (`"oauth_client": []`), la configuración de OAuth no quedó aplicada y el login puede fallar.

## 6) Verificar Pantalla de consentimiento de Google Cloud

En Google Cloud Console (del mismo proyecto):

- **APIs & Services** → **OAuth consent screen**
- Estado: configurada y publicada para testing interno al menos.
- En modo prueba, agregá como **Test user** la cuenta que vas a usar en el emulador.

## 7) Probar en emulador/dispositivo

1. Abrí la app.
2. Si estaba logueada, cerrá sesión o limpiá datos de app.
3. Tocá **Continuar con Google**.
4. Elegí una cuenta.

## 8) Si falla, mensajes y causa probable

- **"Google Sign-In no está configurado correctamente (SHA-1/OAuth)"**
  - Revisar pasos 2, 3, 4 y 5.
- **"No hay conexión a internet"**
  - Revisar red del emulador/dispositivo.
- **"Inicio de sesión cancelado"**
  - Usuario cerró el selector de cuenta.

## 9) Client ID opcional por dart-define

La app soporta opcionalmente `GOOGLE_SERVER_CLIENT_ID` por build-time:

```bash
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=TU_WEB_CLIENT_ID
```

Solo usar si tu flujo OAuth lo requiere explícitamente.
