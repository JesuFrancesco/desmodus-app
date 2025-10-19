# Desmodus App

## Ambiente de desarrollo

### Environment variables

1. Completar con credenciales en [.env](.env)
2. Correr el [comando de ejecución](#comando-de-ejecución)

### Comando de ejecución

```sh
flutter run --dart-define-from-file .env
```

## Otros comandos

### Generar DB local con Drift o mocks de testing

```sh
dart run build_runner build
```
